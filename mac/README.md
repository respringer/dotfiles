## packages will typically be installed by homebrew

## emacs
# clone the git repo then
autogen.sh
./configure --with-ns
# if the ./configure output has lxml2, then you get eww
make
make install
# sudo cp -R Emacs.app from the nextstep folder to /Applications
