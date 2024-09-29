#!/bin/bash

# Colors
yellow='\033[1;33m'
white='\033[0;37m'
nocolor='\033[0m'

# Function to get commit infos
get_commit_info() {
    local commit_hash=$1

    # Get commit information
    local branch_name=$(git rev-parse --abbrev-ref HEAD)
    local commit_date=$(git show -s --format='%ci' "$commit_hash" | sed 's/\+.*//')  # Commit date without timezone
    local author_name=$(git show -s --format='%aN' "$commit_hash")
    local author_email=$(git show -s --format='%aE' "$commit_hash")
    local commit_message=$(git show -s --format='%s' "$commit_hash")
    local changed_files=$(git show --name-only --pretty=format:'' "$commit_hash")  # List of changed files

    # Show commit information with colors
    echo -e "${yellow}• Branch Name:${nocolor} ${white}$branch_name${nocolor}"
    echo -e "${yellow}• Commit Date:${nocolor} ${white}$commit_date${nocolor}"
    echo -e "${yellow}• Author Name:${nocolor} ${white}$author_name${nocolor}"
    [[ -n $author_email ]] && echo -e "${yellow}• Author Email:${nocolor} ${white}$author_email${nocolor}"
    echo -e "${yellow}• Commit Hash:${nocolor} ${white}$commit_hash${nocolor}"
    echo -e "${yellow}• Commit Message:${nocolor} ${white}$commit_message${nocolor}"

    if [[ -n $changed_files ]]; then
        echo -e "${yellow}• Changed Files:${nocolor}"
        echo "$changed_files" | sed 's/^/  - /'  # Format the changed files
    else
        echo -e "${yellow}• Changed Files:${nocolor} ${white}None${nocolor}"
    fi
}

# Results
echo -e "${yellow}=====================================${nocolor}"
read -p "Enter the commit hash to get details: " commit_hash
get_commit_info "$commit_hash"
