## package install list for dev with ubuntu 14.04 LTS
# sudo apt-get install tmux

## i3 stuff
# sudo apt-get install i3

## konsole stuff

## emacs stuff
# sudo apt-get install emacs24
## unzip needed for cider 
# sudo apt-get install unzip

# Put this in .lein/profiles.clj
 {:user
  {:plugins
     [[cider/cider-nrepl "0.9.0"]]
   :dependencies
     [[org.clojure/tools.nrepl "0.2.10"]]}}
