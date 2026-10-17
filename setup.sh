#!/bin/zsh

# clean terminal
clear

# exit on error
set -eu

# Source utility functions
source "$(dirname "$0")/utils/log.sh"

# Source modules
source "$(dirname "$0")/modules/update_system.sh"
source "$(dirname "$0")/modules/packages.sh"
source "$(dirname "$0")/modules/external_tools.sh"
source "$(dirname "$0")/modules/system_optimize.sh"
source "$(dirname "$0")/modules/shell_setup.sh"
source "$(dirname "$0")/modules/editor_setup.sh"
source "$(dirname "$0")/modules/git_setup.sh"
source "$(dirname "$0")/modules/nextdns.sh"
source "$(dirname "$0")/modules/cleanup.sh"
source "$(dirname "$0")/modules/verify_install.sh"


# --- Execution ---

update_system
uninstall_packages
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
