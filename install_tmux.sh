#!/bin/bash
# ============================================================================
# Tmux Installer & Configurator
# ============================================================================
# Installs tmux (if not already installed) and sets up the configuration.
# Supports: Debian/Ubuntu (apt), RHEL/CentOS/Fedora (dnf/yum), macOS (brew)
# ============================================================================

set -e

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMUX_CONF_SOURCE="$SCRIPT_DIR/.tmux.conf"
TMUX_CONF_TARGET="$HOME/.tmux.conf"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
echo_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
echo_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# ----------------------------------------------------------------------------
# Check if tmux is installed
# ----------------------------------------------------------------------------
check_tmux_installed() {
    if command -v tmux &> /dev/null; then
        TMUX_VERSION=$(tmux -V | cut -d' ' -f2)
        echo_info "tmux $TMUX_VERSION is already installed"
        return 0
    else
        return 1
    fi
}

# ----------------------------------------------------------------------------
# Detect package manager and install tmux
# ----------------------------------------------------------------------------
install_tmux() {
    echo_info "Installing tmux..."
    
    # Detect OS and package manager
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        if command -v brew &> /dev/null; then
            brew install tmux
        else
            echo_error "Homebrew not found. Please install Homebrew first:"
            echo "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
            exit 1
        fi
    elif command -v apt &> /dev/null; then
        # Debian/Ubuntu
        sudo apt update
        sudo apt install -y tmux
    elif command -v dnf &> /dev/null; then
        # Fedora/RHEL 8+
        sudo dnf install -y tmux
    elif command -v yum &> /dev/null; then
        # CentOS/RHEL 7
        sudo yum install -y tmux
    elif command -v pacman &> /dev/null; then
        # Arch Linux
        sudo pacman -S --noconfirm tmux
    elif command -v zypper &> /dev/null; then
        # openSUSE
        sudo zypper install -y tmux
    else
        echo_error "Could not detect package manager. Please install tmux manually."
        echo_warn "For systems without root access, use install_tmux_local.sh instead."
        exit 1
    fi
    
    echo_info "tmux installed successfully!"
}

# ----------------------------------------------------------------------------
# Configure tmux
# ----------------------------------------------------------------------------
configure_tmux() {
    echo_info "Configuring tmux..."
    
    # Check if source config exists
    if [[ ! -f "$TMUX_CONF_SOURCE" ]]; then
        echo_error "Config file not found: $TMUX_CONF_SOURCE"
        exit 1
    fi
    
    # Backup existing config if it exists and is different
    if [[ -f "$TMUX_CONF_TARGET" ]]; then
        if ! diff -q "$TMUX_CONF_SOURCE" "$TMUX_CONF_TARGET" &> /dev/null; then
            BACKUP="$TMUX_CONF_TARGET.backup.$(date +%Y%m%d_%H%M%S)"
            echo_warn "Backing up existing config to: $BACKUP"
            cp "$TMUX_CONF_TARGET" "$BACKUP"
        else
            echo_info "Config already up to date"
            return 0
        fi
    fi
    
    # Copy config file
    cp "$TMUX_CONF_SOURCE" "$TMUX_CONF_TARGET"
    echo_info "Config installed to: $TMUX_CONF_TARGET"
    
    # Reload tmux config if tmux is running
    if tmux list-sessions &> /dev/null; then
        tmux source-file "$TMUX_CONF_TARGET"
        echo_info "Reloaded tmux configuration"
    fi
}

# ----------------------------------------------------------------------------
# Main
# ----------------------------------------------------------------------------
echo "=== Tmux Installer & Configurator ==="
echo ""

# Install tmux if not present
if ! check_tmux_installed; then
    install_tmux
fi

# Configure tmux
configure_tmux

echo ""
echo_info "Done! Tmux is installed and configured."
echo ""
echo "Quick reference:"
echo "  Prefix:        Ctrl+A (instead of Ctrl+B)"
echo "  Switch panes:  Alt+Arrow keys"
echo "  Switch windows: Ctrl+H (prev) / Ctrl+L (next)"
echo "  New window:    Ctrl+A, c"
echo "  Split horiz:   Ctrl+A, \""
echo "  Split vert:    Ctrl+A, %"
