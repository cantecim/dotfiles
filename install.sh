#!/bin/sh

if [ ! $(which brew) ]; then
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew bundle -v
echo "Set dock application ? (yY/nN) [n]? "
read -s -n 1 answer
[ -z "$answer" ] && answer="n"  # default choice
case $answer in
    "y"|"Y" ) SET_DOCK=true;;
    "n"|"N"|* ) SET_DOCK=false;;
esac

if $SET_DOCK; then
	sh ./dock.sh
fi

echo "Set defaults ? (yY/nN) [y]? "
read -s -n 1 answer
[ -z "$answer" ] && answer="y"  # default choice
case $answer in
    "y"|"Y" ) SET_DEFAULTS=true;;
    "n"|"N"|* ) SET_DEFAULTS=false;;
esac

if $SET_DEFAULTS; then
	sh ./defaults.sh
fi

