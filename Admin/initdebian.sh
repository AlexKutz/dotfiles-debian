#!/bin/bash

log_message() {
    echo "[INFO] $1"
}

error_message() {
    echo "[ERROR] $1"
}

update_system() {
    log_message "Updating system..."
    sudo apt update && sudo apt upgrade -y
}

install_package() {
    log_message "Installing: $1"
    sudo apt install -y "$1" || {
        error_message "Failed to install: $1"
        return 1
    }
}

main() {
    #echo "alex ALL=(ALL) NOPASSWD: /sbin/poweroff, /sbin/reboot" | sudo tee /etc/sudoers.d/sudo-poweroff

    update_system

    # sudo package
    install_package sudo

	install_package zip

    # font for terminal and status bar
    install_package fonts-jetbrains-mono

    # better i3 status bar alternative: i3blocks is available
    install_package i3blocks

    # fastfetch
    install_package fastfetch

    # Build backlight_control
    git clone https://github.com/Hendrikto/backlight_control.git
    cd backlight_control
    sudo make install
    cd ~
}

main

