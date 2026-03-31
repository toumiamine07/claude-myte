# Myte Instruction Refresh Prompt

```text
Myte has changed. Refresh this project's Myte instruction system.

Inputs to use:
- Existing `MYTE_PROJECT_API.md`
- Any new Myte release notes/changelog/text I provide in this chat
- Current files that depend on Myte behavior (at least: `CLAUDE.md`, `.claude/agents/myte-sync.md`, `PROMPT_LIBRARY.md`, `README.md`, `SYSTEM_BLUEPRINT.md`)

Your tasks:

1. Compare old vs new Myte behavior
2. List exactly what changed (commands, flags, limits, endpoints, flow, auth/env requirements, outputs)
3. Propose required doc/rule updates file-by-file
4. Apply the updates directly to project docs and subagent instructions
5. Keep command guidance strict:
   - use documented commands only
   - remove deprecated/invalid commands
   - add new supported commands
6. Add a short "What Changed" summary section to `MYTE_PROJECT_API.md` with date and key deltas
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
