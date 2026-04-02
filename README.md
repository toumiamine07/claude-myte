# Claude Product System

Reusable Claude Code package for product managers and builders.

This project is meant to become a GitHub package plus installer that can be dropped into a new or existing project so Claude can support product strategy, PRDs, planning, implementation, QA, changelogs, and Myte sync in one consistent workflow.

## Quick Start (New Project)

From the root of your new project folder, run:

```bash
tmp="$(mktemp -d)" && \
git clone --depth 1 --branch main git@github.com:toumiamine07/claude-skills---toumi.git "$tmp/toolkit" && \
"$tmp/toolkit/install.sh" --target "$PWD" && \
rm -rf "$tmp"
```

Install a specific version tag:

```bash
tmp="$(mktemp -d)" && \
git clone --depth 1 --branch v0.1.0 git@github.com:toumiamine07/claude-skills---toumi.git "$tmp/toolkit" && \
"$tmp/toolkit/install.sh" --target "$PWD" && \
rm -rf "$tmp"
```

## How To Use (Step-by-Step)

1. Open your project folder and install this toolkit.
2. Make sure Claude can see project context:
   - keep product artifacts in `product-planning/`
   - keep Myte context in `MyteCommandCenter/` when available
3. Start with strategy:
   - "Use `product-strategy` to turn this messy note into options and a PRD draft."
4. Plan implementation:
   - "Use `implementation-planner` to create phased delivery with risks and done criteria."
5. Execute:
   - "Use `implementor` to build this approved plan and update `product-specs.md`."
6. Validate:
   - "Use `feature-qa` to give me step-by-step PM test flow and edge cases."
7. Run Myte operations when needed:
   - "Use `myte-sync` to map this request to Myte commands and execute now."

## Reliability Layer (Why This Is More Than Prompts)

This package is designed to avoid the common failure mode of "prompt-only AI workflows."

It enforces a practical stack:

1. intent classification (what job are we doing)
2. context contract (what artifacts are required)
3. scoped retrieval (only relevant files, not full dumps)
4. role execution (strategy/plan/implement/QA/Myte)
5. output gates + eval loop (quality checks and drift control)

If you want to harden this further in your org, use:

- `docs/LLM_RELIABILITY_PLAYBOOK.md`
- `docs/QUALITY_EVAL_SCORECARD_TEMPLATE.md`
- new reliability prompts in `prompts/PROMPT_LIBRARY.md`

Recommended cadence:

1. before major work: run prompt 15 (context pack)
2. before handoff to execution: run prompt 17 (quality gate)
3. weekly: run prompt 18 (reliability review) and fill scorecard template

## Switch Protocol (Claude Code <-> Codex)

Use this whenever you switch tools because chat memory does not transfer automatically.

1. Update `product-planning/session-handoff.md` before switching.
2. Include: objective, completed work, in-progress step, blockers, touched files, next best step.
3. In the new tool, ask it to read:
   - `CLAUDE.md`
   - `product-planning/product-specs.md`
   - `product-planning/decision-log.md`
   - `product-planning/session-handoff.md`
4. Continue from the recorded next step, not from scratch.
5. Avoid editing the same files from two tools at the same time.

## Use Cases (Examples)

### 1. Messy CEO/Client Notes -> PRD

Prompt:

```text
Use product-strategy. Turn these messy notes into:
1) clean summary
2) options with tradeoffs
3) PRD draft
4) open decisions
```

### 2. Approved PRD -> Safe Plan

Prompt:

```text
Use implementation-planner. Read this PRD and give me:
attack surface, phased implementation, risks, and measurable done criteria.
```

### 3. Plan -> Build + PM Handoff

Prompt:

```text
Use implementor. Execute this approved plan, update product-planning/product-specs.md,
then return PM-friendly test steps, expected behavior, edge cases, and regressions.
```

### 4. Plain English -> Myte Commands

Prompt:

```text
Use myte-sync. I want to sync feedback, run QAQC for M002 and M004, then post a team update. Execute now.
```

## Changelog Automation (Per Commit + Daily)

If you want changelogs to stay updated automatically:

1. Install git post-commit hook:

```bash
./scripts/install_post_commit_hook.sh
```

This runs `./scripts/sync_changelogs.sh --quiet` after every commit.

2. Run a daily end-of-day sync (cron at 23:00):

```bash
(crontab -l 2>/dev/null; echo "0 23 * * * cd $PWD && ./scripts/sync_changelogs.sh --quiet") | crontab -
```

3. Optional dry-run preview:

```bash
./scripts/sync_changelogs.sh --dry-run
```

Notes:

- Default areas: `backend,frontend`.
- Override area names if needed:

```bash
./scripts/sync_changelogs.sh --areas api,web
```

## Roles (You vs Claude)

| You (Product Manager / Builder) | Claude Role | Main Output |
|---|---|---|
| Define goals, constraints, outcomes | `product-strategy` | brainstorms, PRDs, revisions, proposals, audits |
| Approve direction and scope | `implementation-planner` | phased execution plan, risks, dependencies, done criteria |
| Confirm product behavior and priorities | `implementor` | code changes, updated `product-specs.md`, PM-ready testing handoff |
| Validate feature behavior | `feature-qa` | step-by-step functional QA, edge cases, regressions |
| Ask for Myte actions in plain language | `myte-sync` | valid Myte command routing/execution and PM-friendly sync outputs |

## What This Project Is

This system is designed around one simple setup:

- `MyteCommandCenter/` = synced project context from Myte
- `product-planning/` = shared product strategy and execution workspace
- Claude subagents = separate roles for strategy, planning, implementation, QA, and Myte sync
- prompt library = reusable prompts that can evolve outside the subagents

The goal is to let a product manager open a project, install the system once, and start working directly with Claude.

## Main Goal

Build a reusable operating system that helps a product manager:

- turn messy notes into structured product thinking
- generate and revise PRDs
- plan features safely before code
- implement with Claude Code without losing context
- keep product memory updated when development changes mid-flight
- review work through functional testing steps
- maintain changelogs
- sync updates back to Myte

## Product Philosophy

This is a PM-first system.

Claude should:

- speak in functional product language by default
- focus on user behavior, workflows, screens, touchpoints, and outcomes
- avoid pushing technical decision-making to the user during normal work
- escalate technical details only when the risk is high

High-risk escalation includes:

- major DB or migration changes
- API contract changes
- auth or permission changes
- backward compatibility risks
- possible data loss or corruption
- major workflow-breaking changes

When escalation is needed, Claude should explain it in product terms.

## Shared Sources Of Truth

### `MyteCommandCenter/`

Project truth synced from Myte, including:

- missions
- phases
- epics
- stories
- QA/QC context
- feedback and PRD-related context

### `product-planning/`

The shared product workspace for everything strategic and execution-adjacent, including:

- brainstorms
- audits
- proposals
- PRDs
- diagrams
- implementation plans
- feedback notes
- handoff summaries
- decision logs
- `product-specs.md`

### `product-specs.md`

This is the living product record of what is actually implemented or currently in progress.

Important distinction:

- PRD = intended behavior
- `product-specs.md` = implemented or in-progress behavior

If development changes the feature, `product-specs.md` must be updated.

## Planned Roles

The system is built around separate Claude subagents.

### `product-strategy`

Uses messy inputs to produce structured product artifacts.

Owns:

- brainstorming
- PRD generation
- PRD revision after feedback
- proposals
- audits
- diagrams
- epic and functional task breakdown when needed

### `implementation-planner`

Turns approved product intent into a safe delivery plan.

Owns:

- attack surface analysis
- touched workflows and screens
- implementation phases
- risk detection
- rollout thinking

### `implementor`

Executes approved work and keeps reality documented.

Owns:

- coding from approved context
- updating `product-specs.md`
- maintaining area changelogs
- giving PM-friendly test handoff after implementation

### `feature-qa`

Explains how to validate finished work functionally.

Owns:

- step-by-step test flows
- expected behavior
- edge cases
- regression checks

### `myte-sync`

Keeps local work aligned with project state in Myte.

Owns:

- reading `MyteCommandCenter/`
- routing plain-English intent to valid Myte commands
- running full Myte flows (config/bootstrap/query/QAQC/feedback/suggestions/updates/PRD upload)
- preparing Myte-ready updates when needed

## Working Rules

- brainstorm before PRD when the idea is still unclear
- treat PRDs as handoff documents, not discussion dumps
- separate layers explicitly
- avoid semantic duplication
- ask the PM about workflows and outcomes, not low-level implementation
- require visibility before destructive changes
- keep backlog as a real scope boundary
- maintain changelogs as part of the workflow

## Prompt Library

This project should also include a prompt library for reusable prompts outside the subagents.

That library is useful for:

- messy-note brainstorming
- PRD generation
- PRD revision after feedback
- implementation planning
- PM-friendly QA handoff
- Myte update drafting
- extracting working style from old collaboration examples

## Planned Project Structure

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
  LLM_RELIABILITY_PLAYBOOK.md
  MYTE_PROJECT_API.md
  QUALITY_EVAL_SCORECARD_TEMPLATE.md
  SYSTEM_BLUEPRINT.md
  WORKING_STYLE_PATTERN.md
  WORKING_STYLE_RULES.md
  RELEASE.md
prompts/
  PROMPT_LIBRARY.md
  MYTE_AGENT_QUICK_PROMPT.md
  MYTE_INSTRUCTION_UPDATE_PROMPT.md
README.md
```

## Packaging Direction

The long-term package should include:

- reusable Claude subagents
- a base `CLAUDE.md`
- `product-planning/` scaffolding
- prompt library
- changelog guidance
- optional Myte-aware setup
- installer script

## Installer Goal

Target setup flow:

1. clone or open project
2. run one install command
3. start using Claude directly

The installer should eventually:

- create `.claude/agents/`
- create or extend `CLAUDE.md`
- create `product-planning/`
- create `product-planning/product-specs.md`
- install prompt library and templates
- support `MyteCommandCenter/` when present

## Installer (v1)

Script:

- `./install.sh`

Usage:

```bash
# Install into current directory
./install.sh

# Install into a target repo path
./install.sh --target /path/to/repo

# Preview actions only
./install.sh --target /path/to/repo --dry-run

# Overwrite existing files
./install.sh --target /path/to/repo --force

# Update toolkit-managed files only (do not touch product-planning scaffold)
./install.sh --target /path/to/repo --update --force
```

Current installer behavior:

- installs full `docs/` tree
- installs full `prompts/` tree
- installs subagents into `.claude/agents/`
- installs `product-planning/` scaffold
- skips existing files by default unless `--force` is used
- changelog file creation remains manual per project naming conventions
- `--update` mode skips `product-planning/` scaffold so existing planning docs are preserved

## Private GitHub Install

For a private repo, users must already have GitHub access (SSH key or authenticated HTTPS).

Option A (recommended one-liner from any target project directory):

```bash
tmp="$(mktemp -d)" && \
git clone --depth 1 --branch main git@github.com:toumiamine07/claude-skills---toumi.git "$tmp/toolkit" && \
"$tmp/toolkit/install.sh" --target "$PWD" && \
rm -rf "$tmp"
```

Update existing project to latest toolkit (preserve planning docs):

```bash
tmp="$(mktemp -d)" && \
git clone --depth 1 --branch main git@github.com:toumiamine07/claude-skills---toumi.git "$tmp/toolkit" && \
"$tmp/toolkit/install.sh" --target "$PWD" --update --force && \
rm -rf "$tmp"
```

Preview update only:

```bash
tmp="$(mktemp -d)" && \
git clone --depth 1 --branch main git@github.com:toumiamine07/claude-skills---toumi.git "$tmp/toolkit" && \
"$tmp/toolkit/install.sh" --target "$PWD" --update --dry-run && \
rm -rf "$tmp"
```

Install a tagged version:

```bash
tmp="$(mktemp -d)" && \
git clone --depth 1 --branch v0.1.0 git@github.com:toumiamine07/claude-skills---toumi.git "$tmp/toolkit" && \
"$tmp/toolkit/install.sh" --target "$PWD" && \
rm -rf "$tmp"
```

Option B (using local bootstrap helper from this toolkit):

```bash
./bootstrap.sh --repo git@github.com:toumiamine07/claude-skills---toumi.git --ref main --target /path/to/project
```

Useful flags:

- `--dry-run` to preview
- `--force` to overwrite existing files

## Files In This Repo

- `README.md`: high-level project overview
- `docs/SYSTEM_BLUEPRINT.md`: detailed operating model
- `docs/WORKING_STYLE_PATTERN.md`: rough observed pattern draft
- `docs/WORKING_STYLE_RULES.md`: extracted actionable rules from the pattern draft
- `docs/MYTE_PROJECT_API.md`: Myte API and CLI reference
- `docs/RELEASE.md`: release and tagging flow
- `docs/LLM_RELIABILITY_PLAYBOOK.md`: context/retrieval/eval hardening model
- `docs/QUALITY_EVAL_SCORECARD_TEMPLATE.md`: repeatable scoring template for quality checks
- `prompts/PROMPT_LIBRARY.md`: reusable prompts outside the subagents
- `prompts/MYTE_AGENT_QUICK_PROMPT.md`: plain-English Myte command router prompt
- `prompts/MYTE_INSTRUCTION_UPDATE_PROMPT.md`: Myte instruction refresh prompt
- `prompts/ENABLE_CHANGELOG_AUTOMATION_PROMPT.md`: setup prompt for per-commit + daily changelog automation
- `install.sh`: installer script for applying this system to a project
- `bootstrap.sh`: helper that clones toolkit repo and runs installer into a target path
- `scripts/sync_changelogs.sh`: sync/append backend/frontend changelogs from commits
- `scripts/install_post_commit_hook.sh`: installs git post-commit hook for automatic changelog updates
