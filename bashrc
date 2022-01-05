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
export GOROOT=/home/goroot
export GOPATH=$HOME/go
mkdir -p $GOPATH

export LANG=en_US.UTF-8
export EDITOR=vim
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin:$HOME/bin


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

tally() {
	sort | uniq -c | sort -n
}

## Colored ls
if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	alias ls='ls --color=auto'
	alias grep='grep --color=auto'
fi


# Prompt

if [ "$PLATFORM" = Linux ]; then
	PS1="\[\e[1;38m\]\u\[\e[1;34m\]@\[\e[1;31m\]\h\[\e[1;30m\]:"
	PS1="$PS1\[\e[0;38m\]\w\[\e[1;35m\]> \[\e[0m\]"
else
	# git-prompt
	__git_ps1() { :;}
	if [ -e ~/.git-prompt.sh ]; then
		source ~/.git-prompt.sh
	fi
	PS1='\[\e[34m\]\u\[\e[1;32m\]@\[\e[0;33m\]\h\[\e[35m\]:\[\e[m\]\w\[\e[1;30m\]$(__git_ps1)\[\e[1;31m\]> \[\e[0m\]'
fi


# fzf (https://github.com/junegunn/fzf)

pods() {
  FZF_DEFAULT_COMMAND="kubectl get pods --all-namespaces" \
    fzf --info=inline --layout=reverse --header-lines=1 \
    --prompt "$(kubectl config current-context | sed 's/-context$//')> " \
    --header $'╱ Enter (kubectl exec) ╱ CTRL-O (open log in editor) ╱ CTRL-R (reload) ╱\n\n' \
    --bind 'ctrl-/:change-preview-window(80%,border-bottom|hidden|)' \
    --bind 'enter:execute:kubectl exec -it --namespace {1} {2} -- bash > /dev/tty' \
    --bind 'ctrl-o:execute:${EDITOR:-vim} <(kubectl logs --all-containers --namespace {1} {2}) > /dev/tty' \
    --bind 'ctrl-r:reload:$FZF_DEFAULT_COMMAND' \
    --preview-window up:follow \
    --preview 'kubectl logs --follow --all-containers --tail=10000 --namespace {1} {2}' "$@"
}

all-pods() {
  FZF_DEFAULT_COMMAND='
    (echo CONTEXT NAMESPACE NAME READY STATUS RESTARTS AGE
     for context in $(kubectl config get-contexts --no-headers -o name | sort); do
       kubectl get pods --all-namespaces --no-headers --context "$context" | sed "s/^/${context%-context} /"
     done) 2> /dev/null | column -t
  ' fzf --info=inline --layout=reverse --header-lines=1 \
    --prompt 'all-pods> ' \
    --header $'╱ Enter (kubectl exec) ╱ CTRL-O (open log in editor) ╱ CTRL-R (reload) ╱\n\n' \
    --bind 'ctrl-/:change-preview-window(80%,border-bottom|hidden|)' \
    --bind 'enter:execute:kubectl exec -it --context {1}-context --namespace {2} {3} -- bash > /dev/tty' \
    --bind 'ctrl-o:execute:${EDITOR:-vim} <(kubectl logs --all-containers --context {1}-context --namespace {2} {3}) > /dev/tty' \
    --bind 'ctrl-r:reload:eval "$FZF_DEFAULT_COMMAND"' \
    --preview-window up:follow \
    --preview 'kubectl logs --follow --tail=10000 --all-containers --context {1}-context --namespace {2} {3}' "$@"
}


# Extras

nvm() {
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
  nvm "$@"
}

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# https://github.com/cykerway/complete-alias
# must install bash_completion
#source $HOME/.bash_complete_alias

## kube tools
export KUBE_EDITOR=vim
source $HOME/.completion/kubectl
#alias k=kubectl
#complete -F _complete_alias k
