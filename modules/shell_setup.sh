#1/bin/zsh

#!/bin/zsh

# Define dotfiles to source (relative to ~/.dotfiles/dots/)
DOTFILES=(
    ".alias"
)

setup_shell() {
    log "Setting up shell configurations..."

    local dotfiles_dir="$HOME/.dotfiles/dots"
    local zshrc_path="$HOME/.zshrc"

    for file in "${DOTFILES[@]}"; do
        local full_path="$dotfiles_dir/$file"
        local source_line="[ -f $full_path ] && source $full_path"

        if [[ -f "$full_path" ]]; then
            if ! grep -qF "$source_line" "$zshrc_path"; then
                echo "$source_line" >> "$zshrc_path"
                log "✅ Added $file to .zshrc"
            else
                log "ℹ️ $file already sourced in .zshrc"
            fi
        else
            log "⚠️ Warning: $full_path not found. Skipping."
        fi
    done
}