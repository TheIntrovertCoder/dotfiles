#!/bin/zsh

setup_git() {
    log "Configuring Git..."
    # Set global defaults
    git config --global init.defaultBranch main

    # Prompt for name if not set
    if [[ -z $(git config --global user.name) ]]; then
        read "name?Enter your Git name: "
        git config --global user.name "$name"
    fi

    # Prompt for email if not set
    if [[ -z $(git config --global user.email) ]]; then
        read "email?Enter your Git email: "
        git config --global user.email "$email"
    fi

    # Set rebase to true for cleaner commit histroy
    git config --global pull.rebase true

    # if neovim is installed
    # Set nvim as the default code editor
    if command -v nvim &>/dev/null; then
        git config --global core.editor "nvim"
    fi

}

