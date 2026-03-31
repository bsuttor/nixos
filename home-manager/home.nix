{ config, pkgs, inputs, ... }:
let
  unstable = import inputs.nixpkgs-unstable {
    system = pkgs.system;
    # Uncomment this if you need an unfree package from unstable.
    config.allowUnfree = true;
  };
  llm-agents = inputs.llm-agents.packages.${pkgs.system};
  claude-desktop-unwrapped = inputs.claude-desktop-debian.packages.${pkgs.system}.claude-desktop;
  claude-desktop = pkgs.symlinkJoin {
    name = "claude-desktop";
    paths = [ claude-desktop-unwrapped ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/claude-desktop \
        --add-flags "--no-sandbox"
    '';
  };
in
{
  home.username = "bsuttor";
  home.homeDirectory = "/home/bsuttor";
  home.stateVersion = "25.05";

  home.file.".buildout/default.cfg" = {
    text = ''
      [buildout]
      extends-cache = /home/bsuttor/.buildout/extends
      download-cache = /home/bsuttor/.buildout/downloads
      eggs-directory = /home/bsuttor/.buildout/eggs
      develop-eggs-directory = /home/bsuttor/.buildout/develop-eggs
      find-links = /home/bsuttor/.buildout/extends
      '';
  };

  home.file.".local/bin/takescreenshotfull" = {
    executable = true;
    text = ''
      #!/bin/bash
      SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
      BEFORE=$(ls -t "$SCREENSHOT_DIR"/*.png 2>/dev/null | head -1)

      gdbus call --session \
        --dest org.freedesktop.portal.Desktop \
        --object-path /org/freedesktop/portal/desktop \
        --method org.freedesktop.portal.Screenshot.Screenshot \
        "" "{'interactive': <true>}" 2>/dev/null

      for i in $(seq 1 30); do
        AFTER=$(ls -t "$SCREENSHOT_DIR"/*.png 2>/dev/null | head -1)
        if [ "$AFTER" != "$BEFORE" ] && [ -n "$AFTER" ]; then
          sleep 0.3
          QT_QPA_PLATFORM=xcb ksnip -e "$AFTER"
          exit 0
        fi
        sleep 1
      done
    '';
  };

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
    ./apps/ripgrep.nix
    # ./apps/tmux.nix
    ./apps/vim.nix
    ./apps/vscode.nix
    ./apps/zsh.nix
    ./apps/nvpn.nix
  ];

  home.packages = with pkgs; [
    sops
    neofetch
    # utils
    jq # A lightweight and flexible command-line JSON processor
    yq-go # yaml processor https://github.com/mikefarah/yq
    fzf # A command-line fuzzy finder
    gnumake
    wget
    ffmpeg
    nodejs_22
    pnpm_9
    # system monitoring
    btop
    iotop # io monitoring
    iftop # network monitoring
    gtop # required by tophat gnome extension
    htop

    mdcat
    tailscale

    # dev tools
    git
    tig
    direnv
    # unstable.postman
    volta

    # Kubernetes
    kubectl
    #kubecolor
    kubie
    kind
    stern
    kubernetes-helm
    kubectl-klock
    kubectl-cnpg
    krew
    kubernetes-helm
    kubernetes-helmPlugins.helm-diff
    kubernetes-helmPlugins.helm-secrets
    kubernetes-helmPlugins.helm-unittest

    # networking tools
    mtr # A network diagnostic tool
    # iperf3
    dnsutils  # `dig` + `nslookup`
    # ldns # replacement of `dig`, it provide the command `drill`
    # aria2 # A lightweight multi-protocol & multi-source command-line download utility
    # socat # replacement of openbsd-netcat
    nmap # A utility for network discovery and security auditing
    ipcalc  # it is a calculator for the IPv4/v6 addresses
    speedtest-cli

    # dropbox
    # maestral
    # maestral-gui

    # gnome
    gnome-tweaks
    # gnomeExtensions.tophat
    gnomeExtensions.vitals
    gnomeExtensions.clipboard-history

    # apps
    # firefox
    # google-chrome # not able to start chrome with nix on ubuntu
    # vscode
    libreoffice
    # ghostty
    # xclip
    # signal-desktop
    bitwarden
    bitwarden-cli
    # bitwarden-desktop
    # vnote
    vlc
    ksnip

    # archives
    zip
    xz
    unzip
    p7zip
    unrar

    # ia
    ollama
    llm-agents.gemini-cli
    llm-agents.claude-code
    llm-agents.happy-coder
    claude-desktop
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    ZSH_TMUX_AUTOSTART = "false";
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

  programs.pyenv = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.uv = {
    enable = true;
    # python-downloads = "manual";
    # python-preference = "only-system";
  };

  programs.ghostty = {
    enable = true;
    installVimSyntax = true;
    enableZshIntegration = true;
    settings = {
      theme = "catppuccin-mocha";
      keybind = [
        "super+ctrl+h=goto_split:left"
        "super+ctrl+l=goto_split:right"
        "super+ctrl+k=goto_split:up"
        "super+ctrl+j=goto_split:down"
      ];
    };
  };

  # services.flameshot = {
  #   enable = true;   # not able to start flameshot from tray (only on command line) with nix on ubuntu
  #   package = unstable.flameshot;
  # };
  # services.dropbox.enable = true;  # not able to start dropbox with nix on ubuntu
  # services.nextcloud-client.enable = true;
  targets.genericLinux.enable = true;
  programs.home-manager.enable = true;
}
