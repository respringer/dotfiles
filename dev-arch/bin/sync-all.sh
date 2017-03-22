#!/bin/bash
~/bin/sync-dot-emacs

cp -R ~/.config/fish ~/dotfiles/dev-arch/.config
cp -R ~/.config/i3 ~/dotfiles/dev-arch/.config
cp -R ~/.config/omf  ~/dotfiles/dev-arch/.config
cp -R ~/.config/termite ~/dotfiles/dev-arch/.config

cp -R ~/bin ~/dotfiles/dev-arch/
cp ~/.gitconfig ~/grive
cp ~/.gitignore ~/grive
cp ~/.automaton.conf ~/grive
cp ~/.bashrc ~/grive
cp ~/.ssh ~/grive/work-ssh

cp ~/.vimrc ~/dotfiles/dev-arch
cp ~/.emacs ~/dotfiles/dev-arch
cp ~/.xinitrc ~/dotfiles/dev-arch

cd ~/dotfiles/dev-arch
git add .
git commit -m"dev-arch update"
git push

# Do a grive update

cd ~/grive && grive

echo "Grive synced"
