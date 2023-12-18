#!/bin/bash

# Define your applications
declare -A apps
apps["Firefox"]="firefox"
apps["LibreOffice Writer"]="libreoffice --writer"
apps["LibreOffice Calc"]="libreoffice --calc"
apps["GIMP"]="gimp"
apps["VLC"]="vlc"
apps["Thunderbird"]="thunderbird"
# Add more applications here as needed

# Get app names
appNames=$(printf '%s\n' "${!apps[@]}")

# Launch dmenu/rofi
selectedApp=$(echo "$appNames" | rofi -dmenu -p "Launch App:")

# Execute the selected app
if [ -n "$selectedApp" ]; then
    ${apps[$selectedApp]} &
fi

