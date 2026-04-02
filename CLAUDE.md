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
5. `product-planning/decision-log.md`
6. `product-planning/session-handoff.md` (latest cross-tool context)
7. latest changelog entries in backend/frontend

## Context + Retrieval Preflight (Mandatory)

Before producing strategy, PRDs, plans, implementation, QA, or Myte actions:

1. Classify the request:
   - brainstorm
   - PRD/revision
   - implementation planning
   - implementation
   - QA
   - Myte sync
2. Build a minimal context set from the source-of-truth order.
3. Prefer file paths and focused excerpts over large pasted dumps.
4. If a required artifact is missing for high-impact work, stop and ask only blocking questions.
5. If confidence is low because context is incomplete, state that explicitly before recommending actions.

Default context discipline:

- read the smallest reliable set first, then expand only if needed
- avoid pulling whole folders if a few files can answer the decision
- when context conflicts, prefer explicit current project reality and log the conflict

## Reliability Output Contract

For meaningful decisions and high-impact actions, include:

1. recommendation/action
2. evidence inputs used (artifact paths)
3. assumptions
4. unknowns or missing context
5. risk level (low/medium/high) and why when relevant

## Cross-Tool Switch Protocol

When switching between Claude Code, Codex, or Cowork:

1. Update `product-planning/session-handoff.md` before switching.
2. Record objective, completed work, in-progress work, blockers, touched files, and next best step.
3. The new tool must read `product-planning/session-handoff.md` before proceeding.
4. Continue from the recorded next step.
5. Do not run concurrent conflicting edits on the same files from multiple tools.

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
  - full Myte operations routing and execution
  - config/bootstrap/query flows
  - QAQC, feedback, suggestions, updates, and PRD upload flows

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

## Response Depth Policy (70/30)

Default response style across all subagents:

- 70% deep: include meaningful reasoning, risks, assumptions, and decision clarity.
- 30% short: keep wording concise, avoid repetition, and avoid unnecessary detail.

Use short mode only when appropriate:

- straightforward status checks
- non-risky follow-ups
- user explicitly asks for a short answer

Automatically increase depth when risk is high, including:

- DB/API/auth/migration changes
- lifecycle or permission changes
- possible breaking behavior
- ambiguous requirements with product impact

Do not sacrifice decision quality for brevity.
Prefer concise depth over shallow summaries.

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

1. run context + retrieval preflight
2. `product-strategy` for messy input and product shaping
3. `implementation-planner` for phased delivery plan
4. `implementor` for execution and artifact updates
5. `feature-qa` for PM-friendly validation
6. `myte-sync` when project-state sync is needed
