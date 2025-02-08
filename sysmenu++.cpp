#include <iostream>
#include <cstdlib>
#include <ncurses.h>
#include <string>
#include <vector>
#include <sys/stat.h>
#include <dirent.h>
#include <unistd.h> // for access()
#include <ctime>
#include <sys/utsname.h>
#include <fstream>

void show_message(const std::string &message) {
    clear();
    printw(message.c_str());
    refresh();
    getch();
}

void run_command(const std::string &command) {
    system(command.c_str());
}

std::vector<std::string> get_files_in_directory(const std::string &path) {
    std::vector<std::string> files;
    DIR *dir = opendir(path.c_str());
    if (dir == nullptr) {
        show_message("Could not open directory.");
        return files;
    }

    struct dirent *entry;
    while ((entry = readdir(dir)) != nullptr) {
        files.push_back(entry->d_name);
    }

    closedir(dir);
    return files;
}

bool is_executable(const std::string &file_path) {
    return (access(file_path.c_str(), X_OK) == 0); // Check if the file is executable
}

void run_program(const std::string &file_path) {
    if (is_executable(file_path)) {
        run_command(file_path); // Run the executable file
    } else {
        show_message("This file is not executable.");
    }
}

void open_file_in_nano(const std::string &file_path) {
    int choice = 0;
    clear();
    printw("Open file with admin privileges? (1 = Yes, 2 = No): ");
    refresh();
    choice = getch() - '0'; // Get numerical input

    std::string command;
    if (choice == 1) {
        command = "sudo nano " + file_path;
    } else {
        command = "nano " + file_path;
    }

    run_command(command);
}

void rename_file(const std::string &old_name, const std::string &new_name) {
    std::string command = "mv " + old_name + " " + new_name;
    run_command(command);
}

void delete_file(const std::string &file_path) {
    std::string command = "rm " + file_path;
    run_command(command);
}

void display_file_manager(const std::string &path) {
    int choice;
    std::vector<std::string> files = get_files_in_directory(path);

    while (true) {
        clear();
        printw("File Manager - Path: %s\n", path.c_str());
        printw("\n");

        for (size_t i = 0; i < files.size(); ++i) {
            printw("%zu. %s\n", i + 1, files[i].c_str());
        }

        printw("\nSelect a file (0 to go back, -1 to exit): ");
        refresh();

        choice = getch() - '0'; // Get numerical input

        if (choice == 0) {
            return;  // Go back to the previous menu
        } else if (choice == -1) {
            endwin();
            exit(0);  // Exit program
        } else if (choice > 0 && choice <= files.size()) {
            std::string selected_file = path + "/" + files[choice - 1];
            clear();
            printw("File Selected: %s\n", selected_file.c_str());
            printw("\n1. Open in nano\n2. Rename\n3. Delete\n4. Run Program\n0. Go Back\n");
            refresh();

            int sub_choice = getch() - '0'; // Get numerical input

            switch (sub_choice) {
                case 1:
                    open_file_in_nano(selected_file);
                    break;
                case 2: {
                    char new_name[256];
                    printw("Enter new name: ");
                    refresh();
                    getstr(new_name);
                    rename_file(selected_file, path + "/" + new_name);
                    break;
                }
                case 3:
                    delete_file(selected_file);
                    break;
                case 4:
                    run_program(selected_file); // Try to run the program
                    break;
                case 0:
                    continue; // Go back to the file manager view
            }
        }
    }
}

void display_system_info() {
    struct utsname sys_info;
    if (uname(&sys_info) == 0) {
        clear();
        printw("System Information:\n");
        printw("System Name: %s\n", sys_info.sysname);
        printw("Node Name: %s\n", sys_info.nodename);
        printw("Release: %s\n", sys_info.release);
        printw("Version: %s\n", sys_info.version);
        printw("Machine: %s\n", sys_info.machine);
        refresh();
        getch();
    }
}

void display_weather_info() {
    run_command("curl wttr.in");
}

void display_network_info() {
    run_command("ifconfig");
}

void display_shutdown_options() {
    int choice;
    clear();
    printw("Shutdown Options:\n");
    printw("1. Shutdown\n2. Restart\n3. Suspend\n0. Go Back\n");
    refresh();
    choice = getch() - '0';

    switch (choice) {
        case 1:
            run_command("sudo shutdown now");
            break;
        case 2:
            run_command("sudo reboot");
            break;
        case 3:
            run_command("sudo systemctl suspend");
            break;
        case 0:
            return; // Go back to the system menu
        default:
            break;
    }
}

// Status Report Script
void display_status_report() {
    clear();
    
    // System Info
    printw("System Status Report\n\n");

    // Uptime
    run_command("uptime");

    // Disk Usage
    printw("\nDisk Usage:\n");
    run_command("df -h");

    // Memory Usage
    printw("\nMemory Usage:\n");
    run_command("free -h");

    // Network Info
    printw("\nNetwork Info:\n");
    display_network_info();

    // Weather
    printw("\nWeather Info:\n");
    display_weather_info();

    refresh();
    getch();
}

void display_system_menu() {
    int choice;
    std::vector<std::string> menu_items = {
        "1. File Manager",
        "2. System Info",
        "3. Weather Info",
        "4. Network Info",
        "5. Shutdown Options",
        "6. Status Report",
        "7. Exit"
    };

    while (true) {
        clear();
        printw("System Menu\n\n");

        for (const auto &item : menu_items) {
            printw("%s\n", item.c_str());
        }

        printw("\nEnter your choice (1-7): ");
        refresh();

        choice = getch() - '0'; // Get numerical input

        switch (choice) {
            case 1:
                display_file_manager("/");  // Start file manager with root directory
                break;
            case 2:
                display_system_info();
                break;
            case 3:
                display_weather_info();
                break;
            case 4:
                display_network_info();
                break;
            case 5:
                display_shutdown_options();
                break;
            case 6:
                display_status_report();  // Display the status report
                break;
            case 7:
                endwin();
                exit(0);  // Exit program
            default:
                break;
        }
    }
}

int main() {
    // Initialize ncurses
    initscr();
    cbreak();
    noecho();
    keypad(stdscr, TRUE);

    // Start with the system menu
    display_system_menu();

    // End ncurses mode
    endwin();

    return 0;
}
