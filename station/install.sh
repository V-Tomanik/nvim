#!/usr/bin/env bash
# Code station installer for macOS. Safe to run more than once.
#   bash ~/.config/nvim/station/install.sh
#
# What it does:
#   1. checks Xcode command line tools + Homebrew
#   2. installs everything in station/Brewfile
#   3. installs the tmux-256color terminfo (missing on macOS)
#   4. symlinks the Ghostty and tmux configs (existing files are backed up, never deleted)
#   5. adds one `source` line to ~/.zshrc
set -euo pipefail

STATION="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO="$(dirname "$STATION")"
BACKUP="$HOME/.config/station-backup-$(date +%Y%m%d-%H%M%S)"

say() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!!\033[0m %s\n' "$*"; }

if [ "$(uname)" != "Darwin" ]; then
  warn "This installer is written for macOS."; exit 1
fi

if [ "$REPO" != "$HOME/.config/nvim" ]; then
  warn "This repo is at $REPO, not ~/.config/nvim. Neovim only reads ~/.config/nvim."
  warn "The Ghostty/tmux links will still point here."
fi

# 1. Prerequisites -----------------------------------------------------------
if ! xcode-select -p >/dev/null 2>&1; then
  warn "Xcode command line tools are missing (needed for git, make, compilers)."
  warn "Run: xcode-select --install   then re-run this script."; exit 1
fi
if ! command -v brew >/dev/null 2>&1; then
  warn "Homebrew is missing. Install it from https://brew.sh then re-run this script."; exit 1
fi

# 2. Packages ----------------------------------------------------------------
say "Installing packages from Brewfile"
brew bundle --file="$STATION/Brewfile"

# 3. tmux-256color terminfo ----------------------------------------------------
if ! infocmp tmux-256color >/dev/null 2>&1; then
  say "Installing tmux-256color terminfo"
  tmp="$(mktemp)"
  "$(brew --prefix ncurses)/bin/infocmp" -x tmux-256color >"$tmp"
  tic -x -o "$HOME/.terminfo" "$tmp"
  rm -f "$tmp"
fi

# 4. Config symlinks ---------------------------------------------------------
link() { # link <source in repo> <target>
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    return # already linked
  fi
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    mkdir -p "$BACKUP"
    mv "$dst" "$BACKUP/"
    warn "Backed up existing $dst -> $BACKUP/"
  fi
  ln -s "$src" "$dst"
  say "Linked $dst"
}
link "$STATION/ghostty/config" "$HOME/.config/ghostty/config"
link "$STATION/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf"
if [ -e "$HOME/.tmux.conf" ]; then
  warn "$HOME/.tmux.conf exists and takes priority over ~/.config/tmux/tmux.conf."
  warn "Move it away (e.g. mv ~/.tmux.conf ~/.tmux.conf.old) to use the station config."
fi

# 5. zsh ----------------------------------------------------------------------
line="source \"$STATION/zsh/station.zsh\""
touch "$HOME/.zshrc"
if ! grep -Fq "$STATION/zsh/station.zsh" "$HOME/.zshrc"; then
  printf '\n# Code station (nvim repo)\n%s\n' "$line" >>"$HOME/.zshrc"
  say "Added station.zsh to ~/.zshrc"
fi

say "Done. Next:"
echo "  1. Open Ghostty (it picks up the config automatically)"
echo "  2. Run: tm        (starts a tmux session for the current folder)"
echo "  3. Run: nvim      (first start downloads plugins, then :Mason shows language servers installing)"
echo "  4. Inside nvim run :checkhealth if anything looks off"
