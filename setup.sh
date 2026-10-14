#!/bin/zsh

# exit on error
set -eu

# --- Configuration ---
PACMAN_PKGS=(base-devel proton-vpn-cli)
AUR_PKGS=(brave-nightly-bin vscodium-insiders-bin)
SWAPPINESS=10
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

PACKAGES_TO_CHECK=(bun uv codium-insiders proton-vpn-cli brave-nightly-bin)

# --- Functions ---

update_system() {
    if [[ -f /etc/manjaro-release ]]; then
        log "Configuring Manjaro testing branch..."
        sudo pacman-mirrors --api --set-branch testing --fasttrack 5
    fi
    sudo pacman -Syyu --noconfirm
}

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

install_url_tool() {
    local name="$1"
    local url="$2"

    if ! command -v "$1" &>/dev/null; then
        log "Installing '$1'"
        curl -LsSf "$2" | bash
    fi

}

install_external_tools() {
    install_url_tool 'bun' 'https://bun.sh/install'
    install_url_tool 'uv' 'https://astral.sh/uv/install.sh'

    # Update current session PATH to include bun and uv binaries
    export PATH="$HOME/.bun/bin:$HOME/.local/bin:$PATH"
}

optimize_ssd_system() {
    log "Optimizing for SSD and system performance..."
    sudo systemctl enable --now fstrim.timer
    echo "vm.swappiness=$SWAPPINESS" | sudo tee /etc/sysctl.d/99-swappiness.conf > /dev/null
    sudo sysctl --system
}

setup_shell() {
    log "Setting up aliases..."
    # Check if the file exists in the cloned dotfiles directory
    if [[ -f "$HOME/.dotfiles/.alias" ]]; then
        # Only add to .zshrc if the source line isn't already there
        grep -q "source $HOME/.dotfiles/.alias" ~/.zshrc || echo "[ -f $HOME/.dotfiles/.alias ] && source $HOME/.dotfiles/.alias" >> ~/.zshrc
        log "✅ Aliases configured in .zshrc"
    else
        log "❌ Error: $HOME/.dotfiles/.alias not found. Did you clone the repo?"
    fi
}

cleanup() {
    log "Cleaning up orphans and cache..."
    if [[ -n $(pacman -Qtdq) ]]; then
        sudo pacman -Rns $(pacman -Qtdq) --noconfirm
    fi
    sudo pacman -Sc --noconfirm
}

setup_editor() {

    if command -v codium-insiders &>/dev/null; then
        for ext in ${EXTENSIONS[@]}; do
            codium-insiders --install-extension "$ext"
        done   
    fi
}

verify_install() {
    
    log "Verifying installation..."

    for pkg in ${PACKAGES_TO_CHECK[@]}; do
        # Format: [Command] && [Do this on success] || [Do this on failure]
        command -v "$pkg" &>/dev/null && echo "✅ $pkg installed" || echo "❌ $pkg installation failed"    
    done

}

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

setup_interactive_installers() {
    log "Installing NextDNS"
    sh -c "$(curl -sL https://nextdns.io/install)"
}

log() {
    echo "[$(date +'%H:%M:%S')] $1"
}


# --- Execution ---

update_system
install_pacman_pkgs
install_aur_packages
install_external_tools
optimize_ssd_system
setup_shell
cleanup
setup_editor
setup_git
setup_interactive_installers
verify_install

log "Setup complete! Please reboot to apply all changes."
