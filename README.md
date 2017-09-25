dotfiles
========

My Arch Linux dotfiles

# Installation

First, clone this repo to your home directory: `git clone --recursive https://github.com/raphaeldore/dotfiles ~/.dotfiles`

To only install dotfiles, execute the script: `install-dotfiles.sh` like so: `bash install-dotfiles.sh`

To setup your computer exactly like mine, execute the script: `init_computer.sh` like so: `bash init_computer.sh`

# Personnal Configuration Notes

## Configure KeeAgent (Manual Step)
In Keepass: 
  * Tools --> Option --> KeeAgent --> Agent mode: Agent
  * Tools --> Option --> KeeAgent --> Agent mode socket file = `%XDG_RUNTIME_DIR/keeagent.socket`

## Auto-mount google drive encfs folder (Manual Step)
  * In kwallet, add the entry `/home/rdore/GDrive_Encfs` under the "Passwords" folder, and place your encfs password there.
  * Modify your pam files: https://wiki.archlinux.org/index.php/KDE_Wallet#Unlock_KDE_Wallet_automatically_on_login
  * `stow kde -t ~`
  * Profit.
