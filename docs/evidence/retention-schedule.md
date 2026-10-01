# Vendor Evidence Retention Schedule

| | |
|---|---|
| Version | 1.0 |
| Status | Normative |
| Owner | `@JourneyOfLife` |
| Controls | GDPR Art. 5(1)(e) · Art. 5(2) · ISO A.5.22 · SOC 2 CC9.2 · PCI DSS 12.8 |
| Next review | 2027-09-27 |

## Status of the periods below — counsel to confirm

The retention periods in this schedule are **provisional and marked for legal
confirmation**. They are reasoned from the obligation named in each row; they are
not taken from a legal opinion.

The estate's 2026-08 initial build audit records at evidence item E23 that
retention markers must remain "counsel-to-confirm" and that **no uniform
ten-year assertion** may be made. This schedule follows that position rather than
presenting its periods as settled law.

Until counsel confirms them:

1. Apply the **shorter** of the period below and any period already fixed by an
   applicable contract, statute, or the retention rules in
   `jolarca-compliance/retention/`. Where they conflict, `jolarca-compliance`
   governs — that is where the retention decision is recorded and where
   `docs/adr/ADR-0001-anonymize-dont-delete.md` sets the approach.
2. **Do not delete on the strength of this document alone.** Deletion is
   irreversible and an under-retained record cannot be recovered. Where the correct
   period is uncertain, retain and diarise a review date rather than delete.
3. Record the confirmation when obtained: jurisdiction, counsel, date, and which
   rows it covers. An unconfirmed period that has already been relied upon for a
   deletion is the specific failure this banner exists to prevent.

The periods below assume Lithuanian, Latvian and Estonian law applies, per
`jolarca-compliance/docs/regulatory-contacts.md` (VDAI, DVI, AKI).

## Principles

1. **The longest applicable obligation governs.** Where a contractual, statutory,
   audit and tax period differ, the longest applies. Retention is set per record
   class, not per supplier.
2. **Retention is a limit, not a target.** GDPR Art. 5(1)(e) requires that
   personal data be kept no longer than necessary. Each period below states the
   obligation that justifies it; where no obligation remains, the shorter period
   applies.
3. **Ending a supplier relationship does not end the record.** An audit examines
   a period. A supplier active during that period must remain evidenced after
   exit, so terminated entries are retained, not deleted.
4. **Deletion is reviewed before execution, never automatic.** At the end of a
   period the record is checked against open legal holds, ongoing disputes, and
   open incidents. Deletion proceeds only where none applies.
5. **Deletion is recorded.** What was deleted, when, under which rule, and by
   whom. An unexplained absence of evidence is indistinguishable from destroyed
   evidence.

## Schedule

| Record class | Retention from | Period | Justifying obligation |
|---|---|---|---|
| Vendor register entry (active) | — | Life of relationship + 7 years | Audit trail for SOC 2 and ISO periods covering the relationship |
| Vendor register entry (terminated) | Termination date | 7 years | Audit trail; the period under review may post-date exit |
| Risk assessment and scoring | Assessment date | 7 years | SOC 2 CC9.2 periodic reassessment evidence across audit cycles |
| Due-diligence questionnaire and responses | Assessment date | 7 years | PCI DSS 12.8.3 pre-engagement due diligence |
| Attestations (SOC 2, ISO 27001, PCI AoC) | Period end date | 7 years | Demonstrates assurance was current when relied upon |
| Penetration test summaries | Test date | 7 years | As above |
| Executed DPA | Expiry or termination of the DPA | 10 years | Contractual limitation period; Art. 28 accountability |
| Executed SCCs and annexes | Termination of transfers | 10 years | Chapter V accountability; transfers may be examined after they cease |
| Transfer Impact Assessment | Last transfer date | 10 years | Must remain available for as long as the transfer it justified is examined |
| Master contract and statements of work | Contract end | 10 years | Contractual and tax limitation period |
| Signed responsibilities matrix | Last re-signature | 7 years | PCI DSS 12.8.5 |
| Sub-processor lists and change notifications | Superseded date | 7 years | A.5.21 supply chain evidence; Art. 28(2) authorisation trail |
| Objections, refusals and material correspondence | Correspondence date | 7 years | Evidence that the right to object was exercisable and exercised |
| Supplier incident notifications and our triage | Incident closure | 7 years | A.5.22; may also be input to our own breach records |
| Erasure certifications | Certification date | 7 years | Art. 28(3)(g) — the only proof deletion occurred |
| Data exports obtained at offboarding | Export date | Per the data category's own retention class | The export inherits the retention of the data it contains, not of the vendor record |
| Risk acceptances and approvals | Acceptance date | 7 years | Demonstrates who accepted what, and when |
| Evidence hash registry entries | Registration date | Life of the referenced record + 7 years | Integrity chain must outlive the item it covers |

## Special cases

**Data exports.** An export of personal data obtained at offboarding is a new
store of personal data. It does not inherit the vendor-record retention of 7
years by default; it inherits the retention class of the data it contains, per
`jolarca-compliance/retention/`. Where the underlying data has a shorter
retention, the shorter period applies and the export is deleted on that date.
Treating an export as vendor evidence indefinitely is a common way an
offboarding creates a fresh Art. 5(1)(e) breach.

**Legal hold.** Where litigation, a regulatory investigation, or a supervisory
authority inquiry is open or reasonably anticipated, all related records are
held indefinitely until the hold is lifted in writing. Holds are recorded with
their scope, the reason, and the reviewing party. A hold that is never reviewed
becomes permanent undeclared retention, so each hold carries a review date no
more than 12 months out.

**Open incident.** Records relating to a supplier security incident are held
until the incident is closed **and** any resulting notification obligation is
discharged, whichever is later.

**Superseded versions.** Superseded attestations and assessments are retained for
the full period, not discarded on replacement. The comparison between consecutive
cycles is itself evidence that reassessment was genuinely re-performed rather
than carried forward — deleting the predecessor removes the ability to
demonstrate that.

## Deletion process

1. Identify records reaching the end of their period.
2. Check for legal hold, open incident, open dispute, and open regulatory
   inquiry.
3. Where any applies, extend and record the reason and the new review date.
4. Where none applies, delete from all locations — primary storage, backups on
   their natural cycle, and any derived index.
5. Record the deletion: record class, identifier, period relied upon, date, and
   the person who authorised it, as a signed commit.
6. Remove or mark the corresponding evidence-registry entry as retired. The entry
   is marked, not silently deleted, so that the chain of custody remains
   explainable.

Backups age out on their natural cycle rather than being selectively purged.
Selective purge of backup media is generally impractical and, if claimed without
evidence, invites a finding. The retention position therefore states the backup
cycle explicitly so that the total exposure window is known rather than assumed
to be zero.

## Interaction with this repository

This repository is `public` and holds no vendor evidence, so nothing here is
subject to deletion on a retention clock. Governance documents carry a
`Next review` date in their header table instead, and are revised rather than
deleted. Superseded versions remain in git history by design; that history is
the change-control evidence required by ISO A.5.22 and by the methodology change
rule in [`../methodology/risk-scoring.md`](../methodology/risk-scoring.md) §7.

Where a document in this repository is withdrawn, it is marked `Status:
Superseded` with a pointer to its replacement, and a `CHANGELOG.md` entry is
made. Withdrawal by deletion would remove the evidence of what the governing
rule was during a prior audit period.
