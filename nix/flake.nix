{
  description = "Zenful nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    # nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs}:
  let
    configuration = { pkgs, config, ... }: {

    nixpkgs.config.allowUnfree = true;
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [
        pkgs.carapace
        pkgs.discord
        pkgs.docker
        pkgs.ffmpeg_6
        pkgs.fnm
        pkgs.gh
        pkgs.mkalias
        pkgs.neovim
        pkgs.nushell
        pkgs.obsidian
        pkgs.postman
        pkgs.ripgrep
        pkgs.syncthing
        pkgs.tmux
        # Previously homebrew packages
        pkgs.eza
        pkgs.fzf
        pkgs.git
        pkgs.mas
        pkgs.pnpm
        pkgs.starship
        pkgs.zoxide
        # Cask equivalents
        pkgs.brave
        pkgs.wezterm
        pkgs.p7zip  # alternative to the-unarchiver

        ];


/*       homebrew = {
        enable = true;
        brews = [
          "eza"
          "fzf"
          "git"
          "mas"
          "nushell"
          "pnpm"
          "starship"
          "zoxide"
        ];
        casks = [
        "firefox"
        "the-unarchiver"
        "font-hack-nerd-font"
        "wezterm"
        ];
        onActivation.cleanup = "zap";
        onActivation.autoUpdate = true;
        onActivation.upgrade = true;
      };
 */
      fonts.packages = [
        pkgs.nerd-fonts.meslo-lg
        pkgs.nerd-fonts.hack
      ];

      system.activationScripts.applications.text = let
        env = pkgs.buildEnv {
          name = "system-applications";
          paths = config.environment.systemPackages;
          pathsToLink = "/Applications";
        };
      in
        pkgs.lib.mkForce ''
        # Set up applications.
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

      system.defaults = {
        dock.autohide = true;
        finder.FXPreferredViewStyle = "clmv";
        NSGlobalDomain.KeyRepeat = 2;
      };

      system.keyboard = {
        remapCapsLockToControl = true;
        enableKeyMapping= true;
      };
      # Set primary user for system defaults
      system.primaryUser = "reghinifedericoeng";
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;
      # programs.nushell.enable = true;
      programs.zsh.enableCompletion = false;
      programs.zsh.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      # home-manager.backupFileExtension = "backup";
      # nix.configureBuildUsers = true;
      # nix.useDaemon = true;
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#mini
    darwinConfigurations."mini" = nix-darwin.lib.darwinSystem {
      modules = [
      configuration
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."mini".pkgs;
  };
}

