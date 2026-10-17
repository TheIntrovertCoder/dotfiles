#1/bin/zsh

optimize_ssd_system() {

SWAPPINESS=10

    log "Optimizing for SSD and system performance..."

    # Enable fstrim (SSD TRIM)
    if ! sudo systemctl is-enabled --now fstrim.timer >/dev/null 2>&1; then
        sudo systemctl enable --now fstrim.timer && \
        log "✅ fstrim.timer enabled" || \
        log "❌ Failed to enable fstrim.timer"
    else
        log "ℹ️ fstrim.timer already enabled"
    fi

    # Configure swappiness
    local swappiness_file="/etc/sysctl.d/99-swappiness.conf"
    if [[ "$SWAPPINESS" -ge 0 && "$SWAPPINESS" -le 100 ]]; then
        echo "vm.swappiness=$SWAPPINESS" | sudo tee "$swappiness_file" >/dev/null && \
        log "✅ Swappiness set to $SWAPPINESS" || \
        log "❌ Failed to set swappiness"
    else
        log "⚠️ Invalid SWAPPINESS value ($SWAPPINESS). Skipping."
    fi

    # Apply sysctl changes
    if sudo sysctl --system >/dev/null 2>&1; then
        log "✅ Applied sysctl changes"
    else
        log "❌ Failed to apply sysctl changes"
    fi

}