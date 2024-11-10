#!/bin/bash

SERVER="https://bashupload.com"

RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
NC='\033[0m'

display_usage() {
    echo -e "${CYAN}Usage Instructions for Linux Environment:${NC}"
    echo ""
    echo -e "${CYAN}To make the script globally available, run the following commands in your terminal:${NC}"
    echo -e "${GREEN}sudo wget https://raw.githubusercontent.com/tanvirr007/scripts/main/scripts/bashupload.sh -O \"/usr/local/bin/bashupload\"${NC}"
    echo -e "${GREEN}sudo chmod +x /usr/local/bin/bashupload${NC}"
    echo ""
    echo -e "${CYAN}If you want to uninstall bashupload, you can run:${NC}"
    echo -e "${GREEN}sudo rm \"/usr/local/bin/bashupload\"${NC}"
    echo ""
    echo -e "${RED}Be careful with typos! You don't want to accidentally remove your /usr, like this:${NC} https://github.com/MrMEEE/bumblebee-Old-and-abbandoned/issues/123"
    echo ""
    echo -e "${CYAN}Usage Instructions for Termux:${NC}"
    echo ""
    echo -e "${CYAN}1. Download this script using wget:${NC}"
    echo -e "${GREEN}wget https://raw.githubusercontent.com/tanvirr007/scripts/main/scripts/bashupload.sh -O \"/data/data/com.termux/files/usr/bin/bashupload\" && chmod +x \"/data/data/com.termux/files/usr/bin/bashupload\"${NC}"
    echo ""
    echo -e "${CYAN}To uninstall bashupload from Termux, you can run:${NC}"
    echo -e "${GREEN}rm \"/data/data/com.termux/files/usr/bin/bashupload\"${NC}"
    echo ""
    echo -e "${YELLOW}How to Upload Files:${NC}"
    echo ""
    echo -e "${CYAN}1.${NC} Run the script with the file(s) you want to upload:"
    echo -e "   ${GREEN}bashupload <your_filename>${NC}"
    echo ""
    echo -e "${CYAN}2.${NC} You can upload multiple files by specifying their names separated by spaces:"
    echo -e "   ${GREEN}bashupload <file1> <file2> <file3>${NC}"
    echo ""
    echo -e "${CYAN}3.${NC} If you have long filenames, you can use wildcards like:"
    echo -e "   ${GREEN}bashupload So*.zip${NC}"
    echo -e "   ${GREEN}bashupload Something*.zip${NC}"
    echo ""
    echo -e "${YELLOW}Note:${NC} You cannot upload empty/zero-byte file(s) into bashupload."
}

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

if [ $# -eq 0 ]; then
    echo -e "${RED}Error: No files specified.${NC}"
    display_usage
    exit 1
fi

upload_files() {
    local files=("$@")
    success_count=0
    error_occurred=false
    file_number=1

    if [ ${#files[@]} -eq 1 ]; then
        for file in "${files[@]}"
        do
            echo -e "Uploading file ${YELLOW}$file${NC}"
            if [ ! -f "$file" ]; then
                echo -e "${RED}Error: File $file not found!${NC}"
                error_occurred=true
                continue
            fi

            filename=$(basename "$file")
            filesize=$(stat -c %s "$file")
            human_size=$(human_readable_size $filesize)
            extension="${filename##*.}"
            md5sum=$(md5sum "$file" | awk '{ print $1 }')

            echo -e "Uploading file ${YELLOW}$filename${NC} (${human_size})..."
            response=$(curl -# -T "$file" "$SERVER")

            echo -e "${CYAN}Response from server:${NC}"
            echo "$response"

            file_url=$(echo "$response" | grep -oP 'https://bashupload.com/[a-zA-Z0-9]+/'"$filename")

            if [ -z "$file_url" ]; then
                echo -e "${RED}Error: Failed to upload $filename${NC}"
                echo "Response: $response"
                error_occurred=true
            else
                echo -e "${CYAN}Name:${NC} ${YELLOW}$filename${NC}"
                echo -e "${CYAN}File size:${NC} ${YELLOW}$human_size${NC}"
                echo -e "${CYAN}File type:${NC} ${YELLOW}$extension${NC}"
                echo -e "${CYAN}MD5sum:${NC} ${YELLOW}$md5sum${NC}"
                echo -e "${CYAN}Download URL:${NC} ${GREEN}$file_url${NC}"
                success_count=$((success_count + 1))
            fi

            echo ""
            echo -e "${CYAN}Upload Status:${NC} Your file uploaded successfully."
            echo ""
        done
    else
        for file in "${files[@]}"
        do
            echo -e "• ${file_number}: Uploading file ${YELLOW}$file${NC}"

            if [ ! -f "$file" ]; then
                echo -e "${RED}Error: File $file not found!${NC}"
                error_occurred=true
                continue
            fi

            filename=$(basename "$file")
            filesize=$(stat -c %s "$file")
            human_size=$(human_readable_size $filesize)
            extension="${filename##*.}"
            md5sum=$(md5sum "$file" | awk '{ print $1 }')

            echo -e "Uploading file ${YELLOW}$filename${NC} (${human_size})..."

            response=$(curl -# -T "$file" "$SERVER")

            echo -e "${CYAN}Response from server:${NC}"
            echo "$response"

            file_url=$(echo "$response" | grep -oP 'https://bashupload.com/[a-zA-Z0-9]+/'"$filename")

            if [ -z "$file_url" ]; then
                echo -e "${RED}Error: Failed to upload $filename${NC}"
                echo "Response: $response"
                error_occurred=true
            else
                echo -e "${CYAN}Name:${NC} ${YELLOW}$filename${NC}"
                echo -e "${CYAN}File size:${NC} ${YELLOW}$human_size${NC}"
                echo -e "${CYAN}File type:${NC} ${YELLOW}$extension${NC}"
                echo -e "${CYAN}MD5sum:${NC} ${YELLOW}$md5sum${NC}"
                echo -e "${CYAN}Download URL:${NC} ${GREEN}$file_url${NC}"
                success_count=$((success_count + 1))
            fi

            echo ""
            file_number=$((file_number + 1))
        done
        echo -e "${CYAN}Upload Status:${NC} ${GREEN}$success_count of ${#files[@]} files uploaded.${NC}"
    fi
}

upload_files "$@"
