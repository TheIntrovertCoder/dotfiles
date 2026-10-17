#!/bin/zsh

PACMAN_PKGS=(base-devel proton-vpn-cli)
AUR_PKGS=(brave-nightly-bin vscodium-insiders-bin)

install_pacman_pkgs() {
    log "Installing official packages..."
    for pkg in ${PACMAN_PKGS[@]}; do
        sudo pacman -S --needed --noconfirm "$pkg" && log "☑️ $pkg installed successfully" || log "❌ $pkg wasn't installed"
    done
}

install_aur_packages() {
    if [[ -f /etc/manjaro-release ]]; then
        log "Installing yay"
        sudo pacman -S yay --noconfirm

        log "Installing AUR packages..."
        for pkg in ${AUR_PKGS[@]}; do
            yay -S --needed --noconfirm --cleanafter --answerdiff N --answerclean A "$pkg" && log "☑️ $pkg installed successfully" || log "❌ $pkg wasn't installed"
        done
    fi
}