# Security Requirements Schedule

| | |
|---|---|
| Version | 1.0 |
| Status | Normative template — incorporated by reference into supplier agreements |
| Owner | `@JourneyOfLife` |
| Controls | ISO A.5.20 · ISO A.5.21 · SOC 2 CC9.2 · GDPR Art. 28(3) · PCI DSS 12.8.2 |
| Applies to | Tier 1 and Tier 2 suppliers; Tier 3 where the supplier's own terms are silent |
| Next review | 2027-09-27 |

## Purpose

ISO A.5.20 requires information security to be **addressed within supplier
agreements**. A signed DPA satisfies Art. 28; it does not satisfy A.5.20, because
a DPA governs personal data and says little about access control, vulnerability
management, logging, or continuity.

This schedule is incorporated by reference into the agreement. It is written to
be auditable: every clause states an outcome and an evidence expectation, so that
compliance can be tested at reassessment rather than assumed from a signature.

Executed agreements are filed in `jolarca-legal/contracts/vendors/<vendor>/`.
Authoritative contract templates live in `jolarca-legal/contracts/00-templates/`;
this schedule does not replace them and is not a legal instrument on its own.

## How to use

For each clause record one of: **Accepted**, **Accepted with amendment** (state
the amendment), or **Refused** (state the reason, the compensating control, and
re-score CE). A blank is treated as refused.

Refusals are expected — suppliers have standard paper and will not sign arbitrary
terms. The discipline is that every refusal is visible, has a compensating
control, and moves the risk score. A refusal quietly dropped from the schedule is
how A.5.20 becomes unevidenced.

## 1. Information security management

| # | Requirement | Evidence expected |
|---|---|---|
| 1.1 | A documented information security policy, approved by management, reviewed within the last 12 months | Policy document, dated |
| 1.2 | A named role accountable for information security, with an escalation path independent of delivery or sales | Organisation statement |
| 1.3 | Security awareness training for all personnel at onboarding and at least annually | Completion records or rate |
| 1.4 | Personnel with access to our data bound by confidentiality obligations | Contract terms or policy |
| 1.5 | A disciplinary process for security policy breach | Policy reference |

## 2. Access control

| # | Requirement | Evidence expected |
|---|---|---|
| 2.1 | MFA enforced on all administrative access and all remote access to systems holding our data | Configuration evidence or attestation scope |
| 2.2 | Least-privilege access to our data, granted on documented approval and time-bound where practicable | Access model description |
| 2.3 | Access revoked within one business day of a leaver or role change | Joiner/mover/leaver process |
| 2.4 | Privileged sessions routed through a bastion or PAM tooling, with session logging | Architecture statement |
| 2.5 | Quarterly recertification of accounts with access to our data | Recertification record or attestation control reference |
| 2.6 | Support access to our data only on a request basis, logged, and never standing | Support access procedure |

## 3. Cryptography and key management

| # | Requirement | Evidence expected |
|---|---|---|
| 3.1 | Encryption in transit using TLS 1.2 or higher; deprecated protocols disabled | Configuration or attestation |
| 3.2 | Encryption at rest for all stores holding our data, including backups | Configuration or attestation |
| 3.3 | Keys held in an HSM or managed KMS, with rotation at a defined interval | Key management description |
| 3.4 | Separation of duties between key custody and data access | Access model |
| 3.5 | Where protection from the supplier itself is required, customer-managed keys supported | Product capability statement |

Clause 3.5 matters for DS 4 and DS 5 suppliers. Provider-held keys protect
against outside attackers only; the supplier can read the data. Where that is
unacceptable, key custody stays with us and is recorded per
[`../procedures/cloud-services.md`](../procedures/cloud-services.md) §1.

## 4. Vulnerability, patching and secure development

| # | Requirement | Evidence expected |
|---|---|---|
| 4.1 | Vulnerability scanning of internet-facing and internal systems at least monthly | Scan frequency, or attestation control |
| 4.2 | Remediation SLA: critical within 14 days, high within 30 days | Policy or attestation |
| 4.3 | Independent penetration test at least annually, with critical findings remediated | Test summary, dated, scope stated |
| 4.4 | Security testing in the development lifecycle: code review plus static or dynamic analysis | SDL description |
| 4.5 | Dependency and container scanning in the build pipeline | Pipeline description |
| 4.6 | Secrets held in a vault; no credentials in source control or images | Policy statement |

## 5. Logging and monitoring

| # | Requirement | Evidence expected |
|---|---|---|
| 5.1 | Security-relevant events logged for all systems holding our data | Logging scope |
| 5.2 | Logs protected from modification by the administrators they record | Architecture statement |
| 5.3 | Log retention of at least 12 months, with 3 months immediately available | Retention statement |
| 5.4 | Continuous monitoring with a defined alert triage SLA | Monitoring model, 24×7 or business hours |
| 5.5 | Logs relating to our data made available to us on request during an investigation | Contractual commitment |

## 6. Incident management and notification

| # | Requirement | Evidence expected |
|---|---|---|
| 6.1 | A documented incident response plan, tested within the last 12 months | Plan existence and last test date |
| 6.2 | **Notification to us without undue delay and in any event within 24 hours** of becoming aware of a personal data or security incident affecting our data | Contractual commitment |
| 6.3 | Notification to include: nature of the incident, data categories and approximate volumes affected, likely consequences, measures taken or proposed, and a contact point | Contractual commitment |
| 6.4 | Ongoing updates at agreed intervals until closure | Contractual commitment |
| 6.5 | Reasonable cooperation with our notification obligations to supervisory authorities and data subjects | Contractual commitment |
| 6.6 | No public statement naming us without prior written consent, except where law requires | Contractual commitment |

**Clause 6.2 is the single most important clause in this schedule.** Our own
GDPR Art. 33 obligation runs 72 hours from *our* awareness, and the supervisory
authorities relevant to this platform are the Lithuanian VDAI, the Latvian DVI
and the Estonian AKI. A supplier notifying us at 72 hours consumes our entire
window before we begin. A commitment longer than 48 hours caps CE domain C4 at
0.5 and is raised as a condition with a remediation date.

Where a supplier's standard terms offer only "without undue delay", the amendment
is sought explicitly and the outcome recorded.

## 7. Supply chain and sub-processors

| # | Requirement | Evidence expected |
|---|---|---|
| 7.1 | Prior written notice of at least 30 days before any new or replacement sub-processor | Contractual commitment |
| 7.2 | A right to object on reasonable data-protection grounds | Contractual commitment |
| 7.3 | Termination without penalty where a sustained objection is overridden, with data return and erasure | Contractual commitment |
| 7.4 | Flow-down of obligations equivalent to this schedule to every sub-processor | Contractual commitment, plus evidence on request |
| 7.5 | A current sub-processor list supplied on request within 10 business days | Contractual commitment |
| 7.6 | Notice where a sub-processor changes jurisdiction | Contractual commitment |
| 7.7 | Liability for sub-processor acts and omissions to the same extent as its own | Contractual commitment |

Clause 7.3 is what makes 7.2 real. A right to object with no remedy is not a
control — see
[`../procedures/subprocessor-change.md`](../procedures/subprocessor-change.md).

## 8. Resilience, continuity and exit

| # | Requirement | Evidence expected |
|---|---|---|
| 8.1 | Contractual RTO and RPO, not best-effort statements | Contract terms |
| 8.2 | Backups geographically separated, with restore tested at least annually and the last test date recorded | Test evidence |
| 8.3 | A business continuity plan, exercised at least annually | Last exercise date |
| 8.4 | Data export in a usable non-proprietary format, self-service where available | Product capability |
| 8.5 | Deletion of all our data on termination, including backups, within a stated maximum period | Contractual commitment |
| 8.6 | **Written certification of deletion**, naming the entity, data covered, date, and sub-processors included | Contractual commitment |
| 8.7 | Termination assistance for a defined period at a defined cost | Contract terms |
| 8.8 | Notice of at least 90 days for material adverse service change or end-of-life | Contractual commitment |

Clause 8.6 is the Art. 28(3)(g) evidence and is the clause most often missing.
Without it, offboarding ends with an unverified assertion that deletion occurred
— see [`../procedures/offboarding-exit.md`](../procedures/offboarding-exit.md) §5.

## 9. Audit and assurance

| # | Requirement | Evidence expected |
|---|---|---|
| 9.1 | An independent attestation — SOC 2 Type II or ISO 27001 — maintained, with scope covering the service we consume | Current report or certificate |
| 9.2 | Complementary user entity controls published in the attestation and made available to us | Report section |
| 9.3 | Attestations and penetration-test summaries supplied to us under NDA on request, annually | Contractual commitment |
| 9.4 | A right to audit, or to accept an equivalent independent report in lieu | Contractual commitment |
| 9.5 | Notification of any material change to certification status, including lapse or withdrawal | Contractual commitment |
| 9.6 | For DS 5: a current PCI DSS AoC supplied annually, with the scope description readable | AoC and retrieval record |

Clause 9.4 is frequently resisted by SaaS suppliers. Where refused, the
compensating control is 9.1 plus 9.3 — a current in-scope Type II report with
published CUECs, supplied annually. That substitution is recorded, and CE domain
C2 is capped at 0.5 where neither is available.

## 10. Data protection and jurisdiction

| # | Requirement | Evidence expected |
|---|---|---|
| 10.1 | Processing only on our documented instructions, including for transfers | DPA clause |
| 10.2 | No secondary use of our data, and **no use for model training, benchmarking, or product improvement** without separate written consent | Explicit clause |
| 10.3 | Data processed, stored and backed up only in the named regions; relocation requires prior notice | Contractual region commitment |
| 10.4 | A valid transfer mechanism for every third-country transfer, with SCC modules executed where relied upon | Executed SCCs |
| 10.5 | Assistance with data subject rights requests within 10 business days of referral | Contractual commitment |
| 10.6 | Assistance with DPIAs and with consultations with supervisory authorities | DPA clause |
| 10.7 | Notification of any legally binding request for our data, challenge of unlawful requests, and disclosure limited to the minimum required | Contractual commitment |
| 10.8 | Confirmation whether the supplier is subject to FISA 702, the CLOUD Act or equivalent | Written confirmation |

Clause 10.2 is asked explicitly and separately of AI and LLM suppliers. A
general prohibition on misuse does not cover model training, and the answer
changes the DS factor — training on our data may create retention we did not
authorise and cannot enumerate at exit.

Clause 10.3 requires a **contractual** commitment. A region selected in a console
is a default that the provider may change; only the contract prevents silent
relocation.

## 11. Liability and insurance

| # | Requirement | Evidence expected |
|---|---|---|
| 11.1 | Liability for breach of this schedule and of the DPA, not excluded by a general limitation clause | Contract terms |
| 11.2 | A liability cap appropriate to the data exposed — a cap set at twelve months' fees is inadequate for a DS 4 or DS 5 supplier | Contract terms |
| 11.3 | Cyber and professional indemnity insurance maintained at a stated level | Certificate of insurance |
| 11.4 | Indemnity for regulatory fines and notification costs arising from the supplier's breach, to the extent permitted by law | Contract terms |
| 11.5 | Notice of any change of control, insolvency event, or material litigation affecting the service | Contractual commitment |

Clause 11.2 is a commercial negotiation, not a security one, and is referred to
`jolarca-legal`. It is listed here because a supplier with strong technical
controls and a nominal liability cap transfers the financial consequence of its
own failure to us, which is a risk fact and belongs in the assessment.

## Refusal handling

Where a clause is refused:

1. Record the refusal verbatim, with the supplier's stated reason.
2. Identify a compensating control we can operate, or state that none exists.
3. Re-score the affected CE domain per
   [`../methodology/risk-scoring.md`](../methodology/risk-scoring.md) §3.
4. Raise a condition with a due date and re-test at the next reassessment.
5. For Tier 1 suppliers, refusals of clauses 6.2, 7.2, 7.3, 8.6, 10.1, 10.3 or
   12.8.2 acknowledgment are **approval-blocking** unless the owner records an
   explicit written risk acceptance naming the residual exposure.

The approval-blocking list is short and deliberate. Those clauses are the ones
whose absence cannot be compensated for by anything we control: they govern
whether we learn about an incident in time, whether we can stop an unacceptable
sub-processor, whether we can prove deletion, and whether processing is lawful
at all.
