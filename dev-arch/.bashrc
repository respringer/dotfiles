# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export XDG_CONFIG_HOME="~/.config"

alias c="cd"
alias b="cd .."
alias bb="cd ../.."

alias sb="source ~/.bashrc"
alias vb="vi ~/.bashrc"

alias ls="ls -a --color=always"
alias l="ls -al --color=always"
#alias ls="ls -a --color=never"
#alias l="ls -al --color=never"

alias gs="git status"
alias gsu="git submodule update"
alias gc="git commit"
alias gb="git branch"
alias gcl="git clean -dff"

# Leet Promptness
C0="\[\e[0m\]"
C1="\[\e[1;30m\]" # <- subdued color
C2="\[\e[1;37m\]" # <- regular color
C3="\[\e[1;32m\]" # <- hostname color
C4="\[\e[1;34m\]" # <- seperator color (..[ ]..)
#PROMPT='\$'
PROMPT='>'
export PS1="$C3$C4..( $C2\u$C1@$C3\h$C1($C2\l$C1): $C2\w$C1$C1 : $C2\t$C1 $C4)..\n$C3$C2$PROMPT$C1$PROMPT$C0 "
export PS1=">> "

export EDITOR="vim"

alias s="sudo su"
shopt -s autocd

# kill opscenter
alias ko="killall python2.7; ps aux | grep -i twi"

# Remove cluster configs
alias rc="rm -rf ~/ripcord/opscenterd/local/clusters/*"

# Rebuild js
alias rj="cd ~/ripcord/opscenterd && ant build-static"

# Rebuild ui
alias ru="cd ~/ripcord/opscenterd && ant ui"

# restart opscenterd
alias ro="cd ~/ripcord/opscenterd && ./bin/opscenter"

alias pst="ps aux | grep -i twi"
alias cloud="cd ~/ripcord/opscenterd/src/opscenterd/cloud"
alias cluster="cd ~/ripcord/opscenterd/src/opscenterd/cluster"
alias widgets="cd ~/ripcord/opscenterd/src/js/ripcord/widgets"
alias controls="cd ~/ripcord/opscenterd/src/js/ripcord/controls"
alias yfail="vi ~/ripcord/opscenterd/src/build/build-report.txt"


#eval "$(hub alias -s)"

#alias vi="echo 'use emacs instead'"

# usually good enough for standalone spock
#export JAVA_OPTS="-XX:MaxPermSize=128m"

# opscd-jvm + spock
#export JAVA_OPTS="-XX:MaxPermSize=256m"
#export JAVA_OPTS="-XX:MaxPermSize=512m"
#export JAVA_OPTS="-XX:MaxPermSize=1024m"
#export JAVA_OPTS="-XX:PermSize=1024m -XX:MaxPermSize=4096m"
#export JAVA_OPTS="-XX:PermSize=512m -XX:MaxPermSize=512m -XX:MaxPermGen:256m"
#export JAVA_OPTS="-XX:PermSize=1024m -XX:MaxPermSize=1024m -XX:MaxPermGen:1024m"
#export JAVA_OPTS="-XX:PermSize=1024m -XX:MaxPermSize=1024m -XX:MaxPermGen:1024m -XX:+CMSClassUnloadingEnabled -XX:+CMSPermGenSweepingEnabled"
#export JAVA_OPTS="-XX:PermSize=1024m -XX:MaxPermSize=1024m -XX:MaxPermGen:1024m -XX:+HeapDumpOnOutOfMemoryError  -XX:HeapDumpPath=/home/ryan/heapdumps/"
#export JAVA_OPTS="-XX:PermSize=1024m -XX:MaxPermSize=1024m -XX:+HeapDumpOnOutOfMemoryError"

alias e="cd ~/ripcord/spock && emacs &"
alias eb="emacs ~/.bashrc"

alias rs="rm -f /var/tmp/spock/spock.db && lein run http serve"
alias ru="rm -f /var/tmp/spock/spock.db && java -jar ./target/spock-0.1.0-SNAPSHOT-standalone.jar http serve"
alias ro="rm -f /var/tmp/spock/spock.db && cd ~/ripcord/opscenterd && ./bin/opscenter -f"
alias ro="rm -f ~/ripcord/opscenterd/lcm.db && cd ~/ripcord/opscenterd && ./bin/opscenter -f"

alias redeployjar="cd ~/ripcord/spock && lein uberjar && cp ~/ripcord/spock/target/spock-0.1.0-SNAPSHOT.jar ~/ripcord/opscenterd/lib/jvm/spock/spock/0.1.0-SNAPSHOT/"

alias doreq="curl -L http://10.0.2.15:8888/spock/api/v1/actions/"


alias vt="vi ~/todo"


alias gdc="git diff --cached"

#alias vi="echo 'vi is a bad idea, you are probably inside of ansi-term'"
alias reallyusevi="/usr/bin/vim"

alias r="cd /home/ryan/ripcord"
alias V="vim"
alias lsf="sudo lxc-ls --fancy | grep '^ubu ' | tr -s ' ' | cut -d' ' -f 3"
#alias ubu="ssh ubuntu@`sudo lxc-ls --fancy | grep '^ubu ' | tr -s ' ' | cut -d' ' -f 3`"
alias grh="git reset --hard"
alias msg="notify-send -u critical"
alias rdb="rm -rf /var/tmp/spock/spock.db"
alias sdb="sqlite3 /var/tmp/spock/spock.db"
alias ru="sudo /root/refresh-ubu"
alias rdt="run-dse-test"
#alias si="cd ~/ripcord/spock && lein with-profile build install"
alias si="cd ~/ripcord/spock && lein with-profile build,install install"
alias rmc="rm -rf ~/ripcord/opscenterd/local/clusters/*"
alias p="pwd"
alias k1="kill %1"

export PATH=$PATH:/home/ryan/intellij/idea-IC-143.1821.5/bin
export PATH=$PATH:/home/ryan/git-repos/automaton/bin
export PYTHONPATH=${PYTHONPATH}:/home/ryan/git-repos/automaton
#export PYTHONPATH=/home/ryan/git-repos/automaton:${PYTHONPATH}

export PATH=$PATH:/home/ryan/git-repos/gingham:~/ec/eclipse

alias sl="sqlite3 /home/ryan/ripcord/opscenterd/lcm.db"
alias cpr="curl localhost:8888/api/v1/provisioning/"

setxkbmap -rules evdev -model evdev -layout us -variant altgr-intl


export PATH=~/bin:$PATH
alias vi="vim"
source /usr/share/nvm/init-nvm.sh
