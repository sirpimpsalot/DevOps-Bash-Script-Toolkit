#!/usr/bin/env bash
# terraform_apply_wrapper.sh - Automate Terraform apply with safety and rollback
#
# Usage: terraform_apply_wrapper.sh [-d|--dir <directory>] [--auto-approve] [--rollback] [--help]
#
# Options:
#   -d, --dir           Directory containing Terraform config (default: current)
#   --auto-approve      Skip interactive approval
#   --rollback          Attempt rollback on failure
#   -h, --help          Show this help message

set -euo pipefail

show_help() {
  grep '^#' "$0" | cut -c 3-
}

TF_DIR="."
AUTO_APPROVE=""
ROLLBACK="false"

while [[ $# -gt 0 ]]; do
  case "$1" in
    -d|--dir)
      TF_DIR="$2"; shift 2;;
    --auto-approve)
      AUTO_APPROVE="-auto-approve"; shift;;
    --rollback)
      ROLLBACK="true"; shift;;
    -h|--help)
      show_help; exit 0;;
    *)
      echo "Unknown option: $1"; show_help; exit 1;;
  esac
  done

cd "$TF_DIR"
echo "[INFO] Running: terraform init"
terraform init

echo "[INFO] Running: terraform plan"
terraform plan

echo "[INFO] Running: terraform apply $AUTO_APPROVE"
if ! terraform apply $AUTO_APPROVE; then
  echo "[ERROR] Terraform apply failed."
  if [[ "$ROLLBACK" == "true" ]]; then
    echo "[INFO] Attempting rollback (terraform destroy)"
    terraform destroy $AUTO_APPROVE || echo "[WARN] Rollback failed. Manual intervention required."
  fi
  exit 1
fi

echo "[SUCCESS] Terraform apply completed."
