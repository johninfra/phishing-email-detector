# PhishLens — Phishing Email Detector

**Inspect suspicious messages locally. Understand the evidence. Make a better triage decision.**

A self-contained, dark-mode browser application by **John Tyler / johninfra**, built for practical email inspection and cybersecurity learning. No account, API key, backend, npm install, or administrator rights required.

> This is an explainable **heuristic triage tool**. Its score is not a probability, and a low score does not mean an email is safe. It does not claim production detection accuracy or replace your organization's email security controls.

## Launch from PowerShell — copy and run

Copy this entire block into a normal PowerShell window. It downloads the browser app from this repository into a new temporary folder, verifies the expected SHA-256, and opens it in your default browser. **Git is not required.** The internet is needed only for the initial download; analysis then runs locally.

```powershell
$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$appFolder = Join-Path ([IO.Path]::GetTempPath()) ('PhishLens-' + [Guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $appFolder | Out-Null
$appFile = Join-Path $appFolder 'index.html'
Invoke-WebRequest -UseBasicParsing -Uri 'https://raw.githubusercontent.com/johninfra/phishing-email-detector/main/index.html' -OutFile $appFile
$expectedHash = 'A55F08B6AD8FFFE5BA461CEC3263BD1382B138DE9D544A3B4AC17B669C58CDF1'
if ((Get-FileHash -LiteralPath $appFile -Algorithm SHA256).Hash -ne $expectedHash) {
    Remove-Item -LiteralPath $appFile
    throw 'Integrity check failed. Re-open the current repository README and review the latest code before retrying.'
}
Start-Process -FilePath $appFile
```

The hash detects mismatched or changed downloads; it does not establish independent publisher trust. Inspect the repository before running downloaded software. This launcher does not use `Invoke-Expression`, execution-policy bypasses, background services, or administrative privileges. Future app changes require updating the README hash.

### Offline / downloaded ZIP

Extract the complete repository ZIP and double-click `index.html`. Or open PowerShell in the extracted folder and run:

```powershell
Start-Process -FilePath .\index.html
```

The included `Launch-Phishing-Detector.ps1` also opens the adjacent HTML file. If your execution policy blocks the script, use the direct command above; no policy change is needed.

## Features

- Paste email text or import `.eml` / `.txt` up to 2 MiB.
- Read common multipart MIME, base64 and quoted-printable text parts; unfold headers and decode common encoded header words.
- Compare From and Reply-To domains and an optional independently known expected sender domain.
- Surface **unverified** SPF, DKIM and DMARC header claims. Passing claims never subtract risk points.
- Detect credential requests, urgency, payment diversion, secrecy, and requests to enable macros or weaken security.
- Inspect HTTP(S) destinations, visible URL/target mismatches, IP hosts, URL user-info tricks, punycode, common shorteners, and nonstandard ports.
- Inventory named attachments and flag executable, macro-enabled, archive and double-extension filenames.
- Explain each signal with evidence, points and an action; defang all displayed URLs.
- Export JSON evidence reports or print browser reports. No automatic message storage.
- Three synthetic examples: credential phishing, payment diversion and a routine message.
- Responsive dark navy interface with keyboard controls and explicit coverage notes.

## Using it

1. In your mail client, use **Show original**, **View source**, or **Save as .eml** when available.
2. Paste the source or choose the exported file. Body-only text works with reduced context.
3. Optionally enter the sender domain you already know is correct, such as `example.com`.
4. Select **Analyze message** and review both evidence and coverage notes.
5. If suspicious, report through your approved channel and verify requests with a known contact method. Do not use contact details from the suspicious email.

## Scoring model

Each rule contributes once per analysis, even if repeated many times. Points add to a maximum of 100; there is no statistical calibration or claimed accuracy percentage.

| Score | Label |
|---|---|
| 0 | No listed signals detected (or Inconclusive when parsing is partial) |
| 1–29 | Some concern |
| 30–59 | Elevated concern |
| 60–100 | High concern |

Major signals include active attachments or active link schemes (30), sender-domain or displayed-link mismatch (25), credential requests or URL user-info (20), and financial requests (18). The source contains all rule weights. These are review priorities, not proof of malicious intent; legitimate messages can trigger rules.

## Limitations and privacy

No live reputation queries, redirect expansion, DNS lookups, cryptographic signature validation, attachment-content analysis, OCR or QR inspection. No complete public-suffix or brand-impersonation database. Natural-language rules emphasize English and do not understand sender intent. Obfuscated URLs, unusual HTML, MIME edge cases, encrypted messages, malicious attachments, and compromised legitimate accounts may evade detection.

Header claims must be evaluated within the receiving system's trust boundary; see [RFC 8601](https://www.rfc-editor.org/rfc/rfc8601.html). The app does not independently verify that boundary.

No email data is uploaded or automatically persisted. Exported reports include supplied identity fields and snippets: review before sharing. See [SECURITY.md](SECURITY.md).

## Project structure

Matches the six-file layout of [Security+ Command Center](https://github.com/johninfra/security-plus-command-center), with the launcher renamed for this app.

```text
phishing-email-detector/
├── index.html
├── Launch-Phishing-Detector.ps1
├── README.md
├── SECURITY.md
├── LICENSE
└── .nojekyll
```

## Contributing

Keep the app self-contained and offline. Use synthetic email fixtures only. For changes, verify routine-message behavior, credential phishing, BEC, MIME decoding, misleading links, attachment names, incomplete-input warnings, and that malicious HTML never executes or triggers network requests. Update the launcher hash after changing `index.html`.

## License

MIT.
