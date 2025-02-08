#!/bin/bash

# System Apps Menu Script (CLI-based) with Detailed Weather Feature (No API key required)

# Function to open the CLI file manager (clifm.sh)
open_cli_file_manager() {
    ./clifm.sh
}

# Function to execute the status report script
run_status_report() {
    ./status_report.sh  # Assuming status_report.sh is in the same directory
}

# Function to view running processes
view_processes() {
    echo "Currently running processes:"
    ps aux --sort=-%mem | head -n 10
}

# Function to check network status (using the new network_info.sh script)
check_network_status() {
    ./network_info.sh  # Assuming network_info.sh is in the same directory
}

# Function to check weather (with detailed information using wttr.in)
check_weather() {
    read -p "Enter your city name to check the weather: " city
    if [ -z "$city" ]; then
        echo "City name cannot be empty."
        return
    fi

    echo "Fetching detailed weather information for $city..."

    # Use wttr.in to get detailed weather info (Temperature, Humidity, Wind, Pressure)
    weather_data=$(curl -s "wttr.in/$city?format=%C+%t+%h+%w+%P")

    if [ -z "$weather_data" ]; then
        echo "Could not retrieve weather information for '$city'. Please check the city name and try again."
    else
        # Output the detailed weather information
        echo "Weather in $city: $weather_data"
    fi
}

# Function to handle Power Options (Shutdown, Restart, Suspend, Exit)
power_options_menu() {
    while true; do
        echo ""
        echo "Power Options"
        echo "-------------"
        echo "1. Shutdown"
        echo "2. Restart"
        echo "3. Suspend"
        echo "4. Exit to System Menu"
        read -p "Enter option [1-4]: " choice

        case "$choice" in
            1)
                echo "Shutting down the system..."
                sudo shutdown now
                ;;
            2)
                echo "Restarting the system..."
                sudo reboot
                ;;
            3)
                echo "Suspending the system..."
                sudo systemctl suspend
                ;;
            4)
                echo "Returning to System Menu..."
                return  # Go back to the main system menu
                ;;
            *)
                echo "Invalid option, please try again."
                ;;
        esac
    done
}

# Function to display system information using neofetch
system_info() {
    if command -v neofetch &> /dev/null; then
        echo "Running neofetch..."
        neofetch  # Display system information if neofetch is installed
    else
        echo "neofetch is not installed on this system."
    fi
}

# Main menu for system apps
menu() {
    while true; do
        echo ""
        echo "System Apps Menu"
        echo "-----------------"
        echo "1. Open CLI File Manager"
        echo "2. Run Status Report"
        echo "3. View Running Processes"
        echo "4. Check Network Status"
        echo "5. Check Weather"
        echo "6. Power Options"
        echo "7. System Info"
        echo "8. Exit"
        read -p "Enter option [1-8]: " choice

        case "$choice" in
            1)
                open_cli_file_manager
                ;;
            2)
                run_status_report
                ;;
            3)
                view_processes
                ;;
            4)
                check_network_status
                ;;
            5)
                check_weather
                ;;
            6)
                power_options_menu  # Go to the power options submenu
                ;;
            7)
                system_info  # Show system info using neofetch
                ;;
            8)
                echo "Exiting System Apps Menu..."
                exit 0
                ;;
            *)
                echo "Invalid option, please try again."
                ;;
        esac
    done
}

# Start the system apps menu
menu
