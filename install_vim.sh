#!/bin/bash
# ============================================================================
# Vim Installer & Configurator
# ============================================================================
# Installs vim (if not already installed), sets up the configuration,
# and configures vim as the default editor for sudo/sudoedit.
# Supports: Debian/Ubuntu (apt), RHEL/CentOS/Fedora (dnf/yum), macOS (brew)
# ============================================================================

set -e

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VIM_CONF_SOURCE="$SCRIPT_DIR/.vimrc"
VIM_CONF_TARGET="$HOME/.vimrc"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
echo_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
echo_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# ----------------------------------------------------------------------------
# Check if vim is installed
# ----------------------------------------------------------------------------
check_vim_installed() {
    if command -v vim &> /dev/null; then
        VIM_VERSION=$(vim --version | head -1 | grep -oP 'Vi IMproved \K[0-9.]+' || vim --version | head -1)
        echo_info "vim is already installed: $VIM_VERSION"
        return 0
    else
        return 1
    fi
}

# ----------------------------------------------------------------------------
# Detect package manager and install vim
# ----------------------------------------------------------------------------
install_vim() {
    echo_info "Installing vim..."
    
    # Detect OS and package manager
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS - vim is pre-installed, but we can get a newer version
        if command -v brew &> /dev/null; then
            brew install vim
        else
            echo_warn "Homebrew not found. Using system vim."
            return 0
        fi
    elif command -v apt &> /dev/null; then
        # Debian/Ubuntu
        sudo apt update
        sudo apt install -y vim
    elif command -v dnf &> /dev/null; then
        # Fedora/RHEL 8+
        sudo dnf install -y vim
    elif command -v yum &> /dev/null; then
        # CentOS/RHEL 7
        sudo yum install -y vim
    elif command -v pacman &> /dev/null; then
        # Arch Linux
        sudo pacman -S --noconfirm vim
    elif command -v zypper &> /dev/null; then
        # openSUSE
        sudo zypper install -y vim
    else
        echo_error "Could not detect package manager. Please install vim manually."
        exit 1
    fi
    
    echo_info "vim installed successfully!"
}

# ----------------------------------------------------------------------------
# Configure vim
# ----------------------------------------------------------------------------
configure_vim() {
    echo_info "Configuring vim..."
    
    # Check if source config exists
    if [[ ! -f "$VIM_CONF_SOURCE" ]]; then
        echo_error "Config file not found: $VIM_CONF_SOURCE"
        exit 1
    fi
    
    # Backup existing config if it exists and is different
    if [[ -f "$VIM_CONF_TARGET" ]]; then
        if ! diff -q "$VIM_CONF_SOURCE" "$VIM_CONF_TARGET" &> /dev/null; then
            BACKUP="$VIM_CONF_TARGET.backup.$(date +%Y%m%d_%H%M%S)"
            echo_warn "Backing up existing config to: $BACKUP"
            cp "$VIM_CONF_TARGET" "$BACKUP"
        else
            echo_info "Config already up to date"
            return 0
        fi
    fi
    
    # Copy config file
    cp "$VIM_CONF_SOURCE" "$VIM_CONF_TARGET"
    echo_info "Config installed to: $VIM_CONF_TARGET"
}

# ----------------------------------------------------------------------------
# Set vim as default editor for sudoedit
# ----------------------------------------------------------------------------
configure_sudoedit() {
    echo_info "Configuring vim as default editor..."
    
    # Get vim path
    VIM_PATH=$(command -v vim)
    
    # Method 1: update-alternatives (Debian/Ubuntu)
    if command -v update-alternatives &> /dev/null; then
        echo_info "Setting vim as default editor via update-alternatives..."
        sudo update-alternatives --set editor "$VIM_PATH" 2>/dev/null || \
        sudo update-alternatives --install /usr/bin/editor editor "$VIM_PATH" 100 2>/dev/null || true
    fi
    
    # Method 2: Set EDITOR and VISUAL environment variables
    # Add to shell config files
    EDITOR_EXPORT="export EDITOR=vim"
    VISUAL_EXPORT="export VISUAL=vim"
    SUDO_EDITOR_EXPORT="export SUDO_EDITOR=vim"
    
    add_to_shell_config() {
        local file="$1"
        local updated=false
        
        if [[ -f "$file" ]]; then
            if ! grep -q "^export EDITOR=" "$file"; then
                echo "" >> "$file"
                echo "# Set vim as default editor" >> "$file"
                echo "$EDITOR_EXPORT" >> "$file"
                echo "$VISUAL_EXPORT" >> "$file"
                echo "$SUDO_EDITOR_EXPORT" >> "$file"
                updated=true
            fi
        fi
        
        if $updated; then
            echo_info "Added editor exports to: $file"
        fi
    }
    
    # Add to common shell config files
    add_to_shell_config "$HOME/.bashrc"
    add_to_shell_config "$HOME/.zshrc"
    add_to_shell_config "$HOME/.profile"
    
    # Export for current session
    export EDITOR=vim
    export VISUAL=vim
    export SUDO_EDITOR=vim
    
    echo_info "vim set as default editor for current session"
    echo_warn "Restart your shell or run 'source ~/.bashrc' (or ~/.zshrc) for changes to take effect"
}

# ----------------------------------------------------------------------------
# Main
# ----------------------------------------------------------------------------
echo "=== Vim Installer & Configurator ==="
echo ""

# Install vim if not present
if ! check_vim_installed; then
    install_vim
fi

# Configure vim
configure_vim

# Configure as default editor
configure_sudoedit

echo ""
echo_info "Done! Vim is installed and configured."
echo ""
echo "Quick reference:"
echo "  Save:           Ctrl+J or <space>w"
echo "  Quit:           <space>q"
echo "  Force quit:     <space>d"
echo "  Toggle paste:   F2 (for multi-line paste)"
echo "  Navigate splits: Ctrl+H/K/L"
echo ""
echo "sudoedit will now use vim as the editor."
