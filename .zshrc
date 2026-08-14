export DOTFILES="${${(%):-%N}:A:h}"

# Make user-installed commands available before invoking Sheldon or other tools.
source "$DOTFILES/zsh/env.zsh"

# [FIRST] load zsh plugins
eval "$(sheldon source)"

# completion
autoload -Uz compinit
compinit

source "$DOTFILES/zsh/aliases.zsh"
source "$DOTFILES/zsh/cpp.zsh"
source "$DOTFILES/zsh/functions.zsh"
source "$DOTFILES/zsh/options.zsh"
source "$DOTFILES/zsh/tools.zsh"
