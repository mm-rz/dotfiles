################################################################################
# zsh settings
################################################################################

HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000
setopt extended_history
setopt hist_ignore_dups
bindkey -e

zstyle :compinstall filename '$HOME/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# spell complete
setopt correct

# zsh-completions

if [ -e /usr/local/share/zsh-completions ]; then
  fpath=(/usr/local/share/zsh-completions $fpath)
fi

################################################################################
# aliases
################################################################################

# fd - cd to selected directory
fd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

# fdr - cd to selected directory under ~
fdr() {
  local dir
  dir=$(find ~ -path '*/\.*' -prune \
                -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

# git
alias ga='git add'
alias gc='git commit -m'
alias gst='git status'

# lsd
alias l='lsd -l'
alias la='lsd -a'

# nvim
export PATH="$PATH:/opt/nvim/"

# python
alias python='python3'
alias pip='python3 -m pip'

################################################################################
# utilities
################################################################################

# rust
export PATH="$HOME/.cargo/bin:$PATH"

# show directory infomations after `cd`
chpwd() { pwd && lsd }

# starship
eval "$(starship init zsh)"
export STARSHIP_CONFIG="$HOME/dotfiles/starship.toml"

# volta
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

################################################################################
# for competitive programming
################################################################################

alias B='function _b() { python3 ./cp_templates/bundle.py "$1.cpp" && oj-bundle "z.cpp" | grep -v "^#line " | iconv -t utf16 | tail -c +3 | clip.exe && rm "z.cpp"; }; _b'

alias D='function _d() { g++ "$1.cpp" -g -std=c++2a -Wall -Wextra -Wshadow -Wfloat-equal -fsanitize=undefined,address -ftrapv -DLOCAL -o "$1" && ./"$1" > out && echo "-------" && cat out; }; _d'
alias DACL='function _d() { g++ "$1.cpp" -g -std=c++2a -Wall -Wextra -Wshadow -Wfloat-equal -fsanitize=undefined,address -ftrapv -DLOCAL -I ac-library -o "$1" && ./"$1" > out && echo "-------" && cat out; }; _d'

################################################################################
# for job
################################################################################

alias REVIEW='function _review() {cp _review feedback.md; }; _review'
alias TEST='function _test() {cp _test feedback.md; }; _test'
alias EXPORT='function _export() {cat feedback.md | iconv -t utf16 | tail -c +3 | clip.exe; }; _export'

