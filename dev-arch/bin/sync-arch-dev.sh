#!/bin/bash
cp -R ~/.config/fish ~/dotfiles/dev-arch/.config
cp -R ~/.config/i3 ~/dotfiles/dev-arch/.config
cp -R ~/.config/omf  ~/dotfiles/dev-arch/.config
cp -R ~/.config/termite ~/dotfiles/dev-arch/.config

cp -R ~/bin ~/dotfiles/dev-arch/

cd ~/dotfiles/dev-arch
git add ./.emacs
git commit -m"dev-arch .emacs update"
git push
