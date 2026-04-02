# LLM Reliability Playbook

How to keep this toolkit reliable at real-team scale.

## Why This Exists

Most AI workflow systems fail for the same reasons:

- they rely on clever prompts but weak context structure
- they dump too much context with poor retrieval discipline
- they skip repeatable quality checks
- they cannot explain why an output should be trusted

This playbook adds operational discipline so quality survives real workloads.

## Reliability Stack

Use this stack in order:

1. Intent classification
   Decide what job we are doing: brainstorm, PRD, plan, implementation, QA, or Myte sync.
2. Context contract
   Define minimum required artifacts for that job.
3. Scoped retrieval
   Pull only relevant artifacts, not full-folder dumps.
4. Execution contract
   Produce output with assumptions and clear decision posture.
5. Evaluation loop
   Score output quality and update instructions based on failures.

## Context Contract

Define required vs optional context by task type.

### Brainstorm / PRD

Required:

- relevant `product-planning/brainstorms/` or notes
- related `product-planning/decision-log.md`
- relevant Myte mission context when present

Optional:

- old PRDs for related features
- feedback notes

### Implementation Planning

Required:

- approved PRD
- `product-planning/product-specs.md`
- relevant constraints/dependencies

Optional:

- prior implementation plans for similar scope

### Implementation

Required:

- approved PRD + approved plan
- `product-planning/product-specs.md`
- latest decision log or handoff notes

Optional:

- historical changelog entries for impacted areas

### QA / Acceptance

Required:

- expected behavior source (PRD or product-specs)
- changed scope summary

Optional:

- prior QA findings

### Myte Sync

Required:

- `docs/MYTE_PROJECT_API.md`
- exact requested operation + inputs

Optional:

- related product-planning summary for message drafting

## Retrieval Discipline

Rules:

- start with minimal files; expand only if blocked
- prefer specific files over whole directories
- never hide conflicting context; surface it
- never invent missing data
- use file references as evidence for decisions

Good pattern:

- retrieve -> validate -> decide -> output

Bad pattern:

- retrieve everything -> hope prompt figures it out

## Output Quality Gates

### Strategy / PRD Gate

- scope and non-goals are explicit
- user behavior and touchpoints are explicit
- edge cases and risks are visible
- done criteria are measurable

### Planning Gate

- attack surface is explicit
- phases are cumulative and testable
- high-risk items are explained in product terms

### Implementation Gate

- output matches approved behavior
- `product-specs.md` updated when behavior changed
- relevant changelog(s) updated

### QA Gate

- PM can run the tests without developer context
- expected results are explicit
- regressions and blockers are clear

### Myte Gate

- only documented Myte commands are used
- missing inputs/prerequisites are surfaced before execution

## Weekly Evaluation Loop

Frequency: weekly or each release.

Use 3-5 recent real tasks and score:

- correctness
- completeness
- actionability
- drift from approved intent
- communication clarity for PM use

Record results in a stable template (see `docs/QUALITY_EVAL_SCORECARD_TEMPLATE.md`).

## Metrics That Actually Matter

Track simple operational metrics:

- rework rate after first output
- % outputs needing major clarification
- % outputs failing acceptance gate
- time from messy input to approved PRD
- time from approved PRD to test-ready handoff

If these improve, your system is improving.

## Adoption Order

1. enforce context contract + retrieval discipline
2. enforce output quality gates
3. run weekly eval loop
4. refine subagents/prompts from real failure patterns

Do not start with model fine-tuning.
Most teams get major gains from better context and retrieval alone.
