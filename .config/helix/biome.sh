#!/bin/sh
# Run Biome from wherever this machine has it: PATH first, then Homebrew
# (macOS) or npm's ~/.local prefix (Linux). Helix may not inherit the login
# shell's PATH, hence the explicit fallbacks.
for biome in "$(command -v biome)" /opt/homebrew/bin/biome "$HOME/.local/bin/biome"; do
  [ -x "$biome" ] && exec "$biome" "$@"
done
echo "biome not found" >&2
exit 127
