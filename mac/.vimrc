" To install vim-plug:
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

call plug#begin('~/.vim/plugged')

" rsi mode gives emacs keybindings in insert mode

call plug#end()

set ts=4
set shiftwidth=4
set expandtab
set ruler
set paste
set hlsearch
" for mac ?
"set clipboard=unnamed
set t_Co=256 

syntax enable

filetype plugin indent on

set background=dark

autocmd BufNewFile,BufRead *.json set ft=javascript

map <f2> :w<CR>
map <f4> :nohl<CR>
map <f8> :q<CR>

"inoremap fj <esc>
"inoremap jf <esc>

"inoremap jk <esc>
"inoremap kj <esc>

set nobackup
set nowritebackup
set noswapfile 
