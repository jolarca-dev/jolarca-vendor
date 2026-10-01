# Procedure — Cloud Service Security (ISO A.5.23)

| | |
|---|---|
| Version | 1.0 |
| Status | Normative |
| Owner | `@JourneyOfLife` |
| Controls | ISO A.5.23 · ISO A.5.21 · SOC 2 CC9.2 · GDPR Art. 28 / 32 |
| Next review | 2027-09-27 |

## Why this document exists

The approved vendor policy in
`jolarca-compliance/policies/07-vendor-third-party.md` cites **A.5.19–A.5.22**
and does not cite **A.5.23** — information security for use of cloud services —
even though the register contains cloud infrastructure, hypervisor, hosting and
offsite-backup suppliers. A.5.23 is a distinct control in ISO/IEC 27001:2022 and
is assessed separately.

This procedure supplies the A.5.23 implementation. Amending the approved policy
to cite A.5.23 is a change to `jolarca-compliance` and is raised separately per
[`../gap-intake.md`](../gap-intake.md); until it lands, this document is the
evidence that A.5.23 is addressed.

## Scope

Any service consumed over a network where the supplier operates the underlying
infrastructure: IaaS, PaaS, SaaS, managed hosting, hypervisor platforms, object
storage, CDN, DNS, certificate authorities, and managed AI/LLM APIs.

Self-hosted software running on infrastructure we control is **not** a cloud
service for A.5.23 purposes, but the underlying hosting provider is.

## 1. Service model determines the split

Responsibility follows the service model. The single most common cloud security
failure is assuming the provider secures something it has explicitly disclaimed.

| Layer | IaaS | PaaS | SaaS |
|---|---|---|---|
| Data classification and content | **Us** | **Us** | **Us** |
| Application code | **Us** | **Us** | Provider |
| Runtime, middleware, OS patching | **Us** | Provider | Provider |
| Virtualisation and hypervisor | Provider | Provider | Provider |
| Physical hosts, network, facilities | Provider | Provider | Provider |
| Identity and access to our tenant | **Us** | **Us** | **Us** |
| Network security group / firewall config within our tenant | **Us** | Shared | Provider |
| Encryption key custody | **Us** unless we accept provider-managed keys | Shared | Provider |
| Logging of our tenant activity | **Us** to enable and retain | Shared | Provider |
| Configuration drift in our tenant | **Us** | **Us** | Provider |

Three rows are consistently misjudged and are called out deliberately:

- **Identity and access to our tenant is ours in every model.** A provider's
  excellent platform security does not compensate for our own weak credential
  hygiene. Most cloud breaches are credential and misconfiguration failures on
  the customer side, not platform compromises.
- **Data classification is ours in every model,** including SaaS. Uploading
  DS 4 or DS 5 data to a SaaS tool that was adopted for a DS 2 purpose silently
  re-tiers the supplier.
- **Key custody.** Where the provider holds the only copy of the keys, it can
  read the data, and "encrypted at rest" provides confidentiality against
  outsiders only. Where we require protection from the provider itself, we hold
  the keys — this is recorded per supplier.

## 2. Requirements before adopting any cloud service

Run before the free trial, not after. Trial accounts routinely receive
production data, at which point the supplier is a processor and Art. 28 applies
whether or not a contract was signed.

1. **Service model declared** — IaaS, PaaS or SaaS — and the responsibility
   split from §1 recorded against the supplier.
2. **Region commitment contractual.** A region selected in the console is a
   default, not a control. Require a contractual commitment that our data is
   processed and backed up only in named regions, and that relocation requires
   notice. Providers do move workloads.
3. **Sub-processor list obtained,** and the chain assessed per
   [`subprocessor-change.md`](subprocessor-change.md).
4. **Provider attestations obtained and scope-checked.** A hyperscaler's SOC 2
   or ISO 27001 covers its platform. It does not cover our configuration of it.
   Read the **Complementary User Entity Controls** and assign each one — an
   unassigned CUEC is an unowned obligation that the provider's audit explicitly
   pushed onto us.
5. **Data residency for backups and DR** confirmed, including whether failover
   crosses a jurisdiction.
6. **Government access position** established: is the provider subject to FISA
   702, the CLOUD Act, or equivalent? Does it commit to notify, challenge, and
   minimise? For EU data this drives whether a TIA is required.
7. **Exit capability tested,** not merely documented — see §4.
8. **Shared-responsibility matrix signed** for Tier 1 suppliers, using
   [`../agreements/responsibilities-matrix.md`](../agreements/responsibilities-matrix.md).

Then run [`onboarding.md`](onboarding.md) in full. Cloud services are not a
lighter path through vendor management; several of the highest-DS suppliers in a
marketplace estate are cloud services.

## 3. Ongoing obligations on us

The provider secures the platform; these are ours regardless of how good the
provider is, and are the items an ISO A.5.23 assessment will test:

1. **Tenant access control.** MFA enforced on every human identity; no standing
   administrative access where just-in-time elevation is available; service
   identities scoped to least privilege; access reviewed at each reassessment.
2. **Configuration baseline.** Public-access defaults disabled on storage;
   network exposure minimised; configuration drift detected. A misconfigured
   bucket is our finding, not the provider's.
3. **Key management.** Custody recorded per supplier; rotation interval defined;
   separation between key custody and data access.
4. **Logging and retention.** Tenant activity logging enabled and retained long
   enough to investigate an incident discovered late. Providers often retain
   control-plane logs for far shorter than we assume.
5. **Secrets.** No credentials in source control, configuration files, or
   container images. The secret-scan gate in this repository's CI exists because
   cloud credentials are the most frequently leaked secret class in the estate.
6. **Shadow IT.** Cloud services adopted without intake are the principal route
   by which an unassessed supplier receives DS 4 data. Expense reports and
   outbound DNS are reviewed at each reassessment for undeclared services.
7. **Dependency and concentration.** Where multiple suppliers depend on one
   hyperscaler, that is a single point of failure wearing several names, and it
   is recorded.

## 4. Exit and portability

Cloud lock-in is a business-continuity risk that no provider control mitigates.
Recorded per supplier before adoption:

- Export formats, and whether export is self-service or requires provider action.
- Whether export includes **all** data categories we sent, including logs,
  metadata, and derived artifacts.
- Maximum time to complete deletion, and whether it extends to backups.
- Whether written confirmation of erasure is provided — required for Art. 28(3)(g).
- Termination assistance period and cost.
- Named alternative and the realistic switching effort.

Where no credible exit exists, that is recorded as an accepted concentration risk
with the reason, not omitted. An exit plan that has never been exercised is an
assertion; the first export test is the evidence.

## 5. Cloud-specific failure modes

- **CUECs never assigned.** The provider's audit transfers obligations to us and
  nobody accepts them. Detect by listing CUECs from the current report and
  confirming each has an owner and a control.
- **Trial becomes production.** Data flows before intake. Detect by comparing
  first-transaction or first-integration date against the assessment date.
- **Region treated as settled.** Console default relied on as a commitment.
  Detect by reading the contract, not the console.
- **Provider attestation read as covering our configuration.** It never does.
- **DS rise through usage.** A tool adopted for scrubbed telemetry later
  receives identifiers. The DS factor is re-confirmed at every reassessment
  against what is actually sent, not what was originally intended.
- **Backup copy in a third country.** Primary storage is in-region while DR
  replicas are not. Ask about backups explicitly and separately.
