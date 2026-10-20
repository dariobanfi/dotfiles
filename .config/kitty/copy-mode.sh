#!/bin/sh
# Keyboard copy mode for kitty (the copy_mode action in kitty.conf). kitty pipes the terminal text
# in; this opens it in Helix with the cursor on the last line. Keys are set in copy-mode.toml.
# Sticks to POSIX sh and tools, so it runs the same on macOS and Linux.
f=$(mktemp "${TMPDIR:-/tmp}/kitty-copy.XXXXXX") || exit 1
trap 'rm -f "$f"' EXIT
# Drop the blank lines at the end, so the cursor starts on real text
awk '{ l[NR] = $0 } /[^[:space:]]/ { n = NR } END { for (i = 1; i <= n; i++) print l[i] }' > "$f"
# Some distros call it helix; kitty started from the macOS Dock doesn't have Homebrew on its PATH
hx=$(command -v hx || command -v helix || echo /opt/homebrew/bin/hx)
"$hx" -c "$HOME/.config/kitty/copy-mode.toml" "$f:$(($(wc -l < "$f")))" < /dev/tty
