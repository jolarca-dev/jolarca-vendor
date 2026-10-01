# Pull Request

<!--
This template is completed on every pull request. It exists because there is no
second human reviewer on this repository: required_approving_review_count is 0 as
a documented deviation, and CODEOWNERS provides routing rather than approval. The
checklist is therefore the review artifact. See docs/solo-operator-controls.md.

Do not delete sections. If one does not apply, write "n/a" and why — a silently
removed section is indistinguishable from one that was never considered.
-->

## What changed

<!-- One or two sentences. What is different, not how. -->

## Why

<!-- The problem or the control requirement. A change with no reason is a change
that cannot be evaluated, and cannot be reverted safely later. -->

## Control affected

<!--
Name the specific control, e.g. "ISO A.5.21", "SOC 2 CC9.2", "PCI DSS 12.8.4",
"GDPR Art. 28(3)(g)". If none is affected, say so explicitly and explain why the
change is still worth making.

If a control mapping changes, docs/TRACEABILITY.md must be updated in this same
pull request. An unchanged matrix that no longer matches the artifacts is worse
than no matrix, because it is relied upon at audit.
-->

- Control(s):
- `docs/TRACEABILITY.md` updated: [ ] yes  [ ] no  [ ] n/a — no mapping changed

## Confidentiality boundary — MANDATORY

This repository is **public** and classified **internal**.

- [ ] This pull request adds **no** supplier names paired with findings
- [ ] This pull request adds **no** risk scores, tiers or bands for named suppliers
- [ ] This pull request adds **no** assessment documents, questionnaires or evidence
- [ ] This pull request adds **no** contract or DPA terms
- [ ] This pull request adds **no** transfer impact assessments
- [ ] This pull request adds **no** list of control gaps or open findings
- [ ] This pull request adds **no** personal data, including supplier personnel
      contact details
- [ ] This pull request adds **no** secrets, credentials, tokens or keys

If any box cannot be ticked, **stop**. The content belongs in `jolarca-compliance`
or `jolarca-legal`, and a pointer goes here instead. See
`docs/scope-and-boundaries.md` and `docs/gap-intake.md`.

If a box was ticked in error and the content was already pushed, this is a
disclosure event and not a revert: removal from the working tree does not remove
it from history, forks, clones or CI logs. Follow `SECURITY.md`.

## Source of truth

- [ ] I checked the source-of-truth map in `README.md` and this artifact does not
      duplicate one whose authoritative home is elsewhere

<!--
Duplicating an artifact creates a second source of truth. Two registers that
disagree are worse than one with visible gaps, because neither can then be relied
upon — an auditor sampling both finds contradictory evidence and concludes the
process is uncontrolled.
-->

## Control threshold change

Only complete if this pull request changes the scoring weights, the `0.60`
residual-risk cap, the CE domain definitions, the tier floors, or the
approval-blocking clause list. See `CONTRIBUTING.md`.

- [ ] n/a — no control threshold changed
- [ ] Reason stated below
- [ ] Effect on existing supplier tiers described (do not restate history; record
      the delta so scores remain comparable across the audit period)
- [ ] Commit is signed

Reason and effect:

<!-- Write here, or leave the n/a box ticked. -->

## Verification

- [ ] `make check` passes locally (markdown lint, YAML validation, secret scan)
- [ ] The `lint` status check passes on this pull request
- [ ] Every review conversation is resolved (`require_conversation_resolution` is
      enabled)
- [ ] Commits are signed off (`web_commit_signoff_required` is enabled)

Paste the output of `make check` below. A claim that verification passed, without
output, is not verification.

```text
<!-- paste output here -->
```

## Self-review

There is no second reviewer. Read your own diff before merging.

- [ ] I read the full diff, not just the files I intended to change
- [ ] I re-read any normative wording I changed — "must", "should" and "may" are
      deliberate and are not interchangeable
- [ ] Cross-references and relative links resolve
- [ ] Document header tables updated (`Version`, `Next review`)
- [ ] `CHANGELOG.md` entry added, naming the control affected
- [ ] I did not weaken a control to make an inconvenient supplier, deadline or
      score fit. Where a threshold seemed wrong, I changed the threshold
      deliberately above rather than working around it in a procedure

## Reviewer note

<!--
Optional, but valuable given the absence of independent review: state what you are
least confident about, and what you would want a reviewer to look at hardest.
Recording your own uncertainty is the closest available substitute for someone
else finding it.
-->
