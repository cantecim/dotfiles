# load the bashrc
source ~/.bashrc

# load bash prompt
source ~/.bash_prompt

EDITOR=nano

alias "re-source"="source ~/.bash_profile"

alias g="git"
alias commit="git c"
alias gs="g status"
alias ga="g add"
alias gc=commitWithMessage
alias gpp="g pp"
alias gh="g hist"
alias grsc="git reset HEAD^"
alias gprunelocal="git fetch -p && for branch in \`git branch -vv | awk '{print \$1,\$4}' | grep 'gone]' | awk '{print \$1}'\`; do git branch -d \$branch; done"

alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

alias countfolders='find ./* -maxdepth 0 -type d | wc -l'
alias findtext='function _findtext(){ grep -rnw `pwd` -e "$1";};_findtext'

export NVM_DIR="$HOME/.nvm"
  [ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/usr/local/opt/nvm/etc/bash_completion" ] && . "/usr/local/opt/nvm/etc/bash_completion"  # This loads nvm bash_completion

# load bash completion
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

# pyenv
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
if which pyenv-virtualenv-init > /dev/null; then
	eval "$(pyenv virtualenv-init -)";
fi

# load all extra bash files
for file in `ls ~/.bash_extra_*`; do
	#echo $file;
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;

# the fuck
eval $(thefuck --alias)

# google cloud sdk
source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc'
source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc'
