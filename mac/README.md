## packages will typically be installed by homebrew

## emacs
# clone the git repo then
autogen.sh
./configure --with-ns
# if the ./configure output has lxml2, then you get eww
make
sudo make install

## spacemacs
# mv ~/.emacs.d ~/old-emacs-d
git clone --recursive https://github.com/syl20bnr/spacemacs ~/.emacs.d

## fix the powerline in emacs 25
# comment out the line that contains "chamfer" in ~/.emacs.d/spacemacs/packages.el
# also, you may need to comment out a (package-initialize) from the top of ~/.emacs.d/spacemacs/init.el
# this package-initialize is automatically added by emacs, and does not seem to be part of spacemacs

## gui tweaking
#
# I recommend spectacle and toggle-osx-shadows
