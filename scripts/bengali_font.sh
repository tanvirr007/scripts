#!/bin/bash

REPO_URL="https://raw.githubusercontent.com/tanvirr007/scripts/main/assets/fonts/SolaimanLipiNormal.ttf"

FONT_DIR="$HOME/.termux/fonts"

mkdir -p "$FONT_DIR"

echo "Downloading Bengali font..."
wget -q "$REPO_URL" -O "$FONT_DIR/SolaimanLipiNormal.ttf"

echo "Setting up the font configuration..."
echo "font = $FONT_DIR/SolaimanLipiNormal.ttf" > ~/.termux/font

echo "Font applied successfully. Please restart Termux to see the changes."
