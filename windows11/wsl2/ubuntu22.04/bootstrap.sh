#!/bin/bash

echo "  _          _                               "
echo " | |        | |                              "
echo " | |__   ___| |_ ___   __ _ _ __ _   _ _ __  "
echo " | '_ \\ / _ \\ __/ _ \\ / _\` | '__| | | | '_ \\ "
echo " | |_) |  __/ || (_) | (_| | |  | |_| | | | |"
echo " |_.__/ \\___|\\__\\___/ \\__, |_|   \\__,_|_| |_|"
echo "                       __/ |                 "
echo "                      |___/                  "

echo "# ___________________________________________"
echo "# Running betogrun dotfiles bootstrap script"
echo "# ___________________________________________"

# Update packages
echo "Updating packages..."
sudo apt update && sudo apt upgrade -y

# Install necessary applications
echo "Installing necessary applications..."
sudo apt install curl httpie neovim git zsh docker.io gh awscli docker-ce docker-ce-cli containerd.io -y

# Clone dotfiles repository
echo "Cloning dotfiles..."
git clone https://github.com/betogrun/dotfiles ~/dotfiles

# Path for specific dotfiles
dotfiles_path="~/dotfiles/dotfiles/windows11/wsl2/ubuntu22.04"

# Install Oh My Zsh without user interaction
echo "Installing Oh My Zsh..."
yes | sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Zsh plugins
echo "Installing Zsh plugins..."
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Install Powerlevel10k
echo "Installing Powerlevel10k..."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc

# Copy Zsh and Powerlevel10k configuration from dotfiles
echo "Configuring Zsh and Powerlevel10k from dotfiles..."
rm ~/.zshrc
cp $dotfiles_path/.zshrc ~/
cp $dotfiles_path/.p10k.zsh ~/
source ~/.zshrc

# Install Tmux Plugin Manager (TPM) and copy .tmux.conf from dotfiles
echo "Installing Tmux Plugin Manager and configuring .tmux.conf..."
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
cp $dotfiles_path/.tmux.conf ~/

# Install asdf
echo "Installing asdf..."
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.10.0
echo '. $HOME/.asdf/asdf.sh' >> ~/.zshrc
echo '. $HOME/.asdf/completions/asdf.bash' >> ~/.zshrc
source ~/.zshrc

# Post-installation instructions
echo "Post-installation steps:"
echo "1. Restart your terminal or log out and log back in to apply the changes."
echo "2. If you installed new shells (like Zsh), you may need to set them as your default shell manually."
echo "3. Review and customize your dotfiles as needed."