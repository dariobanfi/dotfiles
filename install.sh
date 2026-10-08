#!/bin/sh
# Link the dotfiles into place. Safe to re-run; afterwards `git pull` is all
# it takes to pick up config changes.
set -eu

repo=$(cd "$(dirname "$0")" && pwd)

# Symlink $HOME/<path> to the repo copy, moving any existing real file or
# directory aside first.
link() {
  src="$repo/$1" dst="$HOME/$1"
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    return
  fi
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    bak="$dst.bak-$(date +%Y%m%d-%H%M%S)"
    mv "$dst" "$bak"
    echo "moved existing $dst to $bak"
  fi
  mkdir -p "$(dirname "$dst")"
  ln -s "$src" "$dst"
  echo "linked $dst"
}

link .config/helix

# Per-machine Helix theme (git-ignored). Edit it by hand to override.
theme="$repo/.config/helix/themes/local.toml"
if [ ! -e "$theme" ]; then
  case "$(uname -s)" in
    Darwin) base=catppuccin_mocha_subtle ;;
    *) base=catppuccin_mocha_transparent ;;
  esac
  printf 'inherits = "%s"\n' "$base" >"$theme"
  echo "wrote $theme (inherits $base)"
fi
