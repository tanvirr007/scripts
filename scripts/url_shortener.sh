#!/bin/bash

# Colors
green='\033[0;32m'
cyan='\033[0;36m'
nocolor='\033[0m'

echo -e "${cyan}====================================="
echo -e "       Requirements Installation"
echo -e "=====================================${nocolor}"
echo -e "${green}Note:${nocolor}"
echo -e "This script is based on the TinyURL API."
echo -e "To run this script, ensure you have curl installed:"
echo -e "- On Linux (Debian/Ubuntu): sudo apt install curl"
echo -e "- On macOS: brew install curl"
echo -e "- On Windows: Download curl from https://curl.se/windows/ and follow installation instructions."
echo -e "- On Termux: pkg install curl"
echo -e "${cyan}=====================================${nocolor}"

echo -e "${cyan}====================================="
echo -e "       URL Shortener Script"
echo -e "=====================================${nocolor}"

read -p "Enter the long URL to shorten: " long_url

shortened_url=$(curl -s "http://tinyurl.com/api-create.php?url=$long_url")

echo -e "${green}Shortened URL: $shortened_url${nocolor}"
