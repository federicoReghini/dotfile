#!/usr/bin/env bash

# ============================================================
# Dotfiles Install Script
# Run this AFTER cloning the repo to ~/.config
# Usage: bash ~/.config/install.sh
# ============================================================

set -e

DOTFILES="$HOME/.config"
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log()    { echo -e "${GREEN}[dotfiles]${NC} $1"; }
warn()   { echo -e "${YELLOW}[dotfiles]${NC} $1"; }
error()  { echo -e "${RED}[dotfiles]${NC} $1"; }

symlink() {
  local src="$1"
  local dest="$2"

  if [ -L "$dest" ]; then
    warn "Symlink already exists: $dest — skipping"
    return
  fi

  if [ -e "$dest" ]; then
    warn "File/dir already exists at $dest — backing up to ${dest}.backup"
    mv "$dest" "${dest}.backup"
  fi

  ln -s "$src" "$dest"
  log "Linked: $dest → $src"
}

# ============================================================
echo ""
echo "╔══════════════════════════════════════╗"
echo "║       Dotfiles Symlink Setup         ║"
echo "╚══════════════════════════════════════╝"
echo ""
# ============================================================

# --- Required: shell config ---
symlink ".config/.zshrc"        "$HOME/.zshrc"

# --- Convenience shortcuts from ~ to ~/.config/<tool> ---
symlink ".config/nvim"          "$HOME/nvim"
symlink ".config/tmux"          "$HOME/tmux"
symlink ".config/aerospace"     "$HOME/aerospace"
symlink ".config/nix"           "$HOME/nix"
symlink ".config/gh"            "$HOME/gh"
symlink ".config/bat"           "$HOME/bat"
symlink ".config/carapace"      "$HOME/carapace"
symlink ".config/starship.toml" "$HOME/starship.toml"

echo ""
log "All done! Run: source ~/.zshrc"
echo ""
