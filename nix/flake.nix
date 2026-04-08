{
  description = "Zenful nix-darwin system flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, config, ... }: {

      nixpkgs.config.allowUnfree = true;

      environment.systemPackages = [
        # --- Shell & CLI ---
        pkgs.zsh-autosuggestions
        pkgs.zsh-syntax-highlighting
        pkgs.starship
        pkgs.fzf
        pkgs.zoxide
        pkgs.bat
        pkgs.eza
        pkgs.fd
        pkgs.ripgrep
        pkgs.btop

        # --- Git ---
        pkgs.git
        pkgs.gh
        pkgs.lazygit

        # --- Editor ---
        pkgs.neovim

        # --- Terminal + Multiplexer ---
        pkgs.ghostty
        pkgs.tmux

        # --- Node.js (version manager) ---
        pkgs.fnm
        pkgs.pnpm

        # --- Languages ---
        pkgs.python313
        pkgs.jdk17

        # --- Utilities ---
        pkgs.ffmpeg_6
        pkgs.p7zip
        pkgs.mas
        pkgs.carapace
        pkgs.syncthing
        pkgs.mkalias

        # --- Window Management ---
        pkgs.aerospace
        pkgs.sketchybar

        # --- GUI Apps (managed via Nix) ---
        pkgs.discord
        pkgs.docker
        pkgs.obsidian
        pkgs.postman
        pkgs.brave
      ];

      fonts.packages = [
        pkgs.nerd-fonts.meslo-lg
        pkgs.nerd-fonts.hack
      ];

      # Create aliases in /Applications/Nix Apps so Spotlight finds them
      system.activationScripts.applications.text = let
        env = pkgs.buildEnv {
          name = "system-applications";
          paths = config.environment.systemPackages;
          pathsToLink = "/Applications";
        };
      in
        pkgs.lib.mkForce ''
          echo "setting up /Applications..." >&2
          rm -rf /Applications/Nix\ Apps
          mkdir -p /Applications/Nix\ Apps
          find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
          while read -r src; do
            app_name=$(basename "$src")
            echo "copying $src" >&2
            ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
          done
        '';

      # macOS system defaults
      system.defaults = {
        dock.autohide = true;
        finder.FXPreferredViewStyle = "clmv";
        NSGlobalDomain.KeyRepeat = 2;
      };

      # Remap Caps Lock → Control at system level
      system.keyboard = {
        remapCapsLockToControl = true;
        enableKeyMapping = true;
      };

      system.primaryUser = "federicoreghini";

      nix.settings.experimental-features = "nix-command flakes";

      programs.zsh.enable = true;
      programs.zsh.enableCompletion = false;

      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.stateVersion = 5;
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Mac Mini (old machine)
    darwinConfigurations."mini" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };

    # Mac Pro (new machine) — change "macpro" to match: scutil --get LocalHostName
    darwinConfigurations."macpro" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };

    darwinPackages = self.darwinConfigurations."mini".pkgs;
  };
}
