#!/bin/bash

# My required packages
termux-change-repo
pkg update && pkg upgrade -y
pkg install git
pkg install gh
pkg install tmate
pkg install android-tools
pkg install termux-tools
pkg install termux-exec
pkg install openssh
apt install openssl-tool
pkg install -y root-repo
pkg install android-tools
pkg install -y git tsu python wpa-supplicant pixiewps iw openssl
pkg install zsh
pkg install curl
pkg install rxfetch
pkg install tmux
pkg install htop
pkg install byobu
pkg install jq

My favorite wifi tool
git clone https://github.com/tanvir-projects-archive/OneShot.git

My GutHub config
curl -O https://raw.githubusercontent.com/tanvirr007/scripts/main/scripts/setup_github.sh
bash setup_github.sh

# My zsh setup
sh -c "$(curl -fsSL https://github.com/tanvir-projects-archive/termux-ohmyzsh/raw/master/install.sh)"
~/.termux/colors.sh
~/.termux/fonts.sh

clear

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
