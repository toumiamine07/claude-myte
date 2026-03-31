# Claude Product System

Reusable Claude Code package for product managers and builders.

This project is meant to become a GitHub package plus installer that can be dropped into a new or existing project so Claude can support product strategy, PRDs, planning, implementation, QA, changelogs, and Myte sync in one consistent workflow.

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
- preparing Myte-ready updates
- supporting PRD and QA/QC sync flows

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
PROMPT_LIBRARY.md
WORKING_STYLE_PATTERN.md
WORKING_STYLE_RULES.md
SYSTEM_BLUEPRINT.md
MYTE_PROJECT_API.md
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
```

Current installer behavior:

- installs core docs and prompt files
- installs subagents into `.claude/agents/`
- installs `product-planning/` scaffold
- skips existing files by default unless `--force` is used
- changelog file creation remains manual per project naming conventions

## Private GitHub Install

For a private repo, users must already have GitHub access (SSH key or authenticated HTTPS).

Option A (recommended one-liner from any target project directory):

```bash
tmp="$(mktemp -d)" && \
git clone --depth 1 --branch main git@github.com:<owner>/<repo>.git "$tmp/toolkit" && \
"$tmp/toolkit/install.sh" --target "$PWD" && \
rm -rf "$tmp"
```

Install a tagged version:

```bash
tmp="$(mktemp -d)" && \
git clone --depth 1 --branch v0.1.0 git@github.com:<owner>/<repo>.git "$tmp/toolkit" && \
"$tmp/toolkit/install.sh" --target "$PWD" && \
rm -rf "$tmp"
```

Option B (using local bootstrap helper from this toolkit):

```bash
./bootstrap.sh --repo git@github.com:<owner>/<repo>.git --ref main --target /path/to/project
```

Useful flags:

- `--dry-run` to preview
- `--force` to overwrite existing files

## Files In This Repo

- `README.md`: high-level project overview
- `SYSTEM_BLUEPRINT.md`: detailed operating model
- `WORKING_STYLE_PATTERN.md`: rough observed pattern draft
- `WORKING_STYLE_RULES.md`: extracted actionable rules from the pattern draft
- `PROMPT_LIBRARY.md`: reusable prompts outside the subagents
- `MYTE_PROJECT_API.md`: Myte API and CLI reference
- `install.sh`: installer script for applying this system to a project
