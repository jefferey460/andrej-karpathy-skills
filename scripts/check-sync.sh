#!/usr/bin/env bash
# Fails if the guideline body (from the "**Tradeoff:**" line onward) differs
# between CLAUDE.md and the other copies.
set -euo pipefail
cd "$(dirname "$0")/.."

body() { sed -n '/^\*\*Tradeoff:\*\*/,$p' "$1"; }

source_file=CLAUDE.md
copies=(
  skills/karpathy-guidelines/SKILL.md
  .cursor/rules/karpathy-guidelines.mdc
)

status=0
for f in "${copies[@]}"; do
  if ! diff -u --label "$source_file" --label "$f" <(body "$source_file") <(body "$f"); then
    echo "::error file=$f::$f is out of sync with $source_file" >&2
    status=1
  fi
done

[ "$status" -eq 0 ] && echo "All guideline copies match $source_file."
exit "$status"
