#!/usr/bin/env bash

# --- Color & Style Config ---
BOLD="\033[1m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
CYAN="\033[36m"
RESET="\033[0m"

# --- Logging Functions ---
info() {
    echo -e "${BLUE}ℹ️  ${RESET} $1"
}

success() {
    echo -e "${GREEN}✅  $1${RESET}"
}

warn() {
    echo -e "${YELLOW}⚠️  $1${RESET}"
}

error() {
    echo -e "${RED}❌  Error: $1${RESET}"
    exit 1
}

header() {
    echo -e "\n${BOLD}${CYAN}🚀  $1 ${RESET}\n"
}

# Strict Error Handling
set -euo pipefail

# Trap for unexpected errors
trap 'echo -e "\n${RED}💥 Script failed unexpectedly on line $LINENO.${RESET}";' ERR

# --- Script Start ---
clear
echo -e "${BOLD}${CYAN}=========================================${RESET}"
echo -e "${BOLD}${CYAN}   🐍 LARAVEL AUTO-INSTALLER 🐍   ${RESET}"
echo -e "${BOLD}${CYAN}      Created by @backendrulz      ${RESET}"
echo -e "${BOLD}${CYAN}=========================================${RESET}"

# 1. Check Dependencies
if ! command -v ddev &> /dev/null; then
    error "DDEV is not installed. Please install it first."
fi

# 2. Request Project Name
echo -e "${YELLOW}Project name (folder):${RESET} [my-laravel-site]"
read -r PROJECT_NAME
PROJECT_NAME=${PROJECT_NAME:-my-laravel-site}

if [ -d "$PROJECT_NAME" ]; then
    warn "The folder '$PROJECT_NAME' already exists."
    read -p "Do you want to continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        error "Operation cancelled by user."
    fi
fi

# 3. Create Directory
header "Creating project directory: $PROJECT_NAME"
mkdir -p "$PROJECT_NAME" && cd "$PROJECT_NAME"
success "Directory created and accessed."

# 4. Configure DDEV
header "Configuring DDEV 🐳"
ddev config --project-type=laravel --docroot=public
success "DDEV configuration complete."

# 5. Start DDEV
header "Starting containers... (this might take a moment ⏳)"
ddev start -y
success "DDEV started successfully."

# 6. Install Laravel with Composer
header "Installing Laravel 12... 📦✨"
# Note: create-project in a folder with .ddev requires forcing or using an empty folder.
# DDEV handles this well, using --no-interaction to prevent blocking.
ddev composer create-project "laravel/laravel:^12" --no-interaction
success "Laravel installed."

# 6a. Install Pest (Optional)
header "Pest Testing Framework Setup 🧪"
echo -e "${YELLOW}Do you want to install Pest (and remove PHPUnit)? (y/n)${RESET} "
read -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    info "Removing PHPUnit..."
    ddev composer remove phpunit/phpunit

    info "Installing Pest..."
    ddev composer require pestphp/pest --dev --with-all-dependencies

    info "Initializing Pest..."
    ddev exec ./vendor/bin/pest --init

    success "Pest installed and initialized."
else
    info "Skipping Pest installation."
fi

# 7. Launch Project
header "All set! Launching the site... 🚀"
info "Project URL: https://$PROJECT_NAME.ddev.site"
ddev launch

echo -e "\n${BOLD}${GREEN}🎉  Installation completed successfully! Happy coding. 🎉${RESET}\n"
