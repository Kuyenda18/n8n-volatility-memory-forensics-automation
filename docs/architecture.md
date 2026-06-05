# Architecture Notes

This project is organized as a repeatable memory-forensics triage pipeline. The goal is to reduce manual Volatility command execution and produce a structured JSON report that can be reviewed or reused by other DFIR tooling.

## Layer 1: Infrastructure and I/O

The original lab setup used Windows, WSL2, Docker, and mounted folders. Memory images are placed into a watched input directory and the generated JSON report is written to an output directory.

The publishable repository keeps this model through Docker Compose mounts:

- `watch-folder/` maps to `/data/input`.
- `output-json/` maps to `/data/output`.
- `tools/volatility3/` maps to `/opt/volatility3`.
- `n8n-data/` maps to n8n local state.

Runtime folders are ignored by Git because they may contain memory images, local n8n state, logs, and generated evidence.

## Layer 2: n8n Orchestration

n8n coordinates the workflow:

1. `Local File Trigger` watches `/data/input`.
2. `Run Volatility3 Triage` runs the selected Volatility3 plugins.
3. `Parse Volatility Output` parses stdout into JSON for the workflow execution.

The sanitized workflow export is stored in `workflows/memory-forensics-auto-triage.json`.

## Layer 3: Volatility3 Core Analysis

The workflow runs three plugins for initial triage:

| Plugin | Artifact Type |
| --- | --- |
| `windows.pslist` | Running processes and process metadata. |
| `windows.netscan` | Network sockets, local/foreign addresses, ports, state, PID, and owner. |
| `windows.malfind` | Suspicious memory regions, executable-write permissions, and injection indicators. |

These plugins are intentionally focused on high-value triage data rather than full forensic coverage.

## Layer 4: JSON Normalization and Review

The plugin outputs are combined into one report:

```json
{
  "status": "success",
  "artifacts": {
    "network_connections": [],
    "process_list": [],
    "injected_memory": []
  }
}
```

The Streamlit dashboard reads the generated report from `output-json/triage_lockdown_report.json`. If no runtime report exists, it loads `sample-data/triage_lockdown_report.sample.json`.

## Extension Ideas

- Add `windows.cmdline`, `windows.dlllist`, or `windows.handles` for richer process context.
- Add IOC extraction and enrichment as a downstream module.
- Add MITRE ATT&CK mapping for suspicious memory and network patterns.
- Generate a markdown or PDF triage summary for analyst handoff.
