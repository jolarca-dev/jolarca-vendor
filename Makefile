# jolarca-vendor — verification targets
#
# This repository holds governance documents, not software, so the gate is
# documentation lint, YAML validation and a secret/personal-data scan. It runs
# locally here and in CI as the `lint` status check that branch protection
# requires — see .github/workflows/ci.yml.
#
# Python is used only as a build tool for YAML validation; no Python source is
# committed. See docs/ASSUMPTIONS.md decision D1.

# .ONESHELL is REQUIRED here, not a style preference: without it make hands each
# recipe line to a separate shell, so a multi-line loop or heredoc is executed
# one line at a time and fails.
#
# .SHELLFLAGS adds -e so that a failing command inside a multi-line recipe aborts
# it. Without -e only the exit status of the LAST command is reported, and a
# failing check followed by an echo would report success. That is the exact defect
# class this repository exists to avoid: a gate that is configured and never fails.
.ONESHELL:
.SHELLFLAGS := -ec
SHELL := /bin/sh

PYTHON ?= python3
MARKDOWNLINT ?= npx --yes markdownlint-cli2

.PHONY: help check lint-docs yaml-check scan selftest clean

## The full gate. Must pass before merge.
check: lint-docs yaml-check scan
	@echo "check: OK"

## Markdown lint. ADVISORY: reported, not enforced. A hard style gate on normative
## prose invites suppression rather than improvement. This is the only target
## whose failure is tolerated, and it is tolerated explicitly, not by accident.
lint-docs:
	@echo "lint-docs: markdownlint-cli2 (advisory — failures tolerated)"
	$(MARKDOWNLINT) "**/*.md" "#.venv" "#node_modules" || echo "lint-docs: markdownlint reported issues (advisory, not failing)"

## YAML validation. HARD FAILURE. Malformed workflow or issue-form YAML fails
## silently at runtime rather than at build time, and a broken CI workflow that
## never runs is indistinguishable from one that passes.
##
## Deliberately invoked once per file with `python -c` rather than through a
## heredoc: a heredoc inside a Makefile recipe is fragile because make strips the
## leading tab from every line, which silently destroys Python indentation.
yaml-check:
	@echo "yaml-check: validating YAML"
	fail=0
	count=0
	for f in $$(find . \( -name '*.yml' -o -name '*.yaml' \) -not -path './.venv/*' -not -path './node_modules/*' -not -path './.git/*' | sort); do
	  count=$$((count + 1))
	  if ! $(PYTHON) -c 'import sys, yaml; list(yaml.safe_load_all(open(sys.argv[1], encoding="utf-8")))' "$$f"; then
	    echo "yaml-check: FAILED — $$f"
	    fail=1
	  fi
	done
	if [ "$$count" -eq 0 ]; then
	  echo "yaml-check: no YAML files found — refusing to report a clean result."
	  echo "yaml-check: an empty scan is indistinguishable from a broken one."
	  exit 1
	fi
	if [ "$$fail" -ne 0 ]; then
	  echo "yaml-check: FAILED — $$count file(s) checked"
	  exit 1
	fi
	echo "yaml-check: OK — $$count file(s) valid"

## Secret, credential and personal-data scan. HARD FAILURE.
## This repository is public; see SECURITY.md and scripts/scan-secrets.sh.
scan:
	sh scripts/scan-secrets.sh

## Negative control for `scan`. A clean scan is worthless if the scanner is
## broken: "0 findings" would then mean "not looking" rather than "nothing found".
## This target plants a synthetic credential, asserts the scan REJECTS it, removes
## it, and asserts the scan then passes.
##
## The credential is assembled at runtime from two fragments so that the complete
## value never appears as a literal in this file. Committing the literal would
## make the repository fail its own scan — which is what the scanner is for, and
## is exactly how this target was first validated.
selftest:
	@echo "selftest: verifying the scan rejects a planted credential"
	tmp=.selftest-tmp.key
	trap 'rm -f $$tmp' EXIT INT TERM
	printf 'AKIA%s\n' "$$(printf 'X%.0s' $$(seq 1 16))" > $$tmp
	if sh scripts/scan-secrets.sh > /dev/null 2>&1; then
	  echo "selftest: FAILED — the scan accepted a planted credential."
	  echo "selftest: the gate does not fire and must not be relied upon."
	  exit 1
	fi
	rm -f $$tmp
	if ! sh scripts/scan-secrets.sh > /dev/null 2>&1; then
	  echo "selftest: FAILED — the scan still reports findings after the planted"
	  echo "selftest: credential was removed, or the scanner is broken."
	  exit 1
	fi
	echo "selftest: OK — scan rejects a planted credential and passes when removed"

## Remove local artifacts. Never touches tracked files.
clean:
	rm -rf node_modules .markdownlint-cli2-* .selftest-tmp.key 2>/dev/null || true
	echo "clean: OK"

help:
	@echo "Targets:"
	echo "  make check       full gate: lint-docs + yaml-check + scan"
	echo "  make lint-docs   markdown lint (advisory)"
	echo "  make yaml-check  YAML validation (hard failure)"
	echo "  make scan        secret and personal-data scan (hard failure)"
	echo "  make selftest    prove the scan actually fires (negative control)"
	echo "  make clean       remove local artifacts"
