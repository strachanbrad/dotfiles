#!/bin/bash

# Function to get the current volume
get_current_volume() {
    pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | tr -d '%' | head -1
}

# Function to change volume
change_volume() {
    # Get current volume
    local current_volume=$(get_current_volume)

    # Launch YAD slider and capture the selected value after pressing "Apply"
    local new_volume=$(yad --scale --text "Adjust volume level" --min-value=0 --max-value=100 --value=$current_volume --step=1 --button="Apply Volume":0)

    # Check if the user clicked "Apply"
    if [ $? -eq 0 ]; then
        # Debug: Print the captured volume value
        echo "Selected volume: ${new_volume}"

        # Set the volume using pactl
        pactl set-sink-volume @DEFAULT_SINK@ ${new_volume}%

        # Check the exit status of the pactl command
        if [ $? -eq 0 ]; then
            echo "Volume set successfully."
        else
            echo "Failed to set volume."
        fi
    else
        echo "Volume adjustment cancelled."
    fi
}

change_volume

