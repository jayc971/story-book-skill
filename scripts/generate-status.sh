#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="${1:?Usage: generate-status.sh <path-to-loop-storybook-checkout> <path-to-this-repo>}"
OUT_DIR="${2:?Usage: generate-status.sh <path-to-loop-storybook-checkout> <path-to-this-repo>}"

BRANCH=$(git -C "$REPO_DIR" rev-parse --abbrev-ref HEAD)
COMMIT=$(git -C "$REPO_DIR" rev-parse --short HEAD)
DATE=$(date +"%Y-%m-%d %H:%M")

{
  echo "# Loop Storybook — Status (auto-generated, do not edit by hand)"
  echo ""
  echo "Last updated: $DATE"
  echo "Branch: $BRANCH @ $COMMIT"
  echo ""
  echo "## Recent commits"
  git -C "$REPO_DIR" log -10 --pretty=format:"- %s (%h)"
  echo ""
  echo ""
  echo "## Structure at a glance"
  echo '```'
  (cd "$REPO_DIR" && find src -maxdepth 2 -type d | sort)
  echo '```'
} > "$OUT_DIR/status.md"

echo "Wrote $OUT_DIR/status.md"
