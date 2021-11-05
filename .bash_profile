# https://github.com/cykerway/complete-alias
# must install bash_completion
#source $HOME/.bash_complete_alias

# vim <C-s>
stty -ixon

# golang
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin:$HOME/bin

# pyenv
#export PYENV_ROOT="$HOME/.pyenv"
#export PATH="$PYENV_ROOT/bin:$PATH"
#eval "$(pyenv init -)"
#eval "$(pyenv virtualenv-init -)"

## kube tools
export KUBE_EDITOR=vim
source $HOME/.completion/kubectl
#alias k=kubectl
#complete -F _complete_alias k
