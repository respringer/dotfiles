" on ubuntu, install vim-gtk to enable the clipboard
set ts=4
set shiftwidth=4
set ruler
set expandtab
set hlsearch
set clipboard=unnamedplus
"set mouse=a
set t_Co=256 
set paste

"set ignorecase
"set smartcase

syntax enable

filetype plugin indent on

set background=dark

map <f2> :w<CR>
map <f4> :nohl<CR>
map <f8> :q<CR>

autocmd BufNewFile,BufRead *.json set ft=javascript
autocmd BufNewFile,BufRead *.boot set ft=clojure

"inoremap fj <esc>
"inoremap jf <esc>
"
"inoremap jk <esc>
"inoremap kj <esc>
"



set nobackup
set nowritebackup
set noswapfile 

