#!/bin/bash
mkdir -p ~/bin
cp .vimrc ~/.vimrc
cp .emacs ~/.emacs
cp .bashrc ~/.bashrc
cp .lein ~/.lein
cp .gitconfig ~/.gitconfig

# Set up vim-plug

curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# packages

sudo add-apt-repository ppa:ubuntu-elisp/ppa
sudo apt-get update
sudo apt-get install emacs-snapshot

if [[ `lsb_release -rs` == "12.04" ]] 
then
sudo apt-add-repository ppa:lvillani/silversearcher
sudo apt-get update
fi

sudo apt-get install silversearcher-ag


# Done

echo "All done, please: source ~/.bashrc"
