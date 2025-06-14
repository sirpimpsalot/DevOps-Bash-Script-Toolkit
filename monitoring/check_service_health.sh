#!/usr/bin/env bash
# check_service_health.sh - Check service/process health and port availability
#
# Usage: check_service_health.sh -s <service> [-p <port>] [--help]
#
# Options:
#   -s, --service      Service/process name (required)
#   -p, --port         Port to check (optional)
#   -h, --help         Show this help message

set -euo pipefail

show_help() {
  grep '^#' "$0" | cut -c 3-
}

SERVICE=""
PORT=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    -s|--service)
      SERVICE="$2"; shift 2;;
    -p|--port)
      PORT="$2"; shift 2;;
    -h|--help)
      show_help; exit 0;;
    *)
      echo "Unknown option: $1"; show_help; exit 1;;
  esac
  done

if [[ -z "$SERVICE" ]]; then
  echo "[ERROR] Service name is required."; show_help; exit 1
fi

if pgrep -x "$SERVICE" > /dev/null; then
  echo "[OK] Service $SERVICE is running."
else
  echo "[FAIL] Service $SERVICE is not running."
fi

if [[ -n "$PORT" ]]; then
  if nc -z 127.0.0.1 "$PORT"; then
    echo "[OK] Port $PORT is open."
  else
    echo "[FAIL] Port $PORT is not open."
  fi
fi
