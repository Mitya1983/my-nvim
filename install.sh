#!/usr/bin/env bash
set -euo pipefail

# ── Neovim IDE Setup ─────────────────────────────────────────────
# Installs Neovim 0.11+ with full C++/Python IDE configuration.
# Supports Linux (Ubuntu/Debian) and macOS.
# Usage: ./install.sh
# ─────────────────────────────────────────────────────────────────

NVIM_MIN_VERSION="0.11.0"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_SRC="$SCRIPT_DIR/nvim"
CONFIG_DST="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"

# ── Helpers ──────────────────────────────────────────────────────

info()  { printf '\033[1;34m[INFO]\033[0m  %s\n' "$*"; }
warn()  { printf '\033[1;33m[WARN]\033[0m  %s\n' "$*"; }
error() { printf '\033[1;31m[ERROR]\033[0m %s\n' "$*"; exit 1; }

command_exists() { command -v "$1" &>/dev/null; }

version_ge() {
    # returns 0 if $1 >= $2 (semver comparison)
    printf '%s\n%s' "$2" "$1" | sort -V -C
}

detect_os() {
    case "$(uname -s)" in
        Linux*)  echo "linux" ;;
        Darwin*) echo "macos" ;;
        *)       error "Unsupported OS: $(uname -s)" ;;
    esac
}

# ── Install system dependencies ──────────────────────────────────

install_deps_linux() {
    info "Installing system dependencies (apt)..."
    sudo apt-get update -qq
    sudo apt-get install -y \
        git curl gcc g++ make cmake \
        python3 python3-venv \
        ripgrep fd-find fzf \
        unzip wget
    # fd is named 'fdfind' on Debian/Ubuntu; create symlink if needed
    if command_exists fdfind && ! command_exists fd; then
        sudo ln -sf "$(which fdfind)" /usr/local/bin/fd
    fi
}

install_deps_macos() {
    if ! command_exists brew; then
        error "Homebrew is required. Install from https://brew.sh"
    fi
    info "Installing system dependencies (brew)..."
    brew install git curl cmake \
        python3 \
        ripgrep fd fzf \
        node
}

# ── Install Node.js (needed for tree-sitter CLI and some LSPs) ──

install_node_linux() {
    if command_exists node; then
        info "Node.js already installed: $(node --version)"
        return
    fi
    info "Installing Node.js via nodesource..."
    curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
    sudo apt-get install -y nodejs
}

# ── Install Neovim ───────────────────────────────────────────────

install_nvim_linux() {
    local current=""
    if command_exists nvim; then
        current="$(nvim --version | head -1 | grep -oP 'v\K[0-9]+\.[0-9]+\.[0-9]+')"
    fi

    if [ -n "$current" ] && version_ge "$current" "$NVIM_MIN_VERSION"; then
        info "Neovim $current already installed (>= $NVIM_MIN_VERSION)"
        return
    fi

    info "Installing Neovim via AppImage..."
    mkdir -p "$HOME/.local/bin"
    local url="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage"
    curl -fLo "$HOME/.local/bin/nvim" "$url"
    chmod +x "$HOME/.local/bin/nvim"

    # Ensure ~/.local/bin is in PATH
    if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
        warn "Add to your shell profile:  export PATH=\"\$HOME/.local/bin:\$PATH\""
    fi
    info "Neovim installed at $HOME/.local/bin/nvim"
}

install_nvim_macos() {
    if command_exists nvim; then
        local current
        current="$(nvim --version | head -1 | sed 's/NVIM v//')"
        if version_ge "$current" "$NVIM_MIN_VERSION"; then
            info "Neovim $current already installed (>= $NVIM_MIN_VERSION)"
            return
        fi
    fi
    info "Installing Neovim via Homebrew..."
    brew install neovim
}

# ── Install clangd (C++ language server) ─────────────────────────

install_clangd_linux() {
    if command_exists clangd || command_exists clangd-20 || command_exists clangd-19 || command_exists clangd-18; then
        info "clangd already available"
        return
    fi
    info "Installing clangd..."
    sudo apt-get install -y clangd || sudo apt-get install -y clangd-18 || warn "Could not install clangd; Mason will try to install it"
}

install_clangd_macos() {
    # Xcode command line tools include clangd, or install via llvm
    if command_exists clangd; then
        info "clangd already available"
        return
    fi
    info "Installing llvm (includes clangd)..."
    brew install llvm
    warn "Add to your shell profile:  export PATH=\"\$(brew --prefix llvm)/bin:\$PATH\""
}

# ── Install tree-sitter CLI (needed by nvim-treesitter) ──────────

install_treesitter_cli() {
    if command_exists tree-sitter; then
        info "tree-sitter CLI already installed"
        return
    fi
    info "Installing tree-sitter CLI via npm..."
    npm install -g tree-sitter-cli
}

# ── Deploy Neovim config ─────────────────────────────────────────

deploy_config() {
    if [ -d "$CONFIG_DST" ]; then
        local backup="$CONFIG_DST.backup.$(date +%Y%m%d%H%M%S)"
        warn "Existing config found at $CONFIG_DST"
        warn "Backing up to $backup"
        mv "$CONFIG_DST" "$backup"
    fi

    info "Deploying config to $CONFIG_DST..."
    mkdir -p "$(dirname "$CONFIG_DST")"
    cp -r "$CONFIG_SRC" "$CONFIG_DST"

    # Remove lazy-lock.json so lazy.nvim resolves fresh versions
    # (the lock file is included as reference but may be stale)
    rm -f "$CONFIG_DST/lazy-lock.json"
}

# ── Bootstrap plugins ────────────────────────────────────────────

bootstrap_plugins() {
    info "Bootstrapping plugins (lazy.nvim will install everything)..."
    nvim --headless "+Lazy! sync" +qa 2>/dev/null || true
    info "Clearing catppuccin cache..."
    rm -rf "${XDG_CACHE_HOME:-$HOME/.cache}/nvim/catppuccin/"
    info "Plugins installed."
}

# ── Main ─────────────────────────────────────────────────────────

main() {
    local os_type
    os_type="$(detect_os)"
    info "Detected OS: $os_type"

    # System dependencies
    if [ "$os_type" = "linux" ]; then
        install_deps_linux
        install_node_linux
        install_nvim_linux
        install_clangd_linux
    else
        install_deps_macos
        install_nvim_macos
        install_clangd_macos
    fi

    # tree-sitter CLI (both platforms)
    install_treesitter_cli

    # Deploy config
    deploy_config

    # Bootstrap plugins
    bootstrap_plugins

    echo ""
    info "Setup complete!"
    info ""
    info "Next steps:"
    info "  1. Open nvim:  nvim"
    info "  2. Mason will auto-install LSP servers (clangd, pyright, lua_ls)"
    info "  3. For C++ projects: cmake -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON"
    info "     Then symlink: ln -s build/compile_commands.json ."
    info "  4. See nvim-instructions for keybindings: $CONFIG_DST/nvim-instructions"
}

main "$@"
