export EDITOR=nvim

# local
export PATH="$HOME/.local/bin:$PATH"

# go
export PATH=$PATH:/usr/local/go/bin

# nvim
export PATH="$PATH:/opt/nvim/"

# rust
export PATH="$HOME/.cargo/bin:$PATH"

# starship
eval "$(starship init zsh)"
export STARSHIP_CONFIG="$HOME/dotfiles/starship.toml"

# volta
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"
