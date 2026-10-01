# Procedure — Sub-processor and ICT Supply Chain Change

| | |
|---|---|
| Version | 1.0 |
| Status | Normative |
| Owner | `@JourneyOfLife` |
| Controls | ISO A.5.21 · ISO A.5.22 · GDPR Art. 28(2) and 28(4) · SOC 2 CC9.2 |
| Next review | 2027-09-27 |

## Purpose

To identify and control the ICT supply chain beyond our immediate supplier.
ISO A.5.21 requires the supply chain to be **identified**; Art. 28(2) permits
sub-processing only with our authorisation and on the same obligations flowing
down; Art. 28(4) makes us answerable where a sub-processor fails to meet those
obligations.

Our risk does not stop at the contract counterparty. A supplier with an
exemplary control set that routes our data through an unevidenced fourth party
in an unassessed jurisdiction presents the fourth party's risk, not its own.

## Review windows

| Tier | Window from notification |
|---|---|
| 1 | 14 days |
| 2 | 14 days |
| 3 | 30 days |
| 4 | Only where DS rises |

The window runs from notification, not from discovery. Where we discover a
sub-processor that was never notified, that is itself a contractual breach and is
recorded as one — and it means our AB factor has been understated for an unknown
period, which requires re-scoring.

## Steps

### 1. Capture the notification

Record the date received, the channel, and the notice period given. Compare the
notice period against the contractual commitment. Notice shorter than the
contract provides is a breach and is raised with the supplier in writing, even
where we ultimately accept the change — accepting silently forfeits the right to
object next time and erodes the clause.

Where a supplier publishes changes only to a web page, the page is checked at
each reassessment and the check is recorded. A published-page model with no
active notification caps CE domain C4 at 0.5.

### 2. Identify the sub-processor

For each new or changed sub-processor, obtain: legal name, jurisdiction of
incorporation, jurisdictions from which it will access our data, function
performed, and the data categories it will receive.

**A published list is not an acceptable answer to "who are your
sub-processors".** Request the list current as at the assessment date. A
supplier that will not enumerate its chain scores **N** on due diligence
Section G, which caps CE and may block approval for Tier 1.

### 3. Assess the delta

Answer four questions and record each answer:

1. **Jurisdiction.** Does the sub-processor introduce a new country? If it is
   outside the EU/EEA and lacks an adequacy decision, a transfer mechanism is
   required, and where SCCs are the mechanism a TIA must be completed before the
   transfer begins.
2. **Data exposure.** Does it receive data categories beyond those already
   assessed? A rise in DS re-tiers the supplier per the DS floor in
   [`../methodology/tiering-rubric.md`](../methodology/tiering-rubric.md) §3 —
   which cannot be mitigated away by the supplier's own controls.
3. **Flow-down.** Does the supplier impose obligations on the sub-processor
   equivalent to those it owes us? Art. 28(4) requires the same data protection
   obligations to be imposed. Ask for evidence, not assurance.
4. **Concentration.** Does this sub-processor already appear elsewhere in our
   chain? Concentration risk is invisible supplier-by-supplier: three
   independent suppliers all relying on the same underlying provider are not
   three independent dependencies. Where a sub-processor recurs, that is noted
   in the assessment because it defeats the diversification our exit plans
   assume.

### 4. Decide

| Position | Decision |
|---|---|
| No new jurisdiction, no DS rise, flow-down evidenced | Accept; record and re-score CE only |
| New transfer without a mechanism in place | **Object.** No data flows to that sub-processor until the mechanism and TIA exist |
| DS rises | Object or accept only after re-tiering and re-approval; a rise to DS 5 brings PCI DSS 12.8 into scope |
| Flow-down not evidenced | Object; require evidence within the notice window |
| Material adverse change | Exercise the right to object, and if unresolved the right to terminate without penalty |

The **right to object is only real if it carries a consequence**. Where the
agreement grants a right to object but no termination remedy if the objection is
overridden, that asymmetry is recorded as a contractual weakness and capped in
CE domain C4. It is the single most common defect in supplier sub-processing
clauses.

### 5. Update records

1. Sub-processor list updated in the supplier's assessment.
2. Re-score per [`reassessment.md`](reassessment.md) — this is an event-driven
   reassessment and resets the scheduled review date.
3. Register updated in both formats.
4. RoPA updated where a new recipient is introduced. This is frequently missed:
   the sub-processor is a recipient of personal data and belongs in the Art. 30
   record.
5. Objection correspondence filed with the contract in
   `jolarca-legal/contracts/vendors/<vendor>/`.

## Standing obligations for agreements

Required in every Tier 1 and Tier 2 agreement, and reflected in the
[security requirements schedule](../agreements/security-requirements-schedule.md):

1. Prior notice of at least **30 days** before any new or replacement
   sub-processor.
2. A genuine right to object on reasonable data-protection grounds.
3. Termination without penalty where a sustained objection is overridden, with
   data return and erasure on exit.
4. Flow-down of equivalent obligations to every sub-processor.
5. A maintained, current list of sub-processors, supplied on request within a
   defined period.
6. Notification where a sub-processor changes jurisdiction.
7. Liability to us for the acts and omissions of sub-processors to the same
   extent as for its own — Art. 28(4) makes this our position regardless; the
   clause makes it recoverable.

## Failure modes

- **Chain accepted on assurance.** "We impose equivalent obligations" without
  evidence. Records as **A**, caps CE.
- **New transfer treated as an operational change.** It is a legal one. A
  sub-processor in a third country without a mechanism is an unlawful transfer
  from the day processing starts, and the exposure is ours as controller.
- **Objection right never exercised.** A right that is never used is untested and
  may be unenforceable. Where an objection is warranted and commercial pressure
  argues against it, the pressure and the decision are recorded — an auditor
  reading a clean history of accepted changes will ask whether the right exists
  in anything but name.
- **Sub-processor not added to the RoPA.** Very common, and directly testable by
  comparing the sub-processor list against the Art. 30 recipients column.
- **Concentration never examined.** Discovered only during an incident, when
  several suppliers fail simultaneously.
