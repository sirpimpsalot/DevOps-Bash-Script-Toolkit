#!/usr/bin/env bash
# k8s_cleanup.sh - Clean up completed/failed jobs and unused pods in a namespace
#
# Usage: k8s_cleanup.sh [-n|--namespace <namespace>] [--age <hours>] [--help]
#
# Options:
#   -n, --namespace     Kubernetes namespace (default: default)
#   --age               Age threshold in hours (default: 24)
#   -h, --help          Show this help message

set -euo pipefail

show_help() {
  grep '^#' "$0" | cut -c 3-
}

NAMESPACE="default"
AGE=24

while [[ $# -gt 0 ]]; do
  case "$1" in
    -n|--namespace)
      NAMESPACE="$2"; shift 2;;
    --age)
      AGE="$2"; shift 2;;
    -h|--help)
      show_help; exit 0;;
    *)
      echo "Unknown option: $1"; show_help; exit 1;;
  esac
  done

# Clean up jobs
kubectl -n "$NAMESPACE" delete job $(kubectl -n "$NAMESPACE" get jobs --field-selector status.successful=1 --no-headers | awk '{print $1}') 2>/dev/null || true
# Clean up pods older than AGE hours
kubectl -n "$NAMESPACE" get pods --no-headers | awk -v age="$AGE" '{if ($5 ~ /[0-9]+h/ && int($5) >= age) print $1}' | xargs -r kubectl -n "$NAMESPACE" delete pod

echo "[SUCCESS] Cleanup complete in namespace $NAMESPACE."
