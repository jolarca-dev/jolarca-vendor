# AI/LLM Supplier Risk Methodology

| | |
|---|---|
| Version | 1.0 |
| Status | Normative |
| Owner | `@JourneyOfLife` |
| Applies to | Every supplier in the `ai-llm` category per [`../../register/schema.md`](../../register/schema.md) |
| Controls | SOC 2 CC9.2 · ISO A.5.19 · ISO A.5.21 · ISO A.5.22 · GDPR Art. 28 |
| Next review | 2027-10-01 |

This document extends [`risk-scoring.md`](risk-scoring.md) and
[`due-diligence.md`](due-diligence.md) with AI/LLM-specific risk factors,
control-effectiveness criteria and due-diligence questions. Where this document
and the general methodology conflict, this document governs for suppliers in
the `ai-llm` category.

## 1. Scope

Applies to any vendor providing:

- Large language model inference (chat completion, text generation, code generation)
- Fine-tuning or custom model training on our data
- Embedding generation for retrieval-augmented generation
- Model hosting or inference infrastructure

Does not apply to:

- Traditional translation APIs that do not use generative models (covered by the general methodology)
- Self-hosted open-source models where the vendor relationship is limited to software licensing (covered as software vendors, not AI/LLM)

## 2. Inherent risk factors

### 2.1 Data Sensitivity (DS)

Prompt data sent to an LLM vendor may contain personal data, special-category
data, or confidential business data. Score on the **highest** applicable row —
never average downwards.

| DS | Definition | LLM-specific examples |
|---|---|---|
| 1 | No personal data and no confidential business data | Public-content summarisation with no user data in prompts |
| 2 | Pseudonymised or scrubbed operational data | Aggregated telemetry used for prompt context |
| 3 | Personal data per GDPR Art. 4(1) | User names, contact details, order history in prompt context |
| 4 | Special-category data, KYC identity documents, or authentication credentials | Identity verification prompts, biometric descriptions, health-related queries |
| 5 | Cardholder data (PAN) at scale | Payment intent analysis, fraud detection prompts containing PAN |

**Zero-retention API terms can reduce effective DS by one level** (e.g., DS 3 → DS 2)
where the vendor contractually commits to:

- No storage of prompt or response data beyond the inference transaction
- No use of prompts or responses for model training, benchmarking, or product improvement
- Technical evidence of the zero-retention configuration (API header, account setting, or audit log)

The reduction is recorded in the assessment with the contractual clause cited.
Without all three elements, the reduction does not apply and the raw DS stands.

### 2.2 Business Criticality (BC)

| BC | Definition | LLM-specific examples |
|---|---|---|
| 1 | Absence is invisible | Optional AI features with manual fallback |
| 2 | Degraded experience; workaround within hours | AI-assisted content drafting with human-only fallback |
| 3 | A single feature is unavailable for a day | Translation service with cached translations |
| 4 | Core function impaired; revenue impact | AI-powered search or recommendation engine |
| 5 | The marketplace cannot operate | Autonomous agent fleet with no alternative inference path |

**Fallback provider identified before approval.** A supplier at BC ≥ 3 must have
a named alternative with a recorded switching cost. The alternative is assessed
independently; naming a fallback that has not been through onboarding is not a
control.

### 2.3 Access Breadth (AB)

| AB | Definition | LLM-specific examples |
|---|---|---|
| 1 | No access to our systems or data | Public API with no persistent connection |
| 2 | Read-only or narrowly scoped access | Embedding API with no prompt storage |
| 3 | Production access scoped to one system | Single LLM endpoint for content generation |
| 4 | Production access spanning multiple systems | Multi-model platform with access to several agent roles |
| 5 | Administrative production access, or data replicated at scale | Fine-tuning with our data replicated to the vendor's training infrastructure |

**Sub-processor chain for inference.** The vendor's sub-processors include not
only data centres but also GPU providers, model hosting partners, and any party
with access to prompt data during inference. The full chain must be enumerated
per A.5.21; "we use AWS" is not an acceptable answer — the specific regions, the
specific services, and whether support personnel can access prompt data.

## 3. Control effectiveness for LLM vendors

Each domain extends the general criteria in [`risk-scoring.md`](risk-scoring.md) §3.

| # | Domain | 1.0 | 0.5 | 0.0 |
|---|---|---|---|---|
| C1 | Contractual | DPA per Art. 28 signed and current, **plus zero-retention API terms, no-training clause, and data processing addendum for LLM-specific terms** | DPA drafted, or zero-retention asserted but not contractually committed | No DPA, or DPA expired, or vendor reserves the right to use prompts for training |
| C2 | Certification | SOC 2 Type II or ISO 27001 certificate, in period, **scope covers the specific LLM API service** | SOC 2 Type I, or certificate scope covers the vendor's platform but not the specific API | None, or self-asserted only |
| C3 | Technical | Encryption in transit and at rest, MFA for administrative access, **prompt isolation between tenants, and evidence of zero-retention configuration** | Same controls asserted but not evidenced, or prompt isolation asserted without tenant-separation evidence | Not addressed |
| C4 | Operational | Breach notification within 72 hours, sub-processor change notice ≥ 30 days, **model version change notification, and incident history specific to the LLM service** | Some but not all of the four, or model version changes without notification | None contractually committed |
| C5 | Transfer | For any non-EU/EEA transfer: TIA completed, valid mechanism, **and inference residency commitment (where prompts are processed)** | Valid mechanism in place but TIA outstanding, or inference residency is a default not a commitment | A transfer is occurring with no mechanism |

**C5 when inference runs in the EU/EEA only:** score 1.0 and record the reason
as `eu-inference-only` with the contractual clause cited. A commitment that
inference runs only in the EU/EEA is the strongest transfer position an LLM
vendor can offer, and it is verifiable through API latency and the vendor's
infrastructure documentation.

## 4. LLM-specific due-diligence questions

These extend [`due-diligence.md`](due-diligence.md) §4 (Section B — Data handling
and processing). Each question is mandatory for LLM vendors; a general answer
does not substitute for a specific one.

### 4.1 Zero-retention and no-training

1. Does the vendor offer a zero-retention API tier where prompts and responses
   are not stored beyond the inference transaction? If yes, provide the API
   header, account setting, or configuration that enables it.
2. Does the vendor contractually commit to **not** using our prompts or
   responses for model training, benchmarking, or product improvement? Cite
   the specific clause.
3. Is the no-training commitment technical (enforced by the API tier) or
   contractual only (a clause that could be overridden)? Both are recorded.
4. Does the vendor retain prompt data for any purpose other than inference —
   abuse monitoring, billing, or analytics? If yes, what is the retention
   period and the legal basis?

### 4.2 Prompt isolation and tenant separation

5. How does the vendor isolate prompt data between tenants during inference?
   Specifically: is prompt data held in tenant-specific memory, or is there a
   shared context window that could leak across tenants?
6. Can the vendor demonstrate that our prompts are not visible to other
   tenants, to the vendor's own personnel, or to the vendor's sub-processors
   beyond what is necessary for inference?
7. Does the vendor log access to prompt data, and can we request access logs
   for our own data?

### 4.3 Model version and change management

8. What is the vendor's model version pinning policy? Can we pin to a specific
   model version and receive notification before it is deprecated?
9. How does the vendor notify us of model version changes, capability changes,
   or infrastructure changes that affect prompt processing?
10. Does the vendor commit to a minimum notice period before deprecating a
    model version we depend on? What is the period?

### 4.4 Sub-processor chain for inference

11. Enumerate every sub-processor that has access to prompt data during
    inference: legal name, jurisdiction, function, and the data categories
    each receives. A published web page is not acceptable — request the list
    current as at the assessment date.
12. Does the vendor use third-party GPU providers, model hosting partners, or
    inference infrastructure providers? If yes, enumerate them with the same
    detail as question 11.
13. Can the vendor commit to notifying us at least 30 days before adding or
    replacing a sub-processor that has access to prompt data?

### 4.5 Transfer and inference residency

14. In which countries or regions does inference on our prompts occur?
    Specifically: where are the model weights hosted, and where does the
    inference computation run?
15. Is the inference residency contractual (a commitment we can enforce) or
    a default configuration (which the vendor could change without notice)?
16. Does the vendor commit to processing our prompts only in the EU/EEA? If
    not, what is the transfer mechanism for any non-EU/EEA processing?
17. What is the vendor's government access request policy for prompt data?
    Specifically: does the vendor commit to notifying us, challenging unlawful
    requests, and minimising disclosure?

### 4.6 Incident history and fallback

18. Has the vendor experienced a security incident affecting prompt data, model
    integrity, or inference availability in the last 36 months? If yes,
    provide the date, the data involved, and what changed afterwards.
19. What is the vendor's RTO and RPO for the LLM inference service? Is it
    contractual or best-effort?
20. If the vendor becomes unavailable, what is the switching cost to a named
    alternative? Specifically: is the API compatible with another vendor's API,
    or is there a proprietary prompt format that must be rewritten?

## 5. Mapping to jolarca-hermes-agents model-policy controls

The Hermes agent fleet defines four model-policy controls in
`jolarca-hermes-agents/policies/model-policy.md`. Each maps to this methodology
as follows:

| Hermes control | Meaning | Vendor methodology equivalent |
|---|---|---|
| M1 — approved_models | Only models registered in the vendor register may be used | Vendor register entry with completed DPIA, DPA signed, TIA completed |
| M2 — version_pinning | Model versions are pinned and changes are notified | Due-diligence question 4.3 (model version and change management); agreement clause requiring version pinning and notification |
| M3 — model_access | API access is scoped to the assessed data categories | AB factor; due-diligence question 4.2 (prompt isolation); C3 technical controls |
| M4 — fallback | A fallback provider is identified for BC ≥ 3 | BC factor; due-diligence question 4.6 (fallback); alternative provider assessed |

No Hermes agent may declare a non-null `model_policy.provider` until the
corresponding vendor has a completed DPIA in `jolarca-compliance`, a signed DPA,
and a completed TIA where required. The enforcement script
`jolarca-hermes-agents/scripts/check_vendor_risk.py` validates this invariant.

## 6. Worked example (synthetic)

A vendor providing LLM inference for content generation. No real vendor;
illustrative only.

Inputs: prompt data includes user-provided content and retrieved sources
containing personal data (DS 3); content generation is a core feature with
manual fallback (BC 3); API access scoped to one endpoint with zero-retention
terms (AB 2).

```text
IRS = (3 × 0.50) + (3 × 0.30) + (2 × 0.20)
    = 1.50 + 0.90 + 0.40
    = 2.80
```

Controls: DPA signed with zero-retention addendum and no-training clause
(C1 = 1.0); SOC 2 Type II in period, scope covers the specific API
(C2 = 1.0); encryption evidenced, prompt isolation demonstrated, zero-retention
configuration verified (C3 = 1.0); 72-hour breach notice, 30-day sub-processor
notice, model version pinning committed, no LLM-specific incidents in 36 months
(C4 = 1.0); EU-region inference commitment contractual, TIA completed
(C5 = 1.0).

```text
CE  = (1.0 + 1.0 + 1.0 + 1.0 + 1.0) ÷ 5 = 1.00
RRS = 2.80 × (1 − (1.00 × 0.60))
    = 2.80 × 0.40
    = 1.12
```

Band: **Low**. Disposition: accept with standard monitoring per tier. Note the
effect of the 0.60 cap: even with a perfect control set, RRS is 1.12, not zero.
The dependency on the vendor is not mitigated by the control set — which is why
a fallback provider is identified and assessed before approval.

## 7. Known limitations

Stated plainly, because an undocumented limitation becomes an audit finding.

- **Zero-retention claims are difficult to verify independently.** The vendor's
  assertion, even when contractually committed, is evidence class **A** unless
  corroborated by an independent audit or a technical demonstration. A vendor
  that offers a zero-retention API tier and provides evidence of the
  configuration scores **E**; a vendor that asserts zero-retention in the DPA
  but offers no technical evidence scores **A** and caps C1 at 0.5.
- **Model version pinning is a contractual commitment, not a technical
  guarantee.** A vendor could deprecate a model version despite a contractual
  notice period; the remedy is contractual, not technical. The switching cost
  to a fallback provider is the real control, and it must be assessed before
  approval.
- **Prompt isolation is an emerging area.** Industry standards for tenant
  isolation in LLM inference are still forming. A vendor's assertion of prompt
  isolation is accepted as **A** unless corroborated by a penetration test or
  an independent audit of the inference infrastructure.
- **This methodology does not cover fine-tuning.** Where a vendor fine-tunes a
  model on our data, the data sensitivity is higher (DS increases by at least
  one level), the sub-processor chain is longer (training infrastructure), and
  the exit position is more complex (the fine-tuned model may contain our data
  and cannot be "returned" in the same way as prompt data). Fine-tuning
  requires a separate assessment extension, which is not yet written and is
  recorded as a gap per [`../gap-intake.md`](../gap-intake.md).

## 8. Change control

Changes to this methodology follow the same rules as
[`risk-scoring.md`](risk-scoring.md) §7: a pull request, a re-scoring of every
Tier 1 and Tier 2 LLM supplier under both the old and new criteria, a signed
commit, and a version bump.
