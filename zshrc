# System Defaults
[ -z ${PLATFORM+x} ] && export PLATFORM=$(uname -s)
# Environment
export CLICOLOR=1
export LANG=en_US.UTF-8
export EDITOR=vim
export PATH=$PATH:/sbin:$HOME/bin

# Aliases
alias python=python3
alias pip=pip3


# Extras

## homebrew
if [[ "$PLATFORM" == "Darwin" ]]; then
	export PATH=/opt/homebrew/bin:$PATH
	export GOROOT=/opt/homebrew
fi

## Go
export GOPATH=$HOME/go
mkdir -p $GOPATH
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin


## Yazi File Explorer
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

## fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
