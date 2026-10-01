# Evidence Conventions

| | |
|---|---|
| Version | 1.0 |
| Status | Normative |
| Owner | `@JourneyOfLife` |
| Controls | SOC 2 CC9.2 · ISO A.5.22 · PCI DSS 12.8.4 · GDPR Art. 5(2) |
| Next review | 2027-09-27 |

## Principle

**An undocumented control did not operate.** For SOC 2 Type II the evidence must
show operation across the period under review, not merely at a point in time. For
PCI DSS 12.8.4 the annual verification must be attributable and dated. For GDPR
Art. 5(2) we must be able to demonstrate compliance, not assert it.

Evidence is collected **as the work happens**. Evidence reconstructed for an
audit is distinguishable — from document metadata, from commit timestamps, from
the absence of contemporaneous correspondence — and reconstruction is itself a
finding about integrity that is far more serious than the original gap.

## Storage

Vendor evidence is `confidential` and is stored in
`jolarca-compliance/vendor-assessments/<vendor>/` and, for contracts,
`jolarca-legal/contracts/vendors/<vendor>/`.

**No vendor evidence is stored in this repository.** It is `public` and
classified `internal`; assessment findings and contract terms are neither. This
document defines the conventions that those repositories follow.

## Naming

```text
YYYY-MM-DD_<vendor-slug>_<artifact>_<version>.<ext>
```

| Element | Rule |
|---|---|
| `YYYY-MM-DD` | The date the evidence **pertains to**, not the date it was filed. For a report covering a period, use the period end date |
| `vendor-slug` | Lowercase, hyphenated, matching the register's `vendor` value exactly |
| `artifact` | Controlled vocabulary below |
| `version` | `v1`, `v2`, … incremented on re-issue; never overwritten in place |

Artifact vocabulary:

| Artifact | Use |
|---|---|
| `assessment` | The risk assessment document |
| `questionnaire` | Completed due-diligence responses |
| `soc2-type2` | SOC 2 Type II report |
| `soc2-type1` | SOC 2 Type I report |
| `iso27001-cert` | ISO 27001 certificate |
| `iso27001-scope` | Scope statement, where issued separately |
| `pci-aoc` | PCI DSS Attestation of Compliance |
| `pentest-summary` | Penetration test summary |
| `dpa` | Executed data processing agreement |
| `scc` | Executed Standard Contractual Clauses with annexes |
| `tia` | Transfer Impact Assessment |
| `resp-matrix` | Signed responsibilities matrix |
| `subprocessors` | Sub-processor list as at a date |
| `erasure-cert` | Written certification of deletion |
| `correspondence` | Material correspondence, including objections and refusals |
| `incident` | Supplier incident notification and our triage |

Matching the register's `vendor` value exactly is what allows automated
reconciliation between the register and the evidence folders. A supplier folder
spelled differently from the register entry is invisible to the parity check and
silently accumulates unverified evidence.

## Integrity hashing

Every finalized evidence item is hashed into
`jolarca-compliance/audits/evidence-registry.csv` using the house tooling
(`scripts/evidence-hash.py`, invoked as `make hash-evidence` and verified by
`make verify-signatures`).

The hash serves two purposes:

1. **Tamper detection.** If a file changes after registration, verification
   fails. This is what allows a document produced years later to be shown to be
   the document that existed at the time.
2. **Non-repudiation of sequence.** Combined with commit history, it establishes
   that an assessment existed before the data flow it authorises — the evidence
   for PCI DSS 12.8.3 and for the pre-engagement limb of CC9.2.

Rules:

- Hash **after** the document is final. Re-hashing an amended document without
  recording the amendment destroys the sequence evidence.
- Superseded versions retain their hash entries. Deletion of a superseded entry
  looks like concealment and is not done; the entry is marked superseded with a
  pointer to the successor.
- Verification runs in CI. A failing hash check blocks the merge.

## Provenance

For every externally sourced document — attestation, certificate, AoC — record:

| Field | Why |
|---|---|
| Who retrieved it | Attributability. "Someone downloaded it" is not provenance |
| Retrieval date | Establishes currency at the time of reliance |
| Source channel | Customer dashboard, support request, supplier portal, email |
| Document version or identifier | Distinguishes re-issues |
| Period covered | The single most important field for an attestation |
| Scope statement | Whether it covers the service we consume |

Provenance is recorded because PCI AoCs and most SOC 2 reports are **not public
downloads**. Without a retrieval record there is no way to distinguish a
genuinely obtained current document from a stale copy of unknown origin — and an
assessor is entitled to treat an undated, unsourced report as no evidence at all.

## Currency

| Evidence type | Maximum age at reliance |
|---|---|
| SOC 2 Type II | Period end within 12 months, and continuous with the prior report |
| ISO 27001 certificate | Within its stated validity, surveillance audit current |
| PCI AoC | Validation date within 12 months |
| Penetration test | Within 12 months |
| Sub-processor list | As at the assessment date; refresh if older than 90 days |
| Insurance certificate | Within 12 months |
| DPA | Executed and unexpired |

A **gap between consecutive SOC 2 periods** is treated as a lapse in assurance,
not a formality. Continuous coverage is the point of an annual report.

## Sufficiency — what is not evidence

| Not evidence | Why | What is required |
|---|---|---|
| A supplier's marketing or trust-centre page | Uncontrolled, undated, not specific to us | The attestation or a dated written response |
| "See vendor documentation" in an assessment | Defers the answer indefinitely | The enumerated list or the specific control |
| An unsigned questionnaire | No accountability for the answers | Signature or a dated covering email from an authorised representative |
| A certificate without its scope statement | Scope is what determines relevance | Certificate plus scope |
| A screenshot with no date or context | Cannot be tied to a period | Date, system, and the configuration shown |
| A verbal assurance recorded as accepted | Not testable | Written confirmation |
| An assessment identical to the prior cycle | Indicates carry-forward, not re-performance | Re-derived scoring with deltas recorded |
| A document dated after the activity it authorises | Defeats the sequence control | Contemporaneous record; if absent, record the gap honestly |

## Retention

Per [`retention-schedule.md`](retention-schedule.md). Evidence supporting an
audit period is retained for the period plus the statutory and contractual
minimum, and is **not** deleted merely because the supplier relationship has
ended — offboarding closes the relationship, not the record.

## Classification and publication

| Classification | Permitted location |
|---|---|
| `internal` | This repository; other internal repos |
| `confidential` | Private repositories only; never this repository |
| `restricted` | Private repositories only, with encryption at rest and access logging |

`jolarca-control/scripts/validate_repos.py` enforces that `confidential` and
`restricted` content cannot live in a `public` repository. The CI secret and PII
scan in this repository is the second gate, and it exists because the boundary is
easy to cross accidentally — a supplier name in an example, an email address in
a procedure, a real risk score in a worked example.

Where an artifact must be shared externally with an auditor, it is shared
directly from its confidential location under the disclosure process in
`jolarca-compliance/policies/02-data-protection-privacy.md`, not by promotion to
a public repository.
