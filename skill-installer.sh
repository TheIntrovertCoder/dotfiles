#!/bin/zsh

# check if skills file exists before running
if [ ! -f "$PWD/skills.jsonc" ]; then
    echo "skills.json doesn't exist"
    exit 1
fi
