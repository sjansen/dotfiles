" based on:
" https://gist.github.com/subfuzion/7d00a6c919eeffaf6d3dbf9a4eb11d64
"
set nocompatible
set encoding=utf-8 nobomb

set autoindent
set cc=80
set hlsearch
set ignorecase
set mouse=v
set number
set showmatch
set splitbelow
set splitright
set wildmode=longest,list

set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=8

filetype plugin indent on
syntax on

call plug#begin()
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'editorconfig/editorconfig-vim'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'godlygeek/tabular'
Plug 'hrsh7th/nvim-compe' " neorg depenency
Plug 'kristijanhusak/orgmode.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/plenary.nvim' " neorg depenency
Plug 'plasticboy/vim-markdown'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'vhyrro/neorg'
Plug 'vim-airline/vim-airline'
call plug#end()

autocmd BufEnter * setlocal cursorline
autocmd WinEnter * setlocal cursorline
autocmd BufLeave * setlocal nocursorline
autocmd WinLeave * setlocal nocursorline

" Auto start NERD tree when opening a directory
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | wincmd p | endif
" Auto start NERD tree if no files are specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | exe 'NERDTree' | endif
" Let quit work as expected if after entering :q the only window left open is NERD Tree itself
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

let g:go_def_mode='gopls'
let g:go_info_mode='gopls'
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:vim_markdown_folding_disabled = 1
let mapleader=";"

lua << EOF
  require('compe').setup {
    source = {
      orgmode = true
    }
  }
  require('neorg').setup {
    load = {
      ["core.defaults"] = {},
      ["core.norg.concealer"] = {},
      ["core.norg.dirman"] = {
        config = {
          workspaces = {
            notes = "~/Projects/notes"
          }
        }
      }
    },
  }
  require('orgmode').setup{}
EOF

function! Light()
    echom "set bg=light"
    set bg=light
    colorscheme off
    set list
endfunction

function! Dark()
    echom "set bg=dark"
    set bg=dark
    colorscheme darcula
    "darcula fix to hide the indents:
    set nolist
endfunction

function! ToggleLightDark()
  if &bg ==# "light"
    call Dark()
  else
    call Light()
  endif
endfunction
