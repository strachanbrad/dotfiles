#!/bin/bash

# Define your applications under headings
declare -A apps

# Documents
apps["LibreOffice Calc"]="libreoffice --calc"
apps["LibreOffice Impress"]="libreoffice --impress"
apps["LibreOffice Writer"]="libreoffice --writer"
apps["Neovim"]="nvim"

# Utilities
apps["Boxes"]="gnome-boxes"
apps["Calculator"]="gnome-calculator"
apps["Characters"]="gnome-characters"
apps["Connections"]="nm-connection-editor"
apps["Disks"]="gnome-disks"
apps["Disk Usage Analyzer"]="baobab"
apps["Document Scanner"]="simple-scan"
apps["Fonts"]="gnome-font-viewer"
apps["Icon Browser"]="gtk3-icon-browser"  # Placeholder, adjust as needed
apps["Kitty"]="kitty"
apps["Logs"]="gnome-logs"
apps["Problem Reporting"]="gnome-abrt"  # Placeholder, adjust as needed
apps["Settings"]="gnome-control-center"
apps["System Monitor"]="gnome-system-monitor"
apps["Terminal"]="gnome-terminal"
apps["Text Editor"]="gnome-text-editor"

# Media
apps["Cheese"]="cheese"
apps["Document Viewer"]="evince"
apps["Image Viewer"]="eog"
apps["Media Editor"]="gnome-media-editor"  # Placeholder, adjust as needed
apps["Rhythmbox"]="rhythmbox"
apps["Videos"]="totem"

# Communication and Weather
apps["Calendar"]="gnome-calendar"
apps["Clocks"]="gnome-clocks"
apps["Contacts"]="gnome-contacts"
apps["Maps"]="gnome-maps"
apps["Weather"]="gnome-weather"

# Get app names sorted under each category
appNames=$(for key in "${!apps[@]}"; do echo "$key"; done | sort)

# Launch bmenu/wofi
selectedApp=$(echo "$appNames" | wofi --show drun -p "Search App" --style wofi-gruvbox.css)


# Execute the selected app
if [ -n "$selectedApp" ]; then
    ${apps[$selectedApp]} &
fi
