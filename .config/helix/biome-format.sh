#!/bin/sh
# Helix formatter for JS/TS: organize imports + format with Biome via stdin.
# Uses the project's biome.json(c) if one exists at or above $PWD, otherwise
# falls back to ~/.config/biome/biome.json.
# $1: a dummy filename so Biome knows the language (e.g. x.tsx).
biome="$(dirname "$0")/biome.sh"
dir=$PWD
while [ "$dir" != / ]; do
  if [ -e "$dir/biome.json" ] || [ -e "$dir/biome.jsonc" ]; then
    exec "$biome" check --write --linter-enabled=false --stdin-file-path="$1"
  fi
  dir=$(dirname "$dir")
done
exec "$biome" check --write --linter-enabled=false \
  --config-path="$HOME/.config/biome" --stdin-file-path="$1"
