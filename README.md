# n8n Volatility Memory Forensics Automation

This project demonstrates a lightweight DFIR automation workflow that uses n8n to trigger Volatility3 analysis when a memory image is added to a watched folder. The workflow runs common triage plugins, saves a structured JSON report, and provides a Streamlit dashboard for reviewing the results.

It is intended as a Blue Team, SOC, and DFIR internship portfolio project. It does not claim production incident response deployment or real company experience.

## What It Does

The automation flow is designed to support a memory-forensics triage workflow:

1. Watch a local folder for new memory image files.
2. Run Volatility3 plugins against the uploaded memory image.
3. Collect network connections, process list, and injected memory findings.
4. Save the combined output as `triage_lockdown_report.json`.
5. Review the JSON output through a Streamlit dashboard.

No external API keys are required. The project runs locally with Docker, n8n, Volatility3, Python, and Streamlit.

## Security Use Case

This project is related to:

- DFIR memory triage automation.
- Volatility3-based artifact collection.
- Process, network, and injected-memory review.
- SOC investigation workflow support.
- Repeatable triage output generation for analyst review.

## Architecture

The design follows the four-layer structure described in the original project report:

- Infrastructure and I/O layer: WSL2/Docker runtime, mounted input/output folders, and local memory image handling.
- Orchestration layer: n8n watches for new memory images and controls the analysis workflow.
- Core analysis layer: Volatility3 extracts process, network, and injected-memory artifacts.
- Normalization and visualization layer: plugin output is combined into JSON and reviewed in a Streamlit dashboard.

The repo keeps these layers separated so the workflow can be extended with additional Volatility plugins, enrichment logic, or reporting modules without changing the whole pipeline.

## Tech Stack

- n8n
- Docker and Docker Compose
- WSL2-compatible local lab setup
- Volatility3
- Python
- Streamlit
- Pandas
- JSON

## Repository Structure

```text
.
|-- Dockerfile
|-- docker-compose.yml
|-- README.md
|-- requirements.txt
|-- .env.example
|-- .gitignore
|-- docs/
|   |-- architecture.md
|   |-- sample-memory-dump.md
|   `-- security-review.md
|-- sample-data/
|   `-- triage_lockdown_report.sample.json
|-- scripts/
|   `-- dfir_dashboard.py
`-- workflows/
    `-- memory-forensics-auto-triage.json
```

## Workflow Overview

```text
Memory image added to watch-folder/
        |
        v
n8n Local File Trigger
        |
        v
Volatility3 plugins:
  - windows.netscan
  - windows.pslist
  - windows.malfind
        |
        v
Combined JSON report
        |
        v
Streamlit dashboard review
```

The default workflow uses these Volatility3 plugins:

| Plugin | Purpose |
| --- | --- |
| `windows.pslist` | Lists running processes from memory. |
| `windows.netscan` | Extracts sockets and network connections. |
| `windows.malfind` | Identifies suspicious executable memory regions. |

The combined report groups the output under:

- `network_connections`
- `process_list`
- `injected_memory`

## Setup

Create local runtime folders:

```bash
mkdir -p n8n-data watch-folder output-json tools
```

Clone Volatility3 locally:

```bash
git clone https://github.com/volatilityfoundation/volatility3.git tools/volatility3
```

Create a local environment file:

```bash
cp .env.example .env
```

Start n8n:

```bash
docker compose up --build
```

Open n8n at:

```text
http://localhost:5678
```

Import the workflow from:

```text
workflows/memory-forensics-auto-triage.json
```

## Usage

Place an authorized memory image into:

```text
watch-folder/
```

The n8n workflow runs Volatility3 and writes:

```text
output-json/triage_lockdown_report.json
```

Run the dashboard:

```bash
pip install -r requirements.txt
streamlit run scripts/dfir_dashboard.py
```

If no runtime report exists, the dashboard falls back to:

```text
sample-data/triage_lockdown_report.sample.json
```

## Notes and Limitations

- This repository does not include memory dumps, raw forensic output, n8n runtime databases, or third-party tool checkouts.
- The included workflow is a sanitized export intended for lab use and portfolio review.
- The original lab memory dump is about 4.7 GB. It is intentionally not committed because normal GitHub repositories are not suitable for files of that size.
- Volatility3 plugin results depend on the memory image, operating system, symbols, and plugin compatibility.
- The dashboard is a triage aid, not a full forensic report.
- Only analyze memory images that you are authorized to examine.

## GitHub Safety

The original local workspace included a memory dump, n8n SQLite database, n8n encryption key, logs, raw triage reports, a local virtual environment, a full Volatility3 checkout, and a personal report document. These items are ignored and were not included in the publishable project structure. See `docs/security-review.md` for details.
