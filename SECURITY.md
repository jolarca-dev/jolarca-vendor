# Security Policy

## Scope

This repository is **public** and classified **internal**. It contains vendor
management methodology, procedures and agreement templates. It contains no
secrets, no supplier records, no personal data and no audit evidence — by design,
and enforced by the continuous integration scan in `.github/workflows/ci.yml`.

A compromise here is nevertheless a security matter, for three reasons:

1. **Silent weakening of controls.** This repository defines how supplier risk is
   scored, how tiers are assigned, and which clauses are approval-blocking. An
   attacker who can amend it without detection can lower the tier floor, raise the
   residual-risk cap, or remove an approval-blocking clause — and the change would
   then propagate into every subsequent assessment as though it were policy. The
   methodology is a control surface even though it holds no data.
2. **Disclosure of the boundary.** The documents describe which artifact classes
   are confidential and where they live. That is a map to the repositories worth
   attacking.
3. **Injected confidential content.** A contribution or a compromised commit that
   adds supplier findings to a public repository is a data disclosure event with
   contractual and GDPR consequences, and it cannot be undone by reverting.

## Reporting a vulnerability

**Do not open a public issue.**

GitHub private vulnerability reporting is enabled for this organisation. To
report:

1. Go to the affected repository.
2. Select **Security** → **Report a vulnerability**.
3. Describe the issue and how to reproduce it.

If private reporting is unavailable, contact the operator through the channel
recorded in the organisation profile at `github.com/jolarca-dev`. Do not include
credentials, tokens or personal data in the initial report; a secure channel will
be arranged.

The organisation-level policy at `github.com/jolarca-dev/.github` applies where
this document is silent.

## Report immediately

Treat the following as urgent and report them even if you are unsure:

- A credential, API key, token, certificate or private key committed to this
  repository, in any file or in any commit in history.
- Supplier-specific assessment content, risk scores, contract terms, transfer
  impact assessments, or a list of control gaps committed to this repository.
- Personal data of any individual, including supplier personnel contact details.
- An unauthorised commit, branch, tag, force-push, or history rewrite.
- A change to `.github/workflows/`, `CODEOWNERS`, or the branch-protection
  settings that was not made through a reviewed pull request.
- A change to a control threshold — the scoring weights, the `0.60` residual-risk
  cap in `docs/methodology/risk-scoring.md`, the tier floors in
  `docs/methodology/tiering-rubric.md`, or the approval-blocking clause list in
  `docs/agreements/security-requirements-schedule.md` — that you did not author.
- A fork or mirror of this repository presenting its content as authoritative or
  as the work of another party.

## Response

| Step | Target |
|---|---|
| Acknowledge the report | 2 working days |
| Assess severity and blast radius | 5 working days |
| Remediate, or record an accepted risk with a date | 30 days |
| Notify the reporter of the outcome | On closure |

Where committed content is confidential or personal data, the assessment includes
whether a notification obligation arises under GDPR Article 33 or Article 34, and
that assessment is recorded **even where the conclusion is that no notification
is due**. The 72-hour clock runs from awareness, so the date of awareness is
recorded at the point of report rather than reconstructed later.

Where a secret is exposed, it is **revoked first and the history cleaned second**.
Removing a secret from a working tree does not un-leak it: it remains in history,
in forks, in clones and in any CI log that printed it. Revocation is the only
remediation that works, and history rewriting is cleanup afterwards.

## Hardening applied to this repository

- Branch protection on `main`: required `lint` status check with strict
  re-validation, squash-only linear history, force-pushes and deletion blocked,
  administrators enforced.
- `web_commit_signoff_required`: commits carry sign-off.
- Signed commits by the operator, providing tamper-evident approval records — see
  `docs/solo-operator-controls.md` for what this does and does not prove.
- Least-privilege workflow permissions (`contents: read`) in CI.
- A secret and personal-data scan on every pull request and push.
- Vulnerability alerts enabled.

These settings are managed as infrastructure in
`jolarca-control/repos/jolarca-vendor.yml` and applied by Terraform. **They are
not changed in the GitHub UI.** Out-of-band changes drift from declared state and
may be silently unenforced; a settings change is a pull request against
`jolarca-control`.

## Known limitations

Stated because an undocumented limitation invites false confidence.

- There is **one operator**. No second person reviews a change to this repository
  before merge; `required_approving_review_count` is 0 as a documented deviation.
  The compensating controls are the automated gates and the annual external audit,
  set out in `docs/solo-operator-controls.md`.
- **CODEOWNERS provides no independent review** while no resolvable team exists in
  the organisation. It is present for routing and attribution, not as an approval
  control, and is annotated as such.
- Branch protection is **not enforceable on private repositories under the
  organisation's current hosting plan**. This repository is public, so protection
  applies here; the limitation is recorded because it affects the wider estate and
  because assuming uniform protection across repositories would be wrong.
- Nothing in-repository prevents an administrator from altering history or
  disabling a gate. The controls are **detective, not preventive**.

## Supported versions

This repository holds documents, not software. The current `main` branch is the
only supported version. Superseded revisions remain in history and are the
change-control evidence for the period in which they were in force; they are not
maintained, and a document withdrawn from `main` is marked `Status: Superseded`
rather than deleted, so that the rule in force during a prior audit period remains
discoverable.
