#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOGFILE="$HOME/debian-init.log"

# Выводит лог в консоль и файл
log_message() {
    echo "[INFO] $1" | tee -a "$LOGFILE"
}

# Выводит ошибку в консоль и файл
error_message() {
    echo "[ERROR] $1" | tee -a "$LOGFILE" >&2
}

update_system() {
    log_message "Updating system..."
    if sudo apt update >>"$LOGFILE" 2>&1 && sudo apt upgrade -y >>"$LOGFILE" 2>&1; then
        log_message "System updated successfully."
    else
        error_message "System update failed. Check $LOGFILE for details."
        exit 1
    fi
}

install_package() {
    log_message "Installing: $1"
    if sudo apt install -y "$1" >>"$LOGFILE" 2>&1; then
        log_message "Installed: $1"
    else
        error_message "Failed to install: $1. Check $LOGFILE for details."
        return 1
    fi
}

main() {
    command -v sudo >/dev/null 2>&1 || {
        error_message "sudo is not installed."; exit 1;
    }

    log_message "==== Debian Setup Started at $(date) ===="

    update_system

    install_package zip
    install_package xserver-xorg
    install_package xinit
    install_package i3
    install_package kitty
    install_package xclip
    install_package fonts-jetbrains-mono
    install_package acpi # for i3blocks battery widget
    install_package $SCRIPT_DIR/backlight-control_20250705-1_amd64.deb

    # Build tools
    # install_package build-essential
    # install_package autoconf
    # install_package automake
    # install_package libtool

    install_package $SCRIPT_DIR/i3blocks_1.5-1_amd64.deb

    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    AUTOLOGIN_SCRIPT="$SCRIPT_DIR/setup-autologin.sh"

    if [ -f "$AUTOLOGIN_SCRIPT" ]; then
        log_message "Running setup-autologin.sh..."
        chmod +x "$AUTOLOGIN_SCRIPT"
        if "$AUTOLOGIN_SCRIPT" >>"$LOGFILE" 2>&1; then
            log_message "Autologin script executed successfully."
        else
            error_message "Autologin script failed. Check $LOGFILE for details."
            exit 1
        fi
    else
        error_message "Autologin script not found: $AUTOLOGIN_SCRIPT"
        exit 1
    fi


    cd "$HOME"
    # if [ ! -d backlight_control ]; then
        # log_message "Cloning backlight_control..."
        # git clone https://github.com/Hendrikto/backlight_control.git >>"$LOGFILE" 2>&1
    # fi

    # cd backlight_control
    # log_message "Building and installing backlight_control..."
    # if sudo make install >>"$LOGFILE" 2>&1; then
        # log_message "backlight_control installed."
    # else
        # error_message "Failed to build/install backlight_control."
        # exit 1
    # fi
    # cd "$HOME"
    # rm -rf backlight_control

    log_message "==== Setup Complete at $(date) ===="
}

main
