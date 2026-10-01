# DPA Checklist — GDPR Article 28

| | |
|---|---|
| Version | 1.0 |
| Status | Normative checklist |
| Owner | `@JourneyOfLife` |
| Controls | GDPR Art. 28 · Art. 32 · Art. 44–49 · ISO A.5.20 · SOC 2 CC9.2 |
| Applies when | DS ≥ 3 — the supplier processes personal data on our behalf |
| Next review | 2027-09-27 |

## Purpose and boundary

This is a **verification checklist**, not a contract. It is used to test a
supplier's DPA against Art. 28 before signature, and to re-test it at each
reassessment.

Authoritative DPA texts live in `jolarca-legal/contracts/00-templates/`:
`dpa-processor.md` and `dpa-controller-processor.md`. Executed agreements are
filed in `jolarca-legal/contracts/vendors/<vendor>/`. **No DPA is drafted,
amended or stored in this repository** — creating a second contract source would
produce divergent obligations.

## Which instrument

Determine the relationship first, because it selects the template and the
obligations:

| Relationship | Instrument | Note |
|---|---|---|
| We determine purposes and means; supplier processes on our behalf | Art. 28 processor DPA | The common case |
| Both determine purposes and means | Art. 26 joint-controller arrangement | A DPA is the wrong instrument; refer to `jolarca-legal` |
| Supplier determines its own purposes for our data | Not a processor relationship | Art. 28 does not apply; assess as an independent controller disclosure and re-examine lawful basis |
| Supplier is a recipient but not a processor | Disclosure terms | Record in the RoPA as a recipient |

Mischaracterising a joint-controller relationship as a processor relationship is
a substantive defect, not a labelling error: Art. 26 requires the essence of the
arrangement to be made available to data subjects, and no DPA does that. Where
the supplier's terms claim independent use of our data — for analytics,
benchmarking, or model training — the relationship is not a clean processor
relationship and is referred before signature.

## Art. 28(3) mandatory content

Every item below must be present. Record **Present**, **Partial** (state what is
missing) or **Absent** against each.

| Ref | Requirement | Notes |
|---|---|---|
| 28(3)(a) | Processes only on our documented instructions, including as regards transfers, unless required by Union or Member State law — in which case the supplier notifies us before processing unless legally prohibited | The "unless legally prohibited" carve-out must itself be present |
| 28(3)(b) | Ensures persons authorised to process are bound by confidentiality, by contract or by statute | A reference to internal policy alone is **Partial** |
| 28(3)(c) | Takes all measures required pursuant to Art. 32 | Must be more than a cross-reference — see the Art. 32 table below |
| 28(3)(d) | Respects the conditions for engaging sub-processors: prior specific or general written authorisation, and the same obligations flow down | General authorisation requires a duty to inform us of intended changes and an opportunity to object |
| 28(3)(e) | Assists us in responding to data subject rights requests, taking account of the nature of the processing | Must include a response timeframe |
| 28(3)(f) | Assists us with Art. 32–36 obligations: security, breach notification, DPIAs, prior consultation | Must cover all four, not security alone |
| 28(3)(g) | Deletes or returns all personal data at the end of the provision of services, at our choice, unless Union or Member State law requires storage | Must name a maximum deletion period and extend to backups |
| 28(3)(h) | Makes available all information necessary to demonstrate compliance, and allows for and contributes to audits, including inspections, conducted by us or an auditor we mandate | Suppliers frequently weaken this to "a SOC 2 report on request" — that is **Partial** |

## Art. 28(2) sub-processing

| Ref | Requirement |
|---|---|
| 28(2) | No sub-processing without our prior specific or general written authorisation |
| 28(2) | Under general authorisation: the supplier informs us of intended additions or replacements, giving us the opportunity to object |
| 28(4) | Where a sub-processor fails to fulfil its obligations, the initial supplier remains fully liable to us |

Test whether the authorisation model is **specific or general** and record which.
Under a general authorisation the notice period and the objection mechanism must
both exist; a general authorisation with no notice obligation is effectively
unrestricted sub-processing and is **Absent** for 28(2).

Cross-reference the notice period against clause 7 of the
[security requirements schedule](security-requirements-schedule.md): we require
at least 30 days. A DPA giving 7 days is a defect even where the DPA is
otherwise complete.

## Art. 32 security measures

Art. 28(3)(c) imports Art. 32, so the DPA must address, as appropriate:

| Ref | Measure |
|---|---|
| 32(1)(a) | Pseudonymisation and encryption of personal data |
| 32(1)(b) | Ability to ensure ongoing confidentiality, integrity, availability and resilience |
| 32(1)(c) | Ability to restore availability and access in a timely manner after an incident |
| 32(1)(d) | A process for regularly testing, assessing and evaluating the effectiveness of measures |
| 32(2) | Risk assessment appropriate to the processing, considering state of the art, cost, nature, scope, context and purposes |
| 32(4) | Persons acting under our authority who access personal data do so only on instructions |

A DPA that merely cross-refers to Art. 32 without specifying measures is
**Partial**. The specification may live in the security requirements schedule
provided the DPA incorporates it by reference — confirm the incorporation is
explicit.

## Art. 33 and breach notification

| Item | Requirement |
|---|---|
| Notification | Without undue delay after becoming aware, with a stated maximum hour count |
| Content | Nature of the breach, categories and approximate numbers of data subjects and records, contact point, likely consequences, measures taken or proposed |
| Cooperation | Ongoing updates and reasonable cooperation with our notification duties |
| Documentation | The supplier documents the breach and makes the record available to us |

**Our Art. 33 clock runs 72 hours from our awareness**, and a supervisory
authority will ask when we became aware. A supplier notifying us at 72 hours
consumes the entire window before we can act. We require **24 hours**, accept 48
with a recorded condition, and treat anything longer as capping CE domain C4 at
0.5 per [`../methodology/risk-scoring.md`](../methodology/risk-scoring.md) §3.

"Aware" must be defined. A clause running from "confirmation of a personal data
breach" rather than "awareness of a security incident" lets the supplier's own
investigation consume the window. Prefer awareness of an incident, with the
breach determination following.

## Transfers — Chapter V

| Item | Requirement |
|---|---|
| Mechanism identified | Adequacy decision, SCCs, binding corporate rules, or a named Art. 49 derogation |
| SCC module | Correct module for the relationship — Module 2 for controller-to-processor |
| SCC executed | Signed, dated, with Annexes I, II and III **completed** — uncompleted annexes are the most common SCC defect and render the instrument unusable |
| Docking clause | Where sub-processors accede |
| Region commitment | Contractual commitment to named regions for processing, storage and backup |
| Government access | Notify, challenge unlawful requests, minimise disclosure |
| TIA | Where SCCs are relied on and no adequacy decision exists, a Transfer Impact Assessment is authored by us and filed in `jolarca-compliance/vendor-assessments/tia/` |

The TIA is **ours to author**. The supplier provides the DPA and SCCs as inputs
and does not issue the TIA. A supplier-supplied "transfer impact assessment" is a
marketing document and does not discharge our obligation.

Annex II of the SCCs must describe the technical and organisational measures
specifically. A generic Annex II that restates Art. 32 in the abstract is a
recurring supervisory-authority criticism and is recorded as **Partial**.

## Additional items to verify

Beyond the statutory minimum, each of these is tested because its absence causes
practical failure:

| Item | Why |
|---|---|
| Named legal entity and jurisdiction | The DPA must bind the entity actually processing, not a group parent or a trading name |
| Term and survival | Obligations must survive termination, or deletion cannot be enforced after the contract ends |
| Precedence clause | Which document governs where the DPA and the main terms conflict — without it, the supplier's liability-limiting terms may override |
| Liability | Data protection liability not excluded or capped at a nominal figure |
| No use for model training | Explicit, for AI and LLM suppliers; a general no-secondary-use clause does not clearly cover training |
| Audit right practicalities | Notice period, frequency, cost allocation, and whether a third-party report is an acceptable substitute |
| Deletion certification | Written certification naming entity, data, date and sub-processors — the 28(3)(g) evidence |
| Sub-processor list mechanism | How we obtain a current list and how often |
| Contact for data protection matters | A reachable address, not a form |

## Outcome recording

Record the result in the supplier's assessment, not in this repository:

1. Instrument type and template used.
2. Each Art. 28(3)(a)–(h) item as Present, Partial or Absent.
3. Sub-processing authorisation model and notice period.
4. Transfer mechanism, SCC module, and Annex completion status.
5. Breach notification hours committed, and the definition of "aware".
6. Every Partial or Absent item raised as a condition with a due date.
7. CE domain C1 scored from the outcome: 1.0 where signed, current and all items
   Present; 0.5 where signed but with open Partials; 0.0 where unsigned or
   expired.
8. DPA execution date and expiry date recorded in the register.

**An unsigned DPA with DS ≥ 3 means processing is occurring without an Art. 28
contract.** That is not a documentation gap; it is an infringement in progress.
It is recorded per [`../gap-intake.md`](../gap-intake.md), the data flow is
reviewed for suspension, and it is not resolved by backdating.
