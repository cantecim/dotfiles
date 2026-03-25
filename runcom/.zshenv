prepend-fpath() {
  [ -d $1 ] && fpath=("$1" $fpath)
}

# add function path
prepend-fpath "$HOME/.zsh/functions"

# Resolve DOTFILES_DIR (assuming ~/.dotfiles on distros without readlink and/or $BASH_SOURCE/$0)
CURRENT_SCRIPT=$BASH_SOURCE

if [[ -n $CURRENT_SCRIPT && -x readlink ]]; then
  SCRIPT_PATH=$(readlink -n $CURRENT_SCRIPT)
  DOTFILES_DIR="${PWD}/$(dirname $(dirname $SCRIPT_PATH))"
elif [ -d "$HOME/.dotfiles" ]; then
  DOTFILES_DIR="$HOME/.dotfiles"
else
  echo "Unable to find dotfiles, exiting."
  return
fi

# Make utilities available

PATH="$DOTFILES_DIR/bin:$PATH"

# Source the dotfiles (order matters)

# load brew zsh env (should be called before omz sourcing since it calls compinit for us)
# see also for more : https://docs.brew.sh/Shell-Completion#configuring-completions-in-zsh
# we change the order of homebrew paths in system/.path, give priority to n's binary path
is-executable brew && eval "$(brew shellenv)"

for DOTFILE in "$DOTFILES_DIR"/system/.{function,function_*,n,path,env,exports,alias,grep,fix,zoxide}; do
  . "$DOTFILE"
done

if is-macos; then
  for DOTFILE in "$DOTFILES_DIR"/system/.{env,alias,function}.macos; do
    . "$DOTFILE"
  done
fi

# Wrap up

unset CURRENT_SCRIPT SCRIPT_PATH DOTFILE
export DOTFILES_DIR
