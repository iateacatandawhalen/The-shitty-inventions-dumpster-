#!/bin/bash

# File manager script

# Function to list files and directories
list_files() {
    echo "Listing files in $(pwd):"
    ls -lh
}

# Function to change directory
change_directory() {
    if [ -d "$1" ]; then
        cd "$1" || { echo "Failed to change directory"; return; }
        echo "Changed directory to $(pwd)"
    else
        echo "Directory '$1' not found."
    fi
}

# Function to copy a file or directory
copy_file() {
    if [ -e "$1" ]; then
        cp -r "$1" "$2" && echo "Copied '$1' to '$2'"
    else
        echo "Source file/directory '$1' not found."
    fi
}

# Function to move a file or directory
move_file() {
    if [ -e "$1" ]; then
        mv "$1" "$2" && echo "Moved '$1' to '$2'"
    else
        echo "Source file/directory '$1' not found."
    fi
}

# Function to delete a file or directory
delete_file() {
    if [ -e "$1" ]; then
        rm -rf "$1" && echo "Deleted '$1'"
    else
        echo "File/directory '$1' not found."
    fi
}

# Function to rename a file or directory
rename_file() {
    if [ -e "$1" ]; then
        mv "$1" "$2" && echo "Renamed '$1' to '$2'"
    else
        echo "File/directory '$1' not found."
    fi
}

# Function to search for a file or directory by name
search_file() {
    echo "Searching for '$1' in $(pwd)..."
    find . -type f -name "*$1*" -print
    find . -type d -name "*$1*" -print
}

# Function to edit a file with nano (optionally with sudo)
edit_file() {
    read -p "Enter the file name to edit: " filename
    if [ -e "$filename" ]; then
        read -p "Do you want to edit this file with sudo privileges? (sy/sn): " use_sudo
        if [[ "$use_sudo" == "sy" || "$use_sudo" == "SY" ]]; then
            sudo nano "$filename"
        elif [[ "$use_sudo" == "sn" || "$use_sudo" == "SN" ]]; then
            nano "$filename"
        else
            echo "Invalid input. Please enter 'sy' for sudo or 'sn' for no sudo."
        fi
    else
        echo "File '$filename' not found."
    fi
}

# Main menu for user interaction
menu() {
    while true; do
        echo ""
        echo "CLI File Manager"
        echo "--------------------"
        echo "1. List files"
        echo "2. Change directory"
        echo "3. Copy file/directory"
        echo "4. Move file/directory"
        echo "5. Delete file/directory"
        echo "6. Rename file/directory"
        echo "7. Search for file/directory"
        echo "8. Edit file with nano"
        echo "9. Exit"
        read -p "Enter option [1-9]: " choice

        case "$choice" in
            1)
                list_files
                ;;
            2)
                read -p "Enter directory path: " dir
                change_directory "$dir"
                ;;
            3)
                read -p "Enter source path: " src
                read -p "Enter destination path: " dest
                copy_file "$src" "$dest"
                ;;
            4)
                read -p "Enter source path: " src
                read -p "Enter destination path: " dest
                move_file "$src" "$dest"
                ;;
            5)
                read -p "Enter file/directory to delete: " target
                delete_file "$target"
                ;;
            6)
                read -p "Enter current name: " old_name
                read -p "Enter new name: " new_name
                rename_file "$old_name" "$new_name"
                ;;
            7)
                read -p "Enter search pattern: " pattern
                search_file "$pattern"
                ;;
            8)
                edit_file
                ;;
            9)
                echo "Exiting File Manager..."
                exit 0
                ;;
            *)
                echo "Invalid option, please try again."
                ;;
        esac
    done
}

# Start the file manager
menu
