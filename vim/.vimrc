" Plugin manager: vim-plug
call plug#begin('~/.vim/plugged')
" Basic plugins
Plug 'tpope/vim-sensible'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'scrooloose/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-commentary'
Plug 'airblade/vim-gitgutter'
Plug 'sheerun/vim-polyglot'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'norcalli/nvim-colorizer.lua'
call plug#end()

let mapleader=","  " easier leader key
let g:python3_host_prog = '/opt/homebrew/opt/python@3.14/bin/python3.14'  " point Neovim/Vim to Python 3 host

" General settings
syntax on
filetype plugin indent on
set termguicolors
set background=dark
set number relativenumber
set cursorline
set hlsearch
set incsearch
set ignorecase smartcase
set tabstop=4 shiftwidth=4 expandtab
set clipboard=unnamedplus
set splitright splitbelow

" Theme (custom colors live in .vim/colors)
if filereadable(expand('~/.vim/colors/azimuth_night.vim'))
  colorscheme azimuth_night
endif

" Enable hex color highlighting if Lua is available
if has('nvim') || has('lua')
  lua << EOF
  require('colorizer').setup()
EOF
endif

" NERDTree toggle
nnoremap <leader>n :NERDTreeToggle<CR>

" FZF for file search
nnoremap <leader>p :Files<CR>

" CoC settings for autocompletion and LSP
inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <silent><expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
let g:coc_global_extensions = ['coc-snippets', 'coc-pairs', 'coc-json', 'coc-tsserver', 'coc-python']

" Airline theme
let g:airline_theme='dark'
let g:airline_powerline_fonts = 1

" Automatically start NERDTree if no files specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif
