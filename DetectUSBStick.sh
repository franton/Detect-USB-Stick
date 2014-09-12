#!/bin/sh

# Script to detect if a user has left their USB stick in a computer on logout.
# Lovingly stolen from https://jamfnation.jamfsoftware.com/discussion.html?id=5924

# Implemented : contact@richard-purves.com
# Version 1.0 : 27-2-2013 - Initial Version

for disk in $(diskutil list | awk '/disk[1-9]s/{ print $NF }' | grep -v /dev); do
	if [[ $(diskutil info $disk | awk '/Protocol/{ print $2 }') == "USB" ]]; then
		echo "Device $disk is a USB removable disk"
		diskName=$(diskutil info $disk | awk -F"/" '/Mount Point/{ print $NF }')
		MSG="There is a USB disk named \"$diskName\" still connected to this computer.

Please remember to take it with you!"
		sudo /Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper \
		-windowType utility -title "USB device still attached" -description "$MSG" -button1 "OK" \
		-icon /System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/AlertCautionIcon.icns -iconSize 96
	fi
done
