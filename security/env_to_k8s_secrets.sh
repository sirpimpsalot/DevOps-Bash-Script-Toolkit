#!/usr/bin/env bash
# env_to_k8s_secrets.sh - Convert .env file to Kubernetes secrets
#
# Usage: env_to_k8s_secrets.sh -f <env_file> -n <namespace> -s <secret_name> [--help]
#
# Options:
#   -f, --file         Path to .env file (required)
#   -n, --namespace    Kubernetes namespace (required)
#   -s, --secret       Secret name (required)
#   -h, --help         Show this help message

set -euo pipefail

show_help() {
  grep '^#' "$0" | cut -c 3-
}

ENV_FILE=""
NAMESPACE=""
SECRET=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    -f|--file)
      ENV_FILE="$2"; shift 2;;
    -n|--namespace)
      NAMESPACE="$2"; shift 2;;
    -s|--secret)
      SECRET="$2"; shift 2;;
    -h|--help)
      show_help; exit 0;;
    *)
      echo "Unknown option: $1"; show_help; exit 1;;
  esac
  done

if [[ -z "$ENV_FILE" || -z "$NAMESPACE" || -z "$SECRET" ]]; then
  echo "[ERROR] File, namespace, and secret name are required."; show_help; exit 1
fi

kubectl -n "$NAMESPACE" create secret generic "$SECRET" --from-env-file="$ENV_FILE" --dry-run=client -o yaml | kubectl apply -f -

echo "[SUCCESS] Secret $SECRET created/updated in namespace $NAMESPACE."
