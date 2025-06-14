#!/usr/bin/env bash
# docker_cleanup.sh - Clean up Docker resources safely
#
# Usage: docker_cleanup.sh [--prune] [--volumes] [--help]
#
# Options:
#   --prune         Run docker system prune (remove unused data)
#   --volumes       Remove dangling volumes
#   -h, --help      Show this help message

set -euo pipefail

show_help() {
  grep '^#' "$0" | cut -c 3-
}

PRUNE="false"
VOLUMES="false"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --prune)
      PRUNE="true"; shift;;
    --volumes)
      VOLUMES="true"; shift;;
    -h|--help)
      show_help; exit 0;;
    *)
      echo "Unknown option: $1"; show_help; exit 1;;
  esac
  done

if [[ "$PRUNE" == "true" ]]; then
  echo "[INFO] Running: docker system prune -f"
  docker system prune -f
fi

if [[ "$VOLUMES" == "true" ]]; then
  echo "[INFO] Removing dangling volumes"
  docker volume prune -f
fi

echo "[SUCCESS] Docker cleanup complete."
