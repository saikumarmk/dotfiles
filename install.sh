#!/usr/bin/env bash
set -eu
set -o pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colours
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'
info()    { echo -e "${GREEN}[dotfiles]${NC} $*"; }
warn()    { echo -e "${YELLOW}[dotfiles]${NC} $*"; }
die()     { echo -e "${RED}[dotfiles]${NC} $*" >&2; exit 1; }

# Detect OS
case "$(uname -s)" in
  Darwin) OS=macos ;;
  Linux)  OS=linux ;;
  *)      die "Unsupported OS: $(uname -s)" ;;
esac
info "Detected OS: $OS"

# Helper: create symlink, backing up any existing file
link() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [[ -e "$dst" && ! -L "$dst" ]]; then
    warn "Backing up existing $dst -> ${dst}.bak"
    mv "$dst" "${dst}.bak"
  fi
  ln -sfn "$src" "$dst"
  info "  $dst -> $src"
}

# ── Ghostty ──────────────────────────────────────────────────────────────────
info "Linking ghostty config..."
link "$DOTFILES/ghostty/config"          ~/.config/ghostty/config
link "$DOTFILES/ghostty/config-$OS"      ~/.config/ghostty/config-platform

# ── Neovim ───────────────────────────────────────────────────────────────────
info "Linking nvim config..."
link "$DOTFILES/nvim" ~/.config/nvim

info "Done. Restart Ghostty and nvim to pick up changes."
