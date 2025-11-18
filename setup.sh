#!/bin/bash

# =============================
# Universal Debian + JWM Setup (Minimal)
# =============================

# -------- VARIABLES --------
USER_HOME="$HOME"
GIT_REPO="https://github.com/growty/custom-jwm.git"
CLONE_DIR="$USER_HOME/custom-jwm"

APT_PACKAGES=(
    # Lightweight desktop / JWM
    lxterminal
    pcmanfm
    brightnessctl
    gnome-screenshot
    network-manager-gnome
    lxpanel
    x11-xkb-utils
    lxdm
    jwm
    feh
    x11-xserver-utils
    x11-utils
    volumeicon-alsa
    picom
    xfce4-power-manager
    # Audio only
    pulseaudio
    pulseaudio-utils
    # Firmware
    firmware-sof-signed
    firmware-iwlwifi
)

GREEN="\e[32m"
YELLOW="\e[33m"
RESET="\e[0m"

# -------- SYSTEM UPDATE --------
echo -e "${GREEN}Updating system...${RESET}"
sudo apt update -y && sudo apt upgrade -y

# -------- ADD NON-FREE & CONTRIB --------
echo -e "${GREEN}Adding contrib and non-free repositories...${RESET}"
sudo sed -i '/^deb / s/$/ contrib non-free/' /etc/apt/sources.list
sudo apt update -y

# -------- INSTALL PACKAGES (MINIMAL) --------
echo -e "${GREEN}Installing required packages (minimal)...${RESET}"
for pkg in "${APT_PACKAGES[@]}"; do
    if dpkg -s "$pkg" &> /dev/null; then
        echo -e "${YELLOW}✔ $pkg already installed, skipping...${RESET}"
    else
        echo -e "${GREEN}➜ Installing $pkg...${RESET}"
        sudo apt install -y --no-install-recommends "$pkg"
    fi
done

# -------- CLONE OR UPDATE CUSTOM JWM REPO --------
echo -e "${GREEN}Setting up custom JWM repo...${RESET}"
if [ -d "$CLONE_DIR" ]; then
    echo -e "${YELLOW}✔ $CLONE_DIR already exists, pulling latest changes without deleting files...${RESET}"
    git -C "$CLONE_DIR" pull || echo -e "${YELLOW}⚠ Could not pull updates, continuing with existing files.${RESET}"
else
    git clone "$GIT_REPO" "$CLONE_DIR"
fi

# -------- CREATE NECESSARY FOLDERS --------
mkdir -p "$USER_HOME/.config/autostart-scripts"
mkdir -p "$USER_HOME/.jwm"

# -------- COPY FILES TO RESPECTIVE PATHS --------
echo -e "${GREEN}Copying files to proper locations...${RESET}"
cp "$CLONE_DIR/.asoundrc" "$USER_HOME/.asoundrc"
cp "$CLONE_DIR/.fehbg.sh" "$USER_HOME/.fehbg.sh"
cp "$CLONE_DIR/set-touchpad-settings.sh" "$USER_HOME/set-touchpad-settings.sh"
cp "$CLONE_DIR/load_dmic.sh" "$USER_HOME/.config/autostart-scripts/load_dmic.sh"
cp "$CLONE_DIR/.jwm"/* "$USER_HOME/.jwm/"

# -------- SET EXECUTABLE PERMISSIONS --------
echo -e "${GREEN}Setting executable permissions...${RESET}"
chmod +x "$USER_HOME/set-touchpad-settings.sh"
chmod +x "$USER_HOME/.fehbg.sh"
chmod +x "$USER_HOME/.config/autostart-scripts/load_dmic.sh"

echo -e "${GREEN}✅ All done! Please reboot your system for changes to take effect.${RESET}"
