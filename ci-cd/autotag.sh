#!/usr/bin/env bash
# autotag.sh - Semantic version auto-tagging based on commit messages
#
# This script automates semantic versioning for your repository:
# - Determines the latest tag and inspects commit messages since that tag
# - Increments major, minor, or patch version based on commit content
#   - 'BREAKING CHANGE' in commit: major
#   - 'feat:' in commit: minor
#   - 'fix:' in commit: patch
# - Supports a dry-run mode to preview the next tag
# - Designed for use in CI/CD pipelines or release automation
#
# Usage: autotag.sh [--dry-run] [--help]
#
# Options:
#   --dry-run     Show what would be tagged, but do not create tag
#   -h, --help    Show this help message

set -euo pipefail  # Exit on error, unset variable, or failed pipe

# Print help message by extracting comments from the script
show_help() {
  grep '^#' "$0" | cut -c 3-
}

DRY_RUN="false"  # Whether to only preview the tag

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)
      DRY_RUN="true"; shift;;    # Enable dry-run mode
    -h|--help)
      show_help; exit 0;;         # Show help and exit
    *)
      echo "Unknown option: $1"; show_help; exit 1;;  # Handle unknown options
  esac
  done

# Get the latest tag, or default to 0.0.0 if none exists
LATEST_TAG=$(git describe --tags --abbrev=0 2>/dev/null || echo "0.0.0")
# Get commit messages since the latest tag
COMMITS=$(git log ${LATEST_TAG}..HEAD --oneline)

# Parse the latest tag into major, minor, patch
MAJOR=0; MINOR=0; PATCH=0
IFS='.' read -r MAJOR MINOR PATCH <<< "$LATEST_TAG"

# Inspect commit messages to determine which version part to increment
for c in $COMMITS; do
  if [[ "$c" == *"BREAKING CHANGE"* ]]; then
    ((MAJOR++)); MINOR=0; PATCH=0  # Major bump resets minor/patch
  elif [[ "$c" == feat:* ]]; then
    ((MINOR++)); PATCH=0           # Minor bump resets patch
  elif [[ "$c" == fix:* ]]; then
    ((PATCH++))                    # Patch bump
  fi
  break  # Only the first relevant commit determines the bump
fi

target_tag="$MAJOR.$MINOR.$PATCH"  # Construct the new tag
if [[ "$DRY_RUN" == "true" ]]; then
  echo "[DRY RUN] Would tag: $target_tag"
else
  git tag "$target_tag"
  echo "[INFO] Created tag: $target_tag"
fi
