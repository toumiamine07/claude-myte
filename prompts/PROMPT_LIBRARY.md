# Prompt Library

Reusable prompts that can live outside the Claude subagents.

These prompts are intentionally editable and can evolve faster than the subagent definitions.

## 1. Extract Working Style

Use when feeding Claude old collaboration examples so it can infer style and standards.

```text
I want you to study these examples of how I worked in the past and extract my actual product-working style from them.

Do not turn this into generic product advice.

Infer patterns from the real material I give you and return:

1. Observed patterns
2. Likely working standards
3. Communication preferences
4. Product decision habits
5. Planning habits
6. Execution and review habits
7. What should become system rules
8. What still needs clarification

Important:
- Separate my real style from borrowed habits
- Call out contradictions when they exist
- Focus on what is operationally useful for building a reusable Claude workflow
```

## 2. Read Messy Notes And Brainstorm

Use when you have messy client notes, CEO notes, voice-note style dumps, or rough ideas.

```text
Read the following messy notes and help me brainstorm product directions.

Do not ask me to rewrite or clean them first.

Your job is to structure the mess and return:

1. Clean summary
2. Problem or opportunity
3. Possible feature directions
4. Touched workflows and touchpoints
5. Risks and tradeoffs
6. Non-goals if visible
7. Open questions for me
8. Recommended next artifact

If the direction is still unclear, stay in brainstorming mode and do not finalize the PRD yet.
```

## 3. Generate PRD

Use when the idea is ready to become a formal product artifact.

```text
Turn this feature definition into a functional PRD.

First read the full context and build a mental model of:
- business goal
- actors
- workflows
- rules
- constraints
- touched touchpoints

If core business rules are unclear, ask short numbered clarification questions before finalizing the PRD.

The PRD should include:
- background
- problem
- goal
- user stories
- scope
- non-goals
- touched touchpoints
- expected behavior
- edge cases
- risks
- measurable done criteria
- rollout or phase notes when relevant

Keep it functional and product-facing.
Avoid unnecessary technical detail.
Treat the PRD as a real handoff document.
```

## 4. Revise PRD After Feedback

Use when client or internal feedback changes an existing PRD.

```text
I am giving you an existing PRD and new feedback.

Revise the PRD by:

1. Comparing old intent vs new intent
2. Explaining what changed
3. Highlighting impact on workflow, scope, and risks
4. Regenerating the PRD in a clean final form
5. Calling out new open questions only if they materially affect the feature

Keep the output product-facing and functional.
```

## 5. Create Implementation Plan

Use after the PRD is approved and before coding starts.

```text
Read this approved PRD and create an implementation plan.

Constrain the problem first.

Then identify:
- attack surface
- touched workflows
- touched screens or states
- key business rules
- high-risk areas
- implementation phases
- measurable done criteria
- rollout or migration concerns

Do not dump technical architecture unless it is necessary for a high-risk decision.

Write the plan like a serious handoff artifact, not loose notes.
```

## 6. Ask Functional Touchpoint Questions Before Coding

Use when moving from plan into implementation and some product-facing questions still matter.

```text
Before implementation, identify any missing product-facing decisions I need to answer.

Ask only short, numbered, decision-oriented questions about:
- workflow
- screens or UX
- expected behavior
- what must not break
- functional edge cases

Do not ask low-level technical questions unless the impact is high.
```

## 7. PM-Friendly Test Handoff

Use after implementation is complete.

```text
The feature is implemented.

Give me a PM-friendly testing handoff that includes:

1. What changed
2. Step-by-step test flow
3. Expected behavior at each step
4. Important edge cases
5. Regression checks
6. Anything intentionally unchanged

Write this for a product manager, not a developer.
```

## 8. Draft Myte Update

Use when local product or implementation work needs to be reflected back into Myte.

```text
Read the local product and implementation context and help me prepare a Myte-ready update.

Return:

1. What was completed
2. What changed functionally
3. What mission or board state should likely be updated
4. Any PRD, QA, or follow-up note that should be synced
5. A concise update message I can send or adapt

Keep it concise and operational.
```

## 9. Product Audit

Use when you want Claude to assess an existing product area.

```text
Audit this product area from a product manager perspective.

Return:

1. What exists today
2. Workflow strengths
3. Workflow gaps
4. UX and logic inconsistencies
5. Risks or breaking-change concerns
6. Quick wins
7. Larger product opportunities
8. Recommended next step
```

## 10. Refresh Myte Instructions

Use when Myte CLI/API behavior has changed and project docs or subagent rules need updates.

```text
Myte has changed. Refresh this project's Myte instruction system.

Inputs to use:
- Existing `docs/MYTE_PROJECT_API.md`
- Any new Myte release notes/changelog/text I provide in this chat
- Current files that depend on Myte behavior (at least: `CLAUDE.md`, `.claude/agents/myte-sync.md`, `prompts/PROMPT_LIBRARY.md`, `README.md`, `docs/SYSTEM_BLUEPRINT.md`)

Your tasks:

1. Compare old vs new Myte behavior
2. List exactly what changed (commands, flags, limits, endpoints, flow, auth/env requirements, outputs)
3. Propose required doc/rule updates file-by-file
4. Apply the updates directly to project docs and subagent instructions
5. Keep command guidance strict:
   - use documented commands only
   - remove deprecated/invalid commands
   - add new supported commands
6. Add a short "What Changed" summary section to `docs/MYTE_PROJECT_API.md` with date and key deltas
7. Return:
   - files updated
   - key changes
   - any unresolved ambiguity or assumptions

Rules:
- Do not invent commands or endpoints.
- If information is missing or contradictory, mark it explicitly.
- Keep PM-facing language clear and concise.
- Preserve existing project workflow unless Myte changes require adjustments.
```

## 11. Myte Plain-English Command Router

Use when you want to describe your goal casually and get exact Myte commands fast.

```text
Act as my Myte command router.

I will describe what I want in plain language.
Your job:

1. Interpret my intent.
2. Map it to the correct `npx myte ...` command(s) using `docs/MYTE_PROJECT_API.md`.
3. Keep command sequence minimal and in correct order.
4. Ask only for truly missing required inputs (mission ids, subject, body file path, query text, etc.).
5. Never invent commands or flags.

Response format:

- Interpreted intent
- Exact command sequence
- Missing required inputs (if any)
- One-line note on expected result

If I say `execute now`, run the commands directly.

My request:
<write request here>
```

## 12. Adopt Toolkit In Existing Project

Use when a project already has its own Claude setup and planning docs, and you want to migrate to this toolkit safely.

```text
Adopt this Claude Product System toolkit into the current existing project.

Toolkit repo:
- git@github.com:toumiamine07/claude-skills---toumi.git
- branch/tag: main

Goals:
1. Install toolkit files into this project.
2. Replace old Claude setup with this toolkit structure.
3. Migrate existing planning documents into `product-planning/` without losing context.
4. Keep a backup of replaced files before changing anything.

Execution rules:
- Do not start editing before inventory + migration plan are shown.
- Create a backup folder first (for example: `migration-backup/<timestamp>/`).
- Map old files to new destinations before moving/merging.
- Preserve valuable project-specific context from old files.
- If there is conflict between old and new instructions, prefer explicit project reality and note the conflict.
- Do not delete old artifacts until migration summary is complete.

Required process:
1. Inventory current files related to:
   - Claude instructions (`CLAUDE.md`, `.claude/agents/`, old prompts)
   - product planning docs
   - QA, decision, and handoff docs
2. Propose migration map old -> new path.
3. Ask for confirmation.
4. Install toolkit (using local commands, not theory).
5. Migrate/merge docs into:
   - `product-planning/`
   - `docs/`
   - `prompts/`
6. Update references/paths so everything is consistent.
7. Return final report:
   - files created
   - files migrated
   - files replaced
   - unresolved conflicts
   - recommended next validation step
```
