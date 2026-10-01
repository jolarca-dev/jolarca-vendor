# Procedure — Periodic and Event-Driven Reassessment

| | |
|---|---|
| Version | 1.0 |
| Status | Normative |
| Owner | `@JourneyOfLife` |
| Controls | SOC 2 CC9.2 · ISO A.5.22 · PCI DSS 12.8.4 · GDPR Art. 28(3)(h) |
| Next review | 2027-09-27 |

## Purpose

To keep every supplier's risk position current. CC9.2 requires **periodic**
reassessment; A.5.22 requires monitoring, review and change management of
supplier services; PCI DSS 12.8.4 requires the compliance status of every
third-party service provider handling cardholder data to be verified at least
annually.

An onboarding assessment is a point-in-time opinion. Auditors test the interval,
not the existence of a document.

## Cadence

From [`../methodology/tiering-rubric.md`](../methodology/tiering-rubric.md) §4:

| Tier | Scheduled reassessment | Sub-processor change review |
|---|---|---|
| 1 | 12 months | 14 days |
| 2 | 12 months | 14 days |
| 3 | 24 months | 30 days |
| 4 | 36 months | Only if DS rises |

DPA renewal begins **at least 60 days before expiry**. Where a DPA expires
before renewal completes, CE domain C1 drops to 0.0 and the supplier must be
re-scored — an expired DPA is not a minor administrative lapse, it means
processing is occurring without an Art. 28 contract.

## Event-driven triggers

These take precedence over the schedule and are listed in
[`../methodology/risk-scoring.md`](../methodology/risk-scoring.md) §6:

1. Sub-processor change notification.
2. Security incident affecting our data — handled first under the incident
   procedure in `jolarca-compliance/incidents/`, because the Art. 33 clock runs
   from awareness and takes precedence over reassessment; the reassessment
   follows.
3. Certification lapse, withdrawal, or scope change.
4. Change in the data categories we send, in particular any rise to DS 4 or 5.
5. Supplier acquisition, change of controlling jurisdiction, material service
   change, or end-of-life announcement.
6. Change in our own use of the service that raises BC or AB.

An event-driven reassessment **resets** the scheduled review date. Without that
reset, an event review in month two of a twelve-month cycle leaves ten months of
unmonitored drift before the next scheduled review.

## Steps

### 1. Confirm the trigger

Record whether this is a scheduled review or event-driven, and if event-driven
which trigger. This is the first thing an auditor asks, because it distinguishes
a genuine monitoring programme from a calendar exercise.

### 2. Refresh attestations

Retrieve the **current** document — do not carry forward a prior copy.

For each certification or report held: re-obtain it, and record who retrieved
it, when, and the document version and date. Where a document is distributed
through a customer dashboard rather than a public download, that retrieval record
is the evidence of provenance. An undated report of unknown origin supports
nothing.

Check the four things that make a report usable:

- Period covered is current and continuous with the prior report.
- Opinion is unqualified; exceptions are listed and assessed.
- Systems description scope covers the service we actually consume.
- Complementary user entity controls are extracted and still assigned to us.

### 3. Re-verify what changed

Compare against the prior assessment and record each delta explicitly:

- Data categories sent — unchanged, increased, or decreased.
- Access actually granted versus the assessed AB factor. Credentials issued
  since the last review are enumerated; access creep raises AB and invalidates
  the prior score.
- Sub-processor list versus the list on file.
- Hosting regions versus the contractual commitment.
- Open conditions from the prior cycle: closed with evidence, still open, or
  lapsed. A condition carried forward twice without movement is escalated to a
  documented risk acceptance or becomes grounds for exit.

### 4. Re-score

Recalculate IRS, CE and RRS per
[`../methodology/risk-scoring.md`](../methodology/risk-scoring.md). Do not copy
the previous numbers forward — a reassessment that reproduces the prior score
without re-deriving it is not a reassessment.

Re-derive the tier. Promotion takes effect immediately; demotion requires two
consecutive cycles per
[`../methodology/tiering-rubric.md`](../methodology/tiering-rubric.md) §5, and
`consecutive_cycles_at_current_tier` is incremented or reset accordingly.

### 5. PCI DSS 12.8.4 confirmation (DS 5 only)

Obtain current evidence of the provider's own PCI DSS compliance status — AoC or
equivalent — and confirm the scope still covers our service. Record the document
version and retrieval date. File per
[`pci-tsp-management.md`](pci-tsp-management.md).

### 6. Update the register and file

1. Update the assessment in
   `jolarca-compliance/vendor-assessments/<vendor>/assessment.md`.
2. Update `next_review` and any changed fields in **both** `register.csv` and
   `register.md` in the same change.
3. Record the review evidence hash into
   `jolarca-compliance/audits/evidence-registry.csv` per
   [`../evidence/conventions.md`](../evidence/conventions.md).
4. Commit signed, message naming the vendor, tier and RRS.

The currency gate in `jolarca-compliance` (`scripts/vendor-review-dates.py`,
run by `make check` and by `vendor-review-due.yml`) fails on overdue reviews. It
is enforced hard and must not be bypassed — a bypassed currency gate is
indistinguishable from no gate at all.

### 7. Act on the outcome

| Outcome | Action |
|---|---|
| RRS unchanged or improved, all conditions closed | Set `next_review` from cadence; close the cycle |
| RRS increased but band unchanged | Raise new conditions with dates |
| Band worsened | Re-approve as a risk acceptance, or begin exit per [`offboarding-exit.md`](offboarding-exit.md) |
| Critical band (≥ 3.50) | Suspend new data flows immediately; remediate or exit |
| Supplier unresponsive after two chases | Treat as a material service failure; escalate to exit evaluation |

## Monitoring between cycles

Reassessment is annual at best; monitoring is continuous. Between cycles:

- Sub-processor change notifications are processed within the tier's window —
  see [`subprocessor-change.md`](subprocessor-change.md).
- Supplier status pages and security advisories for Tier 1 and Tier 2 suppliers
  are subscribed to, so an incident reaches us without waiting for the supplier
  to notify.
- Certification expiry dates are diarised at least 90 days ahead.
- Contract and DPA expiry dates are diarised at least 60 days ahead.

Where a supplier will not commit to notify us, the subscription is the
compensating control and is recorded as such.

## Failure modes

- **Carry-forward reassessment.** Prior scores and text copied without
  re-derivation. Detect by diffing consecutive assessments: identical arithmetic
  and identical narrative across a year is implausible.
- **Review performed but register not updated.** The register is what the
  currency gate reads. An updated assessment with a stale `next_review` shows as
  overdue and will be sampled.
- **Expired attestation accepted as current.** Check period covered against
  today's date, not against the date the review started.
- **Conditions silently dropped.** Every prior condition must appear in the new
  assessment as closed-with-evidence, open, or escalated. A condition that
  simply vanishes is the most common way a reassessment launders an unresolved
  finding.
- **Event reviews not resetting the clock.** Produces long unmonitored gaps and
  makes the cadence meaningless.
