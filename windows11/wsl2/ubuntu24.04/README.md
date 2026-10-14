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
- Install Neovim from the `neovim-ppa/unstable` PPA and link the LazyVim config to `~/.config/nvim`
- Set up asdf version manager
- Configure GitHub CLI

## Neovim

The config in `.config/nvim` is [LazyVim](https://www.lazyvim.org) with:
- the gruvbox light theme;
- [claudecode.nvim](https://github.com/coder/claudecode.nvim) (LazyVim extra `ai.claudecode`) to run Claude Code in a
  side panel. Its proposed edits open as a unified diff that takes 55% of the screen, with the theme's diff colors, and
  the focus goes back to Claude once the diff is accepted or rejected.

`~/.config/nvim` is a symlink to this folder, so changes made in Neovim show up in the repo. Plugins install on the
first start, pinned by `lazy-lock.json`.

Claude Code keys: `<leader>ac` toggle the panel, `<leader>af` focus it, `<leader>as` send the selection,
`<leader>aa` / `<leader>ad` accept / reject a diff. Requires the [Claude Code CLI](https://docs.anthropic.com/en/docs/claude-code)
as `claude` on the `PATH`.

### Windows Terminal

The file and folder icons need a [Nerd Fonts](https://github.com/ryanoasis/nerd-fonts/releases/latest) **v3** font;
the older `MesloLGS NF` from Powerlevel10k shows `?` instead.
1. Download `Meslo.zip`, extract it and install the `MesloLGSNerdFont-*.ttf` files (right click, Install).
2. In Windows Terminal, set the Ubuntu profile's font to `MesloLGS Nerd Font` and its color scheme to `Gruvbox Light`
   (add the scheme first if it is missing, e.g. from [windowsterminalthemes.dev](https://windowsterminalthemes.dev)).

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
