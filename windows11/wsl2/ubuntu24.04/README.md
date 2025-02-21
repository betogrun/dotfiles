# WSL2 Ubuntu 24.04 Bootstrap

This script automates the setup of a development environment on WSL2 Ubuntu 24.04.

## ⚠️ Disclaimer

This script is provided "as is", without warranty of any kind. Use it at your own risk. It's recommended to review the script content before running it in your environment.

## Quick Installation

You can install using either `curl` or `wget`:

Using curl:
```bash
curl -fsSL https://raw.githubusercontent.com/betogrun/dotfiles/main/windows11/wsl2/ubuntu24.04/bootstrap.sh | bash
```

Using wget:
```bash
wget -qO- https://raw.githubusercontent.com/betogrun/dotfiles/main/windows11/wsl2/ubuntu24.04/bootstrap.sh | bash
```

## What's Included?

The script will:
- Install essential development tools and utilities
- Set up Zsh with Oh My Zsh and Powerlevel10k theme
- Configure Git with templates and global settings
- Install and configure Tmux with plugins
- Set up asdf version manager
- Configure GitHub CLI

## Post-Installation

After running the script:
1. Restart your terminal or run: `exec zsh`
2. Follow the Powerlevel10k configuration wizard
3. Configure your Git user information
4. Set up GitHub CLI authentication using `gh auth login`

## Manual Installation

If you prefer to review the script before running it:
1. Clone this repository
2. Review the script content
3. Run it locally:
```bash
./bootstrap.sh
```
