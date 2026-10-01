# Risk Scoring Methodology

| | |
|---|---|
| Version | 1.0 |
| Status | Normative |
| Owner | `@JourneyOfLife` |
| Applies to | Every supplier in the vendor register |
| Controls | SOC 2 CC9.2 · ISO A.5.19 · ISO A.5.21 · ISO A.5.22 |
| Next review | 2027-09-27 |

This document is **normative**. Any tooling that calculates a vendor risk score
must reproduce these formulas and weights exactly. If an implementation and this
document disagree, this document wins and the implementation is defective.

No implementation exists at the time of writing. That is recorded as a gap in
`jolarca-control/docs/drift-findings.md` per [`../gap-intake.md`](../gap-intake.md);
scoring is therefore performed manually using
[`../procedures/onboarding.md`](../procedures/onboarding.md) and the score is
recorded in the assessment.

## 1. Inputs

Three inherent-risk factors, each an integer 1–5, plus five control-effectiveness
domains, each a rational 0.0–1.0.

### 1.1 Data Sensitivity (DS)

The highest category of data the supplier can access or receive. Score on the
highest applicable row — never average downwards.

| DS | Definition | Examples |
|---|---|---|
| 1 | No personal data and no confidential business data | Public DNS, TLS certificate authority validating domain control only |
| 2 | Pseudonymised or scrubbed operational data; no direct identifiers | Aggregated telemetry with identifiers stripped |
| 3 | Personal data per GDPR Art. 4(1); no special categories | Name, contact details, order and shipping address |
| 4 | Special-category data per Art. 9, KYC identity documents, or authentication credentials | Identity verification documents, biometric data, API credentials with production scope |
| 5 | Cardholder data (PAN), or special-category data at scale | Payment processing where PAN transits or is stored |

A supplier scoring DS 5 brings PCI DSS Requirement 12.8 into scope; see
[`../procedures/pci-tsp-management.md`](../procedures/pci-tsp-management.md).

### 1.2 Business Criticality (BC)

The consequence of the supplier becoming unavailable.

| BC | Definition |
|---|---|
| 1 | Absence is invisible to customers and to operations |
| 2 | Degraded experience; manual workaround available within hours |
| 3 | A single marketplace feature is unavailable; workaround within one business day |
| 4 | Core marketplace function impaired; direct revenue impact |
| 5 | The marketplace cannot operate — payments or fulfilment halted |

### 1.3 Access Breadth (AB)

How much of our environment and data the supplier can reach, including through
its own sub-processors.

| AB | Definition |
|---|---|
| 1 | No access to our systems or data; wholly external service |
| 2 | Read-only or narrowly scoped access to non-production data |
| 3 | Production access scoped to one system or one data category |
| 4 | Production access spanning multiple systems or data categories |
| 5 | Administrative production access, or our data is replicated to the supplier's sub-processors at scale |

## 2. Inherent risk

Weighted sum. The weights express that data exposure dominates vendor risk,
because it is the factor that converts a supplier failure into a regulatory
event rather than merely an operational one.

```text
IRS = (DS × 0.50) + (BC × 0.30) + (AB × 0.20)
```

Range: 1.00 (all factors 1) to 5.00 (all factors 5). Weights sum to 1.00.

IRS is calculated **before** considering any supplier control. It answers: how
bad is this relationship if the supplier's security were irrelevant?

## 3. Control effectiveness

Five domains, each scored 0.0, 0.5, or 1.0. Evidence — not assertion — is
required for 1.0. A supplier claim in a sales document scores 0.5 at most.

| # | Domain | 1.0 | 0.5 | 0.0 |
|---|---|---|---|---|
| C1 | Contractual | DPA per Art. 28 signed and current, plus the security requirements schedule | DPA drafted, or signed but expiring within 90 days | No DPA, or DPA expired |
| C2 | Certification | SOC 2 Type II or ISO 27001 certificate, in period, scope covers the service we consume | SOC 2 Type I, ISO certificate with partial scope, or PCI AoC covering only part of the service | None, or self-asserted only |
| C3 | Technical | Encryption in transit and at rest, MFA for administrative access, vulnerability management, and security logging all **evidenced** | Same controls asserted but not evidenced | Not addressed in the questionnaire response |
| C4 | Operational | Breach notification within 72 hours enabling our Art. 33 duty; sub-processor change notice of at least 30 days with a right to object; support SLA defined | Some but not all of the three | None contractually committed |
| C5 | Transfer | For any non-EU/EEA transfer: a completed Transfer Impact Assessment and a valid mechanism (adequacy decision or SCCs) | Valid mechanism in place but the TIA is outstanding | A transfer is occurring with no mechanism |

**C5 when no transfer occurs:** score 1.0 and record the reason as
`no-transfer` in the assessment. A domain that is not applicable is scored and
justified; it is never silently omitted, because omitting it inflates the mean
and hides the reasoning from an auditor.

```text
CE = (C1 + C2 + C3 + C4 + C5) ÷ 5
```

Range: 0.00 to 1.00.

## 4. Residual risk

```text
RRS = IRS × (1 − (CE × 0.60))
```

The **0.60 cap is deliberate and must not be raised**. A perfect control set
(CE = 1.00) removes at most 60% of inherent risk. Rationale: supplier controls
mitigate the likelihood and detectability of a failure, but they cannot mitigate
our own dependency on the supplier, its sub-processor chain, its jurisdiction,
or its commercial continuity. A supplier holding PAN with an exemplary SOC 2
report still exposes us if it is acquired, sanctioned, or exits the market.

Capping the reduction prevents the most common vendor-risk error: treating a
current attestation as the elimination of risk.

Best case with CE = 1.00: `RRS = IRS × 0.40`. Worst case with CE = 0.00:
`RRS = IRS`.

### 4.1 Bands

| RRS | Band | Disposition |
|---|---|---|
| < 1.50 | Low | Accept. Standard monitoring per tier. |
| 1.50 – 2.49 | Moderate | Accept with named conditions and a remediation date per condition. |
| 2.50 – 3.49 | High | Requires documented compensating controls **and** a recorded risk acceptance before any data flows. |
| ≥ 3.50 | Critical | Do not engage. If already engaged, no new data flows until RRS is reduced below 3.50. |

Risk acceptance is recorded per
[`../solo-operator-controls.md`](../solo-operator-controls.md) as a signed
commit, since there is no second approver.

## 5. Worked example (synthetic)

A supplier providing hosted object storage for order documents. No real vendor;
illustrative only.

Inputs: personal data including addresses (DS 3); fulfilment depends on it
(BC 4); production access scoped to one system (AB 3).

```text
IRS = (3 × 0.50) + (4 × 0.30) + (3 × 0.20)
    = 1.50 + 1.20 + 0.60
    = 3.30
```

Controls: DPA signed and current (C1 = 1.0); SOC 2 Type II in period, scope
covers the service (C2 = 1.0); encryption and MFA asserted in the questionnaire
but no evidence supplied (C3 = 0.5); 30-day breach notice rather than 72-hour
and no right to object to sub-processors (C4 = 0.5); EU-region commitment with
no TIA on file (C5 = 0.5).

```text
CE  = (1.0 + 1.0 + 0.5 + 0.5 + 0.5) ÷ 5 = 3.50 ÷ 5 = 0.70
RRS = 3.30 × (1 − (0.70 × 0.60))
    = 3.30 × (1 − 0.42)
    = 3.30 × 0.58
    = 1.914  → 1.91
```

Band: **Moderate**. Disposition: accept with named conditions — obtain C3
evidence, amend the agreement to 72-hour notification and a right to object,
and complete the TIA. Each condition carries a date. Tier is then derived from
[`tiering-rubric.md`](tiering-rubric.md), not from RRS alone.

Note the effect of the cap: a strong SOC 2 report moved RRS from 3.30 to 1.91,
not to 1.32. The relationship remains a Moderate risk because the dependency
itself is not mitigated by the supplier's attestation.

## 6. Recalculation triggers

RRS is recalculated, and the assessment re-approved, when any of the following
occurs. This discharges the "periodic reassessment" limb of CC9.2 and the
change-management limb of A.5.22.

1. Scheduled reassessment falls due per the tier cadence.
2. The supplier notifies a change of sub-processors (A.5.21).
3. The supplier notifies a security incident affecting our data.
4. A certification lapses, is withdrawn, or its scope changes.
5. The data categories we send change — in particular any move to DS 4 or DS 5.
6. The supplier is acquired, changes controlling jurisdiction, or announces a
   material service change or end-of-life.
7. Our own use of the service changes such that BC or AB increases.

Triggers 2–7 are event-driven and take precedence over the schedule. An
event-driven recalculation resets the scheduled review date.

## 7. Changing this methodology

Weights and the 0.60 cap are change-controlled. A change requires:

1. A pull request amending this file, stating the reason.
2. Re-scoring of every Tier 1 and Tier 2 supplier under both the old and new
   weights, with the delta recorded, so that historical scores remain
   comparable across an audit period.
3. A signed commit by the owner (see
   [`../solo-operator-controls.md`](../solo-operator-controls.md)).
4. A version bump in the header table and a `CHANGELOG.md` entry.

Retrospectively re-scoring history without recording the delta destroys the
comparability that CC9.2 periodic reassessment relies on, and is not permitted.

## 8. Known limitations

Stated plainly, because an undocumented limitation becomes an audit finding.

- **Ordinal inputs treated as interval.** DS, BC and AB are ordinal scales; the
  weighted sum assumes equal spacing between levels. This is a standard
  simplification in vendor risk models and is accepted, but a move from DS 3 to
  DS 4 is not necessarily the same increase in exposure as DS 1 to DS 2.
- **Single-assessor subjectivity.** With one operator there is no calibration
  against a second scorer. Mitigated by the published rubric above, which
  constrains judgement to defined rows, and by requiring the row cited in each
  assessment.
- **CE granularity is coarse.** Three permitted values per domain means a
  supplier marginally short of a requirement scores the same as one wholly
  absent. Accepted deliberately: finer granularity would imply precision the
  underlying evidence does not support.
- **No quantitative loss modelling.** RRS is a prioritisation ordinal, not a
  monetary expected loss. It must not be used as an input to financial
  provisioning without a separate model.
