#!/bin/bash
mkdir ~/bin
cp .vimrc ~/.vimrc
# Maybe not the best idea
#cp .bashrc ~/.bashrc
cp .gitconfig ~/.gitconfig

# Set up vim-plug

curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Done

echo "All done, please: source ~/.bashrc"
