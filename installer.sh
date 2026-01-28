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

# --- Argument Parsing ---
WITH_GIT=false
WITH_PEST=false
WITH_BUN=false
PROJECT_NAME=""

usage() {
    echo -e "${BOLD}Usage:${RESET} $(basename "$0") [project-name] [options]"
    echo -e "\n${BOLD}Options:${RESET}"
    echo -e "  ${GREEN}--git${RESET}      Initialize Git repository"
    echo -e "  ${GREEN}--pest${RESET}     Install Pest testing framework"
    echo -e "  ${GREEN}--bun${RESET}      Use Bun runtime (installs ddev-bun)"
    echo
}

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --git) WITH_GIT=true ;;
        --pest) WITH_PEST=true ;;
        --bun) WITH_BUN=true ;;
        -h|--help) usage; exit 0 ;;
        -*) error "Unknown option: $1" ;;
        *) 
            if [ -z "$PROJECT_NAME" ]; then
                PROJECT_NAME="$1"
            else
                error "Multiple project names specified."
            fi
            ;;
    esac
    shift
done

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

# 2. Request Project Name (if not provided)
if [ -z "$PROJECT_NAME" ]; then
    usage
    while [ -z "$PROJECT_NAME" ]; do
        echo -e "${YELLOW}Please enter the project name (folder):${RESET}"
        read -r PROJECT_NAME
        if [ -z "$PROJECT_NAME" ]; then
            warn "Project name is required. Please try again."
        fi
    done
fi

if [ -d "$PROJECT_NAME" ]; then
    error "The folder '$PROJECT_NAME' already exists. Please choose a different name or remove the existing folder."
fi

# 3. Create Directory
header "Creating project directory: $PROJECT_NAME"
mkdir -p "$PROJECT_NAME" && cd "$PROJECT_NAME"
success "Directory created and accessed."

# 4. Configure DDEV
header "Configuring DDEV 🐳"
ddev config --project-type=laravel --docroot=public
success "DDEV configuration complete."

# 5. Create Dockerfile for Laravel Installer
header "Setting up Laravel Installer..."

cat <<'INNEREOF' >.ddev/web-build/Dockerfile.laravel
ARG COMPOSER_HOME=/usr/local/composer
RUN composer global require laravel/installer
RUN ln -s $COMPOSER_HOME/vendor/bin/laravel /usr/local/bin/laravel
INNEREOF

success "Dockerfile.laravel created."

# 6. Add-ons (Bun)
if [ "$WITH_BUN" = true ]; then
    header "Installing DDEV Bun Add-on..."
    ddev add-on get OpenForgeProject/ddev-bun
    success "Bun add-on installed."
fi

# 7. Start DDEV
header "Starting containers... (this might take a moment ⏳)"
ddev start -y
success "DDEV started successfully."

# 8. Install Laravel
header "Installing Laravel... 📦✨"

# Construct command
LARAVEL_CMD="laravel new temp --database=sqlite"

if [ "$WITH_GIT" = true ]; then LARAVEL_CMD="$LARAVEL_CMD --git"; fi
if [ "$WITH_PEST" = true ]; then LARAVEL_CMD="$LARAVEL_CMD --pest"; fi
if [ "$WITH_BUN" = true ]; then LARAVEL_CMD="$LARAVEL_CMD --bun"; fi

info "Running: $LARAVEL_CMD"
ddev exec "$LARAVEL_CMD"

# 9. Move files and cleanup
header "Finalizing project structure..."
ddev exec 'rsync -rltgopD temp/ ./ && rm -rf temp'

# Cleanup Dockerfile and .env as per snippet
rm -f .ddev/web-build/Dockerfile.laravel .env

# 10. Restart and Run Scripts
header "Restarting and running post-install scripts..."
ddev restart
ddev composer run-script post-root-package-install
ddev composer run-script post-create-project-cmd

# 11. Launch
header "All set! Launching the site... 🚀"
info "Project URL: https://$PROJECT_NAME.ddev.site"
ddev launch

echo -e "\n${BOLD}${GREEN}🎉  Installation completed successfully! Happy coding. 🎉${RESET}\n"
