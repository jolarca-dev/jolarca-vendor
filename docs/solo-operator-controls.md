# Solo-Operator Controls and Separation of Duties

| | |
|---|---|
| Version | 1.0 |
| Status | Normative |
| Owner | `@JourneyOfLife` |
| Controls | ISO A.5.19 · SOC 2 CC9.2 · CC3.1–CC3.4 · PCI DSS 12.8 · GDPR Art. 24 |
| Next review | 2027-09-27 |

## The problem, stated plainly

Vendor management controls assume at least two people: someone performs the
assessment and someone else approves it. This organisation has **one operator**.
There are no teams, no committees, no second approver, and no security function
independent of the person doing the work.

Two responses to that are both wrong:

1. **Inventing the structure on paper.** A procedure naming a "Vendor Review
   Board", a "DPO" and a "Compliance Lead" that are all one person is not a
   control. It is a fiction that an auditor will test in about ninety seconds, by
   asking for the board's minutes. Worse, once caught it casts doubt on every
   other document in the system.
2. **Declaring separation of duties impossible and moving on.** Several genuine
   compensating controls exist. Not using them because perfect SoD is
   unattainable leaves real risk unmitigated for no reason.

The correct response is the third one: **implement the compensating controls that
actually work, name them explicitly, and state the residual gap honestly.** An
auditor accepts a documented, reasoned deviation with compensating controls far
more readily than an elaborate control that never operated.

## Acting in capacity

One natural person may hold several roles. What makes that auditable is not the
role title but a **record of which capacity was being acted in**, and when.

Every approval, acceptance and override records:

| Field | Content |
|---|---|
| Natural person | Full name, not a role title |
| Capacity acted in | For example: assessor, approver, risk owner, data protection lead |
| Decision | What was approved, rejected, or accepted |
| Basis | The evidence relied upon, by reference |
| Timestamp | ISO 8601, from the commit |
| Cryptographic binding | Signed commit; see below |

Recording "assessor: X, approver: X" is honest and is **stronger** evidence than
"Assessor: Compliance Team / Approver: DPO", because the second form claims a
separation that does not exist and cannot be substantiated. Where the same person
appears in both capacities, the compensating controls below are what provide the
assurance — not the titles.

An approval attributed to a role that has no holder is not evidence that anyone
approved anything. It is a finding.

## Compensating controls

Ordered by how much assurance they actually provide.

### 1. Automated gates as the independent check

This is the strongest control available, because it does not depend on the
operator's discipline at the moment of temptation.

| Gate | What it independently verifies |
|---|---|
| Register parity check | That the machine-readable and human-readable registers agree, and that every register entry has a corresponding supplier folder |
| Review currency gate | That no scheduled reassessment is overdue, by a hard margin — fails the build rather than warning |
| Policy review currency gate | That governance documents are within their review window |
| Evidence hash verification | That finalized evidence has not been altered since registration |
| Secret and PII scan | That no credential or personal data has entered the repository |
| Data-classification validator | That `confidential` or `restricted` content cannot sit in a `public` repository |

A gate that warns is not a control. These fail the build. Where a gate is
configured non-blocking — an advisory lint step, for example — it is described as
advisory in this document and is not counted as a compensating control.

### 2. Signed commits as the approval record

Commit signing binds a decision to a key held only by the operator, and produces
a timestamp that cannot be altered without invalidating the signature and
changing every descendant commit hash.

For vendor approvals, the signed commit **is** the approval record. The commit
message states the supplier, the tier, the residual risk score, the band, and
—for High or Critical bands — the compensating controls and an explicit
acceptance statement.

This is a real control with a real limitation, stated here because the limitation
matters: the same person holds the signing key and can author an approval, so
signing proves **authenticity and non-repudiation, not independence**. It
establishes who decided what and when, and that the record was not altered
afterwards. It does not establish that a second mind reviewed it.

Branch protection may not enforce signed commits. Where it does not, signing is
still performed, because the value is in the tamper-evident record rather than in
the enforcement — but the absence of enforcement is recorded as a deviation
rather than presented as a control that prevents unsigned approvals.

### 3. Immutability through history

Git history is append-only in practice: amending or rebasing published history
changes commit hashes and is detectable. Combined with force-push protection and
squash-only linear history, this makes retrospective alteration of an approval
visible.

Limitation, stated plainly: an administrator can rewrite history and can disable
protection. Nothing in-repository prevents that. The control is **detective, not
preventive**. Where protection is not enforceable — which depends on the
hosting plan and repository visibility — this control is weaker than it appears,
and the deviation register records that rather than claiming full protection.

### 4. Periodic self-attestation against generated evidence

Once per quarter the operator produces an attestation covering:

1. Every supplier in the register has an assessment, and every assessment has a
   current review date.
2. Every supplier at DS ≥ 3 has an executed, unexpired DPA.
3. Every supplier with a non-EU/EEA transfer has a TIA on file.
4. Every supplier at DS 5 has a current AoC with a recorded retrieval date.
5. Every open condition has a due date, and none is more than one cycle overdue.
6. No supplier is receiving data ahead of its assessment date.
7. The register, the supplier folders, and the RoPA recipients agree.

Each item is checked against **system-generated output** — a script listing, a
query result, a CI run — not against recollection. The output is retained with
the attestation. Self-attestation without the underlying generated evidence is a
statement of intent; with it, it becomes a testable assertion that an auditor can
re-perform.

The attestation is committed signed. It is the closest available substitute for a
management review, and is cross-referenced from
`jolarca-compliance/management-review/`.

### 5. External checkpoints

Controls the operator does not administer, and therefore cannot quietly bypass:

| Checkpoint | What it provides |
|---|---|
| Annual independent SOC 2 or ISO 27001 audit | A third party tests the whole system and reports exceptions the operator would not surface |
| Supplier-side attestations | Independent verification of supplier controls we cannot test |
| Dependabot and platform vulnerability alerts | Automated, external detection of supply-chain exposure |
| The hosting platform's own audit logging | Access records we do not control and cannot selectively edit |

The annual external audit is the **principal** compensating control for the
absence of internal separation of duties, and the others support it. This is
stated explicitly because it is the honest answer to "who reviews the reviewer":
somebody external, once a year, and the intervals between are covered by
automation and by self-attestation against generated evidence.

### 6. Two-person integrity for irreversible acts

Some actions are irreversible and cannot be compensated for after the fact. For
these, a deliberate delay substitutes for a second person:

1. The action is recorded as an intent, with its reason, in a commit.
2. A minimum interval — 24 hours for deletion of evidence, 7 days for termination
   of a Tier 1 supplier — passes before execution.
3. The action is then executed in a separate commit that references the intent.

This does not create independence. It creates **an opportunity to reconsider and
a record that reconsideration was possible**, and it prevents a single impulsive
act from being unrecoverable. It is used only where the cost of the delay is
acceptable: evidence deletion, mass credential revocation, and Tier 1 supplier
termination. It is not used for routine approvals, where the delay would simply
not be observed.

## What cannot be compensated

Recorded because an honest deviation register is worth more than a confident one,
and because these are exactly the items an assessor will probe.

1. **Independent review of judgement.** Scoring a supplier involves judgement.
   Nobody independent reviews that judgement before it takes effect. The rubric
   in [`methodology/tiering-rubric.md`](methodology/tiering-rubric.md)
   constrains it to defined rows and requires the row to be cited, which reduces
   variance — but it does not eliminate a single point of subjective failure.
2. **Override of one's own decision.** The operator may override a computed tier
   upward, and may accept a High-band risk. No second party can veto that. The
   compensating controls are the recorded reason, the signed commit, and
   examination at the next external audit.
3. **Prevention of administrative abuse.** The operator can alter records,
   disable gates, and rewrite history. Detection exists; prevention does not.
4. **Continuity.** Illness or unavailability halts vendor management entirely.
   There is no delegate. This is a resilience risk that no procedural control
   addresses, and it is the strongest argument for the automation in §1:
   automated gates continue to operate, and continue to fail loudly, when no
   human is available.
5. **Segregation between development and compliance.** The same person builds the
   systems and assesses the suppliers those systems depend on. Self-review bias
   is structural, not incidental.

These are accepted, documented, and revisited at each external audit and at each
management review. Acceptance is not permanent: the trigger for materially
improving this position is **onboarding a second operator**, at which point real
separation of duties becomes available and the deviations recorded here should be
closed rather than carried forward.

## Prohibited practices

Named because each is tempting under time pressure and each converts a manageable
process gap into an integrity finding.

- Attributing an approval to a role or team that does not exist.
- Backdating an assessment to precede a data flow that already occurred.
- Editing a finalized, hashed evidence item without recording the amendment.
- Bypassing a failing currency gate to unblock a merge.
- Recording an unevidenced assertion as verified.
- Deleting a terminated supplier's register entry.
- Marking a condition closed without the evidence that closes it.

Each of these is detectable, and each is more serious than the underlying gap it
is typically used to hide. Where a deadline makes one attractive, the correct
action is to record the gap and accept the consequence.
