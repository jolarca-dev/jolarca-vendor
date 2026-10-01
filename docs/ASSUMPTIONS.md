# Assumptions, Decisions and Deviations

| | |
|---|---|
| Version | 1.0 |
| Recorded | 2026-09-27 |
| Owner | `@JourneyOfLife` |

Every assumption made during the establishment of this repository, every decision
taken, and every deviation from the instruction that created it. Recorded so that
a later reader — or an assessor — can distinguish a deliberate choice from an
oversight.

## Decisions taken

| Ref | Question | Decision | Basis |
|---|---|---|---|
| D1 | Nature of the deliverable: artifacts only, software only, or both | **Governance artifacts only** | `jolarca-control/repos/jolarca-vendor.yml` declares `language: Markdown`. Building a Python service would contradict the authoritative control definition and the branch-protection contexts it sets |
| D2 | Which suppliers appear in the register held here | **None** | The repository is `public` and classified `internal`. Supplier names paired with findings are `confidential`. The register is indexed, not reproduced |
| D3 | Data each supplier touches, and therefore whether PCI DSS 12.8 and GDPR Art. 28 apply | **Derived from the authoritative register, not assumed** | `jolarca-compliance/vendor-assessments/register.csv` was read. It confirms a payment processor, so PCI DSS 12.8 is in scope and [`procedures/pci-tsp-management.md`](procedures/pci-tsp-management.md) is included. **No KYC vendor appears in the register**, so the instruction's assumed KYC supplier was not carried forward |
| D4 | Persistence | **Not applicable** | No software in this repository. Persistence of the register is governed by [`../register/schema.md`](../register/schema.md); the store itself is files under version control in `jolarca-compliance` |
| D5 | Interface: CLI, API, library, or documents | **Documents, plus a public issue form scoped to method defects** | Markdown repository. `has_issues: true` in the control definition permits issues, but issues here are **public**, so vendor intake and incident forms were deliberately not created — both would collect confidential supplier content. `.github/ISSUE_TEMPLATE/config.yml` routes that intake to `jolarca-compliance` and `jolarca-legal` instead |
| D6 | Consumed by other repositories, or standalone | **Standalone** | Nothing imports this repository. It is read alongside `jolarca-compliance`, `jolarca-legal` and `jolarca-control` but has no build or runtime dependency in either direction |

## Contradictions found in the instruction, and how each was resolved

The instruction that created this repository contained five statements that the
estate contradicted. Each was raised before generation rather than resolved
silently.

| Ref | Instruction stated | Estate stated | Resolution |
|---|---|---|---|
| C1 | Python 3.12, pydantic, mypy strict, pytest, `src/jolarca_vendor/`, CLI, scoring engine | `language: Markdown`; branch protection requires exactly one status check, `lint` | **Markdown.** No Python source is committed. D1 above |
| C2 | Publish a named vendor register, assessments, DPA terms and evidence | `visibility: public`, `data_classification: internal`; `validate_repos.py` forbids `confidential` content in a public repository | **Publish method only.** No supplier-specific content. See [`gap-intake.md`](gap-intake.md) for why findings are not published |
| C3 | Create register, assessments, DPA clause library and review automation here | All five already exist in `jolarca-compliance` and `jolarca-legal` | **Index and reference layer.** One source of truth per artifact class; see [`../README.md`](../README.md) source-of-truth map |
| C4 | Assume a payment processor and a KYC vendor | Register contains a payment processor; **no KYC vendor** | Scope derived from the real register. PCI DSS 12.8 in scope; the KYC assumption dropped |
| C5 | Treat the repository as a new build | `launch_status: planned`, `auto_init: false`; the local directory was not a git repository | Git initialised against the existing empty `origin` before any file was written |

## Deviations from the instruction

The instruction specified a component list. These items were **not** created,
with the reason in each case. A deviation recorded here is a decision; the same
deviation recorded nowhere is a gap.

| Instructed | Delivered | Reason |
|---|---|---|
| `src/jolarca_vendor/` with pydantic domain models, validators, scoring engine, CLI | Not created | D1. `language: Markdown`. The scoring model is normative in [`methodology/risk-scoring.md`](methodology/risk-scoring.md) and its absence as code is declared **method only** in [`TRACEABILITY.md`](TRACEABILITY.md) |
| `tests/` with unit tests for scoring, validation, tiering, register loading | Not created | No code to test. The equivalent assurance is the CI gate in `.github/workflows/ci.yml` |
| `pyproject.toml` with ruff, mypy, pytest configuration | Not created | No Python source. Retaining it would imply a build that does not exist |
| `.env.example` | Not created | This repository has no runtime and takes no configuration. An `.env.example` in a documentation repository invites a future contributor to add secrets to a public repo — the opposite of its intent |
| `register/` holding the register | `register/README.md` index plus `register/schema.md` field contract | C3. The register is authoritative in `jolarca-compliance`; duplicating it creates two sources of truth |
| `assessments/` holding assessments | `assessments/README.md` index plus required assessment structure | C2 and C3 |
| `agreements/` holding a DPA clause library | `docs/agreements/dpa-checklist.md` verification checklist | C3. DPA texts are authoritative in `jolarca-legal/contracts/00-templates/`. A second clause library would diverge |
| `evidence/` holding evidence | `docs/evidence/conventions.md` and `retention-schedule.md` | C2. Evidence is `confidential` |
| `docs/vendor-management-policy.md` | `docs/scope-and-boundaries.md`, referencing the approved policy | C3. `jolarca-compliance/policies/07-vendor-third-party.md` is the approved instrument. A second policy would not be the approved one |
| mypy strict and ruff clean; pytest passing | markdownlint, YAML validation, secret and PII scan | D1. These are the checks appropriate to a Markdown repository and are what the `lint` status context runs |
| CI running lint, type check and tests | CI running the single `lint` context | Branch protection in the control definition requires exactly `lint`. A CI job producing contexts that nothing requires is not a control, and one that renames the required context blocks every merge |

Items added that were **not** instructed:

| Added | Reason |
|---|---|
| [`procedures/cloud-services.md`](procedures/cloud-services.md) | ISO A.5.23. The instruction listed A.5.19–A.5.23, but the approved policy cites only A.5.19–A.5.22 and no artifact in the estate covered A.5.23. Included because the register contains cloud and hosting suppliers |
| [`solo-operator-controls.md`](solo-operator-controls.md) | The instruction assumed roles. The estate has one operator and no teams. Separation-of-duties compensating controls had to be defined explicitly or every approval in the system would name a role with no holder |
| [`gap-intake.md`](gap-intake.md) | Required to make C2 coherent: if findings cannot be published here, there must be a defined place they go |
| [`../register/schema.md`](../register/schema.md) | The scoring methodology requires register fields that the existing register does not have. Specifying the contract here is how the methodology becomes executable without this repository holding the data |
| [`TRACEABILITY.md`](TRACEABILITY.md) "Control gaps — method only" | The instruction required a control-to-file table. Presenting method as operating control would make the table misleading, so the distinction is stated |
| `.github/ISSUE_TEMPLATE/config.yml` | `has_issues: true` means issues exist whether or not they are shaped. Blank issues are disabled and confidential intake is routed away, because an unstructured public issue is the easiest accidental disclosure path for supplier content |
| `.github/ISSUE_TEMPLATE/methodology-defect.yml` | Defects in published method are the one class of report that is genuinely safe to file publicly. The form's fields are chosen so a completed report contains no supplier name or score |
| `scripts/scan-secrets.sh` and `scripts/scan-allowlist.txt` | `required_gates.secret_scan: true` in the control definition, and the repository is public. Implemented as POSIX shell plus GNU grep rather than Python so that no source is committed to a repository declared `language: Markdown`; the estate's own `redact-pii.py` is not reachable from a separate repository's CI |
| `.github/PULL_REQUEST_TEMPLATE.md` | `require_conversation_resolution: true` and `web_commit_signoff_required: true` are set for this repository; the template carries the compliance attestations those settings imply |

## Scaffold removed

The instruction directed that the existing scaffold be deleted rather than
refactored. Two files were removed. Their content is reproduced here so that the
deletion is reversible without recourse to git history, which at the time of
deletion did not yet contain them.

`main.py` — unmodified PyCharm sample:

```python
# This is a sample Python script.

# Press Shift+F10 to execute it or replace it with your code.
# Press Double Shift to search everywhere for classes, files, tool windows, actions, and settings.


def print_hi(name):
    # Use a breakpoint in the code line below to debug it.
    print(f'Hi, {name}')  # Press Ctrl+F8 to toggle the breakpoint.


# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    print_hi('PyCharm')

# See PyCharm help at https://www.jetbrains.com/help/pycharm/
```

`pyproject.toml`:

```toml
[project]
name = "jolarca-vendor"
version = "0.1.0"
requires-python = ">=3.12"
dependencies = []
```

Neither contained project logic. A local `.venv/` created by `uv` and a `.idea/`
directory remain on disk and are git-ignored; they are developer artifacts, not
repository content.

## Assumptions carried forward

Each is an assumption rather than a verified fact, and each should be confirmed
before it is relied upon in an audit response.

| Ref | Assumption | How to verify | Impact if wrong |
|---|---|---|---|
| A1 | The GitHub repository `jolarca-dev/jolarca-vendor` exists and is empty (unborn) | `git ls-remote https://github.com/jolarca-dev/jolarca-vendor` returned exit 0 with zero refs on 2026-09-27; a nonexistent repository returns a "not found" error instead | If it does not exist, the push target is wrong and the repository must be provisioned through `jolarca-control` first |
| A2 | `visibility: public` in the control definition reflects the live setting | Query the GitHub API for the repository. Note that `jolarca-compliance.yml` records its own settings as verified **except visibility**, and that estate finding D-01 covers four repositories declared private but live public | If the repository is actually private, publishing method-only content is still safe, but the classification reasoning in [`scope-and-boundaries.md`](scope-and-boundaries.md) would be over-conservative |
| A3 | `@JourneyOfLife` is the correct GitHub handle for the operator | `gh api user` returned that login on 2026-09-27 | CODEOWNERS would be unresolvable, reproducing estate finding D-20 |
| A4 | PCI DSS is in scope for the platform | `jolarca-control/repos/jolarca-vendor.yml` lists `pci-dss` among frameworks, and the register contains a payments processor at DS 5 | If the cardholder-data environment is fully outsourced and scope is nil, `procedures/pci-tsp-management.md` remains correct but applies to no supplier |
| A5 | The estate deviation register is the right home for cross-cutting findings | `jolarca-control/docs/drift-findings.md` exists, carries numbered findings with severity, blocking status and dated corrections | Findings would need a different home; [`gap-intake.md`](gap-intake.md) would need amendment |
| A6 | Litigation and contractual limitation periods of 10 years apply | Confirm against Estonian, Latvian and Lithuanian law with counsel — the platform's supervisory authorities are VDAI, DVI and AKI | Retention periods in [`evidence/retention-schedule.md`](evidence/retention-schedule.md) would need adjustment. The periods chosen are deliberately conservative |
| A7 | Supervisory authorities are VDAI (Lithuania), DVI (Latvia) and AKI (Estonia) | Taken from `jolarca-compliance/LICENSE` | Breach notification routing in the security requirements schedule would name the wrong authorities |

## What was verified, not assumed

Recorded separately, because the distinction between verified and assumed is what
makes this document useful.

| Fact | Verification |
|---|---|
| Local directory contained only `main.py` and `pyproject.toml` and was not a git repository | Directory listing; `git rev-parse` returned "not a git repository" |
| Python 3.12.3, uv 0.12.17, ruff 0.16.5, mypy 2.3.1 available; pytest absent | Version commands executed |
| The estate contains pre-existing vendor policy, register, assessments, TIA directory, onboarding issue form, review-due workflow and review-dates script | `find` across `/opt/jolarca/repos` |
| The register contains 12 suppliers and no KYC vendor | `register.csv` read in full |
| `register.md` lists 9 suppliers while `register.csv` lists 12 | Both files read in full |
| The approved policy cites A.5.19–A.5.22 and omits A.5.23 | `policies/07-vendor-third-party.md` read in full |
| `validate_repos.py` forbids `confidential`/`restricted` in a public repository and permits `internal` | Source read |
| The house `lint` CI job runs markdownlint, YAML validation and a PII redaction scan | `.github/workflows/ci.yml` read in full |
| House conventions for `.markdownlint.json`, `.editorconfig`, `Makefile` and `LICENSE` | Files read in full |
| The estate maintains a numbered deviation register with solo-era deviations already recorded | `docs/drift-findings.md` inspected |

## Open items

Not resolved by this work, and not resolvable within it.

1. **A.5.23 citation.** The approved policy must be amended in `jolarca-compliance`
   to cite A.5.23. Raised through gap intake.
2. **Register schema migration.** The Group C and D columns in
   [`../register/schema.md`](../register/schema.md) must be added to the
   authoritative register and its validation script extended. Until then the
   scoring methodology is executed manually.
3. **Scoring implementation.** No code computes IRS, CE or RRS. Manual arithmetic
   is error-prone and cannot be re-performed mechanically. This is the
   highest-value automation candidate and the one deviation most likely to cause
   a real error rather than a documentation gap.
4. **Parity enforcement.** Register and human-readable index divergence, and
   supplier folders without assessments, are not currently hard failures in the
   estate's validation. Rules are specified in
   [`../register/schema.md`](../register/schema.md) and require implementation in
   `jolarca-compliance`.
5. **Quarterly self-attestation.** Defined but not scheduled.
6. **Second operator.** Every deviation recorded in
   [`solo-operator-controls.md`](solo-operator-controls.md) closes materially on
   onboarding a second operator. Until then the compensating controls are the
   position, and they are weaker than real separation of duties.
