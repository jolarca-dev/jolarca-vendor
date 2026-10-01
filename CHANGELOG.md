# Changelog

All notable changes to the vendor management methodology in this repository.

Format follows Keep a Changelog. This repository holds governance documents
rather than software, so versions describe the state of the method. Every entry
names the control affected, because a change to a control document that does not
identify its control cannot be traced at audit.

Entries are **appended, never rewritten**. The changelog is part of the
change-control evidence required by ISO A.5.22, and editing history defeats that
purpose.

## [1.0.0] - 2026-09-27

Initial establishment of the vendor management governance layer for the
jolarca-dev marketplace.

### Added

#### Methodology

- `docs/methodology/risk-scoring.md` — normative scoring model. Inherent risk as
  a weighted sum of data sensitivity, business criticality and access breadth
  (0.50 / 0.30 / 0.20); control effectiveness across five domains; residual risk
  with a 0.60 mitigation cap; four risk bands with dispositions; recalculation
  triggers; change-control rules. Controls: SOC 2 CC9.2, ISO A.5.19, A.5.21,
  A.5.22.
- `docs/methodology/tiering-rubric.md` — Tier 1–4 derived as the stricter of a
  residual-risk tier and an independent data-sensitivity floor, so that a strong
  supplier attestation cannot remove an obligation created by the data we hand
  over. Per-tier obligations, cadences, promotion and two-cycle demotion rules,
  upward-only overrides. Controls: SOC 2 CC9.2, ISO A.5.19, A.5.22,
  PCI DSS 12.8.3.
- `docs/methodology/due-diligence.md` — question standard aligned to SIG Lite and
  CSA CAIQ, with a three-class evidence model (Evidenced / Asserted / Not
  addressed) that caps control-effectiveness scores where a supplier asserts
  without proving. Nine sections plus a PCI section, with depth varied by tier.
  Controls: SOC 2 CC9.2, ISO A.5.19, A.5.21, PCI DSS 12.8.3.

#### Procedures

- `docs/procedures/onboarding.md` — pre-engagement gate, alternatives
  consideration, data classification, transfer assessment, scoring, agreement,
  conditions, approval and access provisioning, with named failure modes.
  Controls: SOC 2 CC9.2, ISO A.5.19, A.5.20, GDPR Art. 28, PCI DSS 12.8.2, 12.8.3.
- `docs/procedures/reassessment.md` — scheduled and event-driven reassessment,
  attestation refresh with provenance, delta verification, PCI DSS 12.8.4 annual
  confirmation, between-cycle monitoring. Controls: SOC 2 CC9.2, ISO A.5.22,
  PCI DSS 12.8.4.
- `docs/procedures/subprocessor-change.md` — ICT supply chain identification,
  review windows by tier, jurisdiction and data-exposure delta assessment,
  concentration analysis, objection handling. Controls: ISO A.5.21, A.5.22,
  GDPR Art. 28(2) and 28(4).
- `docs/procedures/cloud-services.md` — cloud shared-responsibility model by
  service model, adoption requirements, customer-side obligations, exit and
  portability. **Supplies ISO A.5.23, which the approved vendor policy does not
  cite**; the divergence is disclosed in `docs/scope-and-boundaries.md`.
  Controls: ISO A.5.23, A.5.21, GDPR Art. 28, Art. 32.
- `docs/procedures/offboarding-exit.md` — freeze, inventory, export-before-revoke,
  verified revocation, written erasure certification, contractual closure, record
  updates, post-exit review. Controls: GDPR Art. 28(3)(g), ISO A.5.19, A.5.22,
  PCI DSS 12.8.1.
- `docs/procedures/pci-tsp-management.md` — Requirement 12.8.1 through 12.8.5,
  including the cardholder-data acknowledgment that a DPA does not supply, annual
  AoC verification with provenance, and scope-reduction evaluation.
  Controls: PCI DSS v4.0 12.8.1–12.8.5.

#### Agreement standards

- `docs/agreements/security-requirements-schedule.md` — eleven clause groups for
  incorporation by reference into supplier agreements, with an evidence expectation
  per clause, a refusal-handling process, and a short list of approval-blocking
  clauses. Controls: ISO A.5.20, A.5.21, GDPR Art. 28(3), PCI DSS 12.8.2.
- `docs/agreements/dpa-checklist.md` — Article 28 verification checklist covering
  28(2), 28(3)(a)–(h) and 28(4), Article 32 measures, Article 33 notification,
  and Chapter V transfer instruments including SCC annex completeness.
  Controls: GDPR Art. 28, Art. 32, Art. 44–49, ISO A.5.20.
- `docs/agreements/responsibilities-matrix.md` — blank template for the PCI DSS
  requirement matrix and the cloud shared-responsibility matrix, with a
  complementary-user-entity-control table and five assignment rules.
  Controls: PCI DSS 12.8.5, ISO A.5.20, A.5.23.

#### Evidence and governance

- `docs/evidence/conventions.md` — naming scheme with a controlled artifact
  vocabulary, integrity hashing, provenance recording, currency limits, and an
  explicit table of what does not constitute evidence. Controls: SOC 2 CC9.2,
  ISO A.5.22, PCI DSS 12.8.4, GDPR Art. 5(2).
- `docs/evidence/retention-schedule.md` — retention by record class with the
  justifying obligation for each period, legal-hold and export special cases, and
  a reviewed-before-executed deletion process. Controls: GDPR Art. 5(1)(e),
  Art. 5(2), ISO A.5.22.
- `docs/solo-operator-controls.md` — separation-of-duties compensating controls
  for a single-operator organisation: automated gates as the independent check,
  signed commits as the approval record, immutability through history, quarterly
  self-attestation against generated evidence, external checkpoints, and
  deliberate delay for irreversible acts. States plainly what cannot be
  compensated for. Controls: ISO A.5.19, SOC 2 CC1.3, CC3.1–CC3.4, CC4.1, CC9.2.
- `docs/gap-intake.md` — where control gaps are recorded and why not here, with a
  required gap-record structure, severity scale, acceptance rules including the
  categories for which acceptance is unavailable, and notification escalation
  ahead of remediation. Controls: ISO A.5.22, SOC 2 CC4.1, CC9.2.
- `docs/scope-and-boundaries.md` — scope of vendor management including the
  broader PCI DSS limb, the relationship to the approved policy, the known
  A.5.23 divergence, honest role definitions, the content boundary for a public
  repository, and interaction with the rest of the estate.
  Controls: ISO A.5.19, SOC 2 CC9.2, PCI DSS 12.8.1.
- `docs/TRACEABILITY.md` — control-to-artifact matrix across SOC 2, ISO/IEC
  27001:2022 Annex A.5.19–A.5.23, GDPR and PCI DSS v4.0, separating operating
  records from artifacts that are **method only**.
- `docs/ASSUMPTIONS.md` — decisions D1–D6, contradictions C1–C5 found in the
  originating instruction and how each was resolved, every deviation from that
  instruction with its reason, the removed scaffold reproduced for
  recoverability, assumptions A1–A7 with verification steps, and separately what
  was verified rather than assumed.
- `register/README.md` and `register/schema.md` — index to the authoritative
  register, and the normative field contract: four column groups, eleven hard
  failures, seven warnings, six parity rules, and a migration rule that forbids
  back-filling invented scores.
  Controls: SOC 2 CC9.2, ISO A.5.19, A.5.21, A.5.22, PCI DSS 12.8.1.
- `assessments/README.md` — index to the authoritative assessments, the required
  assessment structure with the control behind each section, seven structural
  rules, triggers and depth by tier.

#### Repository infrastructure

- `README.md`, `LICENSE`, `SECURITY.md`, `CONTRIBUTING.md`, `CHANGELOG.md`.
- `Makefile` with `check`, `lint-docs`, `yaml-check`, `scan` and `selftest`
  targets. `selftest` is a negative control: it plants a synthetic credential,
  asserts the scan rejects it, then asserts the scan passes once removed — so that
  a clean result means "nothing found" rather than "the scanner is broken".
- `scripts/scan-secrets.sh` — self-contained secret, credential and personal-data
  scan across 13 rules. No dependencies beyond POSIX shell and GNU grep. Reports
  file and line only, never the matched value, because echoing a secret into a CI
  log re-discloses it.
- `.github/workflows/ci.yml` — the single `lint` status context required by branch
  protection, running markdown lint, YAML validation and the secret scan with
  least-privilege permissions.
- `.github/CODEOWNERS`, `.github/PULL_REQUEST_TEMPLATE.md`, and
  `.github/ISSUE_TEMPLATE/` — a `config.yml` that disables blank issues and
  routes confidential intake (supplier onboarding, incidents, contracts, gaps,
  repository settings) to the private repositories, plus a
  `methodology-defect.yml` form scoped so that a completed form is safe to
  publish. No vendor intake or incident form exists here: issues on this
  repository are public, and such a form would be a disclosure channel for
  exactly the content this repository excludes.
- `.markdownlint.json`, `.editorconfig`, `.gitignore` matching estate conventions.

### Removed

- `main.py` — unmodified PyCharm sample script. Reproduced in
  `docs/ASSUMPTIONS.md`.
- `pyproject.toml` — declared no dependencies and no build. Retaining it would
  imply a Python build that does not exist in a repository whose control
  definition declares `language: Markdown`. Reproduced in `docs/ASSUMPTIONS.md`.

### Notes

- This repository deliberately holds **no supplier-specific content**. It is
  `public` and classified `internal`; vendor records are `confidential` and remain
  in `jolarca-compliance` and `jolarca-legal`. See
  `docs/scope-and-boundaries.md` and `docs/gap-intake.md`.
- The originating instruction specified a Python implementation with pydantic
  models, mypy strict, ruff, pytest and a scoring engine. That was **not built**,
  because `jolarca-control/repos/jolarca-vendor.yml` declares
  `language: Markdown` and requires exactly one status check context, `lint`.
  Every deviation is recorded with its reason in `docs/ASSUMPTIONS.md`.
- The absence of a scoring implementation is declared **method only** in
  `docs/TRACEABILITY.md` rather than presented as an operating control. It is the
  highest-value automation candidate.

[1.0.0]: https://github.com/jolarca-dev/jolarca-vendor/releases/tag/v1.0.0
