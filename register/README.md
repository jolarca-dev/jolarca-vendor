# Vendor Register — Index

**This repository does not hold the vendor register.**

## Authoritative location

| Artifact | Location |
|---|---|
| Machine-readable register | `jolarca-compliance/vendor-assessments/register.csv` |
| Human-readable register | `jolarca-compliance/vendor-assessments/register.md` |
| Per-supplier folders | `jolarca-compliance/vendor-assessments/<vendor>/` |
| Transfer Impact Assessments | `jolarca-compliance/vendor-assessments/tia/` |
| RoPA recipients (GDPR Art. 30) | `jolarca-compliance/ropa/master-register.csv` |
| Executed contracts | `jolarca-legal/contracts/vendors/` |

Both register formats are updated **in the same change**. The parity check in
`jolarca-compliance` (`scripts/vendor-review-dates.py`, run by `make check` and by
the `vendor-review-due.yml` workflow) reconciles the register against the
supplier folders and fails CI on drift.

## Why the register is not here

Two reasons, either of which is sufficient.

**One source of truth.** A second register copy diverges. When it does, neither
copy can be relied upon, and an auditor sampling both finds contradictory DPA
statuses, transfer positions and review dates for the same supplier. Under
SOC 2 CC9.2 and ISO A.5.22 that reads as an uncontrolled process — which is a
worse outcome than a single register with visible gaps, because gaps can be
remediated while contradictory evidence undermines confidence in the whole
system.

**Classification.** Register content is `confidential`. It names suppliers
alongside their data categories, transfer positions and control status. This
repository is `public` and classified `internal`, and
`jolarca-control/scripts/validate_repos.py` forbids `confidential` content in a
public repository. Publishing which suppliers hold cardholder or special-category
data, and which lack a signed DPA, would disclose our weakest points to anyone
reading the repository.

## What is defined here

[`schema.md`](schema.md) — the field contract for the register: required columns,
permitted values, validation rules, and the parity rules that keep the two
formats and the supplier folders consistent.

The register lives elsewhere; its **shape** is governed here, because the shape is
what makes the methodology in [`../docs/methodology/`](../docs/methodology/)
executable and what allows the currency and parity gates to run.

## Reading the register

Statuses, per the register's own vocabulary:

| Status | Meaning |
|---|---|
| `onboarding` | Assessment in progress; **no production data may flow** |
| `active` | Assessed, approved, agreement in place; data flows within the assessed scope |
| `renewal-due` | Reassessment or DPA renewal window open |
| `terminated` | Relationship ended; erasure not yet certified |
| `data-returned` | Relationship ended and written erasure certification held |

`onboarding` is a transient state. A supplier that remains `onboarding` while its
integration carries production traffic is the single most common defect in a
vendor register, and it is detectable by comparing the register against actual
integration activity — see
[`../docs/procedures/offboarding-exit.md`](../docs/procedures/offboarding-exit.md)
on dormant suppliers and
[`../docs/procedures/reassessment.md`](../docs/procedures/reassessment.md) on the
currency gate.

`terminated` and `data-returned` are distinct for a reason: the difference between
them is whether written erasure certification under GDPR Art. 28(3)(g) has been
obtained. Collapsing them loses the only evidence that deletion occurred.

Entries are never deleted. Terminated suppliers remain for the retention period
in [`../docs/evidence/retention-schedule.md`](../docs/evidence/retention-schedule.md),
because an audit examines a period and will ask about suppliers active during it.
