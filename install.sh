#!/bin/sh

# dotfiles bootstrapper.  Keep this file POSIX sh: it is the first program run
# on a new machine and must not depend on anything except the OS and git.
set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
PROFILE=${DOTFILES_PROFILE:-server}
REQUESTED=
SKIPPED=${DOTFILES_SKIP:-}
DRY_RUN=0
ASSUME_YES=0
APT_UPDATED=0
RESOLVED=

say() { printf '%s\n' "$*"; }
die() { printf 'error: %s\n' "$*" >&2; exit 1; }

usage() {
    cat <<'EOF'
Usage: ./install.sh [options]

Options:
  -p, --profile NAME  minimal, server, developer, or desktop (default: server)
  --only LIST         install only comma-separated components
  --skip LIST         omit comma-separated components
  -n, --dry-run       print commands without changing the machine
  -y, --yes           do not ask for confirmation
  --list              show profiles and components
  -h, --help          show this help

Environment:
  DOTFILES_PROFILE    default profile
  DOTFILES_SKIP       space- or comma-separated components to omit
EOF
}

list_items() {
    cat <<'EOF'
Profiles:
  minimal    base shell links-core
  server     base shell rust cli editor links-core links-editor
  developer  base shell rust cli editor dev links-core links-editor
  desktop    base shell rust cli editor dev fonts desktop links-core links-editor links-desktop

Components (dependencies are selected automatically):
  base build shell rust cli editor dev fonts desktop
  links-core links-editor links-desktop
EOF
}

while [ "$#" -gt 0 ]; do
    case $1 in
        -p|--profile) [ "$#" -ge 2 ] || die "$1 needs a value"; PROFILE=$2; shift 2 ;;
        --only) [ "$#" -ge 2 ] || die "$1 needs a value"; REQUESTED=$2; shift 2 ;;
        --skip) [ "$#" -ge 2 ] || die "$1 needs a value"; SKIPPED="$SKIPPED $2"; shift 2 ;;
        -n|--dry-run) DRY_RUN=1; shift ;;
        -y|--yes) ASSUME_YES=1; shift ;;
        --list) list_items; exit 0 ;;
        -h|--help) usage; exit 0 ;;
        *) die "unknown option: $1" ;;
    esac
done

normalise_list() { printf '%s' "$1" | tr ',' ' '; }
SKIPPED=$(normalise_list "$SKIPPED")

profile_components() {
    case $1 in
        minimal) printf '%s\n' 'base shell links-core' ;;
        server) printf '%s\n' 'base shell rust cli editor links-core links-editor' ;;
        developer) printf '%s\n' 'base shell rust cli editor dev links-core links-editor' ;;
        desktop) printf '%s\n' 'base shell rust cli editor dev fonts desktop links-core links-editor links-desktop' ;;
        *) die "unknown profile: $1" ;;
    esac
}

component_dependencies() {
    case $1 in
        base) printf '\n' ;;
        build) printf '%s\n' base ;;
        shell) printf '%s\n' base ;;
        rust) printf '%s\n' build ;;
        cli) printf '%s\n' 'base rust' ;;
        editor) printf '%s\n' base ;;
        dev) printf '%s\n' base ;;
        fonts) printf '%s\n' base ;;
        desktop) printf '%s\n' base ;;
        links-core) printf '%s\n' shell ;;
        links-editor) printf '%s\n' editor ;;
        links-desktop) printf '%s\n' desktop ;;
        *) die "unknown component: $1" ;;
    esac
}

has_word() { case " $1 " in *" $2 "*) return 0 ;; *) return 1 ;; esac; }

resolve() {
    has_word "$SKIPPED" "$1" && return 0
    has_word "$RESOLVED" "$1" && return 0
    for dependency in $(component_dependencies "$1"); do
        if has_word "$SKIPPED" "$dependency"; then
            die "$1 requires skipped component $dependency"
        fi
        resolve "$dependency"
    done
    RESOLVED="$RESOLVED $1"
}

if [ -n "$REQUESTED" ]; then
    SELECTED=$(normalise_list "$REQUESTED")
else
    SELECTED=$(profile_components "$PROFILE")
fi
for component in $SELECTED; do resolve "$component"; done
RESOLVED=${RESOLVED# }

run() {
    if [ "$DRY_RUN" -eq 1 ]; then
        printf '+ '
        printf "'%s' " "$@"
        printf '\n'
    else
        "$@"
    fi
}

as_root() {
    if [ "$(id -u)" -eq 0 ]; then run "$@"; else run sudo "$@"; fi
}

have() { command -v "$1" >/dev/null 2>&1; }

apt_install() {
    if [ "$APT_UPDATED" -eq 0 ]; then as_root apt-get update; APT_UPDATED=1; fi
    as_root apt-get install -y "$@"
}

packages() {
    if have apt-get; then
        apt_install "$@"
    else
        die "unsupported package manager (currently apt-get is supported)"
    fi
}

cargo_install() {
    crate=$1
    binary=${2:-$1}
    if have "$binary"; then say "  already installed: $binary"; return; fi
    run cargo install --locked "$crate"
}

link_file() {
    source_path=$SCRIPT_DIR/$1
    target_path=$HOME/$2
    [ -e "$source_path" ] || die "link source does not exist: $source_path"
    run mkdir -p "$(dirname "$target_path")"
    if [ -L "$target_path" ] && [ "$(readlink "$target_path")" = "$source_path" ]; then
        say "  already linked: $target_path"
        return
    fi
    if [ -e "$target_path" ] || [ -L "$target_path" ]; then
        backup=$target_path.bak
        [ ! -e "$backup" ] && [ ! -L "$backup" ] || backup=$target_path.bak.$(date +%Y%m%d%H%M%S)
        run mv "$target_path" "$backup"
    fi
    run ln -s "$source_path" "$target_path"
}

install_base() { packages ca-certificates curl unzip; }
install_build() { packages build-essential pkg-config libssl-dev; }
install_shell() {
    packages zsh tmux fzf direnv
    if [ "${SHELL:-}" != "$(command -v zsh 2>/dev/null || printf /usr/bin/zsh)" ]; then
        run chsh -s "$(command -v zsh 2>/dev/null || printf /usr/bin/zsh)"
    fi
}
install_rust() {
    if ! have cargo; then
        if [ "$DRY_RUN" -eq 1 ]; then say "+ download rustup-init with curl and run it"; else
            rustup_tmp=${TMPDIR:-/tmp}/rustup-init.$$
            trap 'rm -f "$rustup_tmp"' EXIT HUP INT TERM
            curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o "$rustup_tmp"
            sh "$rustup_tmp" -y
            rm -f "$rustup_tmp"
            trap - EXIT HUP INT TERM
        fi
    fi
    [ "$DRY_RUN" -eq 1 ] || . "$HOME/.cargo/env"
}
install_cli() {
    cargo_install lsd
    cargo_install starship
    cargo_install zoxide
    cargo_install sheldon
    cargo_install yazi-fm yazi
    cargo_install yazi-cli ya
}
install_editor() { have nvim || packages neovim; }
install_dev() { packages python3 python3-pip ripgrep fd-find; }
install_fonts() {
    packages fontconfig
    font_dir=$HOME/.local/share/fonts
    zip_file=${TMPDIR:-/tmp}/FiraMono.$$.zip
    run mkdir -p "$font_dir"
    if [ "$DRY_RUN" -eq 1 ]; then
        say "+ download and extract FiraMono Nerd Font into '$font_dir'"
    else
        curl -fsSL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraMono.zip -o "$zip_file"
        unzip -oq "$zip_file" -d "$font_dir"
        rm -f "$zip_file"
        fc-cache -f
    fi
}
install_desktop() { packages niri waybar swaylock; }
install_links_core() {
    link_file .zshrc .zshrc
    link_file .vimrc .vimrc
    link_file starship.toml .config/starship.toml
    link_file .config/sheldon .config/sheldon
    link_file tmux/.tmux.conf .tmux.conf
}
install_links_editor() { link_file .config/nvim .config/nvim; }
install_links_desktop() {
    for name in niri swaylock waybar wezterm yazi; do link_file ".config/$name" ".config/$name"; done
}

say "Profile: $PROFILE"
say "Plan:    $RESOLVED"
if [ "$DRY_RUN" -eq 0 ] && [ "$ASSUME_YES" -eq 0 ]; then
    printf 'Continue? [y/N] '
    read answer
    case $answer in y|Y|yes|YES) ;; *) say 'Cancelled.'; exit 0 ;; esac
fi

for component in $RESOLVED; do
    say "==> $component"
    function_name=$(printf 'install_%s' "$component" | tr '-' '_')
    "$function_name"
done

say 'Done.'
