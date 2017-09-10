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
