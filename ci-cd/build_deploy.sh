#!/usr/bin/env bash
# build_deploy.sh - Build Docker image and deploy to Kubernetes
#
# Usage: build_deploy.sh -i <image> -d <deployment> [-n <namespace>] [--help]
#
# Options:
#   -i, --image        Docker image name (required)
#   -d, --deployment   Kubernetes deployment name (required)
#   -n, --namespace    Kubernetes namespace (default: default)
#   -h, --help         Show this help message

set -euo pipefail

show_help() {
  grep '^#' "$0" | cut -c 3-
}

IMAGE=""
DEPLOYMENT=""
NAMESPACE="default"

while [[ $# -gt 0 ]]; do
  case "$1" in
    -i|--image)
      IMAGE="$2"; shift 2;;
    -d|--deployment)
      DEPLOYMENT="$2"; shift 2;;
    -n|--namespace)
      NAMESPACE="$2"; shift 2;;
    -h|--help)
      show_help; exit 0;;
    *)
      echo "Unknown option: $1"; show_help; exit 1;;
  esac
  done

if [[ -z "$IMAGE" || -z "$DEPLOYMENT" ]]; then
  echo "[ERROR] Image and deployment are required."; show_help; exit 1
fi

echo "[INFO] Building Docker image: $IMAGE"
docker build -t "$IMAGE" .

echo "[INFO] Pushing Docker image: $IMAGE"
docker push "$IMAGE"

echo "[INFO] Updating Kubernetes deployment: $DEPLOYMENT"
kubectl set image deployment/"$DEPLOYMENT" "$DEPLOYMENT"="$IMAGE" -n "$NAMESPACE"

echo "[SUCCESS] Build and deploy complete."
