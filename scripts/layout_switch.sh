#!/bin/zsh

# If an explicit layout is provided, use it. 
# Else, cycle between predefined layouts
if [[ -n "$1" ]]; then
    setxkbmap $1
else
    layout=$(setxkbmap -query | awk 'END{print $2}')
    case $layout in
        us)
                setxkbmap ru
            ;;
        it)
                setxkbmap fr
            ;;
        *)
                setxkbmap us
            ;;
    esac
fi

