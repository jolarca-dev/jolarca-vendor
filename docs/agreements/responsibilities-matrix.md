# Responsibilities Matrix Template

| | |
|---|---|
| Version | 1.0 |
| Status | Normative template |
| Owner | `@JourneyOfLife` |
| Controls | PCI DSS v4.0 12.8.5 · ISO A.5.20 · ISO A.5.23 · SOC 2 CC9.2 |
| Required for | Tier 1 suppliers; any supplier at DS 5; any cloud service |
| Next review | 2027-09-27 |

## Purpose

To establish, in writing and signed by both parties, **who performs each
applicable requirement**. PCI DSS 12.8.5 requires a documented understanding of
the responsibilities of each TPSP and of us. ISO A.5.23 requires the shared
responsibility position for cloud services to be clear.

The matrix is what converts "our provider is compliant" into a defensible
statement about **our** compliance. Without it, a provider's attestation tells an
assessor nothing about the requirements that remain ours — and there are always
some.

Completed matrices are `confidential` and are filed with the contract in
`jolarca-legal/contracts/vendors/<vendor>/`. This template contains no supplier
data.

## Rules

1. **Every applicable row is assigned.** A blank cell is an unmanaged
   requirement. Where assignment is genuinely undetermined, the requirement
   defaults to **ours** until proven otherwise, and a condition is raised with a
   date. Defaulting to the provider is the error the rule exists to prevent.
2. **"Shared" is decomposed.** A shared row must state which part each party
   performs in the Notes column. "Shared" alone is not an assignment and will be
   challenged.
3. **CUECs are mapped in.** Where the provider's attestation lists complementary
   user entity controls, each appears as a row assigned to us, because that is
   precisely what a CUEC is: an obligation the provider's audit transferred to
   its customers.
4. **Re-signed on change.** Service change, provider validation-scope change, or
   a change in our use of the service. A matrix that no longer matches the
   architecture is worse than none, because it is relied upon.
5. **Signed by both parties.** An unilaterally completed matrix is our opinion
   about the provider's obligations, not an agreement.

## Assignment key

| Value | Meaning |
|---|---|
| **P** | Provider performs this entirely |
| **C** | Customer (us) performs this entirely |
| **S** | Shared — the Notes column states which part each party performs |
| **N/A** | Not applicable — the Notes column states why |

## Matrix — PCI DSS v4.0

| Req | Subject | P | C | S | Notes (mandatory for S and N/A) |
|---|---|---|---|---|---|
| 1 | Network security controls | | | | |
| 2 | Secure configuration of system components | | | | |
| 3 | Protection of stored account data | | | | |
| 4 | Cryptographic protection of data in transit over open networks | | | | |
| 5 | Protection from malicious software | | | | |
| 6 | Development and maintenance of secure systems and software | | | | |
| 7 | Restriction of access by business need to know | | | | |
| 8 | User identification and authentication | | | | |
| 9 | Restriction of physical access to account data | | | | |
| 10 | Logging and monitoring of access | | | | |
| 11 | Regular testing of security systems and processes | | | | |
| 12 | Organisational security policy and programmes | | | | |

Requirement-level granularity is the minimum. Where a sub-requirement splits
differently — Requirement 3 for tokenised versus stored data, or Requirement 8
for provider personnel versus our tenant administrators — the sub-requirement is
broken out as its own row. Collapsing a split requirement into a single "S" cell
hides the part that is ours.

## Matrix — cloud shared responsibility (ISO A.5.23)

Used alongside the PCI matrix for cloud services. Rows are drawn from
[`../procedures/cloud-services.md`](../procedures/cloud-services.md) §1 and are
completed against the **declared service model** — IaaS, PaaS or SaaS — which is
stated in the header of the completed matrix.

| Layer | P | C | S | Notes |
|---|---|---|---|---|
| Physical facilities, hosts, hypervisor | | | | |
| Platform network and perimeter | | | | |
| Guest OS patching and hardening | | | | |
| Runtime, middleware, managed platform components | | | | |
| Application code and dependencies | | | | |
| Tenant configuration: firewall rules, exposure, public-access defaults | | | | |
| Identity and access management for our tenant | | | | |
| MFA for our tenant identities | | | | |
| Encryption at rest | | | | |
| Encryption key custody and rotation | | | | |
| Tenant activity logging: enabling, retention, review | | | | |
| Platform security monitoring and alerting | | | | |
| Backup execution | | | | |
| Backup restore verification | | | | |
| Data classification and what is uploaded | | | | |
| Region selection and residency assurance | | | | |
| Vulnerability management of provider platform | | | | |
| Vulnerability management of our workloads | | | | |
| Incident detection on the platform | | | | |
| Incident detection in our tenant configuration | | | | |
| Incident notification to us | | | | |
| Data export and deletion on exit | | | | |

Three rows are ours in every service model and must never be assigned to the
provider: **identity and access to our tenant**, **tenant configuration**, and
**data classification**. Most cloud breaches are credential and
misconfiguration failures on the customer side. Assigning those rows to a
provider that has explicitly disclaimed them is the most consequential error this
matrix can contain, and it is the first thing an assessor checks.

## Complementary user entity controls (CUECs)

| CUEC ref (from provider report) | Obligation as stated by the provider | Our implementing control | Owner | Verified |
|---|---|---|---|---|
| | | | | |

Every CUEC in the current attestation appears here. Each is verified at
reassessment — a CUEC listed but not implemented means the provider's assurance
does not transfer to us, and the attestation provides less comfort than it
appears to. An unverified CUEC row caps CE domain C2 at 0.5.

## Completion and sign-off

| Field | Value |
|---|---|
| Supplier legal entity | |
| Service model (IaaS / PaaS / SaaS) | |
| Provider attestation relied upon, with version and date | |
| DS factor and tier | |
| Completed by (customer) | |
| Date | |
| Agreed by (provider) | |
| Date | |
| Last re-signed | |
| Next re-signature due | |

The completed matrix is filed with the contract, referenced from the supplier's
assessment, and re-signed per rule 4. The sign-off is evidenced by the
provider's counter-signature and by our signed commit — see
[`../solo-operator-controls.md`](../solo-operator-controls.md).

Where a provider refuses to counter-sign, the matrix is completed unilaterally,
the refusal is recorded, and the residual position is treated as unassigned per
rule 1 — meaning those requirements are ours. A provider unwilling to state what
it is responsible for has not limited its responsibility; it has left the
boundary undefined, and an assessor will resolve that boundary against us.
