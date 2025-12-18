# ============================================================================
# Zsh Configuration
# ============================================================================

# Path to oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# oh-my-zsh update settings
zstyle ':omz:update' mode auto      # Auto-update silently in background
zstyle ':omz:update' frequency 30   # Check for updates every 30 days

# Theme - fabi_new with git status, background jobs, and return status indicators
# Alternative: fabi_no_git_status (if git status causes issues)
ZSH_THEME="fabi_new"

# Plugins
# - git: git aliases and functions  
# - sudo: press ESC twice to add sudo to current/previous command
# - extract: extract any archive with 'extract <file>' (tar, zip, gz, bz2, etc.)
# - copypath: 'copypath' copies current directory path to clipboard
# - colored-man-pages: colorful man pages
# - fasd: quick access to frequent files/directories (j, z, v commands)
# - fzf: fuzzy finder (Ctrl+R for history, Ctrl+T for files)
# - zsh-autosuggestions: fish-like autosuggestions
# - zsh-syntax-highlighting: syntax highlighting (must be last)
plugins=(
    git
    sudo
    extract
    copypath
    colored-man-pages
    fasd
    fzf
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# ============================================================================
# User Configuration
# ============================================================================

# Preferred editor
export EDITOR='vim'

# Custom aliases
# eza - modern ls replacement (https://github.com/eza-community/eza)
if command -v eza &> /dev/null; then
    alias ls='eza'
    alias ll='eza -la'
    alias la='eza -a'
    alias lt='eza --tree --level=2'
else
    alias ls='ls -aF --color=auto'
fi

# Global aliases - work anywhere in command line, not just at start
# Usage: ls G txt → ls | grep txt
alias -g G='| grep'      # grep
alias -g L='| less'      # less
alias -g H='| head'      # head
alias -g T='| tail'      # tail
alias -g C='| wc -l'     # count lines

# bat - better cat with syntax highlighting
# On Debian/Ubuntu it's installed as 'batcat', elsewhere as 'bat'
if command -v batcat &> /dev/null; then
    alias cat='batcat --style=plain --paging=never'
    alias bat='batcat'
elif command -v bat &> /dev/null; then
    alias cat='bat --style=plain --paging=never'
fi

# fasd shortcuts (in addition to oh-my-zsh fasd plugin defaults)
# j <pattern>  - jump to best matching directory (auto-selects highest score)
# ji <pattern> - interactive jump (shows list when multiple matches)
# jj <pattern> - jump to subdirectory of current dir matching pattern  
# v <pattern>  - open file matching pattern in vim
# vv <pattern> - open file in current dir matching pattern in vim
# d <pattern>  - print directory path matching pattern (useful: cp file $(d target))
alias j='z'                       # Always jump to best match (no prompt)
alias ji='fasd_cd -d'             # Interactive mode (shows choices)
alias jj='fasd_cd -d $(pwd)'
alias vv='fasd -f -e vim $(pwd)'
alias d='fasd -d -e echo'

# zsh-autosuggestions keybindings
bindkey '^ ' autosuggest-accept    # Ctrl+Space to accept suggestion
bindkey '^j' autosuggest-execute   # Ctrl+J to accept and execute

# History options
setopt HIST_IGNORE_SPACE           # Don't save commands starting with space
setopt HIST_IGNORE_ALL_DUPS        # Remove ALL duplicate entries from history

# thefuck - correct previous command (SFW alias: pls)
# Usage: type 'pls' after a failed command to auto-correct it
if command -v thefuck &> /dev/null; then
    eval $(thefuck --alias pls)
fi
