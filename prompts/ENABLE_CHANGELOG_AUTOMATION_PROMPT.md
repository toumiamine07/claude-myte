# Enable Changelog Automation Prompt

```text
Enable changelog automation in this project.

Goals:
1. Ensure changelog files exist and are maintained for backend/frontend areas.
2. Update changelog automatically after each commit.
3. Add daily end-of-day sync as a safety net.

Required process:
1. Verify `scripts/sync_changelogs.sh` and `scripts/install_post_commit_hook.sh` exist.
2. Run a dry-run changelog sync and show expected updates.
3. Install git post-commit hook.
4. Add cron entry for daily sync at 23:00 local time.
5. Return:
   - commands executed
   - hook status
   - cron status
   - files created/updated
```
