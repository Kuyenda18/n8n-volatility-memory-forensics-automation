# GitHub Safety Review

This review was performed while converting the local DFIR automation workspace into a GitHub-ready portfolio repository.

## Sensitive or Large Items Found

- `DFIR_Project/config/config` contains an n8n encryption key.
- `DFIR_Project/config/database.sqlite` contains n8n local state, workflow metadata, and may contain credentials or execution data.
- `DFIR_Project/config/n8nEventLog*.log` contains local n8n logs.
- `DFIR_Project/watch_folder/memtest2.mem` is a memory dump of about 4.8 GB and must not be committed.
- `DFIR_Project/watch_folder/triage_lockdown_report.json` and `DFIR_Project/watch_folder/test/triage_lockdown_report.json` are generated forensic output files.
- `DFIR_Project/watch_folder/dfir_env/` is a local Python virtual environment.
- `DFIR_Project/volatility3/` is a full third-party Volatility3 checkout with its own `.git` directory.
- The root `.docx` report is a personal academic document and should not be published without sanitization.

## Actions Taken

- Created a sanitized n8n workflow export in `workflows/`.
- Created sanitized sample triage output in `sample-data/`.
- Created a portfolio README, Dockerfile, Docker Compose file, and Streamlit dashboard script.
- Added `.gitignore` rules for memory dumps, raw reports, n8n state, logs, SQLite databases, local virtual environments, third-party tool checkouts, and the original `DFIR_Project/` workspace.
- No raw memory dump, n8n database, encryption key, log file, or personal report was copied into the publishable project structure.
- Added `docs/sample-memory-dump.md` to explain how to handle the local lab memory image without committing it.

## Recommended Follow-Up

- If this repository is cloned elsewhere, install or clone Volatility3 into `tools/volatility3/` locally instead of committing it.
- Use only authorized lab memory images or sanitized samples.
- Treat memory dumps and generated triage reports as sensitive evidence unless explicitly created for public sharing.
- Rotate any n8n credentials if they were ever stored in the local database used during development.
