#!/bin/sh
# scan-secrets.sh — secret, credential and personal-data scan.
#
# This repository is PUBLIC and classified internal. It must contain no
# credentials and no personal data, and — per docs/scope-and-boundaries.md — no
# supplier-specific content. This script is the mechanical backstop for the first
# two; the third is a matter of judgement and is not automatable, and the closing
# message says so rather than implying complete coverage.
#
# Runs under `make scan` locally and as part of the `lint` CI status check.
# Requires only POSIX sh and GNU grep (-E -n -I -r --exclude-dir).
#
# Exit codes: 0 clean, 1 findings, 2 the scan could not run.
#
# Deliberate behaviour: matched VALUES are never printed. Echoing a secret to a
# terminal or a CI log re-discloses it, and CI logs are retained and are usually
# more widely readable than the repository. Only file, line number and rule name
# are reported.

set -eu

REPO_ROOT=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$REPO_ROOT"

# Directories never scanned: not repository content.
EXCLUDE_DIRS='.git .venv venv node_modules .idea .mypy_cache .ruff_cache __pycache__'

# Files never scanned: the scan contains the rule patterns, and the allowlist
# contains literals that would match them.
EXCLUDE_FILES='scan-secrets.sh scan-allowlist.txt'

ALLOWLIST_FILE='scripts/scan-allowlist.txt'

# ── Rules ────────────────────────────────────────────────────────────────────
# Format: name<TAB>extended-regular-expression
#
# Each rule matches a VALUE SHAPE rather than a keyword, so that prose discussing
# credentials does not trip it. A rule that fires on the word "password" gets
# disabled within a week and then hides the real thing.
RULES_FILE=$(mktemp)
RESULTS_FILE=$(mktemp)
trap 'rm -f "$RULES_FILE" "$RESULTS_FILE"' EXIT INT TERM

cat > "$RULES_FILE" <<'RULES'
aws-access-key-id	(A3T[A-Z0-9]|AKIA|ASIA|ABIA|ACCA)[A-Z0-9]{16}
age-secret-key	AGE-SECRET-KEY-1[02-9A-HJ-NP-Z]{58}
github-token	gh[pousr]_[A-Za-z0-9]{36,}
slack-token	xox[baprs]-[A-Za-z0-9-]{10,}
stripe-secret-key	(sk|rk)_(live|test)_[A-Za-z0-9]{16,}
google-api-key	AIza[0-9A-Za-z_-]{35}
private-key-block	-----BEGIN [A-Z ]*PRIVATE KEY-----
json-web-token	eyJ[A-Za-z0-9_-]{8,}\.eyJ[A-Za-z0-9_-]{8,}\.[A-Za-z0-9_-]{8,}
credentials-in-url	://[^/[:space:]:]+:[^/[:space:]]+@
generic-secret-assignment	(api[_-]?key|apikey|secret[_-]?key|client[_-]?secret|access[_-]?token|auth[_-]?token|password|passwd|private[_-]?key)["'[:space:]]*[:=]["'[:space:]]*[A-Za-z0-9/+_.-]{16,}
payment-card-number	(4[0-9]{12}([0-9]{3})?|5[1-5][0-9]{14}|3[47][0-9]{13}|6(011|5[0-9]{2})[0-9]{12})
email-address	[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}
baltic-personal-code	[3-6][0-9]{10}
RULES

# ── Build grep arguments ─────────────────────────────────────────────────────
GREP_ARGS='-E -n -I -r'
for d in $EXCLUDE_DIRS; do
  GREP_ARGS="$GREP_ARGS --exclude-dir=$d"
done
for f in $EXCLUDE_FILES; do
  GREP_ARGS="$GREP_ARGS --exclude=$f"
done

# ── Allowlist ────────────────────────────────────────────────────────────────
# One entry per line: a repository-relative path, optionally suffixed ":<line>"
# to allow a single line. Blank lines and lines beginning "#" are ignored. Every
# entry must carry a written reason, because an unexplained allowlist entry
# becomes a permanent blind spot.
ALLOWLIST_CLEAN=$(mktemp)
trap 'rm -f "$RULES_FILE" "$RESULTS_FILE" "$ALLOWLIST_CLEAN"' EXIT INT TERM
if [ -f "$ALLOWLIST_FILE" ]; then
  sed -e 's/#.*//' -e 's/[[:space:]]*$//' "$ALLOWLIST_FILE" \
    | grep -vE '^[[:space:]]*$' > "$ALLOWLIST_CLEAN" || true
fi

allowlisted() {
  # $1 = path, $2 = line number. Whole-line fixed-string match on either form.
  [ -s "$ALLOWLIST_CLEAN" ] || return 1
  grep -Fxq -e "$1:$2" -e "$1" "$ALLOWLIST_CLEAN"
}

# ── Scan ─────────────────────────────────────────────────────────────────────
: > "$RESULTS_FILE"
RULE_COUNT=0

while IFS='	' read -r rule_name rule_regex; do
  [ -n "$rule_name" ] || continue
  RULE_COUNT=$((RULE_COUNT + 1))

  # A non-match returns 1; under `set -e` that must not abort the scan.
  MATCHES=$(eval grep "$GREP_ARGS" -e '"$rule_regex"' . || true)
  [ -n "$MATCHES" ] || continue

  printf '%s\n' "$MATCHES" | while IFS= read -r match; do
    [ -n "$match" ] || continue
    # match format: ./path:lineno:content — content is discarded, never printed.
    rest=${match#./}
    path=${rest%%:*}
    after=${rest#*:}
    lineno=${after%%:*}
    allowlisted "$path" "$lineno" && continue
    printf 'FINDING  rule=%-28s file=%s line=%s\n' "$rule_name" "$path" "$lineno" >> "$RESULTS_FILE"
  done
done < "$RULES_FILE"

FILES_SCANNED=$(eval grep -rl "$GREP_ARGS" -e '' . 2>/dev/null | wc -l | tr -d ' ')
FINDINGS=$(wc -l < "$RESULTS_FILE" | tr -d ' ')

# ── Report ───────────────────────────────────────────────────────────────────
if [ "$FILES_SCANNED" -eq 0 ]; then
  echo "scan-secrets: no files found — refusing to report a clean result." >&2
  echo "scan-secrets: an empty scan is indistinguishable from a broken one." >&2
  exit 2
fi

if [ "$FINDINGS" -gt 0 ]; then
  cat "$RESULTS_FILE"
  echo ""
  echo "scan-secrets: FAILED — $FINDINGS finding(s), $RULE_COUNT rule(s), $FILES_SCANNED file(s)."
  echo ""
  echo "Matched values are deliberately not printed above: echoing a secret to a"
  echo "terminal or a CI log re-discloses it, and CI logs outlive the commit."
  echo ""
  echo "Remediation, in this order:"
  echo "  1. If the value is a live credential, REVOKE IT FIRST. Removing it from the"
  echo "     working tree does not un-leak it — it remains in history, in forks, in"
  echo "     clones and in any log that printed it. Revocation is the only fix."
  echo "  2. Remove the content, or move it to a private repository."
  echo "  3. If this repository was pushed with the value present, treat it as a"
  echo "     security incident under SECURITY.md, including whether a GDPR Article 33"
  echo "     or Article 34 notification duty arises."
  echo "  4. Only if the match is a genuine false positive, add an entry to"
  echo "     $ALLOWLIST_FILE with a written reason."
  exit 1
fi

echo "scan-secrets: OK — 0 findings, $RULE_COUNT rules, $FILES_SCANNED file(s)."
echo "scan-secrets: this scan detects credential and personal-data SHAPES. It cannot"
echo "scan-secrets: detect a supplier name paired with a finding, which is also"
echo "scan-secrets: prohibited here. That boundary is judgement, not automation."
exit 0
