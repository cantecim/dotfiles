#!/usr/bin/env bash

function fstartup()
{
  # .zprofile doesn't do anything if it's not running interactively
  PS1="fake_prompt> " zsh -l -c "source ~/.zprofile && unblock-discord"
  tail -f /dev/null &
  wait $!
}

function fshutdown()
{
  PS1="fake_prompt> " zsh -l -c "source ~/.zprofile && unblock-quit"
}

trap fshutdown SIGTERM
# trap fshutdown SIGKILL
fstartup;
