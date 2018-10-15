#           _ _                     
#     /\   | (_)                    
#    /  \  | |_  __ _ ___  ___  ___ 
#   / /\ \ | | |/ _` / __|/ _ \/ __|
#  / ____ \| | | (_| \__ \  __/\__ \
# /_/    \_\_|_|\__,_|___/\___||___/
#                                   
#

# Management
alias dots="cd ~/.dotfiles"
alias reload='source ~/.bash_profile && echo "sourced ~/.bash_profile"'

# Backup list of installed packages.
# Source: https://www.reddit.com/r/archlinux/comments/78g1xm/thank_you_arch_people/dov3qa4/
alias savpkg='comm -23 <(pacman -Qqen | sort) <(pacman -Qqg base base-devel xorg-apps | sort) | less > ~/.pkglist && sed -i "1ibase\\nbase-devel\\nxorg-apps" ~/.dotfiles/arch_packages.txt'

# ls
alias ll='ls -alhF'
alias la='ls -A'
alias l='ls -CF'

# exa
alias lx='exa -l --time-style=long-iso --git'

# Movement
alias cd..="cd .."
alias cd...="cd ../.."
alias cd....="cd ../../.."
alias cd.....="cd ../../../.."
alias cd......="cd ../../../../.."

alias +='pushd'
alias -- -='popd'

#Tail all logs in /var/log
alias logs="find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -f1 | sed -e's/:$//g' | grep -v '[0-9]$' | xargs tail -f"
