# If not running interactively, don't do anything

[ -z "$PS1" ] && return

# Set LSCOLORS

eval "$(dircolors -b "$DOTFILES_DIR"/system/.dir_colors)"

# autoenv
export AUTOENV_ENV_FILENAME=.auto.env
source /opt/homebrew/opt/autoenv/activate.sh
# autoenv end
