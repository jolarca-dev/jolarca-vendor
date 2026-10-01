# Scope and Boundaries

| | |
|---|---|
| Version | 1.0 |
| Status | Normative |
| Owner | `@JourneyOfLife` |
| Controls | ISO A.5.19 · SOC 2 CC9.2 · PCI DSS 12.8.1 |
| Next review | 2027-09-27 |

## Scope of vendor management

In scope: every third party that receives our data, holds credentials to our
systems, can affect the security of our data or of cardholder data, or provides a
service on which the marketplace depends. This includes cloud providers, SaaS
tools, payment and logistics processors, AI and LLM APIs, support tooling,
self-hosted software vendors, and certificate authorities.

PCI DSS Requirement 12.8 reaches beyond data holders to any provider that **could
affect the security of cardholder data**. A supplier that never touches a PAN but
administers the hosting platform is in scope. The narrower definition — "vendors
we send data to" — is the most common cause of an incomplete TPSP list.

Out of scope:

- Individuals engaged as data subjects rather than suppliers.
- Customers and marketplace sellers, who are counterparties, not suppliers. They
  are governed by the seller terms and by KYC obligations, not by this framework.
- Public authorities exercising statutory functions, including tax and VAT
  validation services. These are recipients recorded in the RoPA where personal
  data is disclosed, but they are not suppliers under contract and cannot be
  subjected to due diligence or to a security requirements schedule. They are
  listed in the register with that basis stated, rather than omitted, so that the
  register reconciles to the RoPA.
- One-off purchases of goods with no data flow and no system access.

## Relationship to the approved policy

The **approved policy instrument** is
`jolarca-compliance/policies/07-vendor-third-party.md`. It is the document that
management approves and that an auditor reads first.

This repository holds the **implementation layer**: the methodology, procedures,
templates and standards that make the policy executable. The relationship is:

| Layer | Location | Changes when |
|---|---|---|
| Policy — intent and requirements | `jolarca-compliance/policies/07-vendor-third-party.md` | Management approves a change of intent |
| Methodology — how risk is measured and tiered | `docs/methodology/` | The scoring model or rubric changes |
| Procedures — how work is performed | `docs/procedures/` | The process changes |
| Agreement standards — what contracts must contain | `docs/agreements/` | Legal or control requirements change |
| Records — the evidence itself | `jolarca-compliance/`, `jolarca-legal/` | Continuously |

Where this repository and the policy conflict, **the policy governs** and the
conflict is raised as a gap per [`gap-intake.md`](gap-intake.md). A methodology
document cannot silently amend an approved policy; if it did, the approved
instrument would no longer describe what is actually done, which is a finding in
itself.

### Known divergence

The policy cites **ISO A.5.19–A.5.22** and does not cite **A.5.23** (information
security for use of cloud services), although cloud and hosting suppliers are in
the register. A.5.23 is a separate control in ISO/IEC 27001:2022 and is assessed
separately.

[`procedures/cloud-services.md`](procedures/cloud-services.md) implements A.5.23.
Amending the policy's control citation is a change to `jolarca-compliance` and is
raised through gap intake rather than assumed here. Until the policy is amended,
that procedure is the evidence that A.5.23 is addressed — and the divergence
itself is disclosed rather than left for an assessor to find, because a control
mapping that does not match the approved policy undermines confidence in the
whole mapping.

## Roles

ISO A.5.19 requires roles and responsibilities to be defined. The honest position
for this organisation:

| Role | Holder | Responsibilities |
|---|---|---|
| Vendor management owner | `@JourneyOfLife` (natural person, single operator) | Maintains this framework; performs assessments; approves engagements; owns the register; performs reassessments; records risk acceptances |
| Data protection lead | The same natural person, acting in a distinct capacity | Determines lawful basis and transfer position; authorises DPAs; assesses Art. 33 notification duty |
| Contract authority | The same natural person | Executes agreements; holds the `jolarca-legal` templates |
| Independent reviewer | **None internally** | Compensated by automated CI gates and the annual external audit |

Roles are capacities, not people. Recording one person against four roles is
accurate; recording four fictional role-holders is not, and an auditor will ask
for the second approver's identity. How the absence of an independent reviewer is
compensated is set out in
[`solo-operator-controls.md`](solo-operator-controls.md).

Where a document in this repository refers to "the owner", it means the natural
person above acting in the capacity named in that document.

## Repository boundaries

What belongs here, and what does not.

| Content | Belongs here | Reason |
|---|---|---|
| Scoring methodology, weights, formula | Yes | Method is not confidential and benefits from being public |
| Tiering rubric and cadences | Yes | As above |
| Due-diligence question standard | Yes | As above; suppliers may read it before being sent it |
| Procedures for onboarding, reassessment, exit | Yes | Process definition |
| Security requirements schedule (template) | Yes | Template clauses contain no supplier data |
| Responsibilities matrix (blank template) | Yes | As above |
| Evidence naming and retention conventions | Yes | Conventions, not evidence |
| A.5.23 cloud shared-responsibility model | Yes | Generic model |
| Vendor register data | **No** | Confidential; authoritative copy in `jolarca-compliance` |
| Completed assessments and scores | **No** | Confidential; supplier-confidential and discloses our risk position |
| Transfer Impact Assessments | **No** | Confidential; discloses transfer vulnerabilities |
| Executed contracts and DPAs | **No** | Confidential; `jolarca-legal` |
| Gap and finding lists | **No** | Discloses weaknesses; see [`gap-intake.md`](gap-intake.md) |
| Supplier names paired with findings | **No** | Both confidential and commercially damaging |
| Secrets, credentials, tokens | **No** | Enforced by the CI scan |
| Personal data of supplier personnel | **No** | Enforced by the CI scan; contact details belong in the confidential assessment |

The test applied to every addition: **would this be acceptable to read aloud to a
competitor and to an attacker?** Method, yes. Findings, no.

## Classification

This repository is classified `internal` and is `public`. That combination is
permitted by `jolarca-control/scripts/validate_repos.py`, which forbids
`confidential` and `restricted` content in a public repository but allows
`internal`.

The classification is therefore a **constraint on content**, and adding a single
supplier finding would breach it. Where in doubt, the content goes in
`jolarca-compliance` and a pointer is left here.

Settings for this repository — visibility, topics, branch protection, required
status checks — are managed as infrastructure in
`jolarca-control/repos/jolarca-vendor.yml` and applied by Terraform. **Do not
change them in the GitHub UI.** Out-of-band changes drift from state and are
either reverted or, worse, silently diverge. A settings change is a pull request
against `jolarca-control`.

## Interaction with other repositories

| Repository | Interaction |
|---|---|
| `jolarca-compliance` | Holds the register, assessments, TIAs, RoPA, incidents, audits, retention and the approved policy. Consumes this repository's methodology |
| `jolarca-legal` | Holds contract and DPA templates and executed vendor contracts. Consumes the security requirements schedule and responsibilities matrix |
| `jolarca-control` | Holds this repository's settings as code, the estate deviation register, and the classification validator |
| `jolarca-security` | Owns security controls that supplier assessments depend upon — access review, logging, secrets management |
| `jolarca-payments` | Determines the cardholder-data environment and therefore which suppliers are at DS 5 |
| `jolarca-infrastructure` | Determines which suppliers are cloud services and the shared-responsibility position |
| `.github` (org) | Org-wide SECURITY.md inheritance and organisation defaults |

This repository is **standalone** in the sense that it builds and verifies
independently and nothing imports it as a library. It is not standalone in
governance: it is read alongside the repositories above, and its authority is
limited to method.
