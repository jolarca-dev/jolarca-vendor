# Gap and Finding Intake

| | |
|---|---|
| Version | 1.0 |
| Status | Normative |
| Owner | `@JourneyOfLife` |
| Controls | ISO A.5.22 · SOC 2 CC9.2 · CC4.1 · GDPR Art. 5(2) |
| Next review | 2027-09-27 |

## Purpose

To define where a control gap in vendor management is recorded, and to state
explicitly why it is **not** recorded here.

## Why gaps are not recorded in this repository

This repository is `public`. A control gap is a statement about where our
defences are weakest. Publishing a list of unassessed suppliers, unsigned DPAs,
missing transfer impact assessments and unapproved policies would:

1. Tell an adversary precisely which supplier relationships to target, and which
   of them lack contractual incident notification.
2. Disclose supplier-confidential findings that we are obliged by agreement to
   keep confidential — publishing them would itself breach the contract the gap
   concerns.
3. Disclose personal data processing gaps, engaging Art. 5(1)(f) and potentially
   Art. 33 considerations.
4. Prejudice our position in a regulatory inquiry by publishing an
   unremediated-findings list of our own authorship.

A public compliance repository that documents its own open weaknesses is not
transparent; it is negligent. Transparency about **method** is appropriate and is
what this repository provides. Transparency about **findings** is not.

Accordingly, this repository contains no register data, no assessment findings,
no risk scores for named suppliers, no contract terms, and no gap list. The CI
secret and PII scan enforces the boundary mechanically rather than relying on
author discipline.

## Where gaps are recorded instead

| Gap type | Authoritative location | Why there |
|---|---|---|
| Governance and configuration deviations across the estate | `jolarca-control/docs/drift-findings.md` | The established deviation register, with numbered findings, severity, status, blocking flags and dated corrections |
| A supplier's missing or deficient assessment, DPA, TIA or AoC | The supplier's assessment in `jolarca-compliance/vendor-assessments/<vendor>/` | Keeps the gap next to the record it concerns, so remediation and evidence live together |
| A process defect in vendor management | An issue against `jolarca-compliance`, cross-referenced from the affected assessment | Issues are enabled on this repository but process defects belong where the process runs |
| A defect in this repository's own governance documents | An issue against `jolarca-vendor` | Method defects are not confidential and may be public |
| A security weakness in a supplier's product | `jolarca-compliance/incidents/` under the incident process | Incident handling has its own escalation and notification clock |
| An audit exception raised by an external assessor | `jolarca-compliance/audits/` | Audit findings are tracked with the audit they came from |

The estate deviation register is the correct home for cross-cutting findings
because it already carries severity, blocking status, ownership, and a correction
history with dates. Creating a parallel findings list in a second repository
would fragment the record — the same failure mode this repository exists to
prevent for registers.

## Recording a gap

Wherever it is filed, a gap record contains:

| Field | Requirement |
|---|---|
| Identifier | Stable and unique within its register |
| Description | What is absent or deficient, in one factual sentence |
| Control affected | The specific clause — for example ISO A.5.21, PCI DSS 12.8.4, GDPR Art. 28(3)(g) |
| Evidence | What was observed that establishes the gap, with dates |
| Severity | Graded against the register's own scale |
| Exposure period | From when the gap existed, and whether data flowed during it |
| Compensating control | What is operating in the meantime, or an explicit statement that nothing is |
| Remediation | The action, and a date |
| Owner | A natural person |
| Status | Open, in remediation, remediated, or accepted |
| Acceptance basis | Where accepted: who accepted, why, and the review date |

**Exposure period is mandatory and is the field most often omitted.** A gap
discovered today may have existed for two years, and the difference between those
two positions is material to whether a notification obligation arose. Recording
the discovery date without the exposure period understates the finding.

## Severity

| Level | Definition | Response |
|---|---|---|
| S1 | Unlawful processing occurring now, or cardholder data exposed without required controls | Suspend the data flow; remediate immediately; assess notification duty |
| S2 | A required control absent for a Tier 1 or Tier 2 supplier | Remediation dated within 30 days; no new data categories until closed |
| S3 | A required control absent for a Tier 3 or Tier 4 supplier, or evidence missing for a control that is operating | Remediation dated within 90 days |
| S4 | Documentation defect with no control impact | Remediation dated within the next cycle |

## Acceptance

A gap may be accepted rather than remediated, where the cost of remediation
exceeds the risk. Acceptance requires:

1. A written reason that addresses the risk, not the effort.
2. Any compensating control that is operating.
3. A review date no more than 12 months out.
4. A signed commit by the operator acting as risk owner — see
   [`solo-operator-controls.md`](solo-operator-controls.md).

Acceptance is **not available** for:

- Processing of personal data at DS ≥ 3 without an executed Art. 28 DPA. This is
  an infringement in progress, not a risk to be accepted.
- A transfer to a third country with no valid mechanism.
- Cardholder data handled by a provider with no current AoC and no compensating
  scope reduction.
- Any S1.

These are remediate-or-suspend decisions. There is no third option, and recording
one as "accepted" does not make it so.

## Escalation to notification

Where a gap indicates that personal data may have been processed unlawfully, or
that a breach may have occurred undetected during the exposure period, the
question of notification under GDPR Art. 33 or Art. 34 is assessed **before**
remediation planning, and the assessment is recorded even where the conclusion is
that no notification is due.

Remediating first and assessing notification afterwards is the common error: it
destroys the contemporaneous record of when we became aware, which is the fact
the 72-hour clock runs from.

## Closing

A gap closes only on evidence. For each closure, record what was produced — the
executed DPA, the filed TIA, the retrieved AoC with its date — and hash it into
the evidence registry per [`evidence/conventions.md`](evidence/conventions.md).

Closure without evidence is a status change, not a remediation, and it will not
survive sampling.
