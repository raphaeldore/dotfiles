#!/bin/bash

# Human readable and sorted folder size usage (https://web.archive.org/web/20160401132454/http://www.earthinfo.org/linux-disk-usage-sorted-by-size-and-human-readable/)
function duf {
du -sk "$@" | sort -n | while read size fname; do for unit in k M G T P E Z Y; do if [ $size -lt 1024 ]; then echo -e "${size}${unit}\t${fname}"; break; fi; size=$((size/1024)); done; done
}

# https://www.tecmint.com/explain-shell-commands-in-the-linux-shell/
# https://www.mankier.com/blog/explaining-shell-commands-in-the-shell.html
explain () {
	if [ "$#" -eq 0 ]; then
		while read  -p "Command: " cmd; do
			curl -Gs "https://www.mankier.com/api/v2/explain/?cols="$(tput cols) --data-urlencode "q=$cmd"
		done
		echo "Bye!"
		
		elif [ "$#" -ge 1 ]; then
			curl -Gs "https://www.mankier.com/api/v2/explain/?cols="$(tput cols) --data-urlencode "q=$*"
		else
			echo "Usage"
			echo "explain                  interactive mode."
			echo "explain 'cmd -o | ...'   one quoted command to explain it."
		fi
}

# Usage: decrypt_pdf pdf_file
decrypt_pdf() {
	local filename=$1
	local output="${filename/.pdf/_decrypted.pdf}"

	if [ -f "$output" ]; then
		echo -n "File $output already exists. Overwrite? [y/N] "
		local choice
		read -r choice

		case "$choice" in 
		y|Y ) echo "Will overwite.";;
		* ) echo "Aborting."; return;;
		esac
	fi

	qpdf --decrypt "$filename" "$output"
}

has_cmd() {
   command -v "$1" > /dev/null 2>&1
}

list-explicitly-installed-packages() {
	if has_cmd dpkg; then
		# Debian based (Debian, Ubuntu, Linux Mint, whatever.)
		dpkg -l | awk '/^[hi]i/{print $2}'
	elif has_cmd pacman; then
		# Arch Linux
		pacman -Qqe
	elif has_cmd yum; then
		# Fedora, Centos, whatever.
		yum list installed
	elif has_cmd rpm; then
		# Fedora, Centos, whatever.
		rpm -qa
	else
		echo "You are using a package manager that I don't know about." 1>&2
	fi    
}

md5-check() {
    if [ "$#" -ne 2 ]; then
        echo "Usage:"
        echo "md5-check filename expected-md5-hash                 verify md5 hash of a file."
        return 1
    else
        echo "$2  $1" | md5sum -c -
    fi
}

sha1-check() {
    if [ "$#" -ne 2 ]; then
        echo "Usage:"
        echo "sha1-check filename expected-sha1-hash                 verify sha1 hash of a file."
        return 1
    else
        echo "$2  $1" | sha1sum -c -
    fi
}

sha256-check() {
    if [ "$#" -ne 2 ]; then
        echo "Usage:"
        echo "sha256-check filename expected-sha256-hash                 verify sha256 hash of a file."
        return 1
    else
        echo "$2  $1" | sha256sum -c -
    fi
}

##############################################################################
# mark/jump support + completion
# un/mark name : bookmark a directory or remove one (unmark)
# jump name : jump to directory
# marks : show all bookmarks
# Source: https://www.reddit.com/r/commandline/comments/9md3pp/a_very_useful_bashrc_file/e7dy21q/
export MARKPATH=$HOME/.marks
function jump {
    cd -P $MARKPATH/$1 2>/dev/null || echo "No such mark: $1"
}

function mark {
    mkdir -p $MARKPATH; ln -s $(pwd) $MARKPATH/$1
}

function unmark {
    rm -i $MARKPATH/$1
}

function marks {
    ls -l $MARKPATH | sed 's/  / /g' | cut -d' ' -f9- | sed 's/ -/\t-/g' && echo
}

_completemarks() {
  local curw=${COMP_WORDS[COMP_CWORD]}
  local wordlist=$(find $MARKPATH -type l -printf "%f\n")
  COMPREPLY=($(compgen -W '${wordlist[@]}' -- "$curw"))
  return 0
}

complete -F _completemarks jump unmark
##############################################################################