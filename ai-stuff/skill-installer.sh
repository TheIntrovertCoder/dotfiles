#!/bin/zsh

file="$PWD/ai-stuff/skills.json"

if [[ ! -f "$file" ]]; then
    echo "❌ Error: $file doesn't exist"
    exit 1
fi

while IFS= read -r item; do
    name=$(jq -r '.name' <<< "$item")
    source_url=$(jq -r '.sourceUrl' <<< "$item")

if bunx skills add "$source_url" --skill "$name" --global --agent opencode -y < /dev/null; then
    echo "Finished: $name"
else
    echo "Failed: $name"
fi
done < <(jq -c '.[]' "$file")


# copy custom config

dest="$HOME/.config/opencode"
source_dir="$PWD/ai-stuff"

mkdir -p "$dest" || exit 1

for file in AGENTS.md opencode.json; do
    if [[ -f "$dest/$file" ]]; then
        echo "❎ $dest/$file already exists"
    elif [[ -f "$source_dir/$file" ]]; then
        if cp "$source_dir/$file" "$dest/$file"; then
            echo "☑️ Copied $file to $dest/"
        else
            echo "❎ Failed to copy $file"
        fi
    else
        echo "❎ Source file not found: $source_dir/$file"
    fi
done