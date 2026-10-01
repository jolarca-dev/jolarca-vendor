# VEN-0001: LLM Vendor Selection Approach for Hermes Agents

| | |
|---|---|
| Status | Proposed |
| Date | 2026-10-01 |
| Owner | `@JourneyOfLife` |
| Controls | C13 (hermes-agents), SOC 2 CC9.2, ISO A.5.19, GDPR Art. 28 |

## Context

The `jolarca-hermes-agents` repository defines 12 AI agents, all of which
currently declare `model_policy.provider: null`. No LLM provider is selected,
and no model calls are made. This is recorded as control C13 (model vendor risk
assessment), which is deferred to the `jolarca-vendor` DPIA.

The `jolarca-compliance` vendor register lists three LLM vendors in
`onboarding` status: `openai`, `anthropic`, and `google-cloud` (plus `deepl`
for translation, which is a separate category). None has a completed DPIA, a
signed DPA, or a completed TIA.

The Hermes agent fleet also requires a runtime orchestration framework
(LangGraph or Microsoft Agent Framework), and the framework choice is coupled
to the provider choice: LangGraph has stronger OpenAI/Anthropic integration,
while Microsoft Agent Framework has native Azure OpenAI support. Selecting a
framework before a provider risks the framework's vendor affinity deciding the
provider, which inverts the control (the DPIA must precede vendor adoption).

## Decision

The LLM vendor selection follows the general vendor onboarding procedure in
[`../procedures/onboarding.md`](../procedures/onboarding.md) with the
LLM-specific methodology extension in
[`../methodology/ai-llm-suppliers.md`](../methodology/ai-llm-suppliers.md).

The selection is **blocked** on three prerequisites:

1. **Completed DPIA** in `jolarca-compliance/vendor-assessments/<vendor>/assessment.md`
   covering the LLM-specific due-diligence questions in
   [`../methodology/ai-llm-suppliers.md`](../methodology/ai-llm-suppliers.md) §4.
2. **Executed DPA** with zero-retention API terms, no-training clause, and
   LLM-specific data processing addendum, filed in
   `jolarca-legal/contracts/vendors/<vendor>/`.
3. **Completed TIA** where inference runs outside the EU/EEA, filed in
   `jolarca-compliance/vendor-assessments/tia/`.

No Hermes agent may declare a non-null `model_policy.provider` until all three
prerequisites are satisfied for the named vendor. The enforcement script
`jolarca-hermes-agents/scripts/check_vendor_risk.py` validates this invariant.

### Ordering constraint

The LLM vendor selection and the runtime framework selection are coupled. The
correct order is:

**C13 vendor DPIA → provider selection → framework selection.**

Selecting a framework first lets the framework's vendor affinity decide the
provider through integration convenience, which bypasses the DPIA and inverts
the control. The framework selection is recorded in a separate ADR
(`HERMES-0003` in `jolarca-hermes-agents`, Status: Proposed, Blocked on C13).

## Consequences

### Positive

- The LLM vendor is selected through a documented, auditable process that
  discharges SOC 2 CC9.2 (alternatives considered, pre-engagement assessment)
  and GDPR Art. 28 (processor contract).
- The DPIA covers LLM-specific risks (prompt data egress, zero-retention,
  model training, inference residency) that a general vendor assessment would
  miss.
- The framework selection is decoupled from vendor affinity, preventing the
  framework from choosing the provider.

### Negative

- The LLM vendor selection is delayed until the DPIA is complete. This delays
  the Hermes agent runtime implementation, which depends on a selected provider.
- The three prerequisites (DPIA, DPA, TIA) require external engagement with
  the vendor, which is outside our direct control and may take weeks or months.

### Neutral

- The LLM-specific methodology extension is normative and change-controlled.
  Amendments require re-scoring every Tier 1 and Tier 2 LLM supplier, which
  is a deliberate constraint to prevent silent drift.

## Alternatives considered

1. **Select a provider without a completed DPIA.** Rejected: this is a
   control violation (C13) and a GDPR Art. 28 infringement. The enforcement
   script hard-fails on any non-null provider without a register entry.

2. **Use a self-hosted open-source model.** Rejected for the initial
   implementation: the Hermes agent fleet requires production-grade inference
   with low latency and high reliability, which self-hosted models cannot
   provide without significant infrastructure investment. Reconsider if the
   vendor DPIA process fails for all candidates.

3. **Select the framework first and let it choose the provider.** Rejected:
   this inverts the control (the DPIA must precede vendor adoption) and risks
   vendor lock-in through framework affinity.

## Open questions

1. **Which LLM vendor?** The three candidates in `jolarca-compliance`
   (`openai`, `anthropic`, `google-cloud`) are all in `onboarding` status.
   The selection depends on which vendor completes the DPIA prerequisites
   first and offers the strongest LLM-specific controls (zero-retention,
   EU inference residency, no-training commitment).

2. **Fine-tuning scope.** The LLM-specific methodology does not yet cover
   fine-tuning. If a Hermes agent requires fine-tuning, the methodology
   must be extended before the vendor is approved for that scope.

3. **Fallback provider.** The methodology requires a named fallback for
   BC ≥ 3. The fallback must be assessed independently, which may delay
   the primary vendor's approval if the fallback assessment is not yet
   complete.

## Related artifacts

- [`../methodology/ai-llm-suppliers.md`](../methodology/ai-llm-suppliers.md) —
  LLM-specific risk methodology
- [`../procedures/onboarding.md`](../procedures/onboarding.md) — general
  vendor onboarding procedure
- `jolarca-hermes-agents/policies/model-policy.md` — Hermes model-policy
  controls (M1–M4)
- `jolarca-hermes-agents/docs/adr/HERMES-0003-…` (Proposed) — runtime
  framework selection, blocked on C13
