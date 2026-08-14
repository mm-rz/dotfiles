export DOTFILES="${${(%):-%N}:A:h}"

# [FIRST] load zsh plugins
eval "$(sheldon source)"

# completion
autoload -Uz compinit
compinit

source "$DOTFILES/zsh/aliases.zsh"
source "$DOTFILES/zsh/cpp.zsh"
source "$DOTFILES/zsh/env.zsh"
source "$DOTFILES/zsh/functions.zsh"
source "$DOTFILES/zsh/options.zsh"
source "$DOTFILES/zsh/tools.zsh"
