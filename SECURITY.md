# Security and privacy

PhishLens is a local heuristic inspection tool, not an email security gateway, malware sandbox, or a safety certification service.

## Data handling

- Analysis has no network requests, remote fonts, telemetry, accounts, or API keys.
- Email content remains in page memory. The app does not use localStorage, cookies, or a database.
- Imported HTML is processed as text. It is never inserted into the document or parsed into a live email preview. Results use textContent.
- Content Security Policy blocks connections, images, frames, objects and form submission. Inline scripts/styles are required for this single-file app.
- Links are shown as defanged text and cannot be clicked in the inventory.
- Export is explicit and contains identity fields and evidence snippets, which may be sensitive. Review reports before sharing. Raw message bodies are excluded.
- Clear all removes page-held inputs and results; it does not erase original files, exported reports, browser/OS caches or forensic traces.

## Trust boundaries

All supplied email fields are untrusted. Authentication-Results fields can be forged; reported passes never lower the score. Verify results against the receiving gateway and original message. No SPF evaluation, DKIM signature validation, DMARC alignment validation, reputation lookup, or attachment-content scanning occurs.

Input is capped at 2 MiB. MIME recursion is limited to 12 levels / 150 parts; URL extraction is capped at 500 candidates. Coverage limitations appear in results. This is a pragmatic parser, not a complete RFC implementation. Unsupported encryption, unusual encodings, malformed HTML, image-only lures and Unicode obfuscation can evade checks.

## Reporting a vulnerability

Use GitHub private vulnerability reporting if enabled. Otherwise open an issue requesting a private contact method without including exploit details or real email data. Use synthetic fixtures for reproductions. Do not publish personal information, credentials or confidential messages.
