#!/usr/bin/env bash
set -euo pipefail

if ! repo_root="$(git rev-parse --show-toplevel 2>/dev/null)"; then
  echo "error: run this inside a git repository" >&2
  exit 1
fi

hook_path="$repo_root/.git/hooks/post-commit"

cat >"$hook_path" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

repo_root="$(git rev-parse --show-toplevel)"
sync_script="$repo_root/scripts/sync_changelogs.sh"

if [[ -x "$sync_script" ]]; then
  "$sync_script" --quiet || true
fi
EOF

chmod +x "$hook_path"
echo "installed git hook: $hook_path"
echo "post-commit now runs: scripts/sync_changelogs.sh --quiet"

