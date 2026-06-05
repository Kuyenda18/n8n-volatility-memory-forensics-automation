# Sample Memory Dump Handling

The original local workspace contains a lab memory image named `memtest2.mem` of approximately 4.7 GB.

That file is intentionally not committed to this repository.

## Why It Is Excluded

- Standard GitHub repositories are not designed for multi-gigabyte binary evidence files.
- Memory dumps may contain sensitive data such as process memory, command history, credentials, IP addresses, file paths, and user activity.
- Keeping large binary evidence outside Git keeps the repository lightweight and cloneable for portfolio review.

## Local Usage

Place an authorized memory image in:

```text
watch-folder/
```

Then run the n8n workflow. The expected output is:

```text
output-json/triage_lockdown_report.json
```

## Sharing a Sample

If a public sample is needed, prefer one of these approaches:

- Use a small, intentionally generated lab memory image.
- Host the large file externally and link to it from documentation.
- Provide only sanitized JSON output in `sample-data/`.

Do not publish memory dumps collected from real systems unless they are explicitly authorized and reviewed for sensitive data.
