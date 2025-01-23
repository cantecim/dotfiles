prepend-fpath() {
  [ -d $1 ] && fpath=("$1" $fpath)
}

# add function path
prepend-fpath "$HOME/.zsh/functions"