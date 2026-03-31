# Myte Project API Guide

This folder now contains a working reference for the Myte Project API and CLI.

## What This Is

The Myte Project API gives a developer **project-scoped access** to Myte from the terminal.

It does **not** give org-wide access.

It is scoped to this project's:

- repos
- missions
- QAQC state
- project comments
- client update drafts
- PRD feedback intake

Use `Authorization: Bearer <YOUR_PROJECT_API_KEY>` on each request.

## Best Starting Flow

1. Install the CLI
2. Verify config
3. Bootstrap local Command Center context
4. Query with or without local git diff context
5. Sync QAQC results when QAQC has run
6. Post team updates, draft client updates, and upload PRDs as needed

## Requirements

- Node 18+
- `git` in PATH for `--with-diff`
- `MYTE_API_KEY=<YOUR_PROJECT_API_KEY>`
- Optional, only if not using prod:
  - `MYTE_API_BASE=https://api.myte.dev/api`

## Install Modes

### Local workspace install

```bash
npm install myte
npx myte ...
npm exec myte -- ...
```

### Global install

```bash
npm i -g myte
myte ...
```

### No install

```bash
npx myte@latest ...
```

## What The CLI Gives You

- `config`: resolve the project and repo allow-list behind this key
- `bootstrap`: write project board context into `MyteCommandCenter/data`
- `run-qaqc`: queue QAQC for up to 10 explicit mission ids, then optionally sync local QAQC context
- `sync-qaqc`: write active mission QAQC context into `MyteCommandCenter/data/qaqc.yml`
- `query`: ask the project assistant against project context
- `query --with-diff`: include local repo diffs from the matching project repos
- `update-team`: create a project-global comment in Myte
- `update-owner`: send a direct project-owner update email through Myte SMTP
- `update-client`: create a client update draft for owner review in Project CRM
- `feedback-sync`: write open project feedback and PRD text copies into `MyteCommandCenter/data/feedback.yml`
- `suggestions sync`: write mission suggestion workflow state into `MyteCommandCenter/data/mission-ops.yml`
- `suggestions create`: submit one or many mission suggestions from a file or local mission-ops drafts
- `suggestions revise`: push another revision to one or many existing suggestions
- `suggestions review`: owner-only request changes, reject, approve, and resync missions locally
- `create-prd`: upload one or many PRD markdown files as deterministic project feedback

## What Lands Locally

- `bootstrap` writes the project board snapshot under `MyteCommandCenter/data`
- `sync-qaqc` writes active mission QAQC context under `MyteCommandCenter/data/qaqc.yml`
- `feedback-sync` writes open feedback cards and PRD copies under `MyteCommandCenter/data/feedback.yml`
- `suggestions sync` writes mission suggestion workflow state under `MyteCommandCenter/data/mission-ops.yml`
- `query` does not write files by default
- `update-team`, `update-owner`, and `update-client` send actions into Myte and do not create local files by default
- `create-prd` uploads into Myte feedback and does not create local files by default

## Core Commands

### 1. Verify config

```bash
npx myte config --json
```

Purpose:

- confirm that the key authenticates
- show the `project_id` behind the key
- show `repo_names` configured for this project
- show which of those repos are found locally

### 2. Bootstrap project context

```bash
npx myte bootstrap
```

Purpose:

- create the local `MyteCommandCenter` board snapshot for this project

Minimal input:

- wrapper root workspace that contains this project's repo folders
- project API key

Local output:

- `MyteCommandCenter/data/project.yml`
- `MyteCommandCenter/data/phases/*.yml`
- `MyteCommandCenter/data/epics/*.yml`
- `MyteCommandCenter/data/stories/*.yml`
- `MyteCommandCenter/data/missions/*.yml`

Behavior:

- calls `/project-assistant/bootstrap`
- validates this workspace against the project's configured repo names
- writes a normalized public DTO, not raw mission/proposal documents
- mission cards include execution context like `complexity`, `estimated_hours`, `due_date`, `subtasks`, `technical_requirements`, `resources_needed`, `labels`, and normalized `test_cases`
- excludes internal fields like `_id`, `org_id`, `project_id`, `created_by`, `assigned_to`, and raw `qa_qc_results`

### 3. Run QAQC

```bash
npx myte run-qaqc --mission-ids M001,M002 --wait --sync
```

Purpose:

- queue QAQC for one or more active missions
- refresh local QAQC context when the batch completes

Minimal input:

- `--mission-ids M001[,M002...]`
- project API key

Output:

- `batch_id`
- `requested_count`
- `accepted_count`
- `status`
- `missions[]` per-mission queued/running/completed state
- optional sync summary when `--sync` is used

Behavior:

- calls `/project-assistant/run-qaqc`
- accepts up to 10 explicit mission ids per request
- uses `--wait` to poll `/project-assistant/run-qaqc/<batch_id>`
- uses `--sync` to refresh `MyteCommandCenter/data/qaqc.yml` after a completed batch
- runs through the dedicated `project_api_qaqc` queue inside the existing Celery service
- global service budget is capped at 20 dispatch starts per rolling minute and 20 live jobs
- a saturated batch wave can take roughly 5 to 10 minutes before sync is ready

### 4. Sync QAQC

```bash
npx myte sync-qaqc
```

Purpose:

- sync the latest active-mission QAQC context after QAQC has run

Minimal input:

- wrapper root workspace that contains this project's repo folders
- project API key

Local output:

- `MyteCommandCenter/data/project.yml`
- `MyteCommandCenter/data/qaqc.yml`

Behavior:

- calls `/project-assistant/qaqc-sync`
- works even if bootstrap has not been run yet
- creates `MyteCommandCenter/data/qaqc.yml` automatically if missing
- syncs only Todo and In Progress missions
- writes the public QAQC summary and active mission working set in one deterministic file
- fully rewrites `qaqc.yml` on every sync without deleting `MyteCommandCenter/data/missions/*.yml`
- keeps QAQC state in `qaqc.yml` so local QAQC context grows and shrinks with current reality

### 5. Query project context

```bash
npx myte query "What changed in logging?"
```

Purpose:

- ask the project assistant against project mission, requirement, and retrieval context

Output:

- answer
- context block count
- telemetry summary

### 6. Query with local diff context

```bash
npx myte query "What changed in logging?" --with-diff
```

Purpose:

- ask the assistant using current local repo diffs from this project's repos

Behavior:

- calls `/project-assistant/config` to get this project's repo names
- matches local folders by exact configured repo name
- compares each repo against `origin/main` or `origin/master`
- includes base vs HEAD, staged, unstaged, and untracked changes
- keeps going if one repo is missing and reports that in diagnostics

Output:

- answer grounded in current local changes
- repo diagnostics when diff collection is partial

### 7. Print query payload without sending

```bash
npx myte query "What changed?" --with-diff --print-context
```

Purpose:

- inspect the exact JSON payload before sending it

Output:

- exact query payload
- `diff_diagnostics`
- no query is sent

### 8. Post a team update

```bash
npx myte update-team "Backend deploy completed; QAQC rerun queued."
```

Purpose:

- create a project-global comment in Myte as the key holder

Behavior:

- calls `/project-assistant/project-comment`
- creates a normal project comment in Mission UI
- API-triggered project comments guarantee project-owner notification in addition to assigned collaborators

### 9. Send owner update

```bash
npx myte update-owner --subject "QAQC progress" --body-file ./updates/owner.md
```

Purpose:

- send a direct project-owner update email through Myte SMTP on behalf of the key holder

Behavior:

- calls `/project-assistant/update-owner`
- resolves the owner from the authenticated project, not from CLI input
- sends the authored markdown as a branded Myte email with reply-to set to the collaborator when available

Output:

- `update_id`
- `project_id`
- `project_title`
- `status`
- owner summary

### 10. Draft client update

```bash
npx myte update-client --subject "Weekly client update" --body-file ./updates/week-12.md
```

Purpose:

- create a client update draft for owner review before anything is sent to the client

Behavior:

- calls `/project-assistant/client-update-drafts`
- draft is reviewed and approved inside `Project CRM > Client Updates`
- owner can edit, approve, request changes, reject, preview, and send

Output:

- `draft_id`
- `project_id`
- `project_title`
- `status`
- target contact summary

### 11. Sync feedback and PRD text

```bash
npx myte feedback-sync
```

Purpose:

- sync open project feedback and PRD-backed document context into `MyteCommandCenter`

Behavior:

- calls `/project-assistant/feedback-sync`
- writes one deterministic file at `MyteCommandCenter/data/feedback.yml`
- includes readable PRD text inline when available
- fully replaces the feedback-owned local sync file to avoid stale feedback noise
- does not delete `MyteCommandCenter/data/missions/*.yml`

Output:

- `MyteCommandCenter/data/feedback.yml`

### 12. Sync mission suggestions

```bash
npx myte suggestions sync
```

Purpose:

- sync the current mission suggestion workflow into one deterministic local file

Behavior:

- calls `/project-assistant/suggestions`
- writes one merge-safe file at `MyteCommandCenter/data/mission-ops.yml`
- sync first before ideating so local drafts start from the latest aggregated thread state
- preserves local `workspace.<actor_scope>` draft blocks across sync
- keeps actionable items in queue and full lineage in `threads[]`
- each thread includes aggregate diffs, conflict summaries, and archived decision history for local review

### 13. Create mission suggestions

```bash
npx myte suggestions create --file ./changes/create.yml
```

Purpose:

- submit one or many mission suggestions from the terminal

Behavior:

- calls `/project-assistant/suggestions`
- accepts one suggestion or a batch in one request
- can read `--file` payloads or local `workspace.<actor_scope>.draft_submissions[]` from `mission-ops.yml`
- auto-sends idempotency and client-session metadata for deterministic retries and auditability
- resyncs `mission-ops.yml` by default after successful submission

### 14. Revise mission suggestions

```bash
npx myte suggestions revise
```

Purpose:

- submit another revision for one or many existing suggestion threads

Behavior:

- calls `/project-assistant/suggestions/revise`
- can read `--file` payloads or local per-thread `workspace.<actor_scope>` drafts from `mission-ops.yml`
- auto-sends idempotency and client-session metadata for deterministic retries and auditability
- resyncs `mission-ops.yml` by default after successful revision submission

### 15. Review mission suggestions

```bash
npx myte suggestions review
```

Purpose:

- owner-only review path for suggestion drafts from the terminal

Behavior:

- calls `/project-assistant/suggestions/review`
- supports `request_changes`, `approve`, and `reject`
- can read `--file` payloads or local owner review intent from `mission-ops.yml`
- auto-sends idempotency and client-session metadata for deterministic retries and auditability
- approvals refresh the affected `MyteCommandCenter/data/missions/*.yml` cards automatically
- notifications deep-link back into the project Reviews workspace for the affected thread

### 16. Upload PRDs

```bash
npx myte create-prd ./drafts/auth-prd.md ./drafts/billing-prd.md
```

Purpose:

- upload one or many PRD markdown files as deterministic project feedback

Behavior:

- calls `/project-assistant/create-prd` for one file and uses the batch upload path for many files
- accepts repeated file paths in one command and sends all multi-file uploads in one deterministic batch request
- each batch item carries the title, optional description or card summary, and the full PRD markdown blob that becomes the stored PRD document
- stores the markdown as PRD content
- creates the feedback item and generated DOCX attachment

Output:

- for one file: `feedback_id`, `project_id`, `title`, `status`
- for many files: `project_id`, `requested_count`, `created_count`, `failed_count`, `items[]`

## Global Command Equivalents

```bash
myte config --json
myte bootstrap
myte run-qaqc --mission-ids M001,M002 --wait --sync
myte sync-qaqc
myte query "..."
myte query "..." --with-diff
myte update-team "..."
myte update-owner --subject "..." --body-file ./owner-update.md
myte update-client --subject "..." --body-file ./update.md
myte feedback-sync
myte suggestions sync
myte suggestions create --file ./changes/create.yml
myte suggestions revise
myte suggestions review
myte create-prd ./drafts/auth-prd.md ./drafts/billing-prd.md
```

## Direct API Surface

```text
GET  https://api.myte.dev/api/project-assistant/config
GET  https://api.myte.dev/api/project-assistant/bootstrap
POST https://api.myte.dev/api/project-assistant/run-qaqc
GET  https://api.myte.dev/api/project-assistant/run-qaqc/<batch_id>
GET  https://api.myte.dev/api/project-assistant/qaqc-sync
GET  https://api.myte.dev/api/project-assistant/feedback-sync
GET  https://api.myte.dev/api/project-assistant/suggestions
POST https://api.myte.dev/api/project-assistant/suggestions
POST https://api.myte.dev/api/project-assistant/suggestions/revise
POST https://api.myte.dev/api/project-assistant/suggestions/review
POST https://api.myte.dev/api/project-assistant/query
POST https://api.myte.dev/api/project-assistant/project-comment
POST https://api.myte.dev/api/project-assistant/update-owner
POST https://api.myte.dev/api/project-assistant/client-update-drafts
POST https://api.myte.dev/api/project-assistant/create-prd
```

## Practical Use For Us

As a product manager and builder, this lets us use Myte from terminal workflows instead of only inside Myte Cody.

The biggest uses are:

- pull project context locally with `bootstrap`
- ask project-aware questions with `query`
- include local code changes with `query --with-diff`
- run and sync QAQC for active missions
- keep feedback and suggestion workflows synced into local files
- push updates to team, owner, and client without leaving terminal
- upload PRDs directly from markdown files

## Suggested Daily Workflow

```bash
npx myte config --json
npx myte bootstrap
npx myte feedback-sync
npx myte suggestions sync
npx myte query "What should I focus on today?"
```

If working across repos and local changes:

```bash
npx myte query "Summarize what changed and what missions are affected" --with-diff
```

If QAQC just ran:

```bash
npx myte sync-qaqc
```

If you need to notify stakeholders:

```bash
npx myte update-team "Work completed and QAQC synced."
npx myte update-owner --subject "Progress update" --body-file ./updates/owner.md
npx myte update-client --subject "Weekly client update" --body-file ./updates/client.md
```

## Recommended First Run

```bash
export MYTE_API_KEY=<YOUR_PROJECT_API_KEY>
npx myte config --json
npx myte bootstrap
```

If that works, the local `MyteCommandCenter/data` folder becomes the shared local context layer for project work.
