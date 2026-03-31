#!/usr/bin/env bash
set -euo pipefail

REPO_URL=""
REF="main"
TARGET_DIR="."
DRY_RUN=0
FORCE=0
KEEP_TEMP=0

print_usage() {
  cat <<'EOF'
Claude Product System Bootstrap

Clones a toolkit repo from GitHub (including private repos you can access)
and runs its install.sh into a target project path.

Usage:
  ./bootstrap.sh --repo <git-url> [--ref <tag-or-branch>] [--target <path>] [--dry-run] [--force] [--keep-temp]

Options:
  --repo <git-url>      Git URL (for example: git@github.com:org/repo.git)
  --ref <name>          Branch or tag to install from (default: main)
  --target <path>       Project path to install into (default: current directory)
  --dry-run             Preview install actions only
  --force               Overwrite existing files in target path
  --keep-temp           Keep the temporary cloned repo for debugging
  --help                Show this help text
EOF
}

log() {
  printf '%s\n' "$*"
}

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
    --repo)
      if [[ $# -lt 2 ]]; then
        log "error: --repo requires a value"
        exit 1
      fi
      REPO_URL="$2"
      shift 2
      ;;
    --ref)
      if [[ $# -lt 2 ]]; then
        log "error: --ref requires a value"
        exit 1
      fi
      REF="$2"
      shift 2
      ;;
    --target)
      if [[ $# -lt 2 ]]; then
        log "error: --target requires a value"
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
    --keep-temp)
      KEEP_TEMP=1
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

require_git() {
  if ! command -v git >/dev/null 2>&1; then
    log "error: git is required"
    exit 1
  fi
}

main() {
  parse_args "$@"
  require_git

  if [[ -z "$REPO_URL" ]]; then
    log "error: --repo is required"
    print_usage
    exit 1
  fi

  local tmp_dir
  tmp_dir="$(mktemp -d)"
  local clone_dir="$tmp_dir/toolkit"

  if [[ "$KEEP_TEMP" -ne 1 ]]; then
    trap 'rm -rf "$tmp_dir"' EXIT
  fi

  log "repo: $REPO_URL"
  log "ref: $REF"
  log "target: $TARGET_DIR"

  log "cloning toolkit..."
  git clone --depth 1 --branch "$REF" "$REPO_URL" "$clone_dir"

  if [[ ! -x "$clone_dir/install.sh" ]]; then
    chmod +x "$clone_dir/install.sh"
  fi

  local cmd=("$clone_dir/install.sh" "--target" "$TARGET_DIR")
  if [[ "$DRY_RUN" -eq 1 ]]; then
    cmd+=("--dry-run")
  fi
  if [[ "$FORCE" -eq 1 ]]; then
    cmd+=("--force")
  fi

  log "running installer..."
  "${cmd[@]}"

  if [[ "$KEEP_TEMP" -eq 1 ]]; then
    log "temp kept at: $tmp_dir"
  fi
}

main "$@"

