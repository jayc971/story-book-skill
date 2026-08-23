#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILL_DIR="$REPO_DIR/claude-ai/skill"
OUT_ZIP="$REPO_DIR/claude-ai/story-book-skill.zip"

cp "$REPO_DIR/status.md" "$SKILL_DIR/references/status.md"

rm -f "$OUT_ZIP"
python3 - "$SKILL_DIR" "$OUT_ZIP" <<'PYEOF'
import sys, zipfile, pathlib

skill_dir, out_zip = pathlib.Path(sys.argv[1]), sys.argv[2]
with zipfile.ZipFile(out_zip, "w", zipfile.ZIP_DEFLATED) as zf:
    for path in sorted(skill_dir.rglob("*")):
        if path.is_file():
            zf.write(path, path.relative_to(skill_dir))
PYEOF

echo "Wrote $OUT_ZIP — upload this in claude.ai Settings > Capabilities/Skills to refresh."
