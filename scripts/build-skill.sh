#!/bin/sh
# Build the Conjurer skill bundle for upload to claude.ai (Customize > Skills).
# The bundle is a build of this repository: SKILL.md plus every file it refers to,
# under a top-level conjurer/ folder. Output: dist/conjurer-skill.zip.
# Keep FILES in step with the "File references" block at the end of SKILL.md.
set -eu

cd "$(dirname "$0")/.."

FILES="SKILL.md index.edn quick-reference.md conjurer.md architecture.md template.md design/conjurer.cnj grimoires"
MAX_DESCRIPTION=1024

for f in $FILES; do
  [ -e "$f" ] || { echo "build-skill: missing $f" >&2; exit 1; }
done

name=$(sed -n 's/^name: //p' SKILL.md | head -n 1)
[ "$name" = "conjurer" ] || { echo "build-skill: SKILL.md name is '$name', expected 'conjurer'" >&2; exit 1; }

# Count characters, not bytes: drop UTF-8 continuation bytes before counting.
length=$(sed -n 's/^description: //p' SKILL.md | head -n 1 | tr -d '\n' | LC_ALL=C tr -d '\200-\277' | wc -c | tr -d ' ')
if [ "$length" -gt "$MAX_DESCRIPTION" ]; then
  echo "build-skill: SKILL.md description is $length characters; claude.ai accepts at most $MAX_DESCRIPTION" >&2
  exit 1
fi

stage=$(mktemp -d)
trap 'rm -rf "$stage"' EXIT
mkdir -p "$stage/conjurer"
for f in $FILES; do
  mkdir -p "$stage/conjurer/$(dirname "$f")"
  cp -R "$f" "$stage/conjurer/$f"
done

mkdir -p dist
rm -f dist/conjurer-skill.zip
out="$(pwd)/dist/conjurer-skill.zip"
(cd "$stage" && zip -qrX "$out" conjurer)
echo "build-skill: wrote dist/conjurer-skill.zip ($length-character description, commit $(git rev-parse --short HEAD 2>/dev/null || echo unknown))"
