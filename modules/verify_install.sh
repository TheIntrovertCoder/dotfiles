#1/bin/zsh

source $PWD/utils/log.sh

PACKAGES_TO_CHECK=(bun uv codium-insiders protonvpn brave-browser-nightly nextdns)

verify_install() {

    for pkg in ${PACKAGES_TO_CHECK[@]}; do
        # Format: [Command] && [Do this on success] || [Do this on failure]
        command -v "$pkg" &>/dev/null && echo "✅ $pkg installed" || echo "❌ $pkg installation failed"    
        
    done

}