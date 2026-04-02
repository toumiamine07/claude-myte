#!/usr/bin/env bash
set -euo pipefail

AREAS_CSV="backend,frontend"
STATE_FILE=".changelog-sync-state"
QUIET=0
DRY_RUN=0
BOOTSTRAP_ALL=0

print_usage() {
  cat <<'EOF'
Sync area changelogs from git commits.

Usage:
  ./scripts/sync_changelogs.sh [--areas backend,frontend] [--state-file .changelog-sync-state] [--bootstrap-all] [--dry-run] [--quiet]

Options:
  --areas <csv>       Comma-separated area folders (default: backend,frontend)
  --state-file <path> State file path (default: .changelog-sync-state)
  --bootstrap-all     On first run, backfill all commits (default first run: latest commit only)
  --dry-run           Show actions without writing files
  --quiet             Minimal output
  --help              Show this help
EOF
}

log() {
  if [[ "$QUIET" -ne 1 ]]; then
    printf '%s\n' "$*"
  fi
}

run_cmd() {
  if [[ "$DRY_RUN" -eq 1 ]]; then
    log "[dry-run] $*"
    return 0
  fi
  "$@"
}

append_line() {
  local line="$1"
  local file="$2"
  if [[ "$DRY_RUN" -eq 1 ]]; then
    log "[dry-run] append to $file: $line"
    return 0
  fi
  printf '%s\n' "$line" >>"$file"
}

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
    --areas)
      if [[ $# -lt 2 ]]; then
        echo "error: --areas requires a value" >&2
        exit 1
      fi
      AREAS_CSV="$2"
      shift 2
      ;;
    --state-file)
      if [[ $# -lt 2 ]]; then
        echo "error: --state-file requires a value" >&2
        exit 1
      fi
      STATE_FILE="$2"
      shift 2
      ;;
    --bootstrap-all)
      BOOTSTRAP_ALL=1
      shift
      ;;
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    --quiet)
      QUIET=1
      shift
      ;;
    --help)
      print_usage
      exit 0
      ;;
    *)
      echo "error: unknown argument '$1'" >&2
      print_usage
      exit 1
      ;;
    esac
  done
}

ensure_changelog_file() {
  local area="$1"
  local path="$area/CHANGELOG.md"

  run_cmd mkdir -p "$area"

  if [[ -f "$path" ]]; then
    return 0
  fi

  if [[ "$DRY_RUN" -eq 1 ]]; then
    log "[dry-run] create $path"
    return 0
  fi

  cat >"$path" <<EOF
# ${area} Changelog

Tracks product-facing changes for the ${area} area.

## Entry Template

### YYYY-MM-DD HH:MM - <commit-sha>

- Change: <short title>
- Functional impact: <what changed for users/workflow>
- Risk notes: <optional>
EOF
  log "created: $path"
}

main() {
  parse_args "$@"

  if ! git_root="$(git rev-parse --show-toplevel 2>/dev/null)"; then
    echo "error: not inside a git repository" >&2
    exit 1
  fi
  cd "$git_root"

  if ! git rev-parse --verify HEAD >/dev/null 2>&1; then
    echo "error: repository has no commits yet" >&2
    exit 1
  fi

  IFS=',' read -r -a areas <<<"$AREAS_CSV"
  if [[ "${#areas[@]}" -eq 0 ]]; then
    echo "error: no areas configured" >&2
    exit 1
  fi

  for i in "${!areas[@]}"; do
    areas[$i]="${areas[$i]// /}"
    if [[ -z "${areas[$i]}" ]]; then
      echo "error: empty area name in --areas value" >&2
      exit 1
    fi
    ensure_changelog_file "${areas[$i]}"
  done

  local last_synced=""
  if [[ -f "$STATE_FILE" ]]; then
    last_synced="$(<"$STATE_FILE")"
    if ! git cat-file -e "$last_synced^{commit}" 2>/dev/null; then
      log "warning: state commit not found, resetting sync state"
      last_synced=""
    fi
  fi

  local commits=()
  if [[ -z "$last_synced" ]]; then
    if [[ "$BOOTSTRAP_ALL" -eq 1 ]]; then
      while IFS= read -r sha; do
        commits+=("$sha")
      done < <(git rev-list --reverse HEAD)
      log "first run: backfilling full history"
    else
      commits+=("$(git rev-parse HEAD)")
      log "first run: syncing latest commit only (use --bootstrap-all to backfill history)"
    fi
  else
    while IFS= read -r sha; do
      commits+=("$sha")
    done < <(git rev-list --reverse "${last_synced}..HEAD")
  fi

  if [[ "${#commits[@]}" -eq 0 ]]; then
    log "no new commits to sync"
    exit 0
  fi

  for sha in "${commits[@]}"; do
    local short_sha subject date
    short_sha="$(git rev-parse --short "$sha")"
    subject="$(git show -s --format=%s "$sha")"
    date="$(git show -s --date=format:'%Y-%m-%d %H:%M' --format=%cd "$sha")"
    local changed_files
    changed_files="$(git diff-tree --no-commit-id --name-only -r "$sha")"

    for area in "${areas[@]}"; do
      local area_hits area_file_count
      area_hits="$(printf '%s\n' "$changed_files" | rg "^${area}/" || true)"
      if [[ -z "$area_hits" ]]; then
        continue
      fi

      area_file_count="$(printf '%s\n' "$area_hits" | sed '/^$/d' | wc -l | tr -d ' ')"
      local changelog_path="$area/CHANGELOG.md"

      append_line "" "$changelog_path"
      append_line "### ${date} - ${short_sha}" "$changelog_path"
      append_line "- Change: ${subject}" "$changelog_path"
      append_line "- Functional impact: ${area_file_count} file(s) touched under ${area}/" "$changelog_path"
      append_line "- Risk notes: review regressions in touched ${area} workflows" "$changelog_path"
      log "updated: $changelog_path <- $short_sha"
    done
  done

  if [[ "$DRY_RUN" -eq 1 ]]; then
    log "[dry-run] would update state file: $STATE_FILE -> $(git rev-parse HEAD)"
  else
    printf '%s\n' "$(git rev-parse HEAD)" >"$STATE_FILE"
    log "state updated: $STATE_FILE"
  fi

  log "changelog sync complete"
}

main "$@"

