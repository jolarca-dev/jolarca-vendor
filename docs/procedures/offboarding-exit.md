# Procedure — Vendor Offboarding and Exit

| | |
|---|---|
| Version | 1.0 |
| Status | Normative |
| Owner | `@JourneyOfLife` |
| Controls | GDPR Art. 28(3)(g) · ISO A.5.19 · ISO A.5.22 · SOC 2 CC9.2 · PCI DSS 12.8.1 |
| Next review | 2027-09-27 |

## Purpose

To end a supplier relationship so that no data, access, or obligation survives
the exit. The vendor policy requires an exit strategy for every critical
processor; this procedure makes it executable.

Offboarding is the most frequently skipped step in vendor management, because
there is no commercial pressure to complete it and the relationship has already
ended. It is also where the largest residual legal exposure sits: a processor
retaining personal data after the contract ends is processing without a lawful
basis, and our Art. 28(3)(g) obligation to ensure return or deletion is not
discharged by ceasing to pay the invoice.

## Triggers

1. Commercial decision to exit or replace.
2. Contract or DPA expiry without renewal.
3. Supplier insolvency, acquisition, or service end-of-life.
4. Risk decision following reassessment — Critical band, or unresolved
   conditions.
5. Supplier breach of agreement, including a sub-processor objection that cannot
   be resolved.
6. Supplier ceases to be used in practice. **Inactivity is a trigger.** A
   supplier whose integration is dormant still holds credentials and possibly
   data; dormant access is the most common unmanaged exposure in a small estate.

## Steps

### 1. Freeze

Immediately on the decision:

1. No new data categories are sent.
2. New credentials are not issued.
3. Where exit is for cause, existing access is suspended pending review rather
   than revoked blindly — revoking first can destroy the ability to export data.

Sequence matters: **export before revoke.** Revoking access and then discovering
that export required that access is an unrecoverable data-loss event, and it
happens often enough that the order is written into the procedure.

### 2. Inventory what they hold

Enumerate, from our records and by written request to the supplier:

- All data categories sent, mapped to RoPA identifiers.
- All credentials, API keys, tokens, OAuth grants and webhooks in existence.
- All access paths: console users, service accounts, VPN, federated identity,
  support tooling, and any standing supplier-side access to our tenant.
- All sub-processors that received our data — each is a separate erasure
  obligation flowing down under Art. 28(4).
- Backups, archives, logs and derived artifacts, including analytics and model
  training corpora where the supplier is an AI provider.
- Any of our intellectual property, source code, or configuration held by them.

The written request is sent even where we believe we know the answer. Our records
describe what we intended to send; the supplier's response describes what it
actually received.

### 3. Export and verify

1. Export all data in a usable, non-proprietary format.
2. **Verify the export before deleting anything at the supplier.** Confirm
   completeness against the inventory in step 2, confirm integrity by checksum
   where the volume justifies it, and confirm the export is readable by restoring
   a sample.
3. Store the export under our retention schedule per
   [`../evidence/retention-schedule.md`](../evidence/retention-schedule.md) —
   export does not create a licence to retain personal data indefinitely.
4. Where the supplier cannot export in a usable format, that is recorded as a
   realisation of lock-in risk and informs future adoption decisions.

### 4. Revoke

1. Revoke every credential and token identified in step 2, including those we
   believe are unused.
2. Remove the supplier's identities from our directory, federated trust, VPN and
   firewall rules.
3. Remove webhook endpoints and inbound integrations.
4. Remove the supplier from deployment pipelines, secret stores and CI/CD
   variable groups. A credential left in a build system continues to grant access
   after the console user is deleted.
5. Confirm revocation by attempting to use a sample of the revoked credentials
   and recording the failure. Revocation that is not verified is asserted, not
   evidenced.

### 5. Obtain erasure confirmation

Request in writing:

1. Deletion of all our data from production, backups, archives, logs and derived
   artifacts, and from every sub-processor.
2. The maximum time to complete deletion, and confirmation when it is complete —
   including confirmation that backup cycles have aged out.
3. **Written certification of erasure**, naming the legal entity, the data
   covered, the date, and the sub-processors included.

Written certification is the Art. 28(3)(g) evidence. A supplier's tick-box in a
cancellation flow is not certification. Where a supplier refuses to certify, the
refusal is recorded, the residual risk is accepted explicitly with a reason, and
it is weighed at the next adoption decision for that supplier class.

Where a legal hold or a statutory retention obligation requires the supplier to
keep data, that obligation is documented, scoped to the minimum necessary, and
its end date diarised.

### 6. Close the contractual and financial position

1. Terminate the agreement per its notice provisions; obtain written
   confirmation of termination and its effective date.
2. Confirm final invoicing and that no recurring charge continues.
3. Recover or destroy any supplier-provided hardware, tokens, or certificates.
4. Confirm return or destruction of our IP and source code.
5. Archive the executed agreement and all correspondence per the retention
   schedule — contract records outlive the contract.

### 7. Update the records

1. Register `status` set to `terminated`, then to `data-returned` once erasure
   certification is held. Both states exist in the register's status vocabulary
   and the distinction is the evidence that step 5 completed.
2. RoPA updated to remove the recipient.
3. Assessment closed with the exit record appended, including the export
   verification and the erasure certification reference.
4. Evidence hashed into `jolarca-compliance/audits/evidence-registry.csv`.
5. PCI DSS: where DS was 5, remove the provider from the TPSP list and record
   the date it ceased handling cardholder data — see
   [`pci-tsp-management.md`](pci-tsp-management.md).
6. Signed commit recording the closure.

**The register entry is not deleted.** A deleted entry removes the evidence that
the supplier was ever managed. Terminated suppliers remain in the register with
`status: terminated` or `data-returned` for the retention period, because an
auditor examining the period under review will ask about suppliers that were
active during it.

### 8. Post-exit review

For any exit that was not purely commercial, record what changed:

- If exit followed an incident or a failed condition, whether the same failure
  mode exists in other suppliers.
- If exit revealed lock-in, whether the
  [`cloud-services.md`](cloud-services.md) §4 questions were asked at onboarding.
- If exit was for insolvency, whether the concentration analysis in
  [`subprocessor-change.md`](subprocessor-change.md) §3.4 had identified the
  dependency.

Feed the answer back into
[`../methodology/due-diligence.md`](../methodology/due-diligence.md). An exit is
the only point at which a supplier relationship produces unambiguous evidence
about our own onboarding assumptions.

## Failure modes

- **Revoke before export.** Unrecoverable data loss. The order in steps 3 and 4
  is mandatory.
- **Credentials left in build systems.** Console access removed while CI secrets
  remain. Enumerate every secret store, not only the supplier's UI.
- **Sub-processors forgotten.** Erasure obtained from the supplier while its
  sub-processors retain copies. Art. 28(4) leaves that exposure with us.
- **No written certification.** Exit recorded internally, nothing obtained from
  the supplier. At audit there is no evidence deletion occurred.
- **Register entry deleted.** Removes the audit trail for the period under
  review. Set status; never delete.
- **Export retained indefinitely.** Creates a new, undocumented store of personal
  data outside the RoPA. Apply the retention schedule to the export.
- **Dormant supplier never offboarded.** Still credentialed, still holding data,
  absent from every review because nobody uses it. The register is reconciled
  against actual integration activity at each reassessment cycle to catch these.
