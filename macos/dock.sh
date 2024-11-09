#!/bin/sh

dockutil --no-restart --remove all
dockutil --no-restart --add "/Applications/Launchpad.app"
dockutil --no-restart --add "/Applications/WebStorm.app"
dockutil --no-restart --add "/Applications/Visual Studio Code.app"
# dockutil --no-restart --add "/Applications/Postman.app"
dockutil --no-restart --add "/System/Applications/Utilities/Terminal.app"
dockutil --no-restart --add "/Applications/Google Chrome.app"
dockutil --no-restart --add "/Applications/Safari.app"
dockutil --no-restart --add "/Applications/Opera.app"
dockutil --no-restart --add "/System/Applications/Notes.app"
dockutil --no-restart --add "/Applications/RemNote.app"
dockutil --no-restart --add "/Applications/Obsidian.app"
dockutil --no-restart --add "/Applications/Microsoft To Do.app"
dockutil --no-restart --add "/Applications/Discord.app"
dockutil --no-restart --add "/System/Applications/Mail.app"
dockutil --no-restart --add "/System/Applications/Calendar.app"
# dockutil --no-restart --add "/Applications/Slack.app"
dockutil --no-restart --add "/System/Applications/System Settings.app"
dockutil --no-restart --add '~/Downloads' --view fan --display stack --allhomes

killall Dock
