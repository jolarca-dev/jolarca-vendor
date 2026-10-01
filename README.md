# jolarca-vendor

Vendor management governance for the **jolarca-dev marketplace**: the policy,
methodology, procedures and agreement standards that control how third parties
and suppliers are assessed, approved, monitored and exited.

| | |
|---|---|
| Tier | governance |
| Criticality | tier-2 |
| Visibility | public |
| Data classification | **internal** |
| Frameworks | SOC 2 · ISO/IEC 27001:2022 · GDPR · PCI DSS v4.0 |
| Owner | `@JourneyOfLife` (single operator) |
| Control definition | `jolarca-control/repos/jolarca-vendor.yml` |

## What this repository is

This is the **governance and methodology layer** for third-party risk. It defines
the rules; it does not hold the records. It answers:

- What makes a vendor Tier 1 versus Tier 4, and what each tier obliges us to do.
- How inherent and residual risk are calculated, with published weights.
- What must be true before a supplier may receive any data.
- What an agreement must contain (ISO A.5.20, GDPR Art. 28, PCI DSS 12.8.2).
- How cloud responsibility is split (ISO A.5.23).
- How a supplier is exited and its data returned or erased.

## What this repository is NOT

**It holds no vendor-specific records.** No named supplier risk scores, no
assessment findings, no contract terms, no transfer impact assessments, no
evidence. That content is `confidential` and lives in the private repositories
listed below.

This is deliberate and enforced. The repository is `public` while classified
`internal`; publishing supplier control weaknesses would disclose our own
attack surface and breach the confidentiality clauses of the agreements
themselves. `jolarca-control/scripts/validate_repos.py` hard-fails any
`confidential` or `restricted` classification in a public repository, so the
boundary is a build gate, not a convention. The CI secret and PII scan in
`.github/workflows/ci.yml` is the second gate.

## Source-of-truth map

One authoritative home per artifact class. This repository links; it never
copies. Duplicated registers produce contradictory audit evidence, which reads
as an uncontrolled process under SOC 2 CC9.2 and ISO A.5.22.

| Artifact | Authoritative location | Referenced here |
|---|---|---|
| Vendor / processor register | `jolarca-compliance/vendor-assessments/register.csv` + `register.md` | `register/README.md` |
| Vendor assessments | `jolarca-compliance/vendor-assessments/<vendor>/assessment.md` | `assessments/README.md` |
| Transfer Impact Assessments | `jolarca-compliance/vendor-assessments/tia/` | `docs/procedures/onboarding.md` |
| RoPA (GDPR Art. 30) | `jolarca-compliance/ropa/master-register.csv` | `docs/procedures/onboarding.md` |
| Vendor policy (approved instrument) | `jolarca-compliance/policies/07-vendor-third-party.md` | `docs/scope-and-boundaries.md` |
| DPA and contract texts | `jolarca-legal/contracts/00-templates/` | `docs/agreements/dpa-checklist.md` |
| Signed vendor contracts | `jolarca-legal/contracts/vendors/` | `docs/agreements/dpa-checklist.md` |
| Evidence hash registry | `jolarca-compliance/audits/evidence-registry.csv` | `docs/evidence/conventions.md` |
| Deviation register | `jolarca-control/docs/drift-findings.md` | `docs/gap-intake.md` |
| Repository settings (IaC) | `jolarca-control/repos/jolarca-vendor.yml` | `docs/scope-and-boundaries.md` |

## Control coverage

| Control | Subject | Where |
|---|---|---|
| SOC 2 CC9.2 | Vendor risk assessed before engagement; alternatives considered; periodic reassessment | `docs/procedures/onboarding.md`, `docs/procedures/reassessment.md` |
| ISO A.5.19 | Supplier relationships: policy, roles, process | `docs/scope-and-boundaries.md`, `docs/procedures/onboarding.md` |
| ISO A.5.20 | Security addressed within supplier agreements | `docs/agreements/security-requirements-schedule.md` |
| ISO A.5.21 | ICT supply chain and sub-processors | `docs/procedures/subprocessor-change.md` |
| ISO A.5.22 | Monitoring, review and change management of supplier services | `docs/procedures/reassessment.md`, `docs/procedures/subprocessor-change.md` |
| ISO A.5.23 | Cloud service security and shared responsibility | `docs/procedures/cloud-services.md` |
| GDPR Art. 28 / 32 | Processor contract content; security of processing | `docs/agreements/dpa-checklist.md` |
| PCI DSS 12.8.1–12.8.5 | Third-party service provider management | `docs/procedures/pci-tsp-management.md` |

Full matrix with per-requirement mapping: [`docs/TRACEABILITY.md`](docs/TRACEABILITY.md).

## Layout

| Path | Content |
|---|---|
| `docs/methodology/` | Risk scoring, tiering rubric, due-diligence standard |
| `docs/procedures/` | Onboarding, reassessment, sub-processor change, cloud, exit, PCI TSP |
| `docs/agreements/` | Security requirements schedule, responsibilities matrix, DPA checklist |
| `docs/evidence/` | Evidence naming, hashing and retention conventions |
| `docs/TRACEABILITY.md` | Control → artifact matrix |
| `docs/ASSUMPTIONS.md` | Recorded decisions and deviations |
| `docs/solo-operator-controls.md` | Separation-of-duties compensating controls |
| `docs/gap-intake.md` | Where control gaps are recorded, and why not here |
| `register/` | Pointer to the authoritative register + required-field contract |
| `assessments/` | Pointer to the authoritative assessments + expected structure |
| `.github/` | CI, confidential-intake routing and the method-defect form, PR compliance checklist, CODEOWNERS |

## Verification

```bash
make check     # markdown lint + YAML validation + secret/PII scan
make scan      # secret and PII scan only
make selftest  # negative control: prove the scan actually fires
```

CI runs the same gate on every pull request and push to `main` as the `lint`
status check, which is the only context branch protection requires for this
repository. `selftest` runs in CI too: a clean scan is only meaningful if the
scanner is known to reject a planted credential, so every run proves it.

## Contributing

Read [`CONTRIBUTING.md`](CONTRIBUTING.md) before opening a pull request. Every
change must state which control it affects. Security issues go through
[`SECURITY.md`](SECURITY.md), never a public issue.

## Licence

All rights reserved — see [`LICENSE`](LICENSE). Published for transparency, not
for reuse.
