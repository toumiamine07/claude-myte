# Update Toolkit In Existing Project Prompt

```text
Update this existing project to the latest Claude Product System toolkit version.

Toolkit repo:
- git@github.com:toumiamine07/claude-skills---toumi.git
- branch/tag: <main or version tag>

Update rules:
- Keep existing `product-planning/` content intact.
- Update toolkit-managed files only (CLAUDE rules, subagents, prompts, docs/rules files).
- Run a dry-run first, then apply update.

Required process:
1. Run dry-run update:
   - install.sh --update --dry-run
2. Show planned file changes.
3. Ask for confirmation.
4. Apply update:
   - install.sh --update --force
5. Return summary:
   - files updated
   - files skipped
   - any merge risk
   - recommended validation checks
```
