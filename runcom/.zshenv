prepend-fpath() {
  [ -d $1 ] && fpath=("$1" $fpath)
}

# add function path
prepend-fpath "$HOME/.zsh/functions"

# Minimal bootstrap only. Keep this file safe for sterile/non-interactive shells.
if [ -d "$HOME/.dotfiles" ]; then
  export DOTFILES_DIR="$HOME/.dotfiles"
fi

export N_PREFIX="$HOME/.n"
typeset -U path PATH

[ -n "$DOTFILES_DIR" ] && path=("$DOTFILES_DIR/bin" $path)
path=("$N_PREFIX/bin" "$HOME/.local/share/pnpm" $path)
