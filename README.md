# DDEV Laravel Installer

![Bash](https://img.shields.io/badge/Script-Bash-success) ![Laravel](https://img.shields.io/badge/Laravel-12-red) ![DDEV](https://img.shields.io/badge/DDEV-Installer-blue)

A robust and stylized Bash script to automatically set up a **Laravel 12** environment using **DDEV**, based on the [official DDEV Laravel Quickstart](https://docs.ddev.com/en/stable/users/quickstart/#laravel).

Created by **[@backendrulz](https://github.com/backendrulz)**.

## 🚀 Features

- **Automated Setup:** Creates the folder, configures DDEV, and installs Laravel.
- **Optional Pest Setup:** Prompts to install and initialize the Pest testing framework.
- **Interactive:** Prompts for the project name (defaults to `my-laravel-site`).
- **Error Handling:** Strict error checking to prevent partial installs.
- **Stylish Output:** Color-coded logs and status updates for a better CLI experience.

## 📋 Prerequisites

Before running this script, ensure you have the following installed:

- **[Docker](https://www.docker.com/)** (Desktop or Engine)
- **[DDEV](https://ddev.com/)**

## 🛠️ Usage

1. **Clone the repository:**
   ```bash
   git clone https://github.com/backendrulz/ddev-laravel-installer.git
   cd ddev-laravel-installer
   ```

2. **Make the script executable:**
   ```bash
   chmod +x installer.sh
   ```

3. **Run the installer:**
   ```bash
   ./installer.sh
   ```

4. **Follow the prompts:**
   - Enter your desired project name (or press Enter for default).
   - The script will handle the rest!

## 🌍 Global Installation (Optional)

To run this script from anywhere as a command (e.g., `ddev-laravel`), creates a symbolic link:

1.  **Create the local bin directory** (if it doesn't exist):
    ```bash
    mkdir -p ~/.local/bin
    ```

2.  **Create the symbolic link:**
    ```bash
    ln -s "$(pwd)/installer.sh" ~/.local/bin/ddev-laravel
    ```

3.  **Ensure `~/.local/bin` is in your PATH:**
    If the command isn't found, add this folder to your shell config (e.g., `~/.bashrc`, `~/.zshrc`):
    ```bash
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    source ~/.bashrc
    ```

4.  **Run it anywhere:**
    ```bash
    ddev-laravel
    ```

## ⚙️ How It Works

This script automates the standard DDEV + Laravel setup workflow:

1. **Validation:** Checks if `ddev` is installed.
2. **Directory:** Creates your project directory (safely checks if it already exists).
3. **Config:** Initializes a DDEV config for Laravel (`--project-type=laravel`).
4. **Start:** Spins up the Docker containers.
5. **Install:** Uses `ddev composer` to install Laravel 12.
6. **Pest (Optional):** Prompts to install and initialize the Pest testing framework.
7. **Launch:** Automatically opens your new local site in the browser.

## 🤝 Contributing

Feel free to fork this project and submit a pull request if you want to add support for older Laravel versions, different PHP versions, or other DDEV configurations.

## 📄 License

This project is open-source and available under the [MIT License](https://opensource.org/licenses/MIT).
