{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.11-darwin";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {

      nixpkgs.config.allowUnfree = true;

      environment.systemPackages = with pkgs; [
        vim
        vscode
        ghostty-bin
        iterm2
        google-chrome
        rectangle
        tmux
        starship
        zoxide
        atuin
        fzf

        zsh-autosuggestions
        zsh-syntax-highlighting

      ];
      fonts.packages = with pkgs; [
        jetbrains-mono
        fira-code
        nerd-fonts.jetbrains-mono
        ];

      nix.settings.experimental-features = "nix-command flakes";
      programs.zsh = {
        enable = true;

        shellInit = ''
          # Starship prompt
          eval "$(starship init zsh)"

          # Autosuggestions tuning
          ZSH_AUTOSUGGEST_STRATEGY=(history completion)

          # Tool initialization
          eval "$(zoxide init zsh)"
          eval "$(atuin init zsh)"

          # fzf integration
          source ${pkgs.fzf}/share/fzf/key-bindings.zsh
          source ${pkgs.fzf}/share/fzf/completion.zsh

          # zsh plugins
          source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
          source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
        '';
      };

      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.stateVersion = 6;

      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    darwinConfigurations."MacBook-Air-de-Jaime" =
      nix-darwin.lib.darwinSystem {
        modules = [ configuration ];
      };
  };
}
