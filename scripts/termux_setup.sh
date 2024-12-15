#!/bin/bash

# My required packages
termux-change-repo
pkg update && pkg upgrade -y
pkg install git -y
pkg install gh -y
pkg install tmate -y
pkg install android-tools -y
pkg install termux-tools -y
pkg install termux-exec -y
pkg install openssh -y
apt install openssl-tool -y
pkg install root-repo -y
pkg install tsu python wpa-supplicant pixiewps iw openssl -y
pkg install zsh -y
pkg install curl -y
pkg install rxfetch -y
pkg install tmux -y
pkg install htop -y
pkg install byobu -y
pkg install jq -y
pkg install wget -y
pkg install bc -y

# My favorite wifi tool
git clone https://github.com/tanvir-projects-archive/OneShot.git

# My GutHub config
curl -O https://raw.githubusercontent.com/tanvirr007/scripts/main/scripts/setup_github.sh
bash setup_github.sh

# My zsh setup
sh -c "$(curl -fsSL https://github.com/tanvir-projects-archive/termux-ohmyzsh/raw/master/install.sh)"
~/.termux/colors.sh
~/.termux/fonts.sh

# Pixeldrain
wget https://raw.githubusercontent.com/tanvirr007/scripts/main/scripts/pixeldrain.sh -O "/data/data/com.termux/files/usr/bin/pixeldrain" && chmod +x "/data/data/com.termux/files/usr/bin/pixeldrain"

# Gofile
wget https://raw.githubusercontent.com/tanvirr007/scripts/main/scripts/gofile.sh -O "/data/data/com.termux/files/usr/bin/gofile" && chmod +x "/data/data/com.termux/files/usr/bin/gofile"

# Clear terminal
clear

# Testing Pixeldrain & Gofile
touch Pixeldrain.json
touch Gofile.json

pixeldrain Pixeldrain.json
gofile Gofile.json

echo -n " pixeldrain and gofile both are wokring -"

rm Pixeldrain.json
rm Gofile.json

# Countdowm
echo -n "Showing device specifications in "
for i in {10..1}; do
    echo -n "$i.."
    sleep 1
done
echo "showing specifications now"


clear
rxfetch

# End
