#!/bin/bash

# Sets up the computer to how I like it. Installs dotfiles, sets up AUR, installs needed software from list, and more.

PROGNAME=${0##*/}
SCRIPT_DIR=$(dirname $0)

if [[ $EUID -eq 0 ]]; then
  echo "This script must NOT be run as root" 1>&2
  exit 1
fi

err() {
    echo "$1" >&2
    exit 1
}

need_ok() {
    if [ $? != 0 ]; then err "$1"; fi
}

# Run a command that should never fail. If the command fails execution
# will immediately terminate with an error showing the failing
# command.
ensure() {
    "$@"
    need_ok "command failed: $*"
}


install_packages() {
    echo "Installing packages"

    # Install Ubuntu for Windows packages.
    ensure xargs < ubuntu_for_windows_packages.txt sudo apt install

    echo "Packages installed."
}

install_dotfiles() {
    echo "Installing dotfiles"
    if bash "install_dotfiles.sh"; then
        echo "Dotfiles installed."
    else
        echo "install_dotfiles.sh's exit code was not 0. There may have been an error. You should probably investigate."
    fi
}

trap '
  trap - INT # restore default INT handler
  kill -s INT "$$"
' INT

echo "Initiating computer."

sudo apt-get update

install_packages
install_dotfiles

if [ $? -eq 0 ]; then
    source ~/.bash_profile
    echo "Computer ready for action. (But you should probably reboot to be sure.)"
else
    err "There was an error somewhere (sorry). You should investigate."
fi
