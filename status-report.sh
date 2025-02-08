#!/bin/bash

# Status Report Script

# Ensure the system timezone is set to Europe/Copenhagen
timedatectl set-timezone Europe/Copenhagen

# Function to display system uptime
get_uptime() {
    echo "System Uptime:"
    uptime -p
    echo ""
}

# Function to display memory usage
get_memory_usage() {
    echo "Memory Usage:"
    free -h
    echo ""
}

# Function to display disk usage
get_disk_usage() {
    echo "Disk Usage:"
    df -h --total
    echo ""
}

# Function to display CPU usage
get_cpu_usage() {
    echo "CPU Usage:"
    top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}'
    echo ""
}

# Function to display network information (using the network_info.sh script)
get_network_info() {
    echo "Network Information:"
    ./network_info.sh
    echo ""
}

# Function to display the status of running processes
get_processes() {
    echo "Running Processes:"
    ps aux --sort=-%mem | head -n 10
    echo ""
}

# Function to get the system's current time and date
get_system_time() {
    echo "Current System Time (Danish Time):"
    date
    echo ""
}

# Function to get logged in users
get_logged_in_users() {
    echo "Logged In Users:"
    who
    echo ""
}

# Function to display a general status report
generate_report() {
    echo "Generating System Status Report..."
    get_uptime
    get_memory_usage
    get_disk_usage
    get_cpu_usage
    get_network_info
    get_processes
    get_system_time
    get_logged_in_users
}

# Run the function to generate the status report
generate_report
