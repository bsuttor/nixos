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

  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops = {
    age.keyFile = "/home/bsuttor/.config/sops/age/key.txt";
    defaultSymlinkPath = "/run/user/1000/secrets";
    defaultSecretsMountPoint = "/run/user/1000/secrets.d";
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    sops

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

    # dev tools
    git
    tig
    direnv
    python310
    python310Packages.black
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
    maestral
    maestral-gui

    # gnome
    gnome3.gnome-tweaks
    # gnomeExtensions.gnome-clipboard
    gnomeExtensions.clipboard-indicator
    gnomeExtensions.vitals

    # apps
    firefox
    google-chrome
    vscode
    libreoffice
    xclip
    signal-desktop
    bitwarden
    bitwarden-cli
    # bitwarden-desktop
    vnote
    vlc

    # archives
    zip
    xz
    unzip
    p7zip
    unrar

    # ia
    ollama

    # # Adds the 'hello' command to your ment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello:Ex

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    ZSH_TMUX_AUTOSTART = "true";
  };

  nixpkgs.config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
  };

  # Let Home Manager install and manage itself.
  programs.home-manager = {
    enable = true;
    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    # version = "21.05";
  };

  dconf.settings = {
    # ...
    "org/gnome/shell" = {
      favorite-apps = [
        "firefox.desktop"
        "google-chrome.desktop"
        "code.desktop"
        "org.gnome.Console.desktop"
        "org.gnome.Nautilus.desktop"
        "signal-desktop.desktop"
        # "spotify.desktop"
        # "virt-manager.desktop"
      ];
      disable-user-extensions = false;
      enabled-extensions = [
        "Vitals@CoreCoding.com"
        "clipboard-indicator@tudmotu.com"
      ];
    };
    "org/gnome/desktop/interface" = {
      clock-show-date = true;
      clock-show-seconds = true;
      clock-format = "24h";
      show-battery-percentage = true;
      clock-show-weekday = true;
    };
    "org/gnome/shell/extensions/vitals" = {
      hot-sensors = [
        "_processor_usage_"
        "_memory_usage_"
        "__network-rx_max__"
        "__network-tx_max__"
      ];
    };
  };

  programs.git = {
    enable = true;
    userName = "Benoit Suttor";
    userEmail = "ben.suttor@gmail.com";
    aliases = {
      st = "status";
      ci = "commit";
      co = "checkout";
      lg = "log --graph --abbrev-commit --decorate --date=relative --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)'";
    };
    extraConfig = {
      core = {
        editor = "nvim";
      };
      pull = {
        rebase = true;
      };
      rebase = {
        autoStash = true;
      };
      github = {
        user = "bsuttor";
      };
      color = {
        diff = "auto";
        status = "auto";
        branch = "auto";
      };
    };
  };

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    plugins = with pkgs.vimPlugins; [
      ctrlp
      editorconfig-vim
      fzf-vim
      gruvbox-community
      gruvbox-material
      mini-nvim
      nvim-lspconfig
      nvim-treesitter.withAllGrammars
      plenary-nvim
      vim-airline
      vim-elixir
      vim-nix
    ];
    extraConfig = ''
      colorscheme shine
      let g:context_nvim_no_redraw = 1
      set mouse=a
      set number
      set nobackup
      set nowritebackup
      set noswapfile
      set title
      set history=1000
      set undolevels=1000
      set autoread
      set ignorecase
      set wildmenu
      set hlsearch
      nnoremap <silent> <Esc><Esc> <Esc>:nohlsearch<CR><Esc>

      set clipboard=unnamed
      set expandtab
      set shiftwidth=4
      set tabstop=4
      set smarttab

      set ai
      set si
      set wrap
      set autochdir
      set nofoldenable
    '';
  };
  programs.vscode = {
    enable = true;
  };
  sops.secrets.atuin_key = {
    sopsFile = ../../secrets/secrets.yaml;
  };
  programs.atuin = {
    enable = true;
    settings = {
      key_path = config.sops.secrets.atuin_key.path;
    };
  };

  programs.tmux = {
    enable = true;
    clock24 = true;
    historyLimit = 10000;
    mouse = true;
    extraConfig = '' # used for less common options, intelligently combines if defined in multiple places.
      ...
    '';
  };

  programs.k9s = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
    # enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    autocd = true;
    shellAliases = {
      ll = "ls -lah";
      switch-nix = "sudo nixos-rebuild switch --flake /home/bsuttor/nixos#default";
      clean-nix = "sudo nixos-collect-garbage --delete-older-than 15d";
      k = "kubecolor";
    };
    history = {
      size = 100000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" "tmux" "docker" "docker-compose" "kubectl" ];
      theme = "robbyrussell";
    };
  };
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };
}
