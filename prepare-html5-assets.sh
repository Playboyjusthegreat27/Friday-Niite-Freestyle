#!/usr/bin/env bash
set -euo pipefail

# The source repository does not include song chart JSON files.
# The published web build repository stores them under assets/data.
# Copy them into assets/preload/data so Project.xml's existing
# assets/preload -> assets mapping packages them as assets/data/*.

SOURCE_REPO="https://github.com/Playboyjusthegreat27/free.git"
TEMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TEMP_DIR"' EXIT

git clone --depth 1 "$SOURCE_REPO" "$TEMP_DIR/web-build"

if [ ! -d "$TEMP_DIR/web-build/assets/data" ]; then
  echo "Could not find assets/data in $SOURCE_REPO"
  exit 1
fi

mkdir -p assets/preload/data
cp -R "$TEMP_DIR/web-build/assets/data/." assets/preload/data/

COUNT="$(find assets/preload/data -type f -name '*.json' | wc -l | tr -d ' ')"
if [ "$COUNT" -eq 0 ]; then
  echo "No song chart JSON files were copied."
  exit 1
fi

echo "Copied $COUNT song chart JSON files into assets/preload/data."
test -f assets/preload/data/doobop/doobop-hard.json
