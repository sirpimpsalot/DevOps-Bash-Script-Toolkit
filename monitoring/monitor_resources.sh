#!/usr/bin/env bash
# monitor_resources.sh - Monitor system resources and alert on thresholds
#
# Usage: monitor_resources.sh [--cpu <percent>] [--mem <percent>] [--disk <percent>] [--help]
#
# Options:
#   --cpu         CPU usage threshold (default: 80)
#   --mem         Memory usage threshold (default: 80)
#   --disk        Disk usage threshold (default: 80)
#   -h, --help    Show this help message

set -euo pipefail

show_help() {
  grep '^#' "$0" | cut -c 3-
}

CPU_THR=80
MEM_THR=80
DISK_THR=80

while [[ $# -gt 0 ]]; do
  case "$1" in
    --cpu)
      CPU_THR="$2"; shift 2;;
    --mem)
      MEM_THR="$2"; shift 2;;
    --disk)
      DISK_THR="$2"; shift 2;;
    -h|--help)
      show_help; exit 0;;
    *)
      echo "Unknown option: $1"; show_help; exit 1;;
  esac
  done

CPU_USAGE=$(top -l 1 | grep "CPU usage" | awk '{print $3}' | sed 's/%//')
MEM_USAGE=$(vm_stat | grep "Pages active" | awk '{print $3}' | sed 's/\.//')
DISK_USAGE=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')

if [[ "$CPU_USAGE" -ge "$CPU_THR" ]]; then
  echo "[ALERT] CPU usage is at $CPU_USAGE% (threshold: $CPU_THR%)"
fi
if [[ "$MEM_USAGE" -ge "$MEM_THR" ]]; then
  echo "[ALERT] Memory usage is at $MEM_USAGE% (threshold: $MEM_THR%)"
fi
if [[ "$DISK_USAGE" -ge "$DISK_THR" ]]; then
  echo "[ALERT] Disk usage is at $DISK_USAGE% (threshold: $DISK_THR%)"
fi

echo "[INFO] Resource monitoring complete."
