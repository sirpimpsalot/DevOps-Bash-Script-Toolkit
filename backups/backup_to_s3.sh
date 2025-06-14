#!/usr/bin/env bash
# backup_to_s3.sh - Backup files/directories to AWS S3
#
# Usage: backup_to_s3.sh -s <source> -b <bucket> [-k <key_prefix>] [--help]
#
# Options:
#   -s, --source        Source file or directory to back up
#   -b, --bucket        S3 bucket name
#   -k, --key-prefix    S3 key prefix (optional)
#   -h, --help          Show this help message

set -euo pipefail

show_help() {
  grep '^#' "$0" | cut -c 3-
}

SOURCE=""
BUCKET=""
KEY_PREFIX=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    -s|--source)
      SOURCE="$2"; shift 2;;
    -b|--bucket)
      BUCKET="$2"; shift 2;;
    -k|--key-prefix)
      KEY_PREFIX="$2"; shift 2;;
    -h|--help)
      show_help; exit 0;;
    *)
      echo "Unknown option: $1"; show_help; exit 1;;
  esac
  done

if [[ -z "$SOURCE" || -z "$BUCKET" ]]; then
  echo "[ERROR] Source and bucket are required."; show_help; exit 1
fi

if [[ -n "$KEY_PREFIX" ]]; then
  DEST="s3://$BUCKET/$KEY_PREFIX/"
else
  DEST="s3://$BUCKET/"
fi

echo "[INFO] Syncing $SOURCE to $DEST"
aws s3 sync "$SOURCE" "$DEST"

echo "[SUCCESS] Backup to S3 complete."
