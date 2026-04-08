# Mac Pro — Complete Setup Guide

> This guide is written to be followed step by step, in order.
> Every command is written out in full. Do not skip steps.
> Estimated total time: ~1.5–2 hours (mostly waiting for downloads).

---

## What This Guide Sets Up

| Category | Tool |
|---|---|
| Package manager | **nix-darwin** (declarative, reproducible) |
| Shell | **Zsh** |
| Prompt | **Starship** |
| Terminal | **Ghostty** |
| Multiplexer | **Tmux** |
| Editor | **Neovim** |
| Window manager | **AeroSpace** |
| Status bar | **Sketchybar** |
| Keyboard remapping | **Karabiner-Elements** |
| Launcher | **Raycast** |
| Notes | **Obsidian** |

---

## Before You Start

You will need:
- The Mac Pro connected to the internet
- Your Apple ID (for App Store apps)
- Your GitHub credentials
- Your NPM auth token (from npmjs.com → Settings → Access Tokens)
- Your Ngrok auth token (from dashboard.ngrok.com)

---

## PHASE 1 — Base System

### Step 1 — macOS Updates

Before anything else, update macOS:

1. Open **System Settings** → **General** → **Software Update**
2. Install all available updates
3. Restart if required

### Step 2 — Install Xcode Command Line Tools

Open **Terminal** (press `Cmd + Space`, type "Terminal", press Enter) and run:

```bash
xcode-select --install
```

A dialog box will appear. Click **Install** and wait for it to finish (~5 minutes).

Verify it worked:
```bash
git --version
# Should print something like: git version 2.x.x
```

### Step 3 — Check Your Mac's Hostname

You will need this later for the Nix configuration:

```bash
scutil --get LocalHostName
```

Write down what it prints. If it says something like `Federicos-Mac-Pro`, that is your hostname. You can change it in **System Settings → General → Sharing → Local hostname** if you want something shorter like `macpro`.

---

## PHASE 2 — Nix

### Step 4 — Install Nix

Nix is the package manager that controls everything. Use the Determinate Systems installer (more reliable than the official one):

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

When it asks for confirmation, type `y` and press Enter.

When it finishes, **close and reopen Terminal**, then verify:

```bash
nix --version
# Should print: nix (Nix) 2.x.x
```

---

## PHASE 3 — SSH Keys (needed before cloning the repo)

### Step 5 — Generate SSH Keys

You have two GitHub accounts: personal and company. Create a key for each.

**Personal key:**
```bash
ssh-keygen -t ed25519 -C "federicoreghini@gmail.com" -f ~/.ssh/github-personal
```
When asked for a passphrase, either enter one (more secure) or press Enter twice to skip.

**Company key** (replace with your company email):
```bash
ssh-keygen -t ed25519 -C "your-company-email@company.com" -f ~/.ssh/github-company
```

### Step 6 — Add SSH Keys to the Agent

```bash
# Start the SSH agent
eval "$(ssh-agent -s)"

# Add both keys
ssh-add ~/.ssh/github-personal
ssh-add ~/.ssh/github-company
```

### Step 7 — Create SSH Config File

```bash
mkdir -p ~/.ssh
cat > ~/.ssh/config << 'EOF'
Host github.com-personal
  HostName github.com
  User git
  IdentityFile ~/.ssh/github-personal
  AddKeysToAgent yes

Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/github-company
  AddKeysToAgent yes
EOF

chmod 600 ~/.ssh/config
```

### Step 8 — Add Public Keys to GitHub

Copy your personal public key:
```bash
cat ~/.ssh/github-personal.pub
```
Select all the output, copy it.

Go to: **github.com** → click your profile photo → **Settings** → **SSH and GPG keys** → **New SSH key**
- Title: `Mac Pro personal`
- Key: paste it
- Click **Add SSH key**

Copy your company public key:
```bash
cat ~/.ssh/github-company.pub
```
Do the same on your company GitHub account.

### Step 9 — Test SSH Connections

```bash
ssh -T git@github.com-personal
# Should print: Hi federicoReghini! You've successfully authenticated...

ssh -T git@github.com
# Should print: Hi <company-username>! You've successfully authenticated...
```

---

## PHASE 4 — Dotfiles

### Step 10 — Clone the Dotfiles Repo

Your dotfiles repo IS your `~/.config` folder:

```bash
git clone git@github.com-personal:federicoReghini/dotfile.git ~/.config
```

Verify it worked:
```bash
ls ~/.config
# Should show: nix, nvim, tmux, aerospace, starship.toml, etc.
```

---

## PHASE 5 — Nix Darwin

### Step 11 — Update the Flake Hostname

The Nix config needs to know your machine's hostname. Open the flake file:

```bash
nano ~/.config/nix/flake.nix
```

Find this line near the bottom:
```nix
darwinConfigurations."macpro" = nix-darwin.lib.darwinSystem {
```

If your hostname (from Step 3) is NOT `macpro`, change `"macpro"` to match exactly what `scutil --get LocalHostName` returned.

Save with `Ctrl+O`, Enter, then `Ctrl+X`.

### Step 12 — Install nix-darwin and Build the System

This is the big step. This single command installs ALL your tools:

```bash
nix run nix-darwin -- switch --flake ~/.config/nix#macpro
```

> Replace `macpro` with your actual hostname if you changed it above.

This will:
- Install Ghostty, Neovim, Tmux, Git, Lazygit, Bat, Eza, Fd, Ripgrep, Btop, Starship, Zoxide, FZF, Discord, Docker, Obsidian, Postman, Brave, AeroSpace, Sketchybar, Python 3.13, Java 17, fnm, pnpm, and more
- Install MesloLGS Nerd Font and Hack Nerd Font
- Set macOS defaults (Dock auto-hide, Finder column view, fast key repeat)
- Remap Caps Lock → Control at the system level

This takes **10–20 minutes** depending on your internet speed. Wait for it to finish.

When it finishes, **restart your Mac**.

### Step 13 — Verify Everything Installed

After restart, open Terminal and check:

```bash
nvim --version      # Should print NVIM v0.x.x
tmux -V             # Should print tmux 3.x
lazygit --version   # Should print lazygit version x.x.x
bat --version       # Should print bat x.x.x
eza --version       # Should print eza vx.x.x
starship --version  # Should print starship x.x.x
ghostty --version   # Should print Ghostty x.x.x
```

### Step 14 — Future Rebuilds

Any time you change `~/.config/nix/flake.nix` to add/remove packages, run:

```bash
darwin-rebuild switch --flake ~/.config/nix#macpro
```

---

## PHASE 6 — Shell Setup

### Step 15 — Clean Up .zshrc

The `.zshrc` in the repo has leftover Powerlevel10k and Nushell config from the old machine. Replace it entirely with the clean version below.

Open the file:
```bash
nano ~/.zshrc
```

Select all (`Ctrl+K` multiple times to delete everything), then paste this clean version:

```zsh
# ============================================================
# ENVIRONMENT
# ============================================================
export XDG_CONFIG_HOME=$HOME/.config
export EDITOR=nvim
export VISUAL=nvim
export TMUX_CONF=~/.config/tmux/tmux.conf
export STARSHIP_CONFIG=~/.config/starship.toml

# Java (managed by Nix)
export JAVA_HOME="/run/current-system/sw/lib/jvm/openjdk-17"
export PATH="$JAVA_HOME/bin:$PATH"

# Cargo (Rust)
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# ============================================================
# ZSH PLUGINS (installed by Nix — no manual cloning needed)
# ============================================================
source /run/current-system/sw/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /run/current-system/sw/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ============================================================
# HISTORY
# ============================================================
HISTFILE=$HOME/.zhistory
SAVEHIST=10000
HISTSIZE=10000
setopt share_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

# ============================================================
# KEYBINDINGS
# ============================================================
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# ============================================================
# ALIASES
# ============================================================
alias ls="eza --color=always --long --no-filesize --icons=always --no-time --no-user --no-permissions"
alias cat="bat --style=plain"
alias cd="z"
alias lg="lazygit"
alias vim="nvim"

# ============================================================
# FZF
# ============================================================
eval "$(fzf --zsh)"

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"
export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

_fzf_comprun() {
  local command=$1
  shift
  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \${}'" "$@" ;;
    ssh)          fzf --preview 'dig {}' "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

# fzf-git (extra git shortcuts with fzf)
[ -f ~/fzf-git.sh/fzf-git.sh ] && source ~/fzf-git.sh/fzf-git.sh

# FZF color theme
fg="#CBE0F0"
bg="#011628"
bg_highlight="#143652"
purple="#B388FF"
blue="#06BCE4"
cyan="#2CF9ED"
export FZF_DEFAULT_OPTS="--color=fg:${fg},bg:${bg},hl:${purple},fg+:${fg},bg+:${bg_highlight},hl+:${purple},info:${blue},prompt:${cyan},pointer:${cyan},marker:${cyan},spinner:${cyan},header:${cyan}"

# ============================================================
# BAT
# ============================================================
export BAT_THEME=tokyonight_night

# ============================================================
# ZOXIDE (better cd)
# ============================================================
eval "$(zoxide init zsh)"

# ============================================================
# NODE (fnm)
# ============================================================
eval "$(fnm env --use-on-cd)"

# ============================================================
# GIT FUNCTIONS
# ============================================================
# Checkout branch with fuzzy search
gitc() {
  local branches branch
  branches=$(git branch) &&
  branch=$(echo "$branches" | fzf +m) &&
  git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
}

# Delete branch with fuzzy search
gitd() {
  local branches branch
  branches=$(git branch) &&
  branch=$(echo "$branches" | fzf +m) &&
  git branch -d $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
}

# ============================================================
# STARSHIP PROMPT (must be last)
# ============================================================
eval "$(starship init zsh)"
```

Save: `Ctrl+O`, Enter, `Ctrl+X`.

Apply it:
```bash
source ~/.zshrc
```

### Step 16 — Clone fzf-git

This adds extra git+fzf shortcuts (used in your `.zshrc`):

```bash
git clone https://github.com/junegunn/fzf-git.sh.git ~/fzf-git.sh
```

---

## PHASE 7 — Ghostty (Terminal)

### Step 17 — Create Ghostty Config

```bash
mkdir -p ~/.config/ghostty
cat > ~/.config/ghostty/config << 'EOF'
font-family = MesloLGS Nerd Font Mono
font-size = 19
theme = tokyonight_storm
background-opacity = 0.8
background-blur-radius = 8
window-decoration = false
macos-option-as-alt = true
cursor-style = bar
shell-integration = zsh
EOF
```

Open Ghostty from `/Applications/Nix Apps/Ghostty.app` and from now on use it instead of Terminal.

### Step 18 — Set Ghostty as Default Terminal

In **System Settings** → there is no system-wide terminal default on macOS. Just keep using Ghostty directly. You can add it to your Dock by right-clicking the app → **Options** → **Keep in Dock**.

---

## PHASE 8 — Tmux

### Step 19 — Install Tmux Plugin Manager (TPM)

```bash
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
```

### Step 20 — Install Tmux Plugins

Open Ghostty, start tmux:
```bash
tmux
```

Press the prefix key, then install plugins:
```
Ctrl+a  then  I   (capital i)
```

Wait for plugins to install. You should see the Tokyo Night theme applied. Press Enter when done.

**Your tmux keybindings:**

| Key | Action |
|---|---|
| `Ctrl+a` | Prefix (instead of default Ctrl+b) |
| `Prefix + \|` | Split pane horizontally |
| `Prefix + -` | Split pane vertically |
| `Prefix + r` | Reload tmux config |
| `Prefix + h/j/k/l` | Resize pane left/down/up/right |
| `Prefix + m` | Maximize/minimize current pane |
| `Ctrl+n` | New Obsidian note (popup) |
| `Ctrl+t` | Search Obsidian vault (popup) |
| Mouse | Click to select panes, scroll to scroll |
| `v` (copy mode) | Start selecting text |
| `y` (copy mode) | Copy selection |

---

## PHASE 9 — Neovim

### Step 21 — First Launch (Auto-installs Everything)

```bash
nvim
```

On first open, **lazy.nvim** will automatically install all plugins (~30 seconds). You will see a progress window. Wait for it to finish, then press `q` to close it.

### Step 22 — Install LSP Servers and Formatters

Inside Neovim, run:
```
:MasonInstallAll
```

This installs all your language servers and formatters. Wait for it to complete (~2 minutes).

What gets installed automatically:
- `ts_ls` — TypeScript / JavaScript
- `html` — HTML
- `cssls` — CSS
- `tailwindcss` — Tailwind CSS
- `lua_ls` — Lua
- `emmet_ls` — Emmet abbreviations
- `prismals` — Prisma ORM
- `pyright` — Python
- `jsonls` — JSON
- `yamlls` — YAML
- `sqlls` — SQL
- `prettier` — Formatter for JS/TS/HTML/CSS
- `stylua` — Lua formatter
- `black` — Python formatter
- `isort` — Python import sorter
- `eslint_d` — JS/TS linter
- `debugpy` — Python debugger

### Step 23 — Activate GitHub Copilot

Inside Neovim, run:
```
:Copilot auth
```

Follow the instructions: it will give you a code and open a browser. Paste the code in the browser to authenticate.

**Your Neovim keybindings:**

| Key | Action |
|---|---|
| `Space` | Leader key |
| `jk` | Exit insert mode |
| `Space ff` | Find files (Telescope) |
| `Space fs` | Search text in project (grep) |
| `Space fr` | Recent files |
| `Space ft` | Find TODOs |
| `Space e` | Toggle file explorer |
| `Space ng` | Open Neogit (git UI) |
| `Space do` | Open DiffView |
| `Space dc` | Close DiffView |
| `Space mp` | Format current file |
| `Space ct` | Toggle GitHub Copilot |
| `Space sv` | Split window vertically |
| `Space sh` | Split window horizontally |
| `Space se` | Make splits equal size |
| `Space sx` | Close current split |
| `Space to` | Open new tab |
| `Space tx` | Close tab |
| `Space on` | New Obsidian note |
| `Space os` | Search Obsidian vault |
| `Space ob` | Open Obsidian in browser |
| `Ctrl+u/d` | Half-page up/down (centered) |
| `Space nh` | Clear search highlight |

---

## PHASE 10 — Git

### Step 24 — Configure Git

```bash
git config --global user.name "federicoReghini"
git config --global user.email "federicoreghini@gmail.com"
git config --global init.defaultBranch main
git config --global pull.rebase true
git config --global core.editor nvim
```

Verify:
```bash
cat ~/.gitconfig
```

### Step 25 — Authenticate GitHub CLI

```bash
gh auth login
```

Choose:
- **GitHub.com**
- **SSH**
- Select your existing key: `~/.ssh/github-personal`
- Login with browser: yes

---

## PHASE 11 — Node.js

### Step 26 — Install Node.js via fnm

```bash
# Install the latest LTS version
fnm install --lts

# Use it
fnm use --lts

# Set it as default for all new shells
fnm default $(fnm current)
```

Verify:
```bash
node --version    # Should print v22.x.x or similar
npm --version     # Should print 10.x.x or similar
```

### Step 27 — Install Global npm Packages

```bash
npm install -g json-server
npm install -g eas-cli
npm install -g mcp-hub
```

### Step 28 — Configure NPM Auth Token

Get your token from **npmjs.com** → click your profile → **Access Tokens** → copy your existing token (or create a new one).

```bash
echo "//registry.npmjs.org/:_authToken=YOUR_TOKEN_HERE" >> ~/.npmrc
```

Replace `YOUR_TOKEN_HERE` with your actual token.

---

## PHASE 12 — Python

### Step 29 — Verify Python

Python 3.13 is already installed by Nix:

```bash
python3 --version   # Should print Python 3.13.x
pip3 --version
```

### Step 30 — Install pip packages you use

```bash
pip3 install debugpy ipython jupyter
```

---

## PHASE 13 — Rust

### Step 31 — Install Rust via rustup

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

Press `1` for the default installation.

Close and reopen your terminal (or run `source ~/.cargo/env`).

Verify:
```bash
rustc --version   # Should print rustc 1.x.x
cargo --version   # Should print cargo 1.x.x
```

### Step 32 — Install Cargo Tools

```bash
cargo install cargo-watch
```

---

## PHASE 14 — Karabiner-Elements (Keyboard Remapping)

### Step 33 — Download and Install Karabiner-Elements

Karabiner is not in Nix, so download it manually:

1. Go to: **https://karabiner-elements.pqrs.org**
2. Click **Download**
3. Open the `.dmg` file and drag Karabiner-Elements to Applications
4. Open Karabiner-Elements from Applications
5. When macOS asks for permissions, click **Open System Settings** and allow each one:
   - **Input Monitoring**: enable Karabiner-Elements
   - **Accessibility**: enable Karabiner-Elements

### Step 34 — Copy Your Karabiner Config

Your Karabiner config is already in the dotfiles repo. It just needs to be in the right place (it already is at `~/.config/karabiner/karabiner.json`). Karabiner reads it automatically.

**What your Karabiner config does:**

| From | To | Why |
|---|---|---|
| **Caps Lock** | **Left Control** | Caps Lock is useless; Ctrl is used constantly and is in an ergonomic position |
| **Right Command** | **Hyper Key (⌃⌥⇧⌘)** | Creates a unique modifier for app shortcuts that never conflicts with anything |

To verify it's working:
1. Open Karabiner-Elements
2. Click **Simple Modifications** — you should see Caps Lock → Left Control
3. Click **Complex Modifications** → **Rules** — you should see "Remap right_shift to Hyper Key"

**Test it:** Press Caps Lock — it should behave like Control (try Caps Lock + C to copy).

---

## PHASE 15 — AeroSpace (Window Manager)

### Step 35 — Launch AeroSpace

AeroSpace is already installed by Nix. Find it in `/Applications/Nix Apps/` or run:

```bash
open /Applications/Nix\ Apps/AeroSpace.app
```

Allow it in **System Settings → Privacy & Security → Accessibility** if prompted.

### Step 36 — Enable Start at Login

```bash
aerospace enable-start-at-login
```

Or manually: right-click the AeroSpace menu bar icon → **Enable Start at Login**.

**Your AeroSpace keybindings:**

| Key | Action |
|---|---|
| `Alt + /` | Switch layout: tiles / horizontal / vertical |
| `Alt + ,` | Switch layout: accordion |
| `Alt + Shift + H/J/K/L` | Move window left/down/up/right |
| `Alt + Shift + 1–9` | Move window to workspace 1–9 |
| `Alt + Shift + T` | Move window to Terminal workspace |
| `Alt + Shift + B` | Move window to Browser workspace |
| `Alt + Shift + D` | Move window to Discord workspace |
| `Alt + Shift + N` | Move window to Notes workspace |
| `Alt + Shift + M` | Move window to Music workspace |
| `Alt + Shift + E` | Move window to Finder workspace |
| `Alt + Shift + F` | Fullscreen |
| `Alt + Tab` | Switch to previous workspace |
| `Alt + Shift + Tab` | Move workspace to next monitor |
| `Ctrl + -` | Resize window smaller |
| `Ctrl + =` | Resize window larger |
| `Alt + Shift + ;` | Enter service mode |

**Auto workspace assignments (apps open automatically in their workspace):**

| App | Workspace |
|---|---|
| Ghostty | T (Terminal) |
| Chrome / Firefox | B (Browser) |
| Spotify | M (Music) |
| Discord | D (Discord) |
| Obsidian / Goodnotes / Notes | N (Notes) |
| Finder | E (Explorer) |
| Postman | M |

---

## PHASE 16 — Sketchybar (Status Bar)

### Step 37 — Start Sketchybar

Sketchybar is installed by Nix. AeroSpace starts it automatically on launch. To start it manually:

```bash
sketchybar
```

> **Note:** Your Sketchybar config was not in the dotfiles repo. Start with a default config and customize later:

```bash
mkdir -p ~/.config/sketchybar
# Sketchybar will use defaults if no config is present
# To get a starter config:
curl -L https://raw.githubusercontent.com/FelixKratz/SketchyBar/master/sketchybarrc -o ~/.config/sketchybar/sketchybarrc
chmod +x ~/.config/sketchybar/sketchybarrc
```

---

## PHASE 17 — Raycast

### Step 38 — Download and Install Raycast

1. Go to **raycast.com**
2. Click **Download for Mac**
3. Open the `.dmg` and drag Raycast to Applications
4. Open Raycast
5. Go through the onboarding
6. Sign in to your Raycast account — your extensions and settings will sync automatically

Raycast replaces Spotlight. Change the hotkey:
- Open Raycast → **Settings** → **General** → change hotkey to `Cmd + Space`
- Go to **System Settings → Keyboard → Keyboard Shortcuts → Spotlight** → uncheck "Show Spotlight search" (to free up Cmd+Space)

---

## PHASE 18 — Secrets

### Step 39 — Ngrok

Get your auth token from **dashboard.ngrok.com** → Your Authtoken.

```bash
ngrok config add-authtoken YOUR_TOKEN_HERE
```

---

## PHASE 19 — Obsidian

### Step 40 — Sync Your Vault

Your Obsidian vault was at `~/Obsidian/Notes` on the old machine. Syncthing is already installed by Nix.

**Option A — Syncthing (recommended, already set up):**

```bash
# Start Syncthing
syncthing

# Open the web UI
open http://127.0.0.1:8384
```

Add the old machine as a device and share the `~/Obsidian` folder.

**Option B — iCloud (simplest):**

Move your vault on the old Mac to `~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Notes` and it will sync via iCloud automatically. On the new Mac, open Obsidian and open vault from iCloud.

### Step 41 — Open Obsidian

1. Open Obsidian from Applications
2. Click **Open folder as vault**
3. Navigate to `~/Obsidian/Notes`
4. Your notes, themes, and plugins will all be there

Neovim's Obsidian integration (`obsidian.nvim`) expects the vault at `~/Obsidian/Notes`. If you use a different path, update `~/.config/nvim/lua/fede/plugins/obsidian.lua`.

---

## PHASE 20 — Applications

### Step 42 — App Store Apps

`mas` is installed by Nix. Use it to install App Store apps from the terminal:

```bash
# Goodnotes
mas install 1444383602

# Check what's available (search for app name):
mas search "Anki"
```

For **Anki**, use the download from ankiweb.net — the App Store version is outdated:
1. Go to **ankiweb.net/downloads**
2. Download and install the `.dmg`

### Step 43 — Download Manually

Install these by downloading from their websites:

| App | URL |
|---|---|
| **NordVPN** | nordvpn.com or App Store |
| **Zoom** | zoom.us/download |
| **Microsoft Teams** | teams.microsoft.com |
| **Citrix Workspace** | company IT provides this |
| **CleanMyMac** | macpaw.com |
| **LetsView** | letsview.com |
| **Android Studio** | developer.android.com/studio |
| **Calibre** | calibre-ebook.com |

### Already Installed by Nix

These are already available in `/Applications/Nix Apps/`:
- Discord
- Docker
- Obsidian
- Postman
- Brave Browser

---

## PHASE 21 — Final Checks

### Step 44 — Verify Everything Works

Run through this checklist:

```bash
# Shell
echo $SHELL           # Should be /bin/zsh
starship --version    # Should print version

# Tools
nvim --version
tmux -V
lazygit --version
bat --version
eza --version
fzf --version
fd --version
rg --version           # ripgrep
zoxide --version
gh --version
node --version
python3 --version
rustc --version
java --version
```

### Step 45 — Open Ghostty and Start Working

```bash
# Open Ghostty
open /Applications/Nix\ Apps/Ghostty.app

# Start a tmux session
tmux new-session -s main

# Open Neovim
nvim
```

---

## Troubleshooting

**"command not found" for a Nix tool:**
```bash
darwin-rebuild switch --flake ~/.config/nix#macpro
source ~/.zshrc
```

**Tmux plugins not loading:**
```bash
# Inside tmux: Prefix + I (capital i) to install
# Or manually:
~/.config/tmux/plugins/tpm/bin/install_plugins
```

**Neovim plugins not loading:**
```bash
# Inside nvim:
:Lazy sync
```

**AeroSpace not tiling windows:**
```bash
# Reload config
aerospace reload-config
# Or: Alt+Shift+; then Esc
```

**Karabiner not remapping keys:**
1. Open Karabiner-Elements
2. Check System Settings → Privacy & Security → Input Monitoring and Accessibility
3. Toggle Karabiner-Elements off and on

**Fonts not showing in Ghostty:**
```bash
# Fonts are installed by Nix. Verify:
fc-list | grep -i meslo
# If empty, rebuild:
darwin-rebuild switch --flake ~/.config/nix#macpro
```

**Zsh plugins not loading (autosuggestions/syntax highlighting):**
```bash
ls /run/current-system/sw/share/zsh-autosuggestions/
ls /run/current-system/sw/share/zsh-syntax-highlighting/
# If folders don't exist, they weren't installed — rebuild nix
```

---

## Adding New Packages Later

To install any new tool permanently:

1. Open `~/.config/nix/flake.nix`
2. Search nixpkgs for the package: `nix search nixpkgs <package-name>`
3. Add `pkgs.<package-name>` to the `environment.systemPackages` list
4. Run: `darwin-rebuild switch --flake ~/.config/nix#macpro`

Example — adding `htop`:
```nix
environment.systemPackages = [
  # ... existing packages ...
  pkgs.htop
];
```

Then:
```bash
darwin-rebuild switch --flake ~/.config/nix#macpro
```
