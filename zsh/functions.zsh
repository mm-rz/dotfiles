# show directory infomations after `cd`
chpwd() { pwd && lsd }

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
