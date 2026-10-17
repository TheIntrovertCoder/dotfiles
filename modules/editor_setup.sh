#!/bin/zsh

EXTENSIONS=(
    "aaron-bond.better-comments"
    "bradlc.vscode-tailwindcss"
    "christian-kohler.path-intellisense"
    "dbaeumer.vscode-eslint"
    "esbenp.prettier-vscode"
    "gruntfuggly.todo-tree"
    "ms-playwright.playwright"
    "ms-vscode.vscode-typescript-next"
    "svelte.svelte-vscode"
    "usernamehw.errorlens"
    "yoavbls.pretty-ts-errors"
)

setup_editor() {

    if command -v codium-insiders &>/dev/null; then
        for ext in ${EXTENSIONS[@]}; do
            codium-insiders --install-extension "$ext"
        done   
    fi
}