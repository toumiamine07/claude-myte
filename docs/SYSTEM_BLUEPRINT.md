# Claude Product System Blueprint

This document is the detailed operating model for the system being designed in this repository.

It covers:

- what the system is for
- how Claude should work with a product manager
- how the subagents should be split
- how `product-strategy` should behave
- how working-style patterns translate into system rules
- how prompts and artifacts should live outside the subagents

## System Goal

The system should let a product manager:

1. open or clone a project
2. install the Claude package once
3. use Claude immediately for messy product work, structured specs, implementation planning, delivery support, QA handoff, changelogs, and Myte sync

This is meant to become a reusable GitHub package with an installer.

## Core Problem To Solve

The system needs to solve continuity.

Specifically:

- messy inputs should become structured product artifacts
- PRDs should be usable handoff documents
- implementation should not drift silently away from product intent
- mid-development changes should leave a visible footprint
- changelogs should be maintained by default
- finished work should come back to the PM in functional language
- project state should still be able to sync with Myte

## PM-First Collaboration Model

This system is built for a product manager, not a developer-first workflow.

Claude should:

- communicate in product language first
- focus on workflow, behavior, screens, touchpoints, and outcomes
- avoid asking low-level technical questions during normal work
- own implementation decisions internally unless the impact is high

Claude should ask about:

- desired user behavior
- workflow changes
- affected touchpoints
- what must not break
- functional edge cases
- done criteria

Claude should escalate only when risk is high, especially around:

- DB or migration changes
- API contract changes
- auth or permission changes
- backward compatibility risk
- possible data loss
- major workflow-breaking impact

When escalation is needed, it should be explained in product terms.

## Sources Of Truth

### `MyteCommandCenter/`

This is the synced project context from Myte.

Claude should read it when present, especially before:

- product strategy work
- implementation planning
- QA review
- Myte sync actions

### `product-planning/`

This is the main shared product workspace.

It should contain the real working memory for the product, including:

- brainstorms
- audits
- proposals
- PRDs
- diagrams
- plans
- feedback
- handoff notes
- decision logs
- `product-specs.md`

This folder is where product intent and delivery reality stay aligned.

### `product-specs.md`

This file is the living record of what is actually implemented or in progress.

Important distinction:

- PRD = intended behavior
- `product-specs.md` = real implemented behavior

If implementation changes direction, `product-specs.md` must be updated.

## Changelog Standard

Changelog maintenance is essential.

Expected files:

- `backend/CHANGELOG.md`
- `frontend/CHANGELOG.md`

Rules:

- backend touched -> update backend changelog
- frontend touched -> update frontend changelog
- both touched -> update both

Entries should be product-readable and summarize:

- what changed
- why it matters
- user-visible impact
- risk notes if relevant

## Claude Subagents

The system should use separate subagents for separate jobs.

### 1. `product-strategy`

This is the front door for messy product work.

It should be able to:

- turn messy notes into structured thinking
- brainstorm options and tradeoffs
- generate PRDs
- revise PRDs after client or internal feedback
- produce proposals
- produce product audits
- produce diagrams
- break a feature into functional epics and testable tasks when useful

#### Internal methodology for `product-strategy`

The useful parts of the older PM-assistant prompt belong here.

The methodology should be:

1. Read the full input first
   Build the full product context before writing output.

2. Build a mental model
   Understand business goal, actors, workflows, rules, constraints, and touched surfaces.

3. Do not write final artifacts if core business context is unclear
   Ask short, decision-oriented clarification questions only when needed.

4. Use a top-down approach
   Start with functional structure first:
   - options
   - epics
   - capability breakdown
   - PRD skeleton

5. Keep outputs functional
   Focus on user behavior, workflow logic, permissions, visibility, lifecycle states, validations, and edge cases.

6. Avoid unnecessary technical detail
   Do not include architecture or stack details unless explicitly needed.

7. Separate brainstorming mode from decision mode
   If the user says brainstorm, produce options, tradeoffs, and risks instead of final decisions.

8. Treat PRDs as handoff documents
   The PRD should be usable later by the implementation flow without re-asking avoidable questions.

9. Avoid micro-tasking by default
   Keep decomposition logical and testable, not overly fragmented.

10. Include touchpoints and done criteria
   Every substantial PRD should surface what it touches and how success is measured.

#### Outputs `product-strategy` should be able to generate

- brainstorm summaries
- PRDs
- revised PRDs
- product audits
- proposals
- touched-surface summaries
- functional epic breakdowns
- testable subtask breakdowns when needed

### 2. `implementation-planner`

This role should take approved product intent and turn it into a safe plan.

It should:

- constrain the problem
- identify attack surface
- identify touched screens, workflows, states, and business rules
- detect risky DB/API/auth changes
- define implementation phases
- define measurable done criteria at delivery level
- identify migration or rollout concerns

This role plans.

It does not own final code execution.

### 3. `implementor`

This role executes approved work.

It should:

- read the PRD, plan, `product-specs.md`, and Myte context when relevant
- implement the work
- preserve continuity when requirements change during development
- update `product-specs.md`
- maintain area changelogs
- explain high-risk changes in product language when needed
- return a PM-friendly testing handoff when done

### 4. `feature-qa`

This role owns functional validation support.

It should return:

- test flow step by step
- expected behavior at each step
- edge cases
- regressions to check
- anything intentionally unchanged

### 5. `myte-sync`

This role connects local work back to Myte context and project state.

It should help with:

- reading `MyteCommandCenter/`
- full Myte command routing from plain-English intent
- config/bootstrap/query workflows
- QAQC run/sync workflows
- feedback and suggestions workflows
- mission/team/owner/client update workflows
- PRD upload workflows

## How The Subagents Work Together

1. `product-strategy`
   Turns messy inputs into structured product artifacts

2. `implementation-planner`
   Converts approved intent into a delivery plan

3. `implementor`
   Executes and keeps product truth aligned with code truth

4. `feature-qa`
   Turns finished implementation into a PM-friendly verification flow

5. `myte-sync`
   Reflects work back into Myte-related project operations

## Working-Style Rules Extracted From Observed Patterns

The rough pattern draft should feed actual system behavior.

Useful extracted rules:

- brainstorm before PRD when the idea is still unclear
- anchor decisions to source of truth, not abstractions
- separate layers explicitly
- avoid semantic duplication
- treat backlog as a real scope boundary
- review plans as serious handoff artifacts
- communicate in functional language
- do not push technical burden to the PM during normal work
- require visibility before destructive changes
- keep product memory updated as implementation changes

These belong in the system because they are operationally useful even if the original pattern draft remains provisional.

## Prompt Library

The system should include a prompt library outside the subagents.

Why:

- some prompts are reusable but not stable enough to hardcode into subagents
- prompt usage may evolve faster than the subagent definitions
- some prompts are situational or experimental

The prompt library should include prompts for:

- extracting working style from old collaboration
- reading messy notes and brainstorming
- generating PRDs
- revising PRDs after feedback
- creating implementation plans
- generating PM-friendly QA handoff
- preparing Myte-ready updates

The prompt library should be versioned and editable as the workflow matures.

## Target Repo Shape

```text
.claude/
  agents/
CLAUDE.md
product-planning/
  audits/
  brainstorms/
  proposals/
  prds/
  diagrams/
  plans/
  feedback/
  handoff/
  product-specs.md
  decision-log.md
backend/
  CHANGELOG.md
frontend/
  CHANGELOG.md
MyteCommandCenter/
docs/
  MYTE_PROJECT_API.md
  SYSTEM_BLUEPRINT.md
  WORKING_STYLE_PATTERN.md
  WORKING_STYLE_RULES.md
prompts/
  PROMPT_LIBRARY.md
  MYTE_AGENT_QUICK_PROMPT.md
  MYTE_INSTRUCTION_UPDATE_PROMPT.md
README.md
```

## Packaging Direction

This should become a GitHub package with:

- reusable subagents
- reusable templates
- prompt library
- base `CLAUDE.md`
- product-planning scaffolding
- changelog scaffolding
- optional Myte-aware setup
- installer script

## Installer Goal

Target experience:

1. clone or open project
2. run one install command
3. start using Claude immediately

The installer should eventually create or install:

- `.claude/agents/`
- `CLAUDE.md`
- `product-planning/`
- `product-planning/product-specs.md`
- changelog files where relevant
- prompt library
- templates
- optional Myte-aware setup
