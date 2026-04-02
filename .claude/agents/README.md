# Claude Subagents

This folder contains role-specific subagents for the Claude Product System.

## Files

- `product-strategy.md`
- `implementation-planner.md`
- `implementor.md`
- `feature-qa.md`
- `myte-sync.md`

## Usage

In Claude Code chat, call explicitly when needed, for example:

- "Use product-strategy to turn these messy notes into a PRD."
- "Use implementation-planner for a phased plan and risk map."
- "Use implementor to execute this approved plan."
- "Use feature-qa to generate PM test steps and edge cases."
- "Use myte-sync to run Myte operations from this request."

Subagents can also be auto-selected if task descriptions match their role descriptions.

Across all subagents, use the same preflight discipline:

1. classify the task
2. build a minimal context set
3. flag missing/conflicting context before final output
