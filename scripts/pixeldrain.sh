#!/bin/bash

PDSERVER="https://pixeldrain.com"
API_KEY_FILE="$HOME/.pixeldrain_api_key"

RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
NC='\033[0m'

display_usage() {
    echo -e "${YELLOW}Usage Instructions for Linux Environment:${NC}"
    echo ""
    echo -e "${CYAN}To make the script globally available, run the following commands in your terminal:${NC}"
    echo -e "   ${GREEN}sudo wget https://raw.githubusercontent.com/tanvirr007/scripts/main/scripts/pixeldrain.sh -O \"/usr/local/bin/pixeldrain\"${NC}"
    echo -e "   ${GREEN}sudo chmod +x /usr/local/bin/pixeldrain${NC}"
    echo ""
    echo -e "${CYAN}To uninstall pixeldrain, you can run:${NC}"
    echo -e "   ${GREEN}sudo rm \"/usr/local/bin/pixeldrain\"${NC}"
    echo ""
    echo -e "${YELLOW}Usage Instructions for Termux:${NC}"
    echo ""
    echo -e "${CYAN}1.${NC} Download this script using wget:"
    echo -e "   ${GREEN}wget https://raw.githubusercontent.com/tanvirr007/scripts/main/scripts/pixeldrain.sh -O \"/data/data/com.termux/files/usr/bin/pixeldrain\" && chmod +x \"/data/data/com.termux/files/usr/bin/pixeldrain\"${NC}"
    echo ""
    echo -e "${CYAN}To uninstall pixeldrain from Termux, you can run:${NC}"
    echo -e "   ${GREEN}rm \"/data/data/com.termux/files/usr/bin/pixeldrain\"${NC}"
}

display_upload_guide() {
    echo ""
    echo ""
    echo -e "${YELLOW}How to Upload Files:${NC}"
    echo ""
    echo -e "${CYAN}1.${NC} Run the script with the file(s) you want to upload:"
    echo -e "   ${GREEN}pixeldrain <your_filename>${NC}"
    echo ""
    echo -e "${CYAN}2.${NC} You can upload multiple files by specifying their names separated by spaces:"
    echo -e "   ${GREEN}pixeldrain <file1> <file2> <file3>${NC}"
    echo ""
    echo -e "${CYAN}3.${NC} If you have long filenames, you can use wildcards like:"
    echo -e "   ${GREEN}pixeldrain So*.zip${NC}"
    echo -e "   ${GREEN}pixeldrain Something*.zip${NC}"
    echo ""
    echo -e "${CYAN}4.${NC} When you run the script for the first time, you’ll be prompted to enter your PixelDrain API key. This key will be saved in your home directory as .pixeldrain_api_key and reused automatically for future uploads. If you want to edit, change, or revoke your API key, simply open it via:"
    echo -e "   ${GREEN}nano .pixeldrain_api_key${NC}"
    echo ""
}

if [ $# -eq 0 ]; then
    echo -e "${RED}Error: No files specified.${NC}"
    display_usage
    display_upload_guide
    exit 1
fi

prompt_api_key() {
    read -p "Enter your Pixeldrain API key: " API_KEY
    if [ -z "$API_KEY" ]; then
        echo -e "${RED}Error: API key cannot be empty.${NC}"
        exit 1
    fi
    echo "Saving API key to $API_KEY_FILE"
    echo "export PIXELDRAIN_API_KEY=\"$API_KEY\"" > "$API_KEY_FILE"
    chmod 600 "$API_KEY_FILE"
}

install_jq() {
    echo -e "${CYAN}jq is required for JSON parsing.${NC}"
    read -p "Do you want to install jq now? (y/n): " install_jq
    if [ "$install_jq" = "y" ] || [ "$install_jq" = "Y" ]; then
        if command -v pacman &> /dev/null; then
            sudo pacman -S jq
        elif command -v apt-get &> /dev/null; then
            sudo apt-get update
            sudo apt-get install jq
        else
            echo -e "${RED}Error: Unsupported package manager.${NC}"
            exit 1
        fi
    else
        echo -e "${RED}Exiting script as jq is required.${NC}"
        exit 1
    fi
}

install_bc() {
    echo -e "${CYAN}bc (Basic Calculator) is required for size calculations.${NC}"
    read -p "Do you want to install bc now? (y/n): " install_bc
    if [ "$install_bc" = "y" ] || [ "$install_bc" = "Y" ]; then
        if command -v pacman &> /dev/null; then
            sudo pacman -S bc
        elif command -v apt-get &> /dev/null; then
            sudo apt-get update
            sudo apt-get install bc
        else
            echo -e "${RED}Error: Unsupported package manager.${NC}"
            exit 1
        fi
    else
        echo -e "${RED}Exiting script as bc is required.${NC}"
        exit 1
    fi
}

check_jq_installation() {
    if ! command -v jq &> /dev/null; then
        install_jq
    fi
}

check_bc_installation() {
    if ! command -v bc &> /dev/null; then
        install_bc
    fi
}

check_jq_installation
check_bc_installation

API_KEY_FILE=$(eval echo "$API_KEY_FILE")

if [ -f "$API_KEY_FILE" ]; then
    source "$API_KEY_FILE"
else
    prompt_api_key
    source "$API_KEY_FILE"
fi

human_readable_size() {
    local size=$1
    if [ "$size" -lt 1024 ]; then
        echo "${size} bytes"
    elif [ "$size" -lt 1048576 ]; then
        echo "$(echo "scale=2; $size/1024" | bc) KB"
    elif [ "$size" -lt 1073741824 ]; then
        echo "$(echo "scale=2; $size/1048576" | bc) MB"
    else
        echo "$(echo "scale=2; $size/1073741824" | bc) GB"
    fi
}

upload_files() {
    local files=("$@")
    success_count=0
    error_count=0
    total_files=${#files[@]}

    if [ $total_files -gt 1 ]; then
        counter=1
    fi

    for file in "${files[@]}"
    do
        if [ ! -f "$file" ]; then
            echo -e "${RED}Error: File $file not found!${NC}"
            error_count=$((error_count + 1))
            continue
        fi

        filename=$(basename "$file")
        filesize=$(stat -c %s "$file")
        human_size=$(human_readable_size $filesize)
        extension="${filename##*.}"
        md5sum=$(md5sum "$file" | awk '{ print $1 }')

        if [ $total_files -gt 1 ]; then
            echo -e "• ${CYAN}$counter:${NC} Uploading Your file ${YELLOW}$filename${NC}"
        else
            echo -e "Uploading Your file ${YELLOW}$filename${NC}"
        fi

        response=$(curl -# -T "$file" -u ":$PIXELDRAIN_API_KEY" "$PDSERVER/api/file/")

        if echo "$response" | grep -q '"success":false'; then
            echo -e "${RED}Error: Failed to upload $filename${NC}"
            echo "Response: $response"
            error_count=$((error_count + 1))
        else
            fileid=$(echo "$response" | jq -r '.id')
            echo -e "${CYAN}Name:${NC} ${YELLOW}$filename${NC}"
            echo -e "${CYAN}File size:${NC} ${YELLOW}$human_size${NC}"
            echo -e "${CYAN}File type:${NC} ${YELLOW}$extension${NC}"
            echo -e "${CYAN}Md5sum:${NC} ${YELLOW}$md5sum${NC}"
            echo -e "${CYAN}File URL:${NC} ${GREEN}$PDSERVER/u/$fileid${NC}"
            success_count=$((success_count + 1))
        fi

        counter=$((counter + 1))
        echo ""
    done

    echo -e "${YELLOW}Upload Status:${NC} ${GREEN}$success_count of $total_files files uploaded successfully.${NC}"
    if [ $error_count -gt 0 ]; then
        echo -e "${RED}$error_count files failed to upload.${NC}"
    fi
}

upload_files "$@"
