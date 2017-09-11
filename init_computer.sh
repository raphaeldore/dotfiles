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



install_pacaur() {

    if command -v pacaur > /dev/null 2>&1; then 
        echo "pacaur already installed. Nothing to do here."
        return 0
    fi
    
    echo "Installing pacaur..."

    # Install needed deps
    sudo pacman -S expac yajl --noconfirm
    
    mkdir /tmp/pacaur_install/
    
    bash <<- EOF
    cd /tmp/pacaur_install/
    
    # Installing cower
    gpg --recv-keys --keyserver hkp://pgp.mit.edu 1EB2638FF56C0C53
    curl -o PKGBUILD https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=cower
    makepkg -i PKGBUILD --noconfirm
    
    # Installing pacaur
    curl -o PKGBUILD https://aur.archlinux.org/cgit/aur.git/plain/PKGBUILD?h=pacaur
    makepkg -i PKGBUILD --noconfirm
EOF
    
    rm -rf /tmp/pacaur_install/
    
    echo "pacaur installed."
}

install_packages() {
    echo "Installing packages"
    pacaur --needed -S - < "${SCRIPT_DIR}/arch_packages.txt"
    echo "Packages installed."
}

install_fonts() {
    echo "Installing fonts"
    stow "${SCRIPT_DIR}/fonts" -t ~
    echo "Updating font cache"
    fc-cache -fv fonts/.fonts
    echo "Fonts installed."
}

install_dotfiles() {
    echo "Installing dotfiles"
    bash "$SCRIPT_DIR/install_dotfiles.sh"
    echo "Dotfiles installed."
}

trap '
  trap - INT # restore default INT handler
  kill -s INT "$$"
' INT

echo "Initiating computer."

sudo pacman -Syy

ensure install_pacaur
ensure install_packages
install_fonts
install_dotfiles

source ~/.bash_profile

echo "Computer ready for action. (But you should probably reboot)"