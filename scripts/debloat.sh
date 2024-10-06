#!/bin/bash

echo "Starting debloat process..."
echo "==============================="

RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
MAGENTA="\033[35m"
CYAN="\033[36m"
RESET="\033[0m"

declare -A apps=(
    ["com.google.android.apps.subscriptions.red"]="Google Play Services Subscriptions"
    ["com.google.android.videos"]="Google Play Movies & TV"
    ["com.google.android.apps.youtube.music"]="YouTube Music"
    ["com.google.android.apps.youtube"]="YouTube"
    ["com.google.android.apps.magazines"]="Google Play Newsstand"
    ["com.google.android.apps.podcasts"]="Google Podcasts"
    ["com.google.android.apps.tachyon"]="Google Duo"
    ["com.google.android.apps.googleassistant"]="Google Assistant"
    ["com.google.android.googlequicksearchbox"]="Google Search"
    ["com.google.android.apps.maps"]="Google Maps"
    ["com.micredit.in"]="Mi Credit"
    ["com.android.email"]="Email"
    ["com.mi.globalbrowser"]="Mi Browser"
    ["com.miui.huanji"]="Miui Huanji"
    ["com.xiaomi.midrop"]="Mi Drop"
    ["com.android.quicksearchbox"]="Google Quick Search Box"
    ["com.google.ar.lens"]="Google Lens"
    ["com.google.android.calendar"]="Google Calendar"
    ["com.google.android.projection.gearhead"]="Android Auto"
    ["com.google.android.apps.wellbeing"]="Digital Wellbeing"
    ["com.google.android.apps.turbo"]="Turbo"
    ["com.facebook.system"]="Facebook System"
    ["com.facebook.services"]="Facebook Services"
    ["com.facebook.appmanager"]="Facebook App Manager"
    ["com.miui.msa.global"]="MIUI MSA"
    ["com.android.hotwordenrollment.okgoogle"]="OK Google"
    ["com.android.hotwordenrollment.xgoogle"]="OK Google"
    ["com.miui.daemon"]="MIUI Daemon"
    ["com.xiaomi.simactivate.service"]="Mi SIM Activation"
    ["com.miui.bugreport"]="MIUI Bug Report"
    ["com.miui.miservice"]="MIUI Service"
    ["com.miui.analytics"]="MIUI Analytics"
    ["com.mi.globalminusscreen"]="Mi Global Minus Screen"
    ["com.xiaomi.mipicks"]="Mi Picks"
    ["com.mi.android.globalFileexplorer"]="Mi File Explorer"
    ["com.google.android.feedback"]="Google Feedback"
    ["com.xiaomi.payment"]="Mi Payment"
    ["com.xiaomi.mi_connect_service"]="Mi Connect Service"
    ["com.miui.player"]="MIUI Player"
    ["com.google.android.youtube"]="YouTube"
    ["com.xiaomi.glgm"]="Mi GLGM"
    ["com.google.android.apps.safetyhub"]="Google Safety Hub"
    ["com.bsp.catchlog"]="Catch Log"
    ["com.mi.global.shop"]="Mi Global Shop"
    ["com.boundax.koreapreloadappinstaller"]="Korea Preload App Installer"
    ["com.miui.weather2"]="Mi Weather"
    ["com.mi.health"]="Mi Health"
    ["com.miui.notes"]="Mi Notes"
    ["com.miui.cleaner"]="Mi Cleaner"
)

for package in "${!apps[@]}"; do
    while true; do
        echo -e "• Do you want to debloat ${YELLOW}${apps[$package]}${RESET} (${CYAN}$package${RESET})? (y/n): "
        read answer
        if [[ $answer == "y" || $answer == "n" ]]; then
            break
        else
            echo -e "${RED}Invalid input. Please enter 'y' for yes or 'n' for no.${RESET}"
        fi
    done

    if [[ $answer == "y" ]]; then
        echo -e "Uninstalling ${YELLOW}${apps[$package]}${RESET}..."
        output=$(su -c "pm uninstall -k --user 0 $package" 2>&1)
        if [[ $output == *"Success"* ]]; then
            echo -e "${YELLOW}${apps[$package]}${RESET} has been uninstalled."
        elif [[ $output == *"not installed for 0"* ]]; then
            echo -e "${RED}Failed to uninstall ${apps[$package]}. Reason: [not installed for 0]${RESET}"
        else
            echo -e "${RED}Failed to uninstall ${apps[$package]}. Reason: [$output]${RESET}"
        fi
    else
        echo -e "Skipping ${YELLOW}${apps[$package]}${RESET}."
    fi
done

echo "Debloat process completed."
