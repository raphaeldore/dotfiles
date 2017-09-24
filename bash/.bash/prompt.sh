#!/bin/bash

if [[ $(uname -r) =~ Microsoft$ ]]; then
    # WSL specific configuration. (Anything git related is slow as balls under WSL)
    # Basic prompt: [Error code] $PWD \n TIME:

    function nonzero_return() {
        RETVAL=$?
        [ $RETVAL -ne 0 ] && echo "$RETVAL"
    }

    lightblue_color="\e[94m"
    red_color="\e[31m"
    lightgreen_color="\e[92m"
    reset_color="\e[0m"

    export PS1="\[${red_color}\]\`nonzero_return\`\[${reset_color}\] \[${lightblue_color}\]\w\[${reset_color}\]\n\A $ "
else
    # Bash git prompt config

    GIT_PROMPT_FETCH_REMOTE_STATUS=0 # Avoid fetching remote status
    GIT_PROMPT_SHOW_UNTRACKED_FILES=normal # can be no, normal or all; determines counting of untracked files

    source ~/.bash-git-prompt/gitprompt.sh
fi
