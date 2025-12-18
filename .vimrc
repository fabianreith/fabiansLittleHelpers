" ============================================================================
" Vim Configuration
" ============================================================================

" ----------------------------------------------------------------------------
" Basic Settings
" ----------------------------------------------------------------------------
syntax on                       " Enable syntax highlighting
filetype plugin indent on       " Enable filetype detection, plugins & indenting
set nocompatible                " Use Vim defaults (not Vi)
set encoding=utf-8              " Use UTF-8 encoding
set backspace=indent,eol,start  " Make backspace work normally

" ----------------------------------------------------------------------------
" UI Settings
" ----------------------------------------------------------------------------
" set number                    " Show line numbers (disabled)
" set relativenumber            " Relative line numbers (disabled)
set cursorline                  " Highlight current line
set showmatch                   " Highlight matching brackets
set showcmd                     " Show command in bottom bar
set wildmenu                    " Visual autocomplete for command menu
set laststatus=2                " Always show status line
set scrolloff=8                 " Keep 8 lines visible above/below cursor
set background=dark             " Assume dark terminal background

" ----------------------------------------------------------------------------
" Search Settings
" ----------------------------------------------------------------------------
set ignorecase                  " Case-insensitive search...
set smartcase                   " ...unless search contains uppercase
set hlsearch                    " Highlight search results
set incsearch                   " Show matches as you type

" Clear search highlight with Escape
nnoremap <silent> <Esc> :nohlsearch<CR>

" ----------------------------------------------------------------------------
" Indentation & Tabs
" ----------------------------------------------------------------------------
set autoindent                  " Copy indent from current line
set smartindent                 " Smart autoindenting for new lines
set expandtab                   " Use spaces instead of tabs
set tabstop=4                   " Tab = 4 spaces
set shiftwidth=4                " Indent = 4 spaces
set softtabstop=4               " Backspace through spaces like tabs

" ----------------------------------------------------------------------------
" Mouse & Clipboard
" ----------------------------------------------------------------------------
set mouse=a                     " Enable mouse in all modes
set clipboard=unnamedplus       " Use system clipboard

" ----------------------------------------------------------------------------
" Paste Handling (fix formatting issues when pasting)
" ----------------------------------------------------------------------------
" Bracketed paste: auto-detect paste vs typing (modern terminals)
if &term =~ "xterm" || &term =~ "screen" || &term =~ "tmux"
    let &t_BE = "\e[?2004h"     " Enable bracketed paste mode
    let &t_BD = "\e[?2004l"     " Disable bracketed paste mode
    let &t_PS = "\e[200~"       " Paste start sequence
    let &t_PE = "\e[201~"       " Paste end sequence
endif

" Fallback: F2 toggles paste mode manually
set pastetoggle=<F2>

" ----------------------------------------------------------------------------
" Splits
" ----------------------------------------------------------------------------
set splitbelow                  " Open horizontal splits below
set splitright                  " Open vertical splits to the right

" ----------------------------------------------------------------------------
" Leader Key
" ----------------------------------------------------------------------------
let mapleader=" "               " Use space as leader key

" ----------------------------------------------------------------------------
" Key Mappings
" ----------------------------------------------------------------------------
" Save file with Ctrl+J (insert and normal mode)
inoremap <C-j> <Esc>:w<CR>
nnoremap <C-j> :w<CR>

" Quick quit/force quit with leader
nnoremap <leader>q :q<CR>
nnoremap <leader>d :q!<CR>

" Quick save with leader
nnoremap <leader>w :w<CR>

" Navigate splits with Ctrl+hjkl
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <C-k> <C-w>k
" Note: <C-j> is used for save, so omitted here

" ----------------------------------------------------------------------------
" Plugins (uncomment to enable)
" ----------------------------------------------------------------------------
" Using native Vim 8+ packages: put plugins in ~/.vim/pack/plugins/start/
" Or use a plugin manager like vim-plug:
" call plug#begin('~/.vim/plugged')
" Plug 'tpope/vim-sensible'
" Plug 'preservim/nerdtree'
" call plug#end()
