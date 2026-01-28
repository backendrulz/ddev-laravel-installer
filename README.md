# DDEV Laravel Installer

![Bash](https://img.shields.io/badge/Script-Bash-success) ![Laravel](https://img.shields.io/badge/Laravel-12-red) ![DDEV](https://img.shields.io/badge/DDEV-Installer-blue)

A robust and stylized Bash script to automatically set up a **Laravel** environment using **DDEV**, leveraging the `laravel new` installer command inside the container.

Created by **[@backendrulz](https://github.com/backendrulz)**.

## 🚀 Features

- **Automated Setup:** Creates the folder, configures DDEV, and installs Laravel using the official installer.
- **Customizable:** Optional flags to enable Git, Pest, or Bun.
- **Interactive:** Prompts for the mandatory project name and displays available options if run without arguments.
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

   **Interactive Mode:**
   Running without arguments will display the available options and prompt for the required project name.
   ```bash
   ./installer.sh
   ```

   **With Arguments:**
   ```bash
   ./installer.sh my-project --git --pest --bun
   ```

### Options

| Flag       | Description                                      |
| :--------- | :----------------------------------------------- |
| `-h`, `--help` | Show usage information.                      |
| `--git`    | Initialize a Git repository.                     |
| `--pest`   | Install the Pest testing framework.              |
| `--bun`    | Use Bun instead of Node (installs Bun add-on).   |

## 🌍 Global Installation (Optional)

To run this script from anywhere as a command (e.g., `ddev-laravel`):

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
    ddev-laravel my-app --git --pest
    ```

## ⚙️ How It Works

This script automates the setup workflow:

1. **Validation:** Checks if `ddev` is installed.
2. **Directory:** Creates your project directory.
3. **Config:** Initializes a DDEV config for Laravel (`--project-type=laravel`).
4. **Environment:** Creates a custom `Dockerfile.laravel` to install the global `laravel/installer` inside the web container.
5. **Start:** Spins up the Docker containers.
6. **Install:** Executes `laravel new temp` inside the container with your chosen options (`--git`, `--pest`, `--bun`, `--boost`).
7. **Sync:** Moves files from the temporary install directory to the root and cleans up.
8. **Finalize:** Restarts DDEV, runs Composer post-install scripts, and launches the site.

## 🤝 Contributing

Feel free to fork this project and submit a pull request if you want to add support for older Laravel versions, different PHP versions, or other DDEV configurations.

## 📄 License

This project is open-source and available under the [MIT License](https://opensource.org/licenses/MIT).
