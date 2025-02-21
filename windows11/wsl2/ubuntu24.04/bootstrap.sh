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
echo "# Running dotfiles bootstrap script for Ubuntu 24.04"
echo "#-------------------------------------------#"

# Função para verificar e criar backup
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
    awscli \
    tmux \
    build-essential \
    unzip \
    jq \
    ripgrep \
    fd-find \
    fzf

# Install Docker using official Docker script
echo "Installing Docker..."
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
rm get-docker.sh

# Add current user to the Docker group
echo "Adding current user to the Docker group..."
sudo usermod -aG docker $USER

# Install Docker Compose V2
echo "Installing Docker Compose..."
DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
mkdir -p $DOCKER_CONFIG/cli-plugins
curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 -o $DOCKER_CONFIG/cli-plugins/docker-compose
chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose

# Install asdf
echo "Installing asdf..."
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.13.1

# Clone dotfiles repository
echo "Cloning dotfiles..."
git clone https://github.com/betogrun/dotfiles ~/dotfiles

# Path for specific dotfiles
dotfiles_path="$HOME/dotfiles/windows11/wsl2/ubuntu24.04"

# Backup and copy Git configuration
echo "Configuring Git from dotfiles..."
create_backup ~/.gitconfig
create_backup ~/.gitignore_global
cp $dotfiles_path/.gitconfig ~/
cp $dotfiles_path/.gitignore_global ~/
cp -r $dotfiles_path/.git_template ~/.git_template
chmod -R +x ~/.git_template/hooks

# Set Zsh as the default shell
echo "Setting Zsh as the default shell..."
sudo chsh -s $(which zsh) $(whoami)

# Install Oh My Zsh
echo "Installing Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
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

# Backup and copy Zsh, Powerlevel10k configuration
echo "Configuring Zsh and Powerlevel10k from dotfiles..."
create_backup ~/.zshrc
create_backup ~/.p10k.zsh
cp $dotfiles_path/.zshrc ~/
cp $dotfiles_path/.p10k.zsh ~/

# Install Tmux Plugin Manager and configure tmux
echo "Installing Tmux Plugin Manager and configuring .tmux.conf..."
[ ! -d "$HOME/.tmux/plugins/tpm" ] && \
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
create_backup ~/.tmux.conf
cp $dotfiles_path/.tmux.conf ~/

# Print completion message and next steps
echo ""
echo "Installation completed! Here are the next steps:"
echo "1. Restart your terminal or run: exec zsh"
echo "2. Run 'docker --version' to verify Docker installation"
echo "3. Open Tmux and press 'prefix + I' to install Tmux plugins"
echo "4. Review your dotfiles and customize as needed"
echo ""
echo "Additional recommendations:"
echo "- Configure Git user info: git config --global user.name 'Your Name'"
echo "- Install languages via asdf (Node.js, Ruby, Python, etc.)"
echo "- Check Docker Compose with: docker compose version"