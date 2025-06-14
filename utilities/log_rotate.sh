#!/usr/bin/env bash
# log_rotate.sh - Rotate and compress logs by size or age
#
# Usage: log_rotate.sh -f <log_file> [-s <size_mb>] [-a <age_days>] [--help]
#
# Options:
#   -f, --file         Log file to rotate (required)
#   -s, --size         Rotate if larger than size in MB (optional)
#   -a, --age          Rotate if older than age in days (optional)
#   -h, --help         Show this help message

set -euo pipefail

show_help() {
  grep '^#' "$0" | cut -c 3-
}

LOG_FILE=""
SIZE_MB=""
AGE_DAYS=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    -f|--file)
      LOG_FILE="$2"; shift 2;;
    -s|--size)
      SIZE_MB="$2"; shift 2;;
    -a|--age)
      AGE_DAYS="$2"; shift 2;;
    -h|--help)
      show_help; exit 0;;
    *)
      echo "Unknown option: $1"; show_help; exit 1;;
  esac
  done

if [[ -z "$LOG_FILE" ]]; then
  echo "[ERROR] Log file is required."; show_help; exit 1
fi

should_rotate=false
if [[ -n "$SIZE_MB" ]]; then
  actual_size=$(du -m "$LOG_FILE" | cut -f1)
  if (( actual_size >= SIZE_MB )); then
    should_rotate=true
  fi
fi
if [[ -n "$AGE_DAYS" ]]; then
  file_age=$(( ( $(date +%s) - $(stat -f %m "$LOG_FILE") ) / 86400 ))
  if (( file_age >= AGE_DAYS )); then
    should_rotate=true
  fi
fi
if [[ "$should_rotate" == true ]]; then
  gzip -c "$LOG_FILE" > "$LOG_FILE.$(date +%Y%m%d%H%M%S).gz"
  : > "$LOG_FILE"
  echo "[INFO] Rotated and compressed $LOG_FILE"
else
  echo "[INFO] No rotation needed for $LOG_FILE"
fi
