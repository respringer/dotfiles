#!/bin/bash
mkdir -p ~/bin
cp .vimrc ~/.vimrc
cp .bashrc ~/.bashrc
cp .gitconfig ~/.gitconfig

# Set up vim-plug

curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Done

echo "All done, please: source ~/.bashrc"
