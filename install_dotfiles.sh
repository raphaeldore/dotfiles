#!/bin/bash

PROGNAME=${0##*/}
SCRIPT_DIR=$(dirname $0)

err() {
    echo "$1" >&2
    exit 1
}

need_cmd() {
   if ! command -v "$1" > /dev/null 2>&1
   then err "need '$1' (command not found). Please install it and re-run the script."
   fi
}

# Installs dotfiles to home directory

need_cmd stow

dotfiles_dirs=( bash git nano )

for dotfile_dir in "${dotfiles_dirs[@]}"
do
    stow "$(dirname $0)/$dotfile_dir" -t ~
done