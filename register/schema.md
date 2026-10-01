# Register Field Contract

| | |
|---|---|
| Version | 1.1 |
| Status | Normative |
| Owner | `@JourneyOfLife` |
| Applies to | `jolarca-compliance/vendor-assessments/register.csv` and `register.md` |
| Controls | SOC 2 CC9.2 · ISO A.5.19 · ISO A.5.21 · ISO A.5.22 · PCI DSS 12.8.1 |
| Next review | 2027-09-27 |

The register lives in `jolarca-compliance`. Its **shape** is governed here,
because the shape is what makes
[`../docs/methodology/`](../docs/methodology/) executable and what the parity and
currency gates validate against.

Version 1.1 adds the scoring columns (group C) required by the risk methodology
and the tiering rubric. Group A and B columns are the established set.

## Group A — identity and relationship

| Column | Type | Required | Rule |
|---|---|---|---|
| `vendor` | slug | Yes | Lowercase, hyphenated. **Must exactly match** the supplier folder name and the contract folder name. This is the join key for every parity check |
| `legal_name` | text | Yes | Contracted legal entity, not the trading name. A DPA binds an entity, and the wrong name makes it unenforceable against the party actually processing |
| `role` | text | Yes | Controller or processor, and the function performed |
| `service_model` | enum | Yes for cloud | `iaas`, `paas`, `saas`, `self-hosted`, `n/a` — drives the A.5.23 responsibility split |
| `category` | enum | Yes | `payments`, `infrastructure`, `ai-llm`, `logistics`, `support`, `observability`, `security`, `marketing`, `other` |
| `owner` | text | Yes | A **natural person**. A role title or team name with no holder is not an owner and fails validation |
| `status` | enum | Yes | `onboarding`, `active`, `renewal-due`, `terminated`, `data-returned` |
| `first_engaged` | date | Yes | ISO 8601. Establishes the sequence against the assessment date for CC9.2 and PCI DSS 12.8.3 |
| `integration_live_from` | date | Where applicable | ISO 8601. Must be **on or after** the assessment approval date. A violation is a hard failure and is reported, not silently corrected |

## Group B — data, agreement and transfer

| Column | Type | Required | Rule |
|---|---|---|---|
| `ropa_ids` | list | Yes | Semicolon-separated RoPA identifiers, or `N/A` with a justification. Every recipient of personal data must appear in the Art. 30 record |
| `dpa_signed` | enum | Yes | `yes`, `no`, `n/a-no-personal-data`. **`no` with DS ≥ 3 is a hard failure** — it means processing without an Art. 28 contract |
| `dpa_date` | date | Where `dpa_signed = yes` | ISO 8601 execution date |
| `dpa_expiry` | date | Where applicable | ISO 8601. Drives the 60-day renewal gate. An expiry in the past drops CE domain C1 to 0.0 |
| `tia_required` | enum | Yes | `yes`, `no`, `maybe`. **`maybe` is not a valid terminal state** — it must be resolved to yes or no with a reason before the entry is `active` |
| `tia_status` | enum | Where required | `not-started`, `in-progress`, `completed`, `n/a-adequacy`, `n/a-eu-only`, `n/a-no-personal-data` |
| `transfer_countries` | list | Where `tia_required = yes` | Semicolon-separated ISO 3166-1 alpha-2 codes, including countries of **support access**, not only storage |
| `transfer_mechanism` | enum | Where a transfer occurs | `adequacy`, `scc`, `bcr`, `art49-derogation`, `none`. `none` with an active transfer is a hard failure |
| `subprocessor_count` | integer | Yes | Count from the current list on file. `0` requires an explicit confirmation that no sub-processor receives our data — silence is not zero |
| `subprocessor_list_date` | date | Where count > 0 | As-at date of the list. Older than 90 days requires refresh per [`../docs/evidence/conventions.md`](../docs/evidence/conventions.md) |

## Group C — scoring (version 1.1)

Derived from [`../docs/methodology/risk-scoring.md`](../docs/methodology/risk-scoring.md)
and [`../docs/methodology/tiering-rubric.md`](../docs/methodology/tiering-rubric.md).

| Column | Type | Rule |
|---|---|---|
| `ds` | int 1–5 | Data sensitivity factor. Cite the rubric row in the assessment |
| `bc` | int 1–5 | Business criticality factor |
| `ab` | int 1–5 | Access breadth factor |
| `irs` | decimal 2dp | `(ds × 0.50) + (bc × 0.30) + (ab × 0.20)` — recomputed and validated, never hand-entered |
| `ce` | decimal 2dp | Mean of C1–C5, each in {0.0, 0.5, 1.0} |
| `rrs` | decimal 2dp | `irs × (1 − (ce × 0.60))` — recomputed and validated |
| `band` | enum | `low`, `moderate`, `high`, `critical` — derived from `rrs` per the band table |
| `tier_from_rrs` | int 1–4 | Derived |
| `tier_floor_from_ds` | int 1–4 | Derived |
| `tier` | int 1–4 | `max(tier_from_rrs, tier_floor_from_ds)` — a lower number is stricter |
| `tier_override` | enum | `none`, `upward`. **`downward` is invalid**; the DS floor cannot be overridden away |
| `tier_override_reason` | text | Mandatory where `tier_override = upward` |
| `cadence_months` | int | 12, 24 or 36, derived from `tier` |
| `consecutive_cycles_at_current_tier` | int | Supports the two-cycle demotion rule |
| `assessed_date` | date | ISO 8601. Must be **on or before** `integration_live_from` |
| `approved_commit` | text | The signed commit hash that constitutes the approval record |

Derived columns are validated by recomputation. A hand-edited `rrs` that does not
match the formula fails the parity gate — this is deliberate, because a score
that cannot be re-derived from its inputs cannot be re-performed by an auditor.

## Group D — review and assurance

| Column | Type | Rule |
|---|---|---|
| `next_review` | date | ISO 8601. `assessed_date + cadence_months`. The currency gate fails when this is more than 30 days past |
| `last_review_type` | enum | `scheduled`, `event-subprocessor`, `event-incident`, `event-certification`, `event-data-change`, `event-corporate`, `event-usage` |
| `aoc_status` | enum | Where `ds = 5`: `current`, `expired`, `out-of-scope`, `not-obtained`, `n/a` |
| `aoc_date` | date | Where `ds = 5`: validation date of the current AoC |
| `aoc_retrieved` | date | Where `ds = 5`: when we retrieved it, and by whom in the assessment. PCI AoCs are not public downloads, so provenance is the evidence |
| `open_conditions` | int | Count of conditions with a due date not yet closed |
| `oldest_condition_days` | int | Age of the oldest open condition. Above one cadence is escalated per [`../docs/procedures/reassessment.md`](../docs/procedures/reassessment.md) §3 |
| `exit_plan` | enum | `documented`, `tested`, `not-required`, `absent`. `absent` for a Tier 1 or Tier 2 supplier is a hard failure |
| `schema_version` | text | This contract's version, e.g. `1.1`. Present so a reader can tell which contract an entry was written against |

## Hard failures

These stop the build. Each corresponds to an obligation that cannot be
compensated for by documentation elsewhere.

| Condition | Why it is a hard failure |
|---|---|
| `dpa_signed = no` and `ds >= 3` | Processing personal data without an Art. 28 contract — an infringement in progress |
| `transfer_mechanism = none` and a transfer is occurring | Unlawful transfer under Chapter V |
| `integration_live_from` earlier than `assessed_date` | Defeats the pre-engagement limb of CC9.2 and PCI DSS 12.8.3 |
| `owner` is a role title or team with no natural-person holder | Unaccountable; A.5.19 requires defined responsibility |
| `status = active` and `tia_required = maybe` | An unresolved legal question recorded as resolved |
| `tier_override = downward` | Defeats the DS floor |
| `ds = 5` and `aoc_status` in {`expired`, `not-obtained`} | PCI DSS 12.8.4 cannot be demonstrated |
| `exit_plan = absent` and `tier` in {1, 2} | Policy requires an exit strategy for every critical processor |
| `irs` or `rrs` not equal to the recomputed value | Score is not re-derivable |
| A `register.csv` entry with no matching supplier folder, or the reverse | Register and evidence have diverged |
| A supplier present in `register.csv` but absent from `register.md`, or the reverse | The two formats are one register in two views; divergence means neither is authoritative |

## Warnings

Reported but not blocking, because each may have a legitimate recorded reason:

- `next_review` within 30 days.
- `dpa_expiry` within 60 days — the renewal gate.
- `subprocessor_list_date` older than 90 days.
- `oldest_condition_days` greater than the tier cadence.
- `status = onboarding` for more than 60 days.
- `open_conditions > 0` with no due dates recorded in the assessment.
- A certification expiry within 90 days.

## Parity rules

Enforced by `jolarca-compliance/scripts/vendor-review-dates.py`:

1. Every `vendor` value has a matching directory under `vendor-assessments/`.
2. Every directory under `vendor-assessments/` — excluding `tia/` and
   non-supplier directories — has a matching register row.
3. Every row appears in **both** `register.csv` and `register.md`, with
   equivalent values.
4. Every row with `ds >= 3` has a corresponding recipient entry in the RoPA.
5. Every row with `ds = 5` has a corresponding entry in the PCI DSS TPSP view
   derived from the same register — **not a separately maintained list**, per
   [`../docs/procedures/pci-tsp-management.md`](../docs/procedures/pci-tsp-management.md).
6. Every row with `status` in {`active`, `renewal-due`} has an `assessment.md`
   in its folder. A supplier folder containing only a placeholder is not an
   assessment and fails this rule.

Rule 6 is the one most often unmet, and it is the substantive one: a register
entry without an assessment document is a claim that a supplier is managed, with
no evidence that it is.

## Migration to version 1.1

The Group C columns are additive. Entries written against version 1.0 lack them.

**Scores are not back-filled by estimation.** An invented `rrs` is worse than an
absent one: it is a false record that will be relied upon and cannot be
re-derived from any assessment. For a version 1.0 entry:

1. Set `schema_version` to `1.0` and leave Group C empty.
2. The tier in force remains the most recently recorded tier.
3. Group C is populated at the next assessment, when the factors can be assigned
   from evidence, and `schema_version` moves to `1.1` in the same change.
4. The absence of Group C for an entry is recorded as a gap per
   [`../docs/gap-intake.md`](../docs/gap-intake.md), graded by tier — an
   unscored Tier 1 supplier is a higher-severity gap than an unscored Tier 4 one.

The register is read at `schema_version` granularity so that version 1.0 and 1.1
entries coexist during migration without the gate failing on absent columns.
