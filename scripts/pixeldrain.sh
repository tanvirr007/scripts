#!/bin/bash
PDSERVER="https://pixeldrain.com"
API_KEY_FILE="$HOME/.pixeldrain_api_key"

prompt_api_key() {
    read -p "Enter your Pixeldrain API key: " API_KEY
    if [ -z "$API_KEY" ]; then
        echo "Error: API key cannot be empty."
        exit 1
    fi
    echo "Saving API key to $API_KEY_FILE"
    echo "export PIXELDRAIN_API_KEY=\"$API_KEY\"" > "$API_KEY_FILE"
    chmod 600 "$API_KEY_FILE"
}

install_jq() {
    echo "jq is required for JSON parsing."
    read -p "Do you want to install jq now? (y/n): " install_jq
    if [ "$install_jq" = "y" ] || [ "$install_jq" = "Y" ]; then
        sudo apt-get update
        sudo apt-get install jq
    else
        echo "Exiting script as jq is required."
        exit 1
    fi
}

check_jq_installation() {
    if ! command -v jq &> /dev/null; then
        install_jq
    fi
}

check_jq_installation

API_KEY_FILE=$(eval echo "$API_KEY_FILE")

if [ -f "$API_KEY_FILE" ]; then
    source "$API_KEY_FILE"
else
    prompt_api_key
    source "$API_KEY_FILE"
fi

upload_files() {
    local files=("$@")

    for file in "${files[@]}"
    do
        if [ ! -f "$file" ]; then
            echo "Error: File $file not found!"
            continue
        fi

        filename=$(basename "$file")

        echo "Uploading $filename ..."
        response=$(curl -# -T "$file" -u ":$PIXELDRAIN_API_KEY" "$PDSERVER/api/file/")


        if echo "$response" | grep -q '"success":false'; then
            echo "Error: Failed to upload $filename"
            echo "Response: $response"
        else
            fileid=$(echo "$response" | jq -r '.id')
            echo "Your file URL: $PDSERVER/u/$fileid"
        fi

        echo ""
    done
}

if [ $# -eq 0 ]; then
    echo "Usage: pdup <file1> <file2> ... <fileN>"
    exit 1
fi

upload_files "$@"
