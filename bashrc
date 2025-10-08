# System Defaults

[ -z ${PLATFORM+x} ] && export PLATFORM=$(uname -s)
[ -f /etc/bashrc ] && . /etc/bashrc


# Options

## Append to the history file, don't overwrite it
shopt -s histappend

## Check the window size after each command and update the values of LINES and COLUMNS
shopt -s checkwinsize

## Bash completion
if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi
fi

## Disable CTRL-S and CTRL-Q
[[ $- =~ i ]] && stty -ixoff -ixon


# Environment

## bash settings (man bash)
export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=
export HISTFILESIZE=
export HISTTIMEFORMAT="%Y/%m/%d %H:%M:%S:   "
[ -z "$TMPDIR" ] && TMPDIR=/tmp

## Global
export GOROOT=/home/go
export GOPATH=$HOME/go
mkdir -p $GOPATH

export LANG=en_US.UTF-8
export EDITOR=vim
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin:$HOME/bin:/sbin


# Aliases

## General
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias cd.='cd ..'
alias cd..='cd ..'
alias l='ls -alF'
alias ll='ls -l'
alias vi=$EDITOR
alias vim=$EDITOR

## Colors
if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	alias ls='ls --color=auto'
	alias grep='grep --color=auto'
fi


# Extras

## rust
. "$HOME/.cargo/env"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
