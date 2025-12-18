#!/bin/bash
# ============================================================================
# Zsh All-in-One Installer
# ============================================================================
# Installs and configures:
# - zsh (and sets as default shell)
# - oh-my-zsh
# - Plugins: zsh-autosuggestions, zsh-syntax-highlighting, fasd
# - fabi_new.zsh-theme
#
# Requirements: sudo access, internet connection
# Tested on: Debian/Ubuntu, Fedora, Arch, macOS
# ============================================================================

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory (where this script and theme files are located)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

print_step() {
    echo -e "${BLUE}==>${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}!${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# ============================================================================
# Detect package manager
# ============================================================================
detect_package_manager() {
    if command -v apt &> /dev/null; then
        PKG_MANAGER="apt"
        PKG_INSTALL="sudo apt install -y"
        PKG_UPDATE="sudo apt update"
    elif command -v dnf &> /dev/null; then
        PKG_MANAGER="dnf"
        PKG_INSTALL="sudo dnf install -y"
        PKG_UPDATE="sudo dnf check-update || true"
    elif command -v yum &> /dev/null; then
        PKG_MANAGER="yum"
        PKG_INSTALL="sudo yum install -y"
        PKG_UPDATE="sudo yum check-update || true"
    elif command -v pacman &> /dev/null; then
        PKG_MANAGER="pacman"
        PKG_INSTALL="sudo pacman -S --noconfirm"
        PKG_UPDATE="sudo pacman -Sy"
    elif command -v zypper &> /dev/null; then
        PKG_MANAGER="zypper"
        PKG_INSTALL="sudo zypper install -y"
        PKG_UPDATE="sudo zypper refresh"
    elif command -v brew &> /dev/null; then
        PKG_MANAGER="brew"
        PKG_INSTALL="brew install"
        PKG_UPDATE="brew update"
    else
        print_error "Could not detect package manager"
        exit 1
    fi
    print_success "Detected package manager: $PKG_MANAGER"
}

# ============================================================================
# Install zsh
# ============================================================================
install_zsh() {
    print_step "Installing zsh..."
    
    if command -v zsh &> /dev/null; then
        print_success "zsh is already installed: $(zsh --version)"
    else
        $PKG_UPDATE
        $PKG_INSTALL zsh
        print_success "zsh installed: $(zsh --version)"
    fi
}

# ============================================================================
# Install oh-my-zsh
# ============================================================================
install_ohmyzsh() {
    print_step "Installing oh-my-zsh..."
    
    if [ -d "$HOME/.oh-my-zsh" ]; then
        print_success "oh-my-zsh is already installed"
    else
        # Unattended mode: doesn't prompt for shell change or run zsh after install
        # We handle shell change ourselves
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        print_success "oh-my-zsh installed"
    fi
}

# ============================================================================
# Install fasd
# ============================================================================
install_fasd() {
    print_step "Installing fasd..."
    
    if command -v fasd &> /dev/null; then
        print_success "fasd is already installed"
    else
        case $PKG_MANAGER in
            apt)
                $PKG_INSTALL fasd
                ;;
            dnf|yum)
                $PKG_INSTALL fasd
                ;;
            pacman)
                # fasd is in AUR, try with yay or manual install
                if command -v yay &> /dev/null; then
                    yay -S --noconfirm fasd
                else
                    print_warning "fasd not in official repos, installing from source..."
                    install_fasd_from_source
                fi
                ;;
            brew)
                $PKG_INSTALL fasd
                ;;
            *)
                print_warning "Installing fasd from source..."
                install_fasd_from_source
                ;;
        esac
        print_success "fasd installed"
    fi
}

install_fasd_from_source() {
    local tmp_dir=$(mktemp -d)
    git clone --depth 1 https://github.com/clvv/fasd.git "$tmp_dir/fasd"
    cd "$tmp_dir/fasd"
    sudo make install
    cd -
    rm -rf "$tmp_dir"
}

# ============================================================================
# Install thefuck (command corrector)
# ============================================================================
install_thefuck() {
    print_step "Installing thefuck (command corrector)..."
    
    if command -v thefuck &> /dev/null; then
        print_success "thefuck is already installed"
    else
        case $PKG_MANAGER in
            apt)
                sudo apt install -y thefuck
                ;;
            dnf)
                sudo dnf install -y thefuck
                ;;
            pacman)
                sudo pacman -S --noconfirm thefuck
                ;;
            brew)
                brew install thefuck
                ;;
            *)
                # Fallback: install via pip
                if command -v pip3 &> /dev/null; then
                    pip3 install thefuck --user
                elif command -v pip &> /dev/null; then
                    pip install thefuck --user
                else
                    print_warning "Could not install thefuck (no pip found)"
                    return
                fi
                ;;
        esac
        print_success "thefuck installed (use 'pls' to correct commands)"
    fi
}

# ============================================================================
# Install fzf (fuzzy finder)
# ============================================================================
install_fzf() {
    print_step "Installing fzf (fuzzy finder)..."
    
    if command -v fzf &> /dev/null; then
        print_success "fzf is already installed"
    else
        case $PKG_MANAGER in
            apt)
                sudo apt install -y fzf
                ;;
            dnf)
                sudo dnf install -y fzf
                ;;
            pacman)
                sudo pacman -S --noconfirm fzf
                ;;
            brew)
                brew install fzf
                ;;
            *)
                # Fallback: install from git
                git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
                ~/.fzf/install --all --no-bash --no-fish
                ;;
        esac
        print_success "fzf installed (Ctrl+R for fuzzy history search)"
    fi
}

# ============================================================================
# Install bat (better cat with syntax highlighting)
# ============================================================================
install_bat() {
    print_step "Installing bat (syntax-highlighted cat)..."
    
    # bat is sometimes called 'batcat' on Debian/Ubuntu
    if command -v bat &> /dev/null || command -v batcat &> /dev/null; then
        print_success "bat is already installed"
    else
        case $PKG_MANAGER in
            apt)
                sudo apt install -y bat
                ;;
            dnf)
                sudo dnf install -y bat
                ;;
            pacman)
                sudo pacman -S --noconfirm bat
                ;;
            brew)
                brew install bat
                ;;
            *)
                print_warning "Could not install bat (unknown package manager)"
                return
                ;;
        esac
        print_success "bat installed"
    fi
}

# ============================================================================
# Install eza (modern ls replacement)
# ============================================================================
install_eza() {
    print_step "Installing eza (modern ls)..."
    
    if command -v eza &> /dev/null; then
        print_success "eza is already installed"
    else
        case $PKG_MANAGER in
            apt)
                # eza needs newer repo on Debian/Ubuntu
                sudo apt install -y gpg
                sudo mkdir -p /etc/apt/keyrings
                wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
                echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
                sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
                sudo apt update
                sudo apt install -y eza
                ;;
            dnf)
                sudo dnf install -y eza
                ;;
            pacman)
                sudo pacman -S --noconfirm eza
                ;;
            brew)
                brew install eza
                ;;
            *)
                print_warning "Could not install eza (unknown package manager)"
                return
                ;;
        esac
        print_success "eza installed (try: eza -la --icons --git)"
    fi
}

# ============================================================================
# Install Nerd Font (required for icons in eza, terminal prompts, etc.)
# ============================================================================
install_nerdfonts() {
    print_step "Installing Nerd Fonts (for terminal icons)..."
    
    local FONT_NAME="JetBrainsMono"
    local FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
    
    # Determine font directory based on OS
    if [[ "$OSTYPE" == "darwin"* ]]; then
        FONT_DIR="$HOME/Library/Fonts"
    else
        FONT_DIR="$HOME/.local/share/fonts"
    fi
    
    # Check if already installed
    if fc-list 2>/dev/null | grep -qi "JetBrainsMono Nerd Font"; then
        print_success "JetBrainsMono Nerd Font already installed"
        return
    fi
    
    # Create font directory if needed
    mkdir -p "$FONT_DIR"
    
    # Download and install
    print_step "Downloading JetBrainsMono Nerd Font..."
    local TEMP_DIR=$(mktemp -d)
    
    if command -v wget &> /dev/null; then
        wget -q --show-progress -O "$TEMP_DIR/$FONT_NAME.zip" "$FONT_URL"
    elif command -v curl &> /dev/null; then
        curl -L --progress-bar -o "$TEMP_DIR/$FONT_NAME.zip" "$FONT_URL"
    else
        print_warning "Neither wget nor curl found. Cannot download fonts."
        rm -rf "$TEMP_DIR"
        return
    fi
    
    # Extract fonts (only .ttf files, skip Windows-compatible fonts)
    print_step "Extracting fonts..."
    unzip -q "$TEMP_DIR/$FONT_NAME.zip" -d "$TEMP_DIR/fonts"
    
    # Copy only regular TTF files (not Windows-compatible ones)
    find "$TEMP_DIR/fonts" -name "*.ttf" ! -name "*Windows*" -exec cp {} "$FONT_DIR/" \;
    
    # Cleanup
    rm -rf "$TEMP_DIR"
    
    # Refresh font cache (Linux only)
    if [[ "$OSTYPE" != "darwin"* ]]; then
        if command -v fc-cache &> /dev/null; then
            print_step "Refreshing font cache..."
            fc-cache -f "$FONT_DIR"
        fi
    fi
    
    print_success "JetBrainsMono Nerd Font installed"
    echo "  NOTE: You may need to configure your terminal to use 'JetBrainsMono Nerd Font'"
}

# ============================================================================
# Install zsh plugins
# ============================================================================
install_plugins() {
    print_step "Installing zsh plugins..."
    
    local ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    
    # zsh-autosuggestions
    if [ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
        print_success "zsh-autosuggestions already installed"
    else
        git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
        print_success "zsh-autosuggestions installed"
    fi
    
    # zsh-syntax-highlighting
    if [ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
        print_success "zsh-syntax-highlighting already installed"
    else
        git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
        print_success "zsh-syntax-highlighting installed"
    fi
}

# ============================================================================
# Install theme
# ============================================================================
install_theme() {
    print_step "Installing fabi_new theme..."
    
    local ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    local THEME_SRC="$SCRIPT_DIR/zsh/fabi_new.zsh-theme"
    local THEME_DST="$ZSH_CUSTOM/themes/fabi_new.zsh-theme"
    
    mkdir -p "$ZSH_CUSTOM/themes"
    
    if [ -f "$THEME_SRC" ]; then
        cp "$THEME_SRC" "$THEME_DST"
        print_success "Theme installed to $THEME_DST"
    else
        print_error "Theme file not found: $THEME_SRC"
        print_warning "Skipping theme installation"
    fi
}

# ============================================================================
# Configure .zshrc
# ============================================================================
configure_zshrc() {
    print_step "Configuring .zshrc..."
    
    local ZSHRC_SRC="$SCRIPT_DIR/zsh/.zshrc"
    local ZSHRC_DST="$HOME/.zshrc"
    
    # Backup existing .zshrc if it exists
    if [ -f "$ZSHRC_DST" ]; then
        local backup_file="$HOME/.zshrc.backup.$(date +%Y%m%d_%H%M%S)"
        cp "$ZSHRC_DST" "$backup_file"
        print_success "Backed up existing .zshrc to $backup_file"
    fi
    
    # Copy .zshrc from repo
    if [ -f "$ZSHRC_SRC" ]; then
        cp "$ZSHRC_SRC" "$ZSHRC_DST"
        print_success ".zshrc installed from $ZSHRC_SRC"
    else
        print_error ".zshrc not found at $ZSHRC_SRC"
        print_warning "Creating minimal .zshrc..."
        cat > "$ZSHRC_DST" << 'ZSHRC_FALLBACK'
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="fabi_new"
plugins=(git sudo fasd zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh
ZSHRC_FALLBACK
    fi
}

# ============================================================================
# Change default shell
# ============================================================================
change_default_shell() {
    print_step "Setting zsh as default shell..."
    
    local zsh_path=$(which zsh)
    
    # Check if zsh is in /etc/shells
    if ! grep -q "$zsh_path" /etc/shells 2>/dev/null; then
        echo "$zsh_path" | sudo tee -a /etc/shells > /dev/null
        print_success "Added $zsh_path to /etc/shells"
    fi
    
    # Change shell
    if [ "$SHELL" = "$zsh_path" ]; then
        print_success "zsh is already the default shell"
    else
        chsh -s "$zsh_path"
        print_success "Default shell changed to zsh"
        print_warning "Log out and log back in for the change to take effect"
    fi
}

# ============================================================================
# Main
# ============================================================================
main() {
    echo ""
    echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}           Zsh All-in-One Installer                         ${BLUE}║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    detect_package_manager
    install_zsh
    install_ohmyzsh
    install_fasd
    install_thefuck
    install_fzf
    install_bat
    install_eza
    install_nerdfonts
    install_plugins
    install_theme
    configure_zshrc
    change_default_shell
    
    echo ""
    echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║${NC}           Installation Complete!                           ${GREEN}║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo "Quick reference:"
    echo "  j <dir>     - Jump to frequently used directory"
    echo "  jj <dir>    - Jump to subdirectory of current dir"
    echo "  v <file>    - Edit frequently used file with vim"
    echo "  d <dir>     - Print directory path (for cp/mv)"
    echo "  pls         - Correct previous failed command (thefuck)"
    echo "  copypath    - Copy current directory to clipboard"
    echo "  extract <f> - Extract any archive"
    echo "  Ctrl+R      - Fuzzy search command history (fzf)"
    echo "  Ctrl+T      - Fuzzy search files (fzf)"
    echo "  cat <file>  - View file with syntax highlighting (bat)"
    echo "  eza -la     - Modern ls with git status (try: eza --icons)"
    echo "  Ctrl+Space  - Accept autosuggestion"
    echo "  Ctrl+J      - Accept and execute autosuggestion"
    echo "  ESC ESC     - Add sudo to current command"
    echo ""
    echo "Log out and log back in, or run: exec zsh"
    echo ""
}

main "$@"
