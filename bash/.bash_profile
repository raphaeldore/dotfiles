#!/bin/bash

[[ -s ~/.profile ]] && source ~/.profile

source ~/.bash/path.sh
source ~/.bash/env.sh
source ~/.bash/completion.sh

source ~/.bash/aliases.sh
source ~/.bash/functions.sh

if [[ $(lsb_release --short --id) = Ubuntu ]]; then
    source ~/.bash/functions_ubuntu.sh
fi

source ~/.bash/prompt.sh
