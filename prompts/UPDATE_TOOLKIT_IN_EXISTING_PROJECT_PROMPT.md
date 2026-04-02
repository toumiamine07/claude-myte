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
- Detect installer capability first:
  - if `--update` exists, use update flow
  - if `--update` is missing, use compatibility fallback (backup + force + restore)

Required process:
1. Check installer flags (`install.sh --help`) and confirm whether `--update` exists.
2. If `--update` exists:
   - run dry-run: `install.sh --update --dry-run`
   - show planned changes
   - ask for confirmation
   - apply: `install.sh --update --force`
3. If `--update` is missing:
   - create backup folder: `migration-backup/<timestamp>/`
   - backup `product-planning/`
   - run dry-run with force: `install.sh --dry-run --force`
   - show planned overwrite
   - ask for confirmation
   - apply: `install.sh --force`
   - restore backed up `product-planning/` content
4. Return summary:
   - files updated
   - files skipped
   - any merge risk
   - recommended validation checks
```
