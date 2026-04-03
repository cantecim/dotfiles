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

# Restore essential toolchain paths after macOS /etc/zprofile path_helper runs.
# Keep this minimal so non-interactive login shells (e.g. Codex `zsh -lc`) can
# still resolve Node/pnpm even though the rest of this file stays interactive-only.
[ -d "/opt/homebrew/bin" ] && PATH="/opt/homebrew/bin:$PATH"
[ -d "/opt/homebrew/sbin" ] && PATH="/opt/homebrew/sbin:$PATH"
[ -d "/opt/homebrew/opt/python/libexec/bin" ] && PATH="/opt/homebrew/opt/python/libexec/bin:$PATH"
[ -d "$DOTFILES_DIR/bin" ] && PATH="$DOTFILES_DIR/bin:$PATH"
[ -d "$HOME/.local/share/pnpm" ] && PATH="$HOME/.local/share/pnpm:$PATH"
[ -d "$HOME/.n/bin" ] && PATH="$HOME/.n/bin:$PATH"

# If not running interactively, don't do anything

[ -z "$PS1" ] && return

# load brew zsh env (should be called before omz sourcing since it calls compinit for us)
# see also for more : https://docs.brew.sh/Shell-Completion#configuring-completions-in-zsh
# we change the order of homebrew paths in system/.path, give priority to n's binary path
is-executable brew && eval "$(brew shellenv zsh)"

# Source the dotfiles (order matters)

for DOTFILE in "$DOTFILES_DIR"/system/.{function,function_*,n,path,env,exports,alias,grep,fix,zoxide}; do
  . "$DOTFILE"
done

if is-macos; then
  for DOTFILE in "$DOTFILES_DIR"/system/.{env,alias,function}.macos; do
    . "$DOTFILE"
  done
fi

# Set LSCOLORS

eval "$(dircolors -b "$DOTFILES_DIR"/system/.dir_colors)"

# Wrap up

unset CURRENT_SCRIPT SCRIPT_PATH DOTFILE
export DOTFILES_DIR

# autoenv
export AUTOENV_ENV_FILENAME=.auto.env
source /opt/homebrew/opt/autoenv/activate.sh
# autoenv end
