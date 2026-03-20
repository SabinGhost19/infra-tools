#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="$(cd "$(dirname "$0")/.." && pwd)"
JSON_DIR="$BASE_DIR/json"

mkdir -p "$JSON_DIR"

curl -fsSL -o "$JSON_DIR/cluster.json" \
  "https://raw.githubusercontent.com/fluxcd/flux2-monitoring-example/main/monitoring/configs/dashboards/cluster.json"

curl -fsSL -o "$JSON_DIR/control-plane.json" \
  "https://raw.githubusercontent.com/fluxcd/flux2-monitoring-example/main/monitoring/configs/dashboards/control-plane.json"

curl -fsSL -o "$JSON_DIR/logs.json" \
  "https://raw.githubusercontent.com/fluxcd/flux2-monitoring-example/main/monitoring/configs/dashboards/logs.json"

echo "Flux dashboards synced into: $JSON_DIR"
