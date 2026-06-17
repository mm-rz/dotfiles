HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000

setopt extended_history
setopt hist_ignore_dups
setopt correct

bindkey -e

zstyle :compinstall filename '$HOME/.zshrc'
