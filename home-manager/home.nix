{ config, pkgs, inputs, ... }:
let
  unstable = import inputs.nixpkgs-unstable {
    system = pkgs.system;
    # Uncomment this if you need an unfree package from unstable.
    config.allowUnfree = true;
  };
in
{
  home.username = "bsuttor";
  home.homeDirectory = "/home/bsuttor";
  home.stateVersion = "24.05";

  sops = {
    age.keyFile = "/home/bsuttor/.config/sops/age/key.txt";
    #defaultSymlinkPath = "/run/user/1000/secrets";
    #defaultSecretsMountPoint = "/run/user/1000/secrets.d";
  };

  imports = [
    inputs.sops-nix.homeManagerModules.sops
    ./apps/atuin.nix
    ./apps/direnv.nix
    ./apps/git.nix
    ./apps/gnome.nix
    ./apps/tmux.nix
    ./apps/vim.nix
    ./apps/vscode.nix
    ./apps/zsh.nix
  ];

  home.packages = with pkgs; [
    sops
    neofetch
    # utils
    ripgrep # recursively searches directories for a regex pattern
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processor https://github.com/mikefarah/yq
    fzf # A command-line fuzzy finder
    gnumake
    wget

    # system monitoring
    btop
    iotop # io monitoring
    iftop # network monitoring
    gtop # required by tophat gnome extension
    htop

    # dev tools
    git
    tig
    direnv
    kubectl
    kubecolor
    kubie
    kind
    stern
    kubernetes-helm
    unstable.postman

    # networking tools
    mtr # A network diagnostic tool
    # iperf3
    dnsutils  # `dig` + `nslookup`
    # ldns # replacement of `dig`, it provide the command `drill`
    # aria2 # A lightweight multi-protocol & multi-source command-line download utility
    # socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing
    ipcalc  # it is a calculator for the IPv4/v6 addresses

    # dropbox
    # maestral
    # maestral-gui

    # gnome
    gnome3.gnome-tweaks
    # gnomeExtensions.tophat
    gnomeExtensions.vitals
    gnomeExtensions.clipboard-history

    # apps
    # firefox
    # google-chrome # not able to start chrome with nix on ubuntu
    # vscode
    libreoffice
    # xclip
    signal-desktop
    bitwarden
    bitwarden-cli
    # bitwarden-desktop
    # vnote
    vlc

    # archives
    zip
    xz
    unzip
    p7zip
    unrar

    # ia
    ollama
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    ZSH_TMUX_AUTOSTART = "true";
  };

  sops.secrets.atuin_key = {
    sopsFile = ../secrets/secrets.yaml;
  };
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      key_path = config.sops.secrets.atuin_key.path;
    };
  };
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  services.flameshot.enable = true;
  # services.dropbox.enable = true;  # not able to start dropbox with nix on ubuntu
  # services.nextcloud-client.enable = true;
  targets.genericLinux.enable = true;
  programs.home-manager.enable = true;
}
