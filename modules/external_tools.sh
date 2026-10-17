#!/bin/zsh

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