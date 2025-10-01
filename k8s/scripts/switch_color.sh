#!/usr/bin/env bash
set -euo pipefail

# Set kubectl path for Windows/Docker Desktop
KUBECTL="/mnt/c/Program Files/Docker/Docker/resources/bin/kubectl.exe"

if [ $# -lt 2 ]; then
  echo "Usage: $0 <namespace> <blue|green>"
  exit 1
fi

NS="$1"
COLOR="$2"

if [ "$COLOR" != "blue" ] && [ "$COLOR" != "green" ]; then
  echo "Color must be blue or green"
  exit 1
fi

echo "Switching backend-svc in $NS to $COLOR"
"$KUBECTL" -n "$NS" patch service backend-svc -p "{\"spec\":{\"selector\":{\"app\":\"backend\",\"color\":\"$COLOR\"}}}"

echo "Updating HPA to target deployment backend-$COLOR"
"$KUBECTL" -n "$NS" patch hpa backend-hpa --type='json' -p \
  "[{\"op\":\"replace\",\"path\":\"/spec/scaleTargetRef/name\",\"value\":\"backend-$COLOR\"}]"

echo "Done."