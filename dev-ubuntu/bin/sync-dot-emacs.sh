#!/bin/bash
cp ~/.emacs ~/dotfiles/dev-ubuntu
cd ~/dotfiles/dev-ubuntu
git add ./.emacs
git commit -m".emacs update"
git push
