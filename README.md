# dotfiles

My personal macOS development environment, managed with **nix-darwin** and manual symlinks.

## Stack

| Tool | Purpose |
|---|---|
| [nix-darwin](https://github.com/LnL7/nix-darwin) | Declarative package & system management |
| [Ghostty](https://ghostty.org) | Terminal emulator |
| [Tmux](https://github.com/tmux/tmux) | Terminal multiplexer |
| [Neovim](https://neovim.io) | Editor |
| [Starship](https://starship.rs) | Shell prompt |
| [AeroSpace](https://github.com/nikitabobko/AeroSpace) | Tiling window manager |
| [Karabiner-Elements](https://karabiner-elements.pqrs.org) | Keyboard remapping |
| [Raycast](https://www.raycast.com) | Launcher |
| Zsh | Shell |

## Quick Install (new machine)

```bash
# 1. Install Nix
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

# 2. Clone this repo
git clone git@github.com-personal:federicoReghini/dotfile.git ~/.config

# 3. Create symlinks
bash ~/.config/install.sh

# 4. Bootstrap nix-darwin (installs everything)
nix run nix-darwin -- switch --flake ~/.config/nix#macpro

# 5. Reload shell
source ~/.zshrc
```

> For the full step-by-step guide (SSH setup, secrets, Karabiner, Neovim, etc.) see [mac-pro-setup.md](./mac-pro-setup.md)

## Repo Structure

```
~/.config/
├── nix/
│   └── flake.nix          # nix-darwin: all packages + macOS defaults
├── nvim/                  # Neovim (lazy.nvim, LSP, Copilot)
├── tmux/
│   └── tmux.conf          # Tmux config + TPM plugins
├── aerospace/
│   └── aerospace.toml     # Tiling window manager
├── karabiner/
│   └── karabiner.json     # Caps Lock → Ctrl, RCmd → Hyper
├── ghostty/
│   └── config             # Terminal config
├── starship.toml          # Prompt theme (Tokyo Night)
├── .zshrc                 # Shell config (symlinked to ~/.zshrc)
├── install.sh             # Creates all symlinks after cloning
└── mac-pro-setup.md       # Full setup guide for a new machine
```

## Symlinks

`install.sh` creates these links from `~` into this repo:

| Symlink | Points to |
|---|---|
| `~/.zshrc` | `~/.config/.zshrc` |
| `~/nvim` | `~/.config/nvim` |
| `~/tmux` | `~/.config/tmux` |
| `~/aerospace` | `~/.config/aerospace` |
| `~/nix` | `~/.config/nix` |
| `~/gh` | `~/.config/gh` |
| `~/bat` | `~/.config/bat` |
| `~/carapace` | `~/.config/carapace` |
| `~/starship.toml` | `~/.config/starship.toml` |
