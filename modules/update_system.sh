#!/bin/zsh

update_system() {

    if [[ -f /etc/manjaro-release ]]; then
        log "Configuring Manjaro testing branch..."
        sudo pacman-mirrors --api --set-branch testing --fasttrack 5 >/dev/null 2>&1 || \
        log "❌ Failed to set Manjaro testing branch"
    fi

    log "Updating system"
    sudo pacman -Syyuq --noconfirm >/dev/null 2>>/tmp/pacman_errors.log || \
    log "❌ Failed to update system"
}