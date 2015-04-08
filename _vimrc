set nocompatible

set encoding=utf-8 nobomb

set modeline
set modelines=5

if filereadable(expand("~/.vim/autoload/pathogen.vim"))
    runtime! autoload/pathogen.vim
    if exists("g:loaded_pathogen")
       execute pathogen#infect()
    endif
endif

if has("autocmd")
    filetype on
    filetype indent on
    filetype plugin on
endif

if has("cmdline_info")
    set ruler
    set showcmd
    set showmode
endif

if has("extra_search")
    set hlsearch
    set incsearch
    set ignorecase
    set smartcase
endif

if has('statusline')
    set laststatus=2
    set statusline=%<%f
    set statusline+=\ %w%h%m%r
    set statusline+=\ [%{getcwd()}]
    set statusline+=%=%-14.(%l,%c%V%)\ %p%%
endif

if has("syntax")
    syntax enable
    "set t_Co=256
    set bg=dark
endif

if has("wildmenu")
    set wildmenu
    set wildmode=longest,list
endif

au FileType json setlocal equalprg=python\ -m\ json.tool
com! FormatJSON %!python -m json.tool
