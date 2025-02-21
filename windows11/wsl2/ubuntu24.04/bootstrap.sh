#!/bin/bash

echo "  _          _                               "
echo " | |        | |                              "
echo " | |__   ___| |_ ___   __ _ _ __ _   _ _ __  "
echo " | '_ \\ / _ \\ __/ _ \\ / _\` | '__| | | | '_ \\ "
echo " | |_) |  __/ || (_) | (_| | |  | |_| | | | |"
echo " |_.__/ \\___|\\__\\___/ \\__, |_|   \\__,_|_| |_|"
echo "                       __/ |                 "
echo "                      |___/                  "
echo " "

# Script Header
echo "#-------------------------------------------#"
echo "# Running dotfiles bootstrap script for WSL2 Ubuntu 24.04"
echo "#-------------------------------------------#"

# Function to create backups of existing files
create_backup() {
    local file=$1
    if [ -f "$file" ]; then
        cp "$file" "$file.backup.$(date +%Y%m%d-%H%M%S)"
    fi
}

# Update packages
echo "Updating packages..."
sudo apt update && sudo apt upgrade -y

# Install necessary applications
echo "Installing necessary applications..."
sudo apt install -y \
    curl \
    httpie \
    neovim \
    git \
    zsh \
    gh \
    tmux \
    build-essential \
    unzip \
    jq \
    ripgrep \
    fd-find \
    fzf

# Check for Docker in WSL2
echo "Checking Docker availability..."
if ! command -v docker &> /dev/null; then
    echo "Docker not found. To use Docker in WSL2:"
    echo "1. Install Docker Desktop for Windows: https://www.docker.com/products/docker-desktop/"
    echo "2. Enable WSL2 integration in Docker Desktop settings"
    echo "3. Restart WSL2 after installation"
fi

# Install asdf
echo "Installing asdf..."
git clone https://github.com/asdf-vm/asdf.git ~/.asdf

# Clone or update dotfiles repository
echo "Setting up dotfiles..."
if [ ! -d "$HOME/dotfiles" ]; then
    echo "Cloning dotfiles repository..."
    git clone https://github.com/betogrun/dotfiles ~/dotfiles
else
    echo "Dotfiles repository already exists, updating..."
    cd ~/dotfiles && git pull
fi

# Set dotfiles path
dotfiles_path="$HOME/dotfiles/windows11/wsl2/ubuntu24.04"

# Backup and copy Git configuration
echo "Configuring Git..."
create_backup ~/.gitconfig
create_backup ~/.gitignore_global
cp "$dotfiles_path/.gitconfig" ~/.gitconfig
cp "$dotfiles_path/.gitignore_global" ~/.gitignore_global
cp -r "$dotfiles_path/.git_template" ~/.git_template
chmod -R +x ~/.git_template/hooks

# Verify Zsh installation
echo "Verifying Zsh installation..."
if ! command -v zsh &> /dev/null; then
    echo "Zsh not found. Installing Zsh..."
    sudo apt install -y zsh
fi

# Set Zsh as the default shell
echo "Setting Zsh as the default shell..."
if [ "$SHELL" != "$(which zsh)" ]; then
    sudo chsh -s "$(which zsh)" "$USER"
fi

# Install Oh My Zsh
echo "Setting up Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    RUNZSH=no sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install Zsh plugins
echo "Installing Zsh plugins..."
ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}
[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ] && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ] && \
    git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions

# Install Powerlevel10k
echo "Installing Powerlevel10k..."
[ ! -d "$HOME/powerlevel10k" ] && \
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k

# Setup Zsh configuration
echo "Setting up Zsh configuration..."
create_backup ~/.zshrc
create_backup ~/.p10k.zsh
cp "$dotfiles_path/.zshrc" ~/.zshrc
cp "$dotfiles_path/.p10k.zsh" ~/.p10k.zsh

# Install and configure Tmux and TPM
echo "Setting up Tmux and TPM..."

# Ensure tmux is installed
if ! command -v tmux &> /dev/null; then
    echo "Installing Tmux..."
    sudo apt install -y tmux
fi

# Setup TPM
echo "Setting up Tmux Plugin Manager..."
TPM_PATH="$HOME/.tmux/plugins/tpm"
if [ ! -d "$TPM_PATH" ]; then
    echo "Installing TPM..."
    git clone https://github.com/tmux-plugins/tpm "$TPM_PATH"
else
    echo "Updating TPM..."
    cd "$TPM_PATH" && git pull
fi

# Configure tmux
echo "Configuring tmux..."
create_backup ~/.tmux.conf
cp "$dotfiles_path/.tmux.conf" ~/.tmux.conf

# Install Tmux plugins
echo "Installing Tmux plugins..."
"$TPM_PATH/bin/install_plugins"
"$TPM_PATH/bin/update_plugins" all

# Check GitHub CLI authentication
if command -v gh &> /dev/null && ! gh auth status &> /dev/null; then
    echo "GitHub CLI is not authenticated."
    echo "You can login later using 'gh auth login'"
fi

# Print completion message and next steps
echo ""
echo "Installation completed! Here are the next steps:"
echo "1. Restart your terminal or run: exec zsh"
echo "2. Install Docker Desktop for Windows (if needed)"
echo "3. Configure GitHub CLI with 'gh auth login'"
echo "4. Tmux plugins have been installed automatically, but you can:"
echo "   - Use prefix + I to install new plugins manually"
echo "   - Use prefix + U to update plugins"
echo "5. Review your dotfiles and customize as needed"
echo ""
echo "Additional recommendations:"
echo "- Configure Git user info: git config --global user.name 'Your Name'"
echo "- Install languages via asdf (Node.js, Ruby, Python, etc.)"
echo "- Configure Windows Terminal settings for better WSL2 integration"