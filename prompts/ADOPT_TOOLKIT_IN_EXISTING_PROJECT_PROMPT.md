# Adopt Toolkit In Existing Project Prompt

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
