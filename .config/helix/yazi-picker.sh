#!/bin/sh
# File picker behind Space-o in Helix: browse with Yazi, starting at the current file, and print
# the path that was picked. The file's name comes in on stdin rather than as an argument: Helix
# pastes it into the command text as is, so a hostile name could otherwise run commands.
# Sticks to POSIX sh and tools, so it runs the same on macOS and Linux.
IFS= read -r name
case $name in # Helix gives a path relative to its working folder, or else to ~
  /*) start=$name ;;
  "~/"*) start=$HOME/${name#??} ;;
  *) start=$PWD/$name ;;
esac
[ -e "$start" ] || start=$PWD # a scratch buffer has no file yet
tmp=$(mktemp -d "${TMPDIR:-/tmp}/hx-yazi.XXXXXX") || exit 1
trap 'rm -rf "$tmp"' EXIT
# kitty started from the macOS Dock doesn't have Homebrew on its PATH
yazi=$(command -v yazi || echo /opt/homebrew/bin/yazi)

"$yazi" "$start" --chooser-file="$tmp/picked" < /dev/tty > /dev/tty
# Yazi switched off the alternate screen and bracketed paste on exit; Helix still needs them
printf '\033[?1049h\033[?2004h' > /dev/tty

# Nothing picked: hand back the current file, so Helix stays where it is
if [ -e "$tmp/picked" ]; then
  cat "$tmp/picked"
elif [ -f "$start" ]; then
  printf '%s\n' "$start"
fi
