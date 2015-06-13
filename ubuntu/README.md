## package install list for ubuntu 14.04 LTS

sudo apt-get install tmux

## i3 stuff

sudo apt-get install i3

## konsole stuff

## emacs stuff, live dangerously with the daily snapshot

sudo add-apt-repository -y ppa:ubuntu-elisp
sudo apt-get update
sudo apt-get install emacs-snapshot

## copy my .spacemacs to ~
## get the latest copy of spacemacs 

git clone --recursive https://github.com/syl20bnr/spacemacs ~/.emacs.d

## spacemacs to-do
## 1. tab control
## 2. make sure scrolling is good
## 3. buffer management
## 4. powerline in ubuntu

