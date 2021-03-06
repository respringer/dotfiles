
call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-rsi'
Plug 'justinmk/vim-sneak'
call plug#end()

let mapleader = "\<Space>"

set ts=4
set shiftwidth=4
set ruler
set expandtab
set hlsearch
set clipboard=unnamed
"set mouse=a
set t_Co=256 

"set ignorecase
"set smartcase

syntax enable

filetype plugin indent on

set background=dark

nnoremap <Leader>w :w<CR>
nnoremap <Leader>q :wq<CR>

map <f2> :w<CR>
map <f4> :nohl<CR>
map <f8> :q<CR>

autocmd BufNewFile,BufRead *.json set ft=javascript

"inoremap fj <esc>
"inoremap jf <esc>
"
"inoremap jk <esc>
"inoremap kj <esc>
"



set nobackup
set nowritebackup
set noswapfile 

