# Procedure — Vendor Onboarding

| | |
|---|---|
| Version | 1.0 |
| Status | Normative |
| Owner | `@JourneyOfLife` |
| Controls | SOC 2 CC9.2 · ISO A.5.19 · ISO A.5.20 · GDPR Art. 28 · PCI DSS 12.8.2 / 12.8.3 |
| Next review | 2027-09-27 |

## Purpose

To ensure no supplier receives data, credentials, or production access before its
risk has been assessed, its agreement is in place, and the engagement is
approved. This discharges the **pre-engagement** limb of SOC 2 CC9.2 and
PCI DSS 12.8.3.

## Gate

> **No production data flows, and no credentials are issued, before step 8 is
> merged.** This is a hard gate. A supplier already receiving data without a
> completed onboarding is an open finding, not a work in progress — record it
> per [`../gap-intake.md`](../gap-intake.md) and remediate; do not backdate the
> assessment to make the sequence look correct. Backdating evidence is fraud and
> converts a process finding into an integrity finding.

## Inputs

- Intake request. Supplier intake is **confidential** and is raised in
  `jolarca-compliance`, never on this repository's public issue tracker — naming
  a supplier alongside its data categories on a public tracker discloses the
  supply chain. Routing is defined in `.github/ISSUE_TEMPLATE/config.yml`.
- Supplier's standard terms, DPA and any attestation reports.
- The RoPA entry for the processing this supplier will support, in
  `jolarca-compliance/ropa/master-register.csv`.

## Steps

### 1. Record the requirement and consider alternatives

Before contacting the supplier, record what business need the engagement meets
and identify at least one alternative, including the option of not engaging and
absorbing the work internally.

CC9.2 is tested on this step specifically. "We chose the obvious vendor" is not
a considered alternative. The record is two or three sentences: what alternatives
were examined, and why this one was selected. Where the selection was driven by
an existing commercial relationship or an integration already built, say so —
that is a legitimate reason, but it must be visible rather than inferred.

### 2. Classify the data

Determine the data categories the supplier will receive and map them to RoPA
identifiers. Assign the **DS** factor from
[`../methodology/risk-scoring.md`](../methodology/risk-scoring.md) §1.1, citing
the row used.

If DS ≥ 3, a DPA is mandatory. If DS = 5, PCI DSS Requirement 12.8 applies in
full and [`pci-tsp-management.md`](pci-tsp-management.md) runs alongside this
procedure.

Do not proceed on an assumed classification. Where the supplier's marketing
material and its DPA describe the data differently, the DPA governs, and the
discrepancy is raised with the supplier.

### 3. Issue due diligence

Send the questionnaire at the depth required by the provisional tier, per
[`../methodology/due-diligence.md`](../methodology/due-diligence.md) §2. Record
the evidence class (**E**, **A**, **N**) against every answer.

Chase unanswered mandatory sections. An unanswered mandatory section blocks
approval; it does not default to acceptable.

### 4. Assess transfer position

For every country in which our data will be processed, stored, backed up, or
accessed from — including by support staff — determine the mechanism. Where the
mechanism is SCCs and the destination lacks an adequacy decision, a **Transfer
Impact Assessment** is authored by us and filed in
`jolarca-compliance/vendor-assessments/tia/`.

The supplier does not issue the TIA. It supplies the DPA and SCCs as inputs.

A supplier's default regional configuration is not a transfer control. Only a
contractual region commitment prevents silent relocation, and only that
commitment is accepted as evidence.

### 5. Score

Assign DS, BC and AB. Calculate IRS. Score CE domains C1–C5. Calculate RRS and
the band. Derive the tier per
[`../methodology/tiering-rubric.md`](../methodology/tiering-rubric.md),
recording both `tier_from_rrs` and `tier_floor_from_ds`.

Show the arithmetic in the assessment. A score with no visible working cannot be
re-performed by an auditor and will be treated as unsupported.

### 6. Negotiate the agreement

Apply the tier's agreement obligations:

- **All tiers with DS ≥ 3:** DPA per Art. 28, checked against
  [`../agreements/dpa-checklist.md`](../agreements/dpa-checklist.md). Use the
  authoritative templates in `jolarca-legal/contracts/00-templates/`; do not
  draft a new DPA in this repository.
- **Tier 1 and 2:** the
  [security requirements schedule](../agreements/security-requirements-schedule.md)
  incorporated by reference into the contract.
- **Tier 1:** a signed
  [responsibilities matrix](../agreements/responsibilities-matrix.md), and for
  DS 5 the PCI DSS 12.8.2 acknowledgment.

Where the supplier refuses a mandatory clause, the refusal is recorded, a
compensating control is identified, and the residual position is re-scored. A
refused 72-hour breach notification clause is not a paperwork problem; it
directly impairs our own Art. 33 capability and caps CE domain C4.

### 7. Raise conditions

Every **A** or **N** answer in a mandatory section, every refused clause, and
every CE domain below 1.0 becomes a condition with a due date. Conditions are
tracked to closure and re-tested at the next reassessment.

Conditions without dates are not controls. An open-ended "supplier to improve"
note will be sampled by an auditor and found wanting.

### 8. Approve and file

1. Write the assessment into the supplier's folder in
   `jolarca-compliance/vendor-assessments/<vendor>/assessment.md`.
2. Add or update the entry in **both** `register.csv` and `register.md` in the
   same change. The parity check in that repository fails CI on drift; a
   register updated in one format only will not merge.
3. Update the RoPA where a new recipient is introduced.
4. Set `status` to `active` and `next_review` from the tier cadence.
5. Commit with a signature and a message naming the vendor, the tier and the
   RRS. The signed commit **is** the approval record — see
   [`../solo-operator-controls.md`](../solo-operator-controls.md).

If RRS falls in the **High** or **Critical** band, the commit message must also
contain the compensating controls and an explicit acceptance statement. Approval
of a High-band supplier is a risk acceptance and is recorded as one.

### 9. Provision access

Only now: issue credentials at least privilege, scoped to the data categories
assessed in step 2. Access broader than the assessed scope invalidates the AB
factor and therefore the score — re-score before widening access, not after.

Record the access granted in the assessment so that the next reassessment can
confirm it still matches.

## Outputs

| Output | Location |
|---|---|
| Completed questionnaire with evidence classes | `jolarca-compliance/vendor-assessments/<vendor>/` |
| Assessment with visible scoring arithmetic | `jolarca-compliance/vendor-assessments/<vendor>/assessment.md` |
| TIA where required | `jolarca-compliance/vendor-assessments/tia/` |
| Register entry, both formats | `jolarca-compliance/vendor-assessments/register.{csv,md}` |
| RoPA update | `jolarca-compliance/ropa/master-register.csv` |
| Executed agreement | `jolarca-legal/contracts/vendors/<vendor>/` |
| Approval record | Signed commit in `jolarca-compliance` |
| Access grant | Recorded in the assessment |

## Failure modes

Named because each has been observed in practice and each defeats the control
while leaving the paperwork looking complete.

- **Assessment after first data flow.** The sequence is the control. Detect by
  comparing the assessment date against the earliest integration commit or first
  transaction.
- **Register and assessment disagree.** Different DPA status, different TIA
  position, or different review dates for the same supplier. Two records that
  contradict each other are worse than one incomplete record, because neither
  can be relied upon. Resolve by re-verifying against the source document and
  correcting both in one change.
- **Approval recorded against a role that does not exist.** An approval
  attributed to "Compliance Team" or "DPO" in a single-operator organisation is
  not evidence that anyone approved anything. Record the natural person and the
  commit signature.
- **Contaminated assessment.** Text from another supplier's assessment left in
  the residual-risk narrative. Indicates copy-paste authorship and undermines
  confidence in the whole document. Read the residual-risk section against the
  supplier's actual data flows before approving.
- **Sub-processors deferred to vendor documentation.** Records as **N**. The
  list must be obtained; A.5.21 requires the chain to be identified.
- **Tier asserted rather than derived.** Where the register carries a tier with
  no DS/RRS inputs, the tier is unsupported. Do not invent retrospective scores
  to justify it — re-score at the next assessment and log the gap.
