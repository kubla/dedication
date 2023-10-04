#!/bin/zsh

# Function to display countdown in a rectangle bordered by the letter J
display_countdown() {
    local total_seconds="$1"
    local width=40
    local height=11

    while (( total_seconds >= 0 )); do
        # Clear the screen
        clear

        # Draw the top border
        for (( col=0; col<width; col++ )); do
            printf "J"
        done
        echo ""

# Draw the sides and center content
for (( i=0; i<height-2; i++ )); do
    printf "J"
    col=0
    while (( col < width-2 )); do
        # Check if we're at the vertical center
        if [ $i -eq $((height / 2 - 1)) ]; then
            local minutes=$((total_seconds / 60))
            local seconds=$((total_seconds % 60))
            local time_string="Time left: ${minutes}m ${seconds}s"
            local total_space=$((width-2))
            local padding=$(( (total_space - ${#time_string}) / 2 ))

            # Print spaces before the time string
            printf "%${padding}s"
            
            # Print the time in green
            printf "\e[32m%s\e[0m" "$time_string"
            
            # Adjust the col counter and print remaining spaces
            col=$(( col + padding + ${#time_string} ))
            printf "%$((total_space - col))s"
            col=$(( width-2 ))  # This will end the loop
        else
            printf " "
            (( col++ ))
        fi
    done
    printf "J\n"
done

        # Draw the bottom border
        for (( col=0; col<width; col++ )); do
            printf "J"
        done
        echo ""

        ((total_seconds--))

    # If time's up, break out of the loop to avoid an extra sleep at the end
    if (( total_seconds < 0 )); then
        break
    fi

    sleep 1

    done
    echo
    echo "Time's up!"
    afplay /System/Library/Sounds/Hero.aiff
    echo
}

# Main function to start the countdown
countdown_timer() {
    local input="$1"
    local minutes=0
    local seconds=0

    if [[ $input =~ ([0-9]+)m([0-9]+)s ]]; then
        minutes=${match[1]}
        seconds=${match[2]}
    elif [[ $input =~ ([0-9]+)m ]]; then
        minutes=${match[1]}
    elif [[ $input =~ ([0-9]+)s ]]; then
        seconds=${match[1]}
    else
        echo "Invalid input format."
        return 1
    fi

    local total_seconds=$((minutes * 60 + seconds))
    display_countdown "$total_seconds"
}

# Check for correct number of arguments
if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <time>"
    echo "Example: $0 5m30s"
    exit 1
fi

countdown_timer "$1"
