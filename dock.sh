#!/bin/sh

dockutil --no-restart --remove all
dockutil --no-restart --add "/Applications/Launchpad.app"
dockutil --no-restart --add "/Applications/Google Chrome.app"
dockutil --no-restart --add "/Applications/Mail.app"
dockutil --no-restart --add "/Applications/Calendar.app"
dockutil --no-restart --add "/Applications/Notes.app"
dockutil --no-restart --add "/Applications/App Store.app"
dockutil --no-restart --add "/Applications/Discord.app"
dockutil --no-restart --add "/Applications/Slack.app"
dockutil --no-restart --add "/Applications/WebStorm.app"
dockutil --no-restart --add "/Applications/PyCharm.app"
dockutil --no-restart --add "/Applications/PhpStorm.app"
dockutil --no-restart --add "/Applications/DataGrip.app"
dockutil --no-restart --add "/Applications/Sublime Text.app"
dockutil --no-restart --add "/Applications/DevDocs.app"
dockutil --no-restart --add "/Applications/Postman.app"
dockutil --no-restart --add "/Applications/Utilities/Terminal.app"
dockutil --no-restart --add "/Applications/System Preferences.app"
# dockutil --no-restart --add '~/Desktop' --view fan --display folder --allhomes
dockutil --no-restart --add '~/Downloads' --view fan --display folder --allhomes

killall Dock