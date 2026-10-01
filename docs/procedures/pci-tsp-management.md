# Procedure — PCI DSS Third-Party Service Provider Management

| | |
|---|---|
| Version | 1.0 |
| Status | Normative |
| Owner | `@JourneyOfLife` |
| Controls | PCI DSS v4.0 Requirement 12.8.1–12.8.5 · SOC 2 CC9.2 · ISO A.5.19 |
| Applies when | A supplier stores, processes or transmits cardholder data, **or** can affect the security of cardholder data (DS 5) |
| Next review | 2027-09-27 |

## Applicability

Requirement 12.8 applies to a third-party service provider (TPSP) where the TPSP
stores, processes, or transmits cardholder data on our behalf, **or** where it
could affect the security of cardholder data. The second limb is broader and is
the one usually missed: a provider that never touches a PAN but manages the
firewall, the hosting platform, or the payment application still falls within
12.8.

DS 5 per [`../methodology/risk-scoring.md`](../methodology/risk-scoring.md) §1.1
is the trigger. Any supplier assessed at DS 5 runs this procedure alongside
[`onboarding.md`](onboarding.md).

Where a supplier was engaged before cardholder data entered scope, the increase
to DS 5 is an event-driven reassessment trigger and this procedure runs at that
point — not at the next annual cycle.

## 12.8.1 — Maintain the TPSP list

A list of all TPSPs is maintained, including:

| Field | Requirement |
|---|---|
| Legal entity name | As contracted, not the trading name |
| Service provided | Specifically, in relation to cardholder data |
| Which requirements they are responsible for | Cross-referenced to the responsibilities matrix |
| Which requirements we retain | Explicit — a requirement unassigned to either party is unmanaged |
| Date first engaged | To evidence that due diligence preceded the relationship |
| Last compliance-status verification date | 12.8.4 evidence |
| Current AoC version and date | Provenance of the attestation |

The authoritative list lives in
`jolarca-compliance/vendor-assessments/register.csv`, filtered to DS 5 entries,
with this table's fields carried in each supplier's assessment. **A second list
is not created here** — a PCI list that diverges from the vendor register is
worse than one list with gaps, because neither can then be relied upon.

Entries are added on engagement and retained after exit with the date the
provider ceased handling cardholder data, per
[`offboarding-exit.md`](offboarding-exit.md) §7.

## 12.8.2 — Written agreements

A written agreement is in place with each TPSP that includes:

1. An acknowledgment of the TPSP's responsibility for the cardholder data it
   possesses or otherwise controls.
2. An acknowledgment of responsibility for cardholder data security for the
   requirements it performs.
3. A defined scope of the services provided, precise enough to establish which
   PCI DSS requirements the TPSP's attestation must cover.
4. The
   [security requirements schedule](../agreements/security-requirements-schedule.md),
   incorporated by reference.

The acknowledgment in items 1 and 2 is **not optional and is not implied by a
DPA**. A GDPR data processing agreement addresses personal data; cardholder data
may be personal data, but PCI DSS requires an explicit acknowledgment of
responsibility for cardholder data security. Where the supplier's standard DPA
lacks it, a PCI addendum is executed. Suppliers used to signing DPAs routinely
resist this clause; the resistance is recorded and the requirement is not
dropped, because 12.8.2 is a level-one requirement with no partial-credit
position.

Executed agreements are filed in `jolarca-legal/contracts/vendors/<vendor>/`.

## 12.8.3 — Due diligence before engagement

Demonstrated due diligence prior to engaging a TPSP, evidenced by:

1. Completion of [`onboarding.md`](onboarding.md) in full, **before** any
   cardholder data flows.
2. Due diligence Section I of
   [`../methodology/due-diligence.md`](../methodology/due-diligence.md)
   completed, including the AoC scope check.
3. The signed
   [responsibilities matrix](../agreements/responsibilities-matrix.md) — the
   12.8.5 artifact — produced **at onboarding**, not reconstructed at audit.
4. Verification that the TPSP's validation covers the specific service we
   consume. A provider validated for its gateway is not thereby validated for
   its analytics, its support tooling, or a newly launched product.
5. Tier 1 assignment, which DS 5 forces via the tier floor in
   [`../methodology/tiering-rubric.md`](../methodology/tiering-rubric.md) §3.

The evidence for 12.8.3 is the **sequence**: assessment date earlier than first
cardholder transaction. Where the sequence cannot be evidenced, the finding is
recorded honestly rather than resolved by re-dating a document.

## 12.8.4 — Annual monitoring of compliance status

At least annually, confirm each TPSP's PCI DSS compliance status.

1. Obtain the **current** Attestation of Compliance. Re-retrieve it each cycle;
   never carry forward a prior copy.
2. Record who retrieved it, when, the document version, and its validation date.
   PCI AoCs are generally not public downloads — they are obtained from the
   provider's customer compliance area or by support request. That retrieval
   record is the provenance evidence, and without it the AoC is an unverified
   document.
3. Verify the validation date is within 12 months.
4. Verify the **scope description** still covers our service. Re-read it each
   cycle; providers narrow and widen scope between validations.
5. Verify the validation route — QSA-assessed Report on Compliance versus
   Self-Assessment Questionnaire — and record it. A SAQ route for a provider
   handling high-volume cardholder data is a material fact about the depth of
   assurance obtained, and is reflected in CE domain C2.
6. Confirm the responsibilities matrix still matches reality. Where the provider
   has taken on or shed a responsibility, the matrix is re-signed.
7. Record the outcome in the assessment and update `next_review`.

An expired, out-of-scope, or unobtainable AoC is not a paperwork gap. It means we
cannot demonstrate 12.8.4 for that provider, and CE domain C2 drops to 0.0 for a
provider we depend on for cardholder data — which for a DS 5 supplier moves the
band and may force a Critical disposition under
[`../methodology/risk-scoring.md`](../methodology/risk-scoring.md) §4.1.

Where a provider will not supply an AoC, the refusal is recorded, the residual
risk accepted in writing with a reason, and the acceptance reviewed at each
cycle. Silence is not an acceptable terminal state.

## 12.8.5 — Responsibilities matrix

A documented understanding of who is responsible for each applicable PCI DSS
requirement, for every TPSP.

Produced using
[`../agreements/responsibilities-matrix.md`](../agreements/responsibilities-matrix.md)
and signed by both parties. The matrix is the artifact that converts "the
provider is PCI compliant" into a defensible statement about **our** compliance,
because it establishes which requirements remain ours irrespective of the
provider's attestation.

Three rules govern the matrix:

1. **Every applicable requirement is assigned** to the TPSP, to us, or shared.
   A blank cell is an unmanaged requirement and is treated as ours until proven
   otherwise.
2. **Shared responsibilities are decomposed.** "Shared" without a statement of
   which part each party performs is not an assignment.
3. **CUECs from the provider's attestation are mapped into it.** The provider's
   audit will list complementary user entity controls; those are obligations
   transferred to us and belong in the matrix with an owner.

The matrix is re-signed when the service changes, when the provider's validation
scope changes, or when our use of the service changes.

## Scope reduction

The most effective PCI DSS control available to a small operator is not a better
questionnaire — it is not holding cardholder data at all. Where a hosted payment
page, redirect, or tokenisation service keeps PAN entirely out of our systems,
our PCI DSS scope reduces materially, usually to SAQ A or SAQ A-EP.

This is evaluated at every payment-related onboarding and recorded in the
assessment: which integration pattern is used, whether PAN touches our
infrastructure, and which SAQ level follows. A decision to accept a broader
integration pattern than necessary expands scope for no compliance benefit and
requires an explicit recorded reason.

## Failure modes

- **12.8 applied only to the payment gateway.** Hosting, CDN, monitoring and
  support tooling that can affect cardholder data security are in scope too.
- **DPA treated as satisfying 12.8.2.** It does not; the cardholder-data
  acknowledgment is a separate, explicit clause.
- **AoC accepted without reading the scope.** The most common 12.8.4 failure.
  A valid AoC for the wrong service is not evidence.
- **AoC carried forward across cycles.** Stale by definition; provenance lost.
- **Responsibilities matrix produced for the audit.** Reconstructing it after
  the fact fails 12.8.3 and is detectable from document metadata and commit
  history.
- **Second TPSP list.** Diverges from the vendor register and invalidates both.
