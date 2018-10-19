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

need_cmd() {
   if ! command -v "$1" > /dev/null 2>&1
   then err "need '$1' (command not found). Please install it and re-run the script."
   fi
}

# Run a command that should never fail. If the command fails execution
# will immediately terminate with an error showing the failing
# command.
ensure() {
    "$@"
    need_ok "command failed: $*"
}


install_yay() {

    if command -v yay > /dev/null 2>&1; then 
        echo "yay already installed. Nothing to do here."
        return 0
    fi
    
    echo "Installing yay..."

    # Install yay
    (git clone https://aur.archlinux.org/yay.git /tmp/yay && cd /tmp/yay/ && makepkg -si)
    
    echo "yay installed."
}

install_packages() {
    echo "Installing packages"
    # xargs < "${SCRIPT_DIR}/arch_packages.txt" pacaur -S --needed # This doesn't install all packages in the list for some weird reason. 
    # This will install all packages listed in the file arch_packages.txt (or ignore it if it's already installed)
    for package_name in $(cat "${SCRIPT_DIR}/arch_packages.txt"); do
        echo "Installing: ${package_name}"
        yay -S --needed "${package_name}"
    done
    echo "Packages installed."
}

install_fonts() {
    echo "Installing fonts"
    stow "fonts" -t ~
    echo "Updating font cache"
    fc-cache -fv fonts/.fonts
    echo "Fonts installed."
}

install_dotfiles() {
    echo "Installing dotfiles"
    if bash "install_dotfiles.sh"; then
        echo "Dotfiles installed."
    else
        err "install_dotfiles.sh's exit code was not 0. There may have been an error. You should probably investigate."
    fi
}

trap '
  trap - INT # restore default INT handler
  kill -s INT "$$"
' INT

echo "Initiating computer."

need_cmd git

sudo pacman -Syu

ensure install_yay
ensure install_packages
install_fonts
install_dotfiles

if [ $? -eq 0 ]; then
    source ~/.bash_profile
    echo "Computer ready for action. (But you should probably reboot to be sure.)"
else
    err "There was an error somewhere (sorry). You should investigate."
fi
