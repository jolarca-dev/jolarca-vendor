# Due Diligence Standard

| | |
|---|---|
| Version | 1.0 |
| Status | Normative |
| Owner | `@JourneyOfLife` |
| Controls | SOC 2 CC9.2 · ISO A.5.19 · ISO A.5.21 · PCI DSS 12.8.3 |
| Aligned to | SIG Lite · CSA CAIQ v4 · ENISA supplier guidance |
| Next review | 2027-09-27 |

Due diligence runs **before** engagement, not after. SOC 2 CC9.2 is tested by
asking for the assessment of a supplier and comparing its date against the date
data first flowed. An assessment dated after the first production transaction is
a finding regardless of how thorough it is.

This document defines the questions and the evidence standard. Completed
responses are `confidential` and are filed in the supplier's folder in
`jolarca-compliance/vendor-assessments/` — never in this repository.

## 1. Evidence standard

Every answer falls into one of three classes. The class is recorded next to the
answer, because an uncorroborated assertion is the most common way a
questionnaire produces false assurance.

| Class | Meaning | Effect on CE domain |
|---|---|---|
| **E** — Evidenced | Independent artifact supplied: certification, audit report, penetration-test summary, policy document, screenshot of a configured control | May score 1.0 |
| **A** — Asserted | Supplier states the control exists; no artifact | Caps at 0.5 |
| **N** — Not addressed | Question unanswered, or answered "not applicable" without justification | Scores 0.0 |

"Not applicable" is a valid answer only where the supplier justifies it. An
unjustified "N/A" is recorded as **N**, not accepted.

Artifacts are checked for **currency and scope**, not merely existence. A SOC 2
report is acceptable only if the period is current, the opinion is unqualified,
and the systems description covers the service we consume. A certificate covering
a different product line of the same supplier is evidence of nothing and scores
as **A**.

## 2. Depth by tier

| Section | Tier 1 | Tier 2 | Tier 3 | Tier 4 |
|---|---|---|---|---|
| A. Corporate identity and stability | Full | Full | Abbreviated | Register only |
| B. Data handling and processing | Full | Full | Full | Skip |
| C. Governance and certification | Full | Full | Abbreviated | Skip |
| D. Technical security controls | Full, all **E** | Full, **E** or current attestation | Abbreviated | Skip |
| E. Operational security | Full | Full | Abbreviated | Skip |
| F. Transfer and jurisdiction | Full | Full | Mechanism only | Skip |
| G. Supply chain and sub-processors | Full | Full | List only | Skip |
| H. Resilience and exit | Full | Full | Exit note only | Skip |
| I. PCI DSS | Full if DS 5 | Full if DS 5 | Skip | Skip |

## 3. Section A — Corporate identity and stability

1. Registered legal name, jurisdiction of incorporation, and registered address.
2. Ultimate parent undertaking, and whether the parent is in a different
   jurisdiction.
3. Years trading; number of employees; whether the service is a core product line
   or an adjacent one.
4. Ownership changes, acquisitions or restructuring in the last 24 months, and
   any announced.
5. Financial viability indicator: funded, profitable, or part of a listed group.
6. Sanctions, export-control and debarment screening status.
7. Named account owner and named security contact with a reachable address, plus
   an out-of-band contact for incident notification.

**Why stability matters:** CC9.2 requires consideration of alternatives, and the
principal non-security vendor risk is commercial discontinuity. A supplier that
cannot fund continued operation fails in a way no control set mitigates — which
is why the 0.60 cap in
[`risk-scoring.md`](risk-scoring.md) §4 exists.

## 4. Section B — Data handling and processing

1. Exact data categories received from us, mapped to our RoPA identifiers.
2. Purpose of processing, and confirmation of no secondary use.
3. Whether the supplier uses our data to train models, build benchmarks, improve
   products, or for analytics. **For LLM and AI suppliers this question is asked
   explicitly and separately** — a general "we do not misuse customer data"
   answer does not cover model training, and the answer changes the DS factor.
4. Whether processing is automated decision-making within GDPR Art. 22, and
   whether profiling occurs.
5. Storage locations, including all regions and all backup locations.
6. Retention period, and the mechanism that enforces it.
7. Encryption at rest and in transit, with algorithms and key-management
   ownership — specifically, whether we hold keys the supplier cannot access.
8. Whether data is commingled with other customers' data, and the isolation
   mechanism.
9. Personnel access model: who can reach our data, on what approval, with what
   logging, and whether access is time-bound.
10. Confirmation that no personal data is used in non-production environments,
    or the pseudonymisation method if it is.

## 5. Section C — Governance and certification

1. ISO/IEC 27001 certificate: number, scope statement, certification body,
   issue and expiry dates. Request the scope statement, not just the certificate.
2. SOC 2 Type II report: period covered, opinion, systems description scope, and
   whether complementary user entity controls (CUECs) are listed. **CUECs are
   obligations transferred to us** and must be extracted and assigned, or the
   report provides less assurance than it appears to.
3. Any further certifications: ISO 27701, ISO 22301, CSA STAR, national schemes.
4. PCI DSS AoC where DS 5 — see Section I.
5. Independent penetration test within 12 months: scope, findings summary, and
   whether critical findings were remediated.
6. Information security policy: exists, approved, dated, reviewed within 12
   months, and communicated to staff.
7. Named role accountable for information security, and to whom it reports. A
   security function reporting into sales or engineering without an independent
   escalation path is recorded as a weakness.
8. Security awareness training: frequency and completion rate.
9. Joiner/mover/leaver process and average time to revoke access.
10. Disciplinary process for policy breach.

## 6. Section D — Technical security controls

1. MFA for all administrative access, and for all remote access.
2. Privileged access management: bastion or PAM tooling, session recording,
   just-in-time elevation.
3. Network segregation between production, non-production and corporate.
4. Vulnerability management: scan frequency, remediation SLA by severity, and
   evidence of the last scan cycle.
5. Patch management SLA for critical vulnerabilities.
6. Centralised logging: what is logged, retention period, and whether logs are
   protected from modification by the administrators they record.
7. Encryption key management: HSM or KMS, key rotation interval, and separation
   of duties between key custody and data access.
8. Secure development lifecycle: code review, static and dynamic analysis,
   dependency scanning, and pre-release security testing.
9. Change management: whether production changes require approval and whether
   they can be rolled back.
10. Malware and endpoint protection on the personnel estate.
11. Secrets management: whether credentials are held in a vault rather than in
    source control or configuration files.
12. Container and infrastructure-as-code security scanning where applicable.

## 7. Section E — Operational security

1. **Security incident notification: contractual commitment and actual target.**
   Both are requested. We require notification fast enough to meet our own
   Art. 33 72-hour obligation to the supervisory authority, so a supplier
   commitment longer than 48 hours is a material weakness and caps CE domain C4
   at 0.5. The supervisory authorities relevant to this platform are the
   Lithuanian VDAI, the Latvian DVI and the Estonian AKI.
2. Incident response plan: exists, tested within 12 months, and the date of the
   last test.
3. Whether the supplier has experienced a reportable breach in the last 36
   months, what data was involved, and what changed afterwards. Suppliers
   frequently answer "no" here; the answer is recorded as asserted unless
   corroborated.
4. Security monitoring: 24×7 or business-hours; in-house or MSSP; alert triage
   SLA.
5. Change notification to us for material service changes, with notice period.
6. Sub-processor change notification period and our right to object — see
   Section G.
7. Support model, SLA, and escalation path with named contacts.
8. Background screening of personnel with access to our data, to the extent
   local law permits.

## 8. Section F — Transfer and jurisdiction

1. All countries in which our data is processed, stored, backed up, or accessed
   from — including by support personnel, which is a transfer even where storage
   is in-region.
2. For each non-EU/EEA location: the transfer mechanism relied upon (adequacy
   decision, SCCs, or another Art. 46 derogation).
3. Whether SCCs are executed and which module.
4. Whether the supplier is subject to FISA 702, CLOUD Act, or equivalent
   third-country government access legislation.
5. Government access request policy: whether the supplier commits to notifying
   us, challenging unlawful requests, and minimising disclosure.
6. Whether an EU-region commitment is contractual or merely a default
   configuration. A default is not a commitment; only a contractual one prevents
   silent relocation.
7. Data localisation guarantees for backup and disaster-recovery copies.

A completed TIA is required where the mechanism is SCCs. The TIA is
**self-authored by us**; the supplier supplies the DPA and SCCs as inputs and
does not issue the TIA. Filed in `jolarca-compliance/vendor-assessments/tia/`.

## 9. Section G — Supply chain and sub-processors

1. Complete list of sub-processors with legal name, jurisdiction, function, and
   the data categories each receives. A published web page is not an acceptable
   answer — request the list current as at the assessment date.
2. Whether the supplier imposes equivalent security obligations on its
   sub-processors, and how that is evidenced.
3. Contractual notice period for adding or replacing a sub-processor. We require
   **at least 30 days**; anything less caps CE domain C4.
4. Our right to object, and the consequence of a sustained objection —
   specifically, whether objection entitles us to terminate without penalty.
5. Whether any sub-processor is a fourth party we would not otherwise know
   about, and whether the supplier maintains the chain beyond tier one.
6. Whether any sub-processor is in a jurisdiction that would create a new
   transfer requiring its own mechanism.

ISO A.5.21 requires the ICT supply chain to be identified, not merely
acknowledged. "See vendor documentation" is recorded as **N**.

## 10. Section H — Resilience and exit

1. RTO and RPO commitments, and whether they are contractual or best-effort.
2. Backup frequency, retention, geographic separation, and whether restore is
   tested — request the date of the last successful restore test.
3. Failover architecture and whether failover crosses jurisdictions.
4. Business continuity plan and last exercise date.
5. **Data export:** formats available, whether export is self-service or
   requires supplier action, and whether it includes all data categories we sent.
6. **Data deletion:** whether deletion is guaranteed on termination, the maximum
   time to complete it, whether it extends to backups, and whether written
   confirmation of erasure is provided.
7. Whether escrow of source code or data is available where the service is
   business-critical.
8. Termination assistance period and cost.
9. Known lock-in: proprietary formats, absence of an import path to any named
   alternative.

**CC9.2 requires alternatives to be considered.** Questions 5–9 are the evidence
for that limb. Where a supplier cannot answer 5 or 6 satisfactorily, an
alternative is identified and the switching cost recorded in the assessment
before approval, not discovered during an exit.

## 11. Section I — PCI DSS (DS 5 only)

1. Current Attestation of Compliance: version, validation date, assessing QSA or
   SAQ route, and the **exact scope description**.
2. Whether the scope covers the specific service we consume. An AoC for the
   supplier's gateway does not cover its analytics platform.
3. Which PCI DSS requirements the supplier is responsible for and which transfer
   to us, captured in the signed
   [`responsibilities-matrix.md`](../agreements/responsibilities-matrix.md).
4. Whether cardholder data is stored, processed, or merely transmitted, and
   whether PAN is truncated or tokenised at the boundary.
5. Contractual acknowledgment of responsibility for cardholder data, per
   PCI DSS 12.8.2.
6. Whether the supplier permits us to verify compliance status annually, per
   12.8.4, and the mechanism.

AoC documents are generally **not** public downloads. Where the supplier
distributes them through a customer dashboard, record who retrieved the document,
when, and the document version and date. An undated AoC of unknown provenance is
recorded as **A**.

## 12. Completion and filing

1. Questionnaire issued; responses received with evidence class marked per answer.
2. Factors DS, BC and AB assigned, citing the row used from
   [`risk-scoring.md`](risk-scoring.md) §1.
3. CE domains C1–C5 scored from the evidence classes.
4. IRS, CE and RRS calculated; band and tier derived per
   [`tiering-rubric.md`](tiering-rubric.md).
5. Conditions raised for every **A** or **N** answer in a mandatory section,
   each with an owner and a date.
6. Assessment filed in the supplier's folder in
   `jolarca-compliance/vendor-assessments/`, register updated in the same change,
   and RoPA updated where a new recipient is introduced.
7. Approval recorded as a signed commit per
   [`../solo-operator-controls.md`](../solo-operator-controls.md).

No production data flows before step 6 is merged.
