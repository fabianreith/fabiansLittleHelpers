# 🚀 Fabian's Terminal Config

A curated collection of terminal configurations for zsh, vim, and tmux. One-command setup for a productive terminal environment.

## ✨ Features

- **Zsh** with oh-my-zsh, beautiful minimal theme, and productivity plugins
- **Vim** configuration with sensible defaults
- **Tmux** modern config with intuitive keybindings
- **Tools**: fasd (directory jumping), fzf (fuzzy finder), bat (better cat), eza (modern ls), thefuck (command correction)

## 🎯 Quick Start

### Full Setup (New Machine)

```bash
git clone https://github.com/fabianreith/fabiansLittleHelpers.git
cd fabiansLittleHelpers
./install_zsh_AIO.sh
```

This installs and configures:
- zsh + oh-my-zsh
- fabi_new theme
- All plugins and tools
- Sets zsh as default shell

After installation, log out and back in (or run `exec zsh`).

### Individual Components

```bash
./install_vim.sh    # Install vim + .vimrc
./install_tmux.sh   # Install tmux + .tmux.conf
```

### No Root Access?

Use the local tmux installer (compiles from source):
```bash
./install_tmux_local.sh
```

## 🎨 What You Get

### Zsh Theme (fabi_new)

Minimal prompt showing only what matters:
```
~/projects/myapp master        # Clean: path + git branch
fabian@server ~/path master    # SSH: user@host shown
~/path ↓2                      # Background jobs indicator
```

### Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Ctrl+R` | Fuzzy search command history (fzf) |
| `Ctrl+T` | Fuzzy search files (fzf) |
| `Ctrl+Space` | Accept autosuggestion |
| `Ctrl+J` | Accept and execute autosuggestion |
| `ESC ESC` | Add sudo to current command |
| `Alt+.` | Insert last argument from previous command |

### Commands & Aliases

| Command | Description |
|---------|-------------|
| `j <dir>` | Jump to frequently used directory |
| `ji <dir>` | Interactive jump (shows choices) |
| `jj <dir>` | Jump within current directory tree |
| `v <file>` | Open frequently used file in vim |
| `pls` | Correct previous failed command (thefuck) |
| `extract <file>` | Extract any archive (tar, zip, gz, etc.) |
| `copypath` | Copy current directory path to clipboard |
| `ls` | eza with colors (modern ls replacement) |
| `ll` | eza long format with hidden files |
| `la` | eza all files |
| `lt` | eza tree view (2 levels) |

### Global Aliases

Works anywhere in the command:
```bash
ls G pattern     # → ls | grep pattern
cat file L       # → cat file | less
cat file H       # → cat file | head
cat file T       # → cat file | tail
ls C             # → ls | wc -l
```

### Vim Keybindings

| Keybind | Action |
|---------|--------|
| `Ctrl+J` | Save file |
| `Space+q` | Quit |
| `Space+d` | Force quit (discard changes) |
| `F2` | Toggle paste mode |
| `Ctrl+H/J/K/L` | Navigate splits |
| `Space+w` | Save file |

### Tmux Keybindings

| Keybind | Action |
|---------|--------|
| `Ctrl+A` | Prefix (instead of Ctrl+B) |
| `Alt+Arrow` | Switch panes without prefix |
| `Ctrl+H` | Previous window |
| `Ctrl+L` | Next window |
| Mouse | Enabled for scrolling/selecting |

## 📁 Repository Structure

```
.
├── install_zsh_AIO.sh      # All-in-one zsh installer
├── install_vim.sh          # Vim installer
├── install_tmux.sh         # Tmux installer (with sudo)
├── install_tmux_local.sh   # Tmux installer (no root needed)
├── .vimrc                  # Vim configuration
├── .tmux.conf              # Tmux configuration
├── zsh/
│   ├── .zshrc              # Zsh configuration
│   ├── fabi_new.zsh-theme  # Main theme
│   ├── fabi_no_git_status.zsh-theme  # Fallback theme
│   └── other_themes/       # Alternative themes
├── ssh/
│   ├── config_file_ssh     # Example SSH config
│   └── important_commands  # SSH command reference
├── bash_scripts/           # Utility scripts
├── local_fasd/             # Fasd for non-root install
└── nvidia-htop/            # GPU monitoring tool
```

## 🔧 Installed Tools

| Tool | Description | Install command |
|------|-------------|-----------------|
| [fasd](https://github.com/clvv/fasd) | Quick directory/file access | `apt install fasd` |
| [fzf](https://github.com/junegunn/fzf) | Fuzzy finder | `apt install fzf` |
| [bat](https://github.com/sharkdp/bat) | Better cat with syntax highlighting | `apt install bat` |
| [eza](https://github.com/eza-community/eza) | Modern ls with colors & git status | `apt install eza` |
| [thefuck](https://github.com/nvbn/thefuck) | Command correction | `apt install thefuck` |

## 🔌 Zsh Plugins

| Plugin | Description |
|--------|-------------|
| git | Git aliases (gst, gco, gp, etc.) |
| sudo | Double-tap ESC to add sudo |
| extract | Universal archive extractor |
| copypath | Copy current path to clipboard |
| colored-man-pages | Colorful man pages |
| fasd | Directory/file jumping |
| fzf | Fuzzy finder integration |
| zsh-autosuggestions | Fish-like suggestions |
| zsh-syntax-highlighting | Command highlighting |

## 🖥️ Compatibility

Tested on:
- Ubuntu/Debian
- Raspberry Pi OS
- Fedora
- macOS

## 📝 Manual Configuration

### SSH Config

Copy the example SSH config:
```bash
cp ssh/config_file_ssh ~/.ssh/config
# Edit with your servers
```

### Rsync Examples

See `rsync.sh` and `win_rsync.sh` for rsync command templates.

## ❓ Troubleshooting

### Git status errors in prompt

Switch to the no-git theme:
```bash
# In ~/.zshrc, change:
ZSH_THEME="fabi_no_git_status"
```

### thefuck not working

Ensure it's installed and run:
```bash
thefuck --alias pls
```

### fasd not tracking directories

Run a few `cd` commands - fasd needs history to work:
```bash
cd /some/directory
cd /another/path
j anoth  # Now it works!
```

## 📜 License

MIT License - feel free to use and modify!

---

*Made with ❤️ for a better terminal experience*
