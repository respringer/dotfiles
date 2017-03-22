filetype plugin indent on

set ts=4
set shiftwidth=4
set expandtab
set ruler

set hlsearch
set clipboard=unnamed
set clipboard+=unnamedplus
"set mouse=a
set t_Co=256 
set paste

syntax enable
set background=dark

map <f2> :w<CR>
map <f4> :nohl<CR>
map <f8> :q<CR>

autocmd BufNewFile,BufRead *.json set ft=javascript
autocmd BufNewFile,BufRead *.boot set ft=clojure

set nobackup
set nowritebackup
set noswapfile 

