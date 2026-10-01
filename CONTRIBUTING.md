# Contributing

This repository holds the **methodology** for vendor management. It holds no
supplier records. Read this before opening a pull request — most rejections are
for a boundary breach that takes ten seconds to check and cannot be undone by
reverting.

## The one rule that matters most

> **Do not add supplier-specific content to this repository.**

No vendor names paired with findings, no risk scores, no assessment documents, no
contract terms, no transfer impact assessments, no evidence, no gap lists, no
personal data, no secrets. This repository is `public` and classified `internal`.
That content is `confidential` and belongs in `jolarca-compliance` or
`jolarca-legal`.

The test for any addition: **would this be acceptable to read aloud to a
competitor and to an attacker?** Method, yes. Findings, no.

A confidential item committed here is a disclosure event, not a mistake to revert.
Removal from the working tree does not remove it from history, forks, clones or CI
logs. Report it under [`SECURITY.md`](SECURITY.md) immediately.

The CI scan enforces this mechanically, but it is a backstop — it catches
credential shapes and personal-data patterns, not a well-written sentence that
discloses a supplier's control weakness. Judgement is the primary control.

## What belongs here

| Change | Welcome |
|---|---|
| A methodology improvement — a better scoring input, a tighter rubric row | Yes |
| A new procedure, or a step added to an existing one | Yes |
| A clause added to the security requirements schedule | Yes |
| A new failure mode observed in practice, described generically | Yes — this is the highest-value contribution type |
| A correction to a control citation | Yes |
| A new control mapped in the traceability matrix | Yes, with its artifact in the same PR |
| Register data, assessments, findings | **No** — `jolarca-compliance` |
| Contract or DPA text | **No** — `jolarca-legal` |
| Repository settings, visibility, branch protection | **No** — `jolarca-control` |

## Before you start

1. Read [`docs/scope-and-boundaries.md`](docs/scope-and-boundaries.md). It states
   what this repository governs and what it deliberately does not.
2. Check the source-of-truth map in [`README.md`](README.md). If the artifact you
   want to add already has an authoritative home elsewhere, add it there and link
   from here. **Duplicating an artifact creates a second source of truth**, and
   two registers that disagree are worse than one with visible gaps.
3. Confirm which control your change affects. If you cannot name one, the change
   probably belongs in a different repository.

## Making the change

1. Branch from `main`. Branch protection requires linear history; squash-merge
   only.
2. Write in the house voice: normative, specific, and stating **why**. A rule
   without a reason is not followed under pressure, and a procedure that says
   "must" without saying what breaks otherwise gets worked around.
3. Update the document header table — bump `Version`, keep `Next review` current.
4. Update [`docs/TRACEABILITY.md`](docs/TRACEABILITY.md) if a control mapping
   changes. An unchanged matrix that no longer matches the artifacts is worse than
   no matrix.
5. Add a [`CHANGELOG.md`](CHANGELOG.md) entry naming the control affected.
6. Cross-reference rather than restate. If two documents say the same thing, one
   will eventually be updated without the other.

### Changing a control threshold

The scoring weights, the `0.60` residual-risk cap, the tier floors, the CE domain
definitions and the approval-blocking clause list are **change-controlled**. A
change to any of them requires:

1. A stated reason in the pull request description.
2. Where scoring changes: the effect on existing tiers described, per
   [`docs/methodology/risk-scoring.md`](docs/methodology/risk-scoring.md) §7.
   Historical scores must remain comparable across an audit period, so the delta
   is recorded rather than the history quietly restated.
3. A signed commit.

Lowering a threshold to make an inconvenient supplier fit is the failure mode
these rules exist to catch. If a supplier does not fit the rubric, the rubric is
probably right and the supplier is the problem.

## Verification

Run before pushing:

```bash
make check
```

This runs markdown lint, YAML validation and the secret and personal-data scan —
the same gate CI runs as the `lint` status check, which branch protection
requires. `make check` failing means the pull request cannot merge.

Markdown lint is advisory in this repository (it does not fail the build), because
prose quality matters more than style-rule conformance. YAML validation and the
secret scan are **hard failures** and must not be bypassed.

## Pull request requirements

Complete the template in `.github/PULL_REQUEST_TEMPLATE.md`. In particular:

- Name the control affected, or state explicitly that none is.
- Confirm no confidential content is added.
- Sign off — `web_commit_signoff_required` is enabled.
- Resolve every review conversation; `require_conversation_resolution` is enabled.

There is no second human reviewer. `required_approving_review_count` is 0 as a
documented deviation, and CODEOWNERS is present for routing and attribution
rather than as an approval control. That means **you are the review**. Read the
diff before merging it, and prefer a smaller pull request you can actually read
over a larger one you cannot. The compensating controls are described in
[`docs/solo-operator-controls.md`](docs/solo-operator-controls.md).

## Conventions

- **Dates** ISO 8601 (`YYYY-MM-DD`), always.
- **Headings** ATX style (`#`), one `H1` per file, blank lines around headings,
  lists and fenced blocks.
- **Line length** not enforced (`MD013` disabled), but wrap prose near 80
  characters so diffs stay readable.
- **Tables** for anything enumerated; prose for reasoning.
- **Fenced code blocks** carry a language tag.
- **No inline HTML.** Markdown only — `MD033` is enabled.
- **Em dashes and section references** (`§6`) are used consistently; match the
  surrounding style.
- **Normative language** is deliberate: "must" is a requirement, "should" is a
  recommendation, "may" is a permission. Do not use them interchangeably.
- **Final newline** in every file; no trailing whitespace (`.editorconfig`).

## Reporting a gap

If you find a control gap rather than a documentation defect, **do not open an
issue describing it here**. This repository is public. Follow
[`docs/gap-intake.md`](docs/gap-intake.md), which routes findings to the correct
register by type.

Issues on this repository are appropriate for defects in the method itself — a
formula that does not compute, a control citation that is wrong, a procedure step
that cannot be performed. Those are not confidential.

## Security issues

Never an issue. See [`SECURITY.md`](SECURITY.md).
