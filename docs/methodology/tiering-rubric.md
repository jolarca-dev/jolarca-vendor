# Vendor Tiering Rubric

| | |
|---|---|
| Version | 1.0 |
| Status | Normative |
| Owner | `@JourneyOfLife` |
| Controls | SOC 2 CC9.2 · ISO A.5.19 · ISO A.5.22 · PCI DSS 12.8.3 |
| Next review | 2027-09-27 |

Tier determines **how much** due diligence, monitoring and contractual protection
a supplier receives. Inputs come from
[`risk-scoring.md`](risk-scoring.md): the residual risk score (RRS) and the data
sensitivity factor (DS).

## 1. Why tier is not derived from RRS alone

RRS is a residual measure — it already reflects the supplier's controls. Deriving
tier from RRS alone produces a circular and gameable result: a supplier with weak
contractual protection scores poorly, is placed in a high tier, receives heavy
scrutiny, and improves; but a supplier with a strong SOC 2 report and no signed
DPA can score a low RRS and thereby escape the very contractual obligation it is
missing.

Data sensitivity is therefore an **independent floor**. It cannot be mitigated
away by the supplier's controls, because it describes what we hand over, not how
well they protect it.

```text
Tier = max( tier_from_rrs(RRS), tier_floor_from_ds(DS) )
```

where a lower tier number means more scrutiny, so `max` selects the stricter of
the two. Both inputs are recorded in the assessment, with the row cited from
each table below.

## 2. Tier from residual risk

| RRS | tier_from_rrs |
|---|---|
| ≥ 2.50 | 1 |
| 2.00 – 2.49 | 2 |
| 1.50 – 1.99 | 3 |
| < 1.50 | 4 |

## 3. Tier floor from data sensitivity

| DS | tier_floor_from_ds | Reason |
|---|---|---|
| 5 — cardholder data, or special category at scale | 1 | PCI DSS 12.8 applies in full; GDPR Art. 9 exposure |
| 4 — special category, KYC documents, credentials | 1 | Art. 9 and Art. 32 obligations; DPIA linkage |
| 3 — personal data | 2 | Art. 28 processor contract mandatory; Art. 30 RoPA entry |
| 2 — pseudonymised operational data | 3 | Re-identification risk is not zero |
| 1 — no personal or confidential data | 4 | Register entry sufficient |

A supplier at DS 5 is Tier 1 even with a perfect control set. The lowest residual
score reachable at DS 5 is with BC 1 and AB 1, giving `IRS = (5 × 0.50) +
(1 × 0.30) + (1 × 0.20) = 3.00`, and `CE = 1.00` giving
`RRS = 3.00 × 0.40 = 1.20` — a **Low** band. The floor still forces Tier 1,
which is precisely its purpose: band measures how well the supplier is controlled,
while the floor measures what we would lose if those controls failed.

## 4. Tier obligations

### Tier 1 — Critical

Suppliers whose failure or compromise is a regulatory event.

| Obligation | Requirement |
|---|---|
| Due diligence before engagement | Full questionnaire per [`due-diligence.md`](due-diligence.md), all sections |
| Assessment | Full written assessment, inherent and residual scoring, all five CE domains evidenced |
| Agreement | DPA (Art. 28) **and** the [`security-requirements-schedule.md`](../agreements/security-requirements-schedule.md) **and** a signed [`responsibilities-matrix.md`](../agreements/responsibilities-matrix.md) |
| Transfer | Completed TIA for any non-EU/EEA transfer, before the first transfer |
| PCI DSS | If DS 5: all of 12.8.1–12.8.5, including annual confirmation of the supplier's own compliance status and a current AoC |
| Reassessment cadence | **Every 12 months**, and on any trigger in [`risk-scoring.md`](risk-scoring.md) §6 |
| Audit right | Contractual right to audit or to accept an equivalent independent report |
| Exit plan | Mandatory, documented, tested against the supplier's stated data-return capability before approval |
| Sub-processor review | Every notification reviewed within **14 days**; objection right exercised where the sub-processor is inadequate |
| Approval | Recorded risk acceptance as a signed commit before any data flows |

### Tier 2 — Significant

| Obligation | Requirement |
|---|---|
| Due diligence | Full questionnaire; the technical-evidence section may be satisfied by a current attestation report |
| Assessment | Written assessment with scoring; CE domains C1 and C5 always evidenced, C2–C4 may rest on attestation |
| Agreement | DPA **and** the security requirements schedule |
| Transfer | Completed TIA for any non-EU/EEA transfer |
| Reassessment cadence | **Every 12 months**, and on any §6 trigger |
| Audit right | Preferred; may be substituted by an annual attestation refresh |
| Exit plan | Documented. Data return and erasure confirmed in writing at offboarding |
| Sub-processor review | Within **14 days** |

### Tier 3 — Limited

| Obligation | Requirement |
|---|---|
| Due diligence | Abbreviated questionnaire: identity, data categories, hosting region, certification, breach notification |
| Assessment | Scored entry in the register with a short written rationale; full assessment document not required |
| Agreement | DPA where any personal data is processed; otherwise the supplier's standard terms plus the security requirements schedule |
| Transfer | Mechanism confirmed (adequacy or SCCs). A full TIA is required only where the mechanism is SCCs |
| Reassessment cadence | **Every 24 months**, and on any §6 trigger |
| Exit plan | One-paragraph exit note: what data they hold and how it is returned or erased |
| Sub-processor review | Within **30 days** |

### Tier 4 — Minimal

Suppliers with no access to personal or confidential data.

| Obligation | Requirement |
|---|---|
| Due diligence | Register entry only: legal name, service, DS/BC/AB factors, and the DS 1 justification |
| Assessment | Scoring recorded; no assessment document |
| Agreement | Supplier standard terms acceptable |
| Reassessment cadence | **Every 36 months** confirmation that DS remains 1, and on any §6 trigger |
| Exit plan | Not required |
| Sub-processor review | Not required unless DS rises |

**DS 1 must be justified, not assumed.** A supplier that validates domain control
for TLS certificates touches no personal data; a supplier that receives
scrubbed telemetry may still permit re-identification. The justification is one
sentence in the register entry and is the thing an auditor will test, because
Tier 4 is where undeclared personal data hides.

## 5. Promotion and demotion

Tier is recalculated at every reassessment and on every §6 trigger.

**Promotion** (to a stricter tier) takes effect immediately. The obligations of
the new tier that are not yet met become conditions with dates, and no new data
categories flow until the agreement obligations of the new tier are satisfied.

**Demotion** (to a weaker tier) requires **two consecutive reassessment cycles**
at the lower tier's score, and must be recorded with both scores. A single good
cycle does not reduce scrutiny. Rationale: control effectiveness is frequently
transient — a certification obtained for a sales cycle, a TIA completed under
audit pressure — and demoting on one observation removes the check that caught
the regression.

Demotion is never permitted where it would remove a PCI DSS 12.8 obligation while
DS remains 5, or an Art. 28 obligation while DS remains 3 or above.

## 6. Overrides

The owner may override a computed tier upward only — never downward. An override
requires a recorded reason in the assessment and a `CHANGELOG.md` entry. A
downward override would defeat the DS floor and is not permitted under any
circumstances, including commercial pressure or supplier insistence.

## 7. Register fields required by this rubric

The authoritative register must carry these columns for the rubric to be
executable. The field contract is in
[`../../register/schema.md`](../../register/schema.md).

`vendor`, `tier`, `ds`, `bc`, `ab`, `irs`, `ce`, `rrs`, `band`, `tier_from_rrs`,
`tier_floor_from_ds`, `override`, `override_reason`, `next_review`, `cadence_months`,
`consecutive_cycles_at_current_tier`, `status`.

Where the existing register lacks the scoring columns, the tier in force is the
one most recently recorded and the gap is logged per
[`../gap-intake.md`](../gap-intake.md) rather than back-filled with invented
scores.
