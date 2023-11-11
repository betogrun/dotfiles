#!/bin/bash

echo "  _          _                               "
echo " | |        | |                              "
echo " | |__   ___| |_ ___   __ _ _ __ _   _ _ __  "
echo " | '_ \\ / _ \\ __/ _ \\ / _\` | '__| | | | '_ \\ "
echo " | |_) |  __/ || (_) | (_| | |  | |_| | | | |"
echo " |_.__/ \\___|\\__\\___/ \\__, |_|   \\__,_|_| |_|"
echo "                       __/ |                 "

#!/bin/bash

# Script Header
echo "# ___________________________________________"
echo "# Running betogrun dotfiles bootstrap script"
echo "# ___________________________________________"

# Update packages
echo "Updating packages..."
sudo apt update && sudo apt upgrade -y

# Install necessary applications
echo "Installing necessary applications..."
sudo apt install -y curl httpie neovim git zsh gh awscli

# Install Docker
echo "Installing Docker..."
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Add current user to the Docker group
echo "Adding current user to the Docker group..."
sudo usermod -aG docker $USER

# Clone dotfiles repository
echo "Cloning dotfiles..."
git clone https://github.com/betogrun/dotfiles ~/dotfiles

# Path for specific dotfiles
dotfiles_path="$HOME/dotfiles/windows11/wsl2/ubuntu22.04"

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

# Copy Zsh, Powerlevel10k, and Git configuration from dotfiles
echo "Configuring Zsh, Powerlevel10k, and Git from dotfiles..."
rm ~/.zshrc
cp $dotfiles_path/.zshrc ~/
cp $dotfiles_path/.p10k.zsh ~/
cp $dotfiles_path/.gitconfig ~/
cp -r $dotfiles_path/.git_template ~/.git_template
cp $dotfiles_path/.gitingore_global ~/.gitignore_global

# Install Tmux Plugin Manager (TPM) and copy .tmux.conf from dotfiles
echo "Installing Tmux Plugin Manager and configuring .tmux.conf..."
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
cp $dotfiles_path/.tmux.conf ~/

# Install asdf
echo "Installing asdf..."
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.10.0
echo '. $HOME/.asdf/asdf.sh' >> ~/.zshrc
echo '. $HOME/.asdf/completions/asdf.bash' >> ~/.zshrc

# Set Zsh as the default shell
echo "Setting Zsh as the default shell..."
chsh -s $(which zsh)

# Post-installation instructions
echo "Post-installation steps:"
echo "1. Restart your terminal or log out and log back in to apply the changes."
echo "2. Open Tmux and press 'prefix + I' to install Tmux plugins."
echo "3. Review and customize your dotfiles as needed."
echo "4. Enjoy!"
