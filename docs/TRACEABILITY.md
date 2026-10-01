# Control Traceability Matrix

| | |
|---|---|
| Version | 1.0 |
| Status | Normative |
| Owner | `@JourneyOfLife` |
| Next review | 2027-09-27 |

Every control in scope maps to at least one artifact in this repository. Where an
obligation can only be discharged by a **record** — an assessment, a signed DPA,
a retrieved attestation — the record column names the authoritative location,
because this repository holds method and not evidence.

An entry with no record location is a control that is documented but not
operating. Those are marked **method only** and are raised per
[`gap-intake.md`](gap-intake.md).

## SOC 2 — CC9.2

*The entity assesses and manages risks associated with vendors and business
partners.*

| Requirement | Method artifact | Record location |
|---|---|---|
| Vendor risk assessed **before** engagement | [`procedures/onboarding.md`](procedures/onboarding.md) gate and steps 1–8 | Register `assessed_date` versus `integration_live_from` |
| LLM vendor risk assessed with AI-specific criteria | [`methodology/ai-llm-suppliers.md`](methodology/ai-llm-suppliers.md) | Register `category: ai-llm` entries with LLM-specific DS/BC/AB and CE domains |
| Vendor risk criteria defined and applied consistently | [`methodology/risk-scoring.md`](methodology/risk-scoring.md) | Scored fields per register entry |
| Alternatives considered before selection | [`procedures/onboarding.md`](procedures/onboarding.md) step 1 | Assessment "Alternatives considered" section |
| Vendors tiered by risk, driving depth of treatment | [`methodology/tiering-rubric.md`](methodology/tiering-rubric.md) | Register `tier`, `tier_from_rrs`, `tier_floor_from_ds` |
| Due diligence performed and evidenced | [`methodology/due-diligence.md`](methodology/due-diligence.md) | Completed questionnaire with **E/A/N** classes |
| Periodic reassessment performed | [`procedures/reassessment.md`](procedures/reassessment.md) | Register `next_review`; assessment review history |
| Reassessment triggered by relevant events | [`methodology/risk-scoring.md`](methodology/risk-scoring.md) §6 | Register `last_review_type` |
| Vendor performance monitored | [`procedures/reassessment.md`](procedures/reassessment.md) "Monitoring between cycles" | Condition tracking, `open_conditions`, `oldest_condition_days` |
| Risk acceptance recorded where residual risk is high | [`methodology/risk-scoring.md`](methodology/risk-scoring.md) §4.1 | Signed commit; `approved_commit` |
| Offboarding controlled | [`procedures/offboarding-exit.md`](procedures/offboarding-exit.md) | Register `status: terminated` → `data-returned` |

## SOC 2 — supporting criteria

| Criterion | Artifact | Note |
|---|---|---|
| CC3.1–CC3.4 risk assessment | [`methodology/risk-scoring.md`](methodology/risk-scoring.md), [`methodology/tiering-rubric.md`](methodology/tiering-rubric.md) | Vendor risk is a component of entity risk |
| CC4.1 monitoring activities | [`procedures/reassessment.md`](procedures/reassessment.md), [`solo-operator-controls.md`](solo-operator-controls.md) §4 | Quarterly self-attestation against generated evidence |
| CC2.2 internal communication | [`scope-and-boundaries.md`](scope-and-boundaries.md), [`gap-intake.md`](gap-intake.md) | Roles and escalation defined |
| CC1.3 control environment | [`solo-operator-controls.md`](solo-operator-controls.md) | Competence, accountability and the limits of one-person governance stated |

## ISO/IEC 27001:2022 — Annex A.5.19

*Relationships with suppliers.*

| Requirement | Method artifact | Record location |
|---|---|---|
| Policy defining supplier relationships | [`scope-and-boundaries.md`](scope-and-boundaries.md) "Relationship to the approved policy" | `jolarca-compliance/policies/07-vendor-third-party.md` |
| Roles and responsibilities defined | [`scope-and-boundaries.md`](scope-and-boundaries.md) "Roles" | As above |
| Supplier relationships identified and documented | [`register/schema.md`](../register/schema.md) | `jolarca-compliance/vendor-assessments/register.csv` |
| Risks associated with suppliers assessed | [`methodology/risk-scoring.md`](methodology/risk-scoring.md) | Assessments |
| Controls agreed and implemented before use | [`procedures/onboarding.md`](procedures/onboarding.md) gate | `integration_live_from` ≥ `assessed_date` |
| Risk treatment for supplier relationships | [`methodology/tiering-rubric.md`](methodology/tiering-rubric.md) §4 | Conditions with due dates |

## ISO A.5.20

*Addressing security within supplier agreements.*

| Requirement | Method artifact | Record location |
|---|---|---|
| Security requirements established in agreements | [`agreements/security-requirements-schedule.md`](agreements/security-requirements-schedule.md) | Executed contracts in `jolarca-legal/contracts/vendors/` |
| Data protection obligations flow down | [`agreements/dpa-checklist.md`](agreements/dpa-checklist.md) | Executed DPAs |
| Refused clauses recorded with compensating controls | [`agreements/security-requirements-schedule.md`](agreements/security-requirements-schedule.md) "Refusal handling" | Assessment conditions |
| Approval-blocking refusals identified | [`agreements/security-requirements-schedule.md`](agreements/security-requirements-schedule.md) §"Refusal handling" item 5 | Signed risk acceptance |
| Breach notification commitment sufficient for our Art. 33 duty | [`agreements/security-requirements-schedule.md`](agreements/security-requirements-schedule.md) clause 6.2 | DPA and schedule |

## ISO A.5.21

*Managing information security in the ICT supply chain.*

| Requirement | Method artifact | Record location |
|---|---|---|
| ICT supply chain identified | [`procedures/subprocessor-change.md`](procedures/subprocessor-change.md) §2 | Register `subprocessor_count`, `subprocessor_list_date` |
| Sub-processor changes controlled | [`procedures/subprocessor-change.md`](procedures/subprocessor-change.md) | Notification records and objection correspondence |
| Right to object with a real remedy | [`agreements/security-requirements-schedule.md`](agreements/security-requirements-schedule.md) clauses 7.2, 7.3 | Executed agreement |
| Fourth parties identified | [`procedures/subprocessor-change.md`](procedures/subprocessor-change.md) §3.4 | Assessment sub-processor section |
| Concentration risk examined | [`procedures/subprocessor-change.md`](procedures/subprocessor-change.md) §3.4; [`procedures/cloud-services.md`](procedures/cloud-services.md) §3.7 | Assessment |
| Flow-down of equivalent obligations | [`agreements/dpa-checklist.md`](agreements/dpa-checklist.md) Art. 28(2)/(4) | Executed DPA |
| New transfers arising from sub-processing assessed | [`procedures/subprocessor-change.md`](procedures/subprocessor-change.md) §3.1 | TIA in `jolarca-compliance/vendor-assessments/tia/` |

## ISO A.5.22

*Monitoring, review and change management of supplier services.*

| Requirement | Method artifact | Record location |
|---|---|---|
| Supplier services monitored against agreement | [`procedures/reassessment.md`](procedures/reassessment.md) | Assessment review history |
| Periodic review at a defined cadence | [`methodology/tiering-rubric.md`](methodology/tiering-rubric.md) §4 | Register `cadence_months`, `next_review` |
| Change management of supplier services | [`procedures/subprocessor-change.md`](procedures/subprocessor-change.md) | Notification and decision records |
| Service changes trigger reassessment | [`methodology/risk-scoring.md`](methodology/risk-scoring.md) §6 | Register `last_review_type` |
| Supplier incidents handled | [`procedures/reassessment.md`](procedures/reassessment.md) triggers; incident procedure in `jolarca-compliance/incidents/` | Incident record and the resulting reassessment |
| Conditions tracked to closure | [`procedures/reassessment.md`](procedures/reassessment.md) §3 | `open_conditions`, `oldest_condition_days` |
| Evidence of reviews retained and integrity-checked | [`evidence/conventions.md`](evidence/conventions.md) | `jolarca-compliance/audits/evidence-registry.csv` |

## ISO A.5.23

*Information security for use of cloud services.*

| Requirement | Method artifact | Record location |
|---|---|---|
| Cloud service security requirements defined | [`procedures/cloud-services.md`](procedures/cloud-services.md) §2 | Assessments of cloud suppliers |
| Shared responsibility documented and agreed | [`agreements/responsibilities-matrix.md`](agreements/responsibilities-matrix.md) cloud matrix | Signed matrix in `jolarca-legal/contracts/vendors/` |
| Service model declared per supplier | [`procedures/cloud-services.md`](procedures/cloud-services.md) §1 | Register `service_model` |
| Customer-side obligations identified | [`procedures/cloud-services.md`](procedures/cloud-services.md) §3 | Assessment; `jolarca-security` controls |
| Complementary user entity controls extracted and assigned | [`agreements/responsibilities-matrix.md`](agreements/responsibilities-matrix.md) CUEC table | Signed matrix |
| Region and residency commitment contractual | [`procedures/cloud-services.md`](procedures/cloud-services.md) §2.2; [`agreements/security-requirements-schedule.md`](agreements/security-requirements-schedule.md) clause 10.3 | Executed agreement |
| Government access position established | [`procedures/cloud-services.md`](procedures/cloud-services.md) §2.6 | TIA |
| Cloud exit and portability assessed | [`procedures/cloud-services.md`](procedures/cloud-services.md) §4 | Register `exit_plan` |

**Note:** the approved policy in `jolarca-compliance` cites A.5.19–A.5.22 and does
not cite A.5.23. The divergence is disclosed in
[`scope-and-boundaries.md`](scope-and-boundaries.md) and raised through gap
intake. This repository's method covers A.5.23; the policy citation does not yet.

## GDPR — Article 28

| Requirement | Method artifact | Record location |
|---|---|---|
| Processor engaged only under a contract meeting Art. 28(3) | [`agreements/dpa-checklist.md`](agreements/dpa-checklist.md) | Register `dpa_signed`, `dpa_date`, `dpa_expiry` |
| Art. 28(3)(a)–(h) content verified item by item | [`agreements/dpa-checklist.md`](agreements/dpa-checklist.md) | Checklist outcome in assessment |
| Sub-processing authorised, obligations flow down, supplier liable | [`agreements/dpa-checklist.md`](agreements/dpa-checklist.md) Art. 28(2)/(4) | Executed DPA |
| Art. 32 measures specified, not merely cross-referenced | [`agreements/dpa-checklist.md`](agreements/dpa-checklist.md) Art. 32 table | Executed DPA and schedule |
| Breach notification supports our Art. 33 72-hour duty | [`agreements/security-requirements-schedule.md`](agreements/security-requirements-schedule.md) clause 6.2 | Executed DPA |
| Return or deletion at end of services, certified | [`procedures/offboarding-exit.md`](procedures/offboarding-exit.md) §5 | Erasure certification |
| Art. 30 record of recipients maintained | [`register/schema.md`](../register/schema.md) parity rule 4 | `jolarca-compliance/ropa/master-register.csv` |
| Joint-controller relationships correctly identified | [`agreements/dpa-checklist.md`](agreements/dpa-checklist.md) "Which instrument" | Referral record |

## GDPR — Chapter V transfers

| Requirement | Method artifact | Record location |
|---|---|---|
| Transfer mechanism identified for every third country | [`agreements/dpa-checklist.md`](agreements/dpa-checklist.md) Chapter V table | Register `transfer_countries`, `transfer_mechanism` |
| SCCs executed with all annexes completed | [`agreements/dpa-checklist.md`](agreements/dpa-checklist.md) | `jolarca-legal/contracts/vendors/` |
| TIA authored by us where SCCs relied upon | [`procedures/onboarding.md`](procedures/onboarding.md) step 4 | `jolarca-compliance/vendor-assessments/tia/` |
| Support access treated as a transfer | [`methodology/due-diligence.md`](methodology/due-diligence.md) §8.1 | Register `transfer_countries` |
| Backup and DR residency confirmed | [`procedures/cloud-services.md`](procedures/cloud-services.md) §2.5 | Assessment |

## GDPR — Article 32 and Article 5(2)

| Requirement | Method artifact | Record location |
|---|---|---|
| Security of processing assessed per supplier | [`methodology/due-diligence.md`](methodology/due-diligence.md) §6 | CE domain C3 |
| Encryption and key custody established | [`agreements/security-requirements-schedule.md`](agreements/security-requirements-schedule.md) §3 | Assessment |
| Accountability demonstrated | [`evidence/conventions.md`](evidence/conventions.md) | Evidence hash registry |
| Storage limitation applied to vendor records | [`evidence/retention-schedule.md`](evidence/retention-schedule.md) | Deletion records |

## PCI DSS v4.0 — Requirement 12.8

| Requirement | Method artifact | Record location |
|---|---|---|
| 12.8.1 TPSP list maintained | [`procedures/pci-tsp-management.md`](procedures/pci-tsp-management.md) §12.8.1 | Register filtered to DS 5 — **not a separate list** |
| 12.8.2 Written agreements with cardholder-data acknowledgment | [`procedures/pci-tsp-management.md`](procedures/pci-tsp-management.md) §12.8.2 | Executed agreement or PCI addendum |
| 12.8.3 Due diligence before engagement | [`procedures/pci-tsp-management.md`](procedures/pci-tsp-management.md) §12.8.3; [`methodology/due-diligence.md`](methodology/due-diligence.md) §11 | Assessment dated before first transaction |
| 12.8.4 Compliance status verified at least annually | [`procedures/pci-tsp-management.md`](procedures/pci-tsp-management.md) §12.8.4 | Register `aoc_status`, `aoc_date`, `aoc_retrieved` |
| 12.8.5 Responsibilities documented | [`agreements/responsibilities-matrix.md`](agreements/responsibilities-matrix.md) | Signed matrix |
| Scope reduction evaluated | [`procedures/pci-tsp-management.md`](procedures/pci-tsp-management.md) "Scope reduction" | Assessment |
| Providers that could affect CHD security included | [`scope-and-boundaries.md`](scope-and-boundaries.md) "Scope of vendor management" | Register DS 5 entries |

## Control gaps — method only

Documented here so that no reader mistakes a method artifact for an operating
control. Each is raised per [`gap-intake.md`](gap-intake.md).

| Control limb | Status | Why |
|---|---|---|
| Automated calculation of IRS, CE, RRS | **Method only** | The formula in [`methodology/risk-scoring.md`](methodology/risk-scoring.md) is normative but no implementation exists; scoring is manual. Consequence: arithmetic errors are not caught mechanically |
| Register validation against [`../register/schema.md`](../register/schema.md) Group C and D | **Method only** | The existing gate validates review dates and folder parity; it does not yet validate the scoring columns or the hard-failure rules. Consequence: hard failures are caught by human review only |
| Quarterly self-attestation | **Method only** | Defined in [`solo-operator-controls.md`](solo-operator-controls.md) §4; not yet scheduled or templated in `jolarca-compliance/management-review/` |
| Exit plan testing | **Method only** | Required by [`methodology/tiering-rubric.md`](methodology/tiering-rubric.md) Tier 1; no test evidence exists for any supplier |
| Policy citation of A.5.23 | **Gap in the policy** | Method exists here; the approved instrument does not cite the control |

A method-only entry is not a deficiency in this repository — the repository's
purpose is method. It is a statement that the control does not yet operate, and
that anyone reading the traceability matrix should not infer otherwise. Presenting
a documented method as an operating control is how a traceability matrix becomes
misleading rather than useful.

## Change control for this matrix

Any change to a control mapping requires:

1. The artifact changed or added in the same pull request.
2. This matrix updated in the same pull request.
3. A `CHANGELOG.md` entry naming the control.
4. A signed commit.

A control mapping that is not updated when the artifact changes is the failure
mode this rule prevents: the matrix asserts coverage that no longer exists, and
the assertion is relied upon at audit.
