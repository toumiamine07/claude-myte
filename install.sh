#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_ROOT="$SCRIPT_DIR"

TARGET_DIR="."
DRY_RUN=0
FORCE=0
UPDATE_MODE=0

print_usage() {
  cat <<'EOF'
Claude Product System Installer

Usage:
  ./install.sh [--target PATH] [--dry-run] [--force] [--update] [--help]

Options:
  --target PATH  Install into PATH (default: current directory)
  --dry-run      Print planned actions without writing files
  --force        Overwrite existing files
  --update       Update toolkit-managed files only (skip product-planning scaffold)
  --help         Show this help text
EOF
}

log() {
  printf '%s\n' "$*"
}

run_cmd() {
  if [[ "$DRY_RUN" -eq 1 ]]; then
    log "[dry-run] $*"
    return 0
  fi
  "$@"
}

ensure_parent_dir() {
  local file_path="$1"
  local dir_path
  dir_path="$(dirname "$file_path")"
  run_cmd mkdir -p "$dir_path"
}

copy_file() {
  local source_file="$1"
  local relative_target="$2"
  local dest_file="$TARGET_DIR/$relative_target"

  if [[ -e "$dest_file" && "$FORCE" -ne 1 ]]; then
    log "skip (exists): $relative_target"
    return 0
  fi

  ensure_parent_dir "$dest_file"
  run_cmd cp "$source_file" "$dest_file"
  log "install: $relative_target"
}

copy_tree_files() {
  local relative_tree="$1"
  local source_tree="$SOURCE_ROOT/$relative_tree"

  if [[ ! -d "$source_tree" ]]; then
    log "skip (missing source tree): $relative_tree"
    return 0
  fi

  while IFS= read -r -d '' source_file; do
    local rel_path
    rel_path="${source_file#$SOURCE_ROOT/}"
    copy_file "$source_file" "$rel_path"
  done < <(find "$source_tree" -type f -print0 | sort -z)
}

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
    --target)
      if [[ $# -lt 2 ]]; then
        log "error: --target requires a path"
        exit 1
      fi
      TARGET_DIR="$2"
      shift 2
      ;;
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    --force)
      FORCE=1
      shift
      ;;
    --update)
      UPDATE_MODE=1
      shift
      ;;
    --help)
      print_usage
      exit 0
      ;;
    *)
      log "error: unknown argument '$1'"
      print_usage
      exit 1
      ;;
    esac
  done
}

main() {
  parse_args "$@"

  if [[ "$DRY_RUN" -eq 0 ]]; then
    mkdir -p "$TARGET_DIR"
  fi

  log "source: $SOURCE_ROOT"
  log "target: $TARGET_DIR"
  if [[ "$DRY_RUN" -eq 1 ]]; then
    log "mode: dry-run"
  fi
  if [[ "$FORCE" -eq 1 ]]; then
    log "mode: force overwrite enabled"
  fi
  if [[ "$UPDATE_MODE" -eq 1 ]]; then
    log "mode: update (product-planning scaffold skipped)"
  fi

  # Core contract
  copy_file "$SOURCE_ROOT/CLAUDE.md" "CLAUDE.md"

  # Toolkit trees (auto-pick new docs/prompts without editing installer)
  copy_tree_files "docs"
  copy_tree_files "prompts"
  copy_tree_files ".claude/agents"

  # Workspace scaffold
  if [[ "$UPDATE_MODE" -eq 0 ]]; then
    copy_tree_files "product-planning"
  else
    log "skip: product-planning scaffold (update mode)"
  fi

  log "install complete."
}

main "$@"
