#!/usr/bin/env bash
set -eu
set -o pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colours
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'
info()    { echo -e "${GREEN}[dotfiles]${NC} $*"; }
warn()    { echo -e "${YELLOW}[dotfiles]${NC} $*"; }
die()     { echo -e "${RED}[dotfiles]${NC} $*" >&2; exit 1; }

has() { command -v "$1" &>/dev/null; }

# Detect OS
case "$(uname -s)" in
  Darwin) OS=macos ;;
  Linux)  OS=linux ;;
  *)      die "Unsupported OS: $(uname -s)" ;;
esac
info "Detected OS: $OS"

# ── Package installation ──────────────────────────────────────────────────────

install_linux() {
  # Prefer yay (AUR) so we get ghostty; fall back to pacman for base packages
  local aur=""
  if has yay; then
    aur=yay
  elif has paru; then
    aur=paru
  fi

  info "Installing packages (pacman)..."
  sudo pacman -Syu --needed --noconfirm \
    neovim git base-devel nodejs npm python python-pip \
    ttf-jetbrains-mono-nerd

  if [[ -n "$aur" ]]; then
    info "Installing AUR packages ($aur)..."
    $aur -S --needed --noconfirm ghostty
  else
    warn "No AUR helper found (yay/paru). Install ghostty manually: https://ghostty.org"
  fi

  # ruff via uv (faster than pip, version-managed)
  if ! has ruff; then
    if has uv; then
      info "Installing ruff via uv..."
      uv tool install ruff
    else
      info "Installing uv then ruff..."
      curl -LsSf https://astral.sh/uv/install.sh | sh
      "$HOME/.local/bin/uv" tool install ruff
    fi
  fi
}

install_macos() {
  if ! has brew; then
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  info "Installing packages (brew)..."
  brew install neovim git node python
  brew install --cask ghostty font-jetbrains-mono-nerd-font

  if ! has ruff; then
    if has uv; then
      uv tool install ruff
    else
      brew install uv
      uv tool install ruff
    fi
  fi
}

info "Installing dependencies..."
if [[ "$OS" == "linux" ]]; then
  install_linux
else
  install_macos
fi

# ── Symlinks ──────────────────────────────────────────────────────────────────

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

info "Linking ghostty config..."
link "$DOTFILES/ghostty/config"      ~/.config/ghostty/config
link "$DOTFILES/ghostty/config-$OS"  ~/.config/ghostty/config-platform

info "Linking nvim config..."
link "$DOTFILES/nvim" ~/.config/nvim

# ── Post-install hints ────────────────────────────────────────────────────────
echo ""
info "Done! Next steps:"
echo "  1. Open nvim and run :Lazy sync  (installs plugins)"
echo "  2. Open nvim and run :Mason      (install LSP servers as needed)"
echo "  3. Restart Ghostty to pick up config"
