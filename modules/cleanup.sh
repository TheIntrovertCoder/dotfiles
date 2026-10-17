#!/bin/zsh

cleanup() {
    log "Cleaning up orphans and cache..."
    if [[ -n $(pacman -Qtdq) ]]; then
        sudo pacman -Rns $(pacman -Qtdq) --noconfirm
    fi
    sudo pacman -Sc --noconfirm
}
