# Claude Product System Contract

Project-level operating rules for Claude in this repository.

## Operating Goal

Support a product manager workflow end to end:

- messy input -> structured strategy
- strategy -> PRD
- PRD -> safe implementation plan
- implementation -> updated product memory and changelogs
- completion -> PM-friendly testing handoff
- optional -> Myte sync-ready updates

## Source Of Truth Order

When present, read in this order:

1. `MyteCommandCenter/` (project context from Myte)
2. `product-planning/` (shared strategy and execution workspace)
3. active PRD(s) and plan(s)
4. `product-planning/product-specs.md` (actual implementation reality)
5. latest changelog entries in backend/frontend

## Subagent Routing

Use the role that matches the user intent:

- `product-strategy`
  - brainstorming
  - PRD generation
  - PRD revisions from feedback
  - proposals and audits

- `implementation-planner`
  - attack surface analysis
  - phased plan creation
  - risk and dependency mapping

- `implementor`
  - execute approved plan
  - update product specs
  - update changelogs
  - provide PM test handoff

- `feature-qa`
  - functional test steps
  - expected behavior
  - edge cases and regressions

- `myte-sync`
  - Myte-aligned progress summaries
  - mission/board update drafting
  - PRD and QA/QC sync support

## Myte Command Policy

For any Myte-related work:

1. Read `docs/MYTE_PROJECT_API.md` first.
2. Use only documented commands/flags/endpoints from that file.
3. Do not invent CLI commands.
4. If a required env var or prerequisite is missing, state it before suggesting execution.

Minimum prerequisites to mention when relevant:

- Node 18+
- `MYTE_API_KEY`
- optional `MYTE_API_BASE`
- `git` in PATH for `--with-diff`

## PM-First Communication Rules

- Speak in functional product language first.
- Ask about behavior, workflows, outcomes, and touchpoints.
- Do not ask low-level technical implementation questions during normal work.
- Escalate technical details only when risk is high.

High-risk escalation includes:

- DB schema or migration impact
- API contract changes
- auth/permission model changes
- backward compatibility risk
- potential data loss/corruption
- major workflow-breaking impact

When escalating, explain in product terms:

- what changes
- why it is risky
- business/user impact
- decision needed from PM

## Artifact Update Rules

If implementation changes behavior:

- update `product-planning/product-specs.md`

If backend is touched:

- update `backend/CHANGELOG.md`

If frontend is touched:

- update `frontend/CHANGELOG.md`

If both are touched:

- update both changelogs

## Completion Handoff Requirement

After implementation, always return:

1. what changed
2. step-by-step functional test flow
3. expected behavior at each step
4. edge cases
5. regression checks
6. intentionally unchanged behavior

## Prompt Library

Reusable prompts live in:

- `prompts/PROMPT_LIBRARY.md`

Use that file for fast prompt reuse and iterative refinement outside subagent definitions.

## Default Workflow

1. `product-strategy` for messy input and product shaping
2. `implementation-planner` for phased delivery plan
3. `implementor` for execution and artifact updates
4. `feature-qa` for PM-friendly validation
5. `myte-sync` when project-state sync is needed
