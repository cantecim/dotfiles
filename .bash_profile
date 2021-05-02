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
alias gwhodeleted="git log --all --stat --diff-filter=D -p --"
alias gsb="git for-each-ref --merged=origin/develop --format=\"%(refname:short)\" refs/heads/ | egrep -v \"(^\\*|master$|develop$)\""
alias gpb="gsb | xargs git branch -d"


alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

alias countfolders='find ./* -maxdepth 0 -type d | wc -l'
alias findtext='function _findtext(){ grep -rnw `pwd` -e "$1";};_findtext'

# cloud
alias ec2-fingerprint='ec2Fingerprint'
alias jaeger-local='docker run -e COLLECTOR_ZIPKIN_HTTP_PORT=9411 -p5775:5775/udp -p6831:6831/udp -p6832:6832/udp -p5778:5778 -p16686:16686 -p14268:14268 -p9411:9411 jaegertracing/all-in-one:latest'
alias mongo-local='(cd /Users/cantecim/Desktop/Docker/laradock && docker-compose up -d mongo)'
alias rabbit-local='docker run --rm --hostname my-rabbit --name some-rabbit -p 5672:5672 -p 15672:15672 rabbitmq:3'
alias act-release='act -j dev_release --secret-file actions.dev.secrets -v'
alias docker-rui="docker rmi \$(docker images -a | grep '^<none>' | awk '{print \$3}')"

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
