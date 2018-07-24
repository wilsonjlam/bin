#!/bin/bash

echo "$1" | osascript 3<&0 <<EOF
	tell application "iTerm"
		tell current session of current window
			select(split vertically with default profile command "/usr/local/bin/vim $1")
		end tell
	end tell
EOF
