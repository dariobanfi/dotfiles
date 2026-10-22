#!/bin/bash
# Installs the new kitty icon, including its light, dark, tinted and clear styles.
# Usage: ./install.sh [--restore] [/path/to/kitty.app]
# Needs Xcode 26 or later. Run it again after each kitty update.
set -euo pipefail

here="$(cd "$(dirname "$0")" && pwd)"
restore=0
if [ "${1:-}" = "--restore" ]; then restore=1; shift; fi
app="${1:-/Applications/kitty.app}"
res="$app/Contents/Resources"
[ -d "$res" ] || { echo "kitty.app not found at $app"; exit 1; }

version="$(plutil -extract CFBundleShortVersionString raw "$app/Contents/Info.plist")"
backup="$HOME/Library/Application Support/kitty-icon/$version/kitty.app"

refresh() {
  touch "$app"
  rm -f /var/folders/*/*/*/com.apple.dock.iconcache 2>/dev/null || true
  killall Dock 2>/dev/null || true
}

put_back() {
  rm -rf "$app"
  ditto "$backup" "$app"
}

if [ "$restore" = 1 ]; then
  [ -d "$backup" ] || { echo "No backup for kitty $version"; exit 1; }
  put_back; refresh
  echo "Restored the original kitty $version."
  exit 0
fi

if pgrep -xq kitty; then echo "Quit kitty first, then run this from another terminal."; exit 1; fi

xcrun --find actool >/dev/null 2>&1 || { echo "actool not found. Install Xcode 26+ and run: sudo xcode-select -s /Applications/Xcode.app"; exit 1; }

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
xcrun actool "$here/kitty.icon" --compile "$tmp" --app-icon kitty \
  --platform macosx --target-device mac --minimum-deployment-target 15.0 \
  --include-all-app-icons --enable-on-demand-resources NO --development-region en \
  --output-partial-info-plist "$tmp/partial.plist" --warnings --errors >/dev/null
[ -s "$tmp/Assets.car" ] || { echo "actool did not produce Assets.car"; exit 1; }

if [ ! -d "$backup" ]; then
  mkdir -p "$(dirname "$backup")"
  ditto "$app" "$backup"
fi

cp "$tmp/Assets.car" "$res/Assets.car"
cp "$here/kitty.icns" "$res/kitty.icns"

# Changing resources breaks the app's signature, so sign it again for this Mac.
if ! codesign --force --deep --sign - "$app" || ! codesign --verify --deep "$app" || ! "$app/Contents/MacOS/kitty" --version >/dev/null; then
  echo "Signing or launch check failed. Putting the original back."
  put_back
  exit 1
fi

refresh
for f in "$HOME/.config/kitty/kitty.app.png" "$HOME/.config/kitty/kitty.app.icns"; do
  if [ -e "$f" ]; then echo "Warning: $f overrides the app icon and turns off dark mode. Remove it."; fi
done
echo "Done. Original kitty $version saved in: $backup"
