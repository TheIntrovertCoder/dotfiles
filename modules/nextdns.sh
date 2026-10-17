#!/bin/zsh

setup_interactive_installers() {
    log "Installing NextDNS"
    sh -c "$(curl -sL https://nextdns.io/install)"
}