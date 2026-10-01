# Vendor Assessments — Index

**This repository holds no assessments.** Completed assessments are
`confidential`: they contain supplier-specific findings, risk scores, contractual
weaknesses and residual-risk positions. Publishing them would disclose our
weakest supplier relationships to anyone reading a public repository, and would
breach the confidentiality obligations in the agreements the assessments concern.

## Authoritative location

`jolarca-compliance/vendor-assessments/<vendor>/assessment.md`

Supporting material in the same folder: the completed questionnaire, attestations
and their provenance records, sub-processor lists, and material correspondence.
Transfer Impact Assessments are in `jolarca-compliance/vendor-assessments/tia/`.

## What an assessment must contain

Defined here because the structure is what makes assessments comparable across
suppliers and across cycles, and what allows the parity gate to distinguish a
real assessment from a placeholder folder.

| Section | Requirement | Control |
|---|---|---|
| Supplier identity | Contracted legal entity, jurisdiction, service, and the service model where cloud | A.5.19, 12.8.1 |
| Scope of engagement | What the supplier does for us, and what data categories it receives, mapped to RoPA identifiers | A.5.19, Art. 30 |
| Alternatives considered | What else was examined, including not engaging, and why this supplier was selected | **CC9.2** |
| Data processing | Categories, purpose, retention, storage locations, and whether used for model training | Art. 28, Art. 5(1)(b) |
| Sub-processors | Enumerated list with jurisdiction and function — not "see vendor documentation" | **A.5.21**, Art. 28(2) |
| Transfer position | Every country of processing, storage, backup and support access, with the mechanism for each | Chapter V, A.5.23 |
| Legal framework | DPA status and dates, SCC module and annex completion, TIA status | Art. 28, 12.8.2 |
| Due-diligence responses | Each answer with its evidence class **E**, **A** or **N** | CC9.2, 12.8.3 |
| Inherent risk | DS, BC and AB with the rubric row cited for each, and the IRS arithmetic shown | CC9.2 |
| Control effectiveness | C1–C5 each scored, with the evidence relied upon named | CC9.2, A.5.22 |
| Residual risk | The CE and RRS arithmetic shown, the band, and a narrative that refers to **this** supplier's actual data flows | CC9.2 |
| Tier | `tier_from_rrs`, `tier_floor_from_ds`, the resulting tier, and any override with its reason | A.5.19, A.5.22 |
| Conditions | Every **A** or **N** answer and every refused clause, each with an owner and a due date | CC9.2 |
| Exit position | Export capability, deletion guarantee, named alternative, switching effort | Art. 28(3)(g), A.5.22 |
| PCI position | Where DS 5: AoC version and date, retrieval record, scope confirmation, responsibilities matrix reference | **12.8.3, 12.8.4, 12.8.5** |
| Approval | Natural person, capacity acted in, date, and the signed commit hash | CC9.2, A.5.19 |
| Review history | Each cycle: date, trigger type, deltas from the prior cycle, and the prior conditions' disposition | **A.5.22**, CC9.2 |

Three of these are routinely missing and are called out deliberately:

- **Alternatives considered.** CC9.2 is tested on this specifically, and it cannot
  be reconstructed after the fact — either alternatives were examined before
  engagement or they were not.
- **Review history with deltas.** A.5.22 requires monitoring and change
  management. A series of standalone assessments with no recorded delta does not
  evidence monitoring; it evidences repetition.
- **Sub-processor enumeration.** "See vendor documentation" is recorded as **N**
  and caps CE. The chain must be identified for A.5.21 to be met at all.

## Structural rules

1. **A folder is not an assessment.** A supplier directory containing only a
   placeholder or a README does not satisfy parity rule 6 in
   [`../register/schema.md`](../register/schema.md). Where a supplier is
   `active`, an `assessment.md` with the sections above must exist.
2. **Arithmetic is shown.** IRS, CE and RRS are displayed with their working, not
   stated as conclusions. A score that cannot be re-derived cannot be
   re-performed.
3. **Attribution is to a natural person.** "Compliance Team", "DPO" or
   "Management" as an approver in a single-operator organisation is not evidence
   that anyone approved anything. Record the person and the capacity — see
   [`../docs/solo-operator-controls.md`](../docs/solo-operator-controls.md).
4. **Approval is not left pending on an active supplier.** An approval field in a
   pending state while data flows means the engagement was never approved.
5. **Each cycle is self-contained but cross-referenced.** The current assessment
   states the deltas from the prior cycle rather than requiring the reader to diff
   two documents.
6. **No contamination.** Text carried over from another supplier's assessment —
   a residual-risk narrative describing a different supplier's data flows —
   invalidates confidence in the whole document. The residual-risk section is read
   against this supplier's actual flows before approval.
7. **Sequence is preserved.** The assessment date precedes the date production
   data first flowed. Where it does not, the assessment records that fact and the
   gap is raised. **The dates are never adjusted to make the sequence correct** —
   that converts a process finding into an integrity finding.

## Assessment triggers

| Trigger | Procedure |
|---|---|
| New supplier | [`../docs/procedures/onboarding.md`](../docs/procedures/onboarding.md) |
| Scheduled reassessment by tier cadence | [`../docs/procedures/reassessment.md`](../docs/procedures/reassessment.md) |
| Sub-processor change | [`../docs/procedures/subprocessor-change.md`](../docs/procedures/subprocessor-change.md) |
| Supplier incident affecting our data | Incident procedure in `jolarca-compliance/incidents/`, then [`../docs/procedures/reassessment.md`](../docs/procedures/reassessment.md) |
| Certification lapse or scope change | [`../docs/procedures/reassessment.md`](../docs/procedures/reassessment.md) |
| Data categories sent increase | Reassess before the increase takes effect |
| Adoption of a new cloud service | [`../docs/procedures/cloud-services.md`](../docs/procedures/cloud-services.md) |
| Cardholder data enters scope | [`../docs/procedures/pci-tsp-management.md`](../docs/procedures/pci-tsp-management.md) |
| Exit | [`../docs/procedures/offboarding-exit.md`](../docs/procedures/offboarding-exit.md) |

## Depth by tier

From [`../docs/methodology/tiering-rubric.md`](../docs/methodology/tiering-rubric.md) §4:

| Tier | Assessment document | Questionnaire depth | Cadence |
|---|---|---|---|
| 1 | Full, all sections, all CE domains evidenced | Full, all sections | 12 months |
| 2 | Full, all sections | Full; technical evidence may rest on a current attestation | 12 months |
| 3 | Scored register entry plus short written rationale | Abbreviated | 24 months |
| 4 | Scored register entry only, with the DS 1 justification | Register entry | 36 months |

The Tier 4 DS 1 justification is one sentence and is mandatory. Tier 4 is where
undeclared personal data hides, and an unjustified DS 1 is the mechanism by which
it stays hidden.
