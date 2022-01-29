#!/bin/bash
PROMPT="\"$1\""
shift 1
CHOICES=$(echo "$@" | sed 's/ /" "/g')
CHOICES=\'\(\"$CHOICES\"\)
emacsclient --eval "(ivy-read $PROMPT $CHOICES)"
