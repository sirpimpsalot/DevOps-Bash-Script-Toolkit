#!/usr/bin/env bash
# autotag.sh - Semantic version auto-tagging based on commit messages
#
# Usage: autotag.sh [--dry-run] [--help]
#
# Options:
#   --dry-run     Show what would be tagged, but do not create tag
#   -h, --help    Show this help message

set -euo pipefail

show_help() {
  grep '^#' "$0" | cut -c 3-
}

DRY_RUN="false"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)
      DRY_RUN="true"; shift;;
    -h|--help)
      show_help; exit 0;;
    *)
      echo "Unknown option: $1"; show_help; exit 1;;
  esac
  done

LATEST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "0.0.0")
COMMITS=$(git log ${LATEST_TAG}..HEAD --oneline)

MAJOR=0; MINOR=0; PATCH=0
IFS='.' read -r MAJOR MINOR PATCH <<< "$LATEST_TAG"

for c in $COMMITS; do
  if [[ "$c" == *"BREAKING CHANGE"* ]]; then
    ((MAJOR++)); MINOR=0; PATCH=0
  elif [[ "$c" == feat:* ]]; then
    ((MINOR++)); PATCH=0
  elif [[ "$c" == fix:* ]]; then
    ((PATCH++))
  fi
  break
fi

target_tag="$MAJOR.$MINOR.$PATCH"
if [[ "$DRY_RUN" == "true" ]]; then
  echo "[DRY RUN] Would tag: $target_tag"
else
  git tag "$target_tag"
  echo "[INFO] Created tag: $target_tag"
fi
