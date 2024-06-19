# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, lib, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "root" "bsuttor" ];
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # inputs.sops-nix.nixosModules.sops
      inputs.home-manager.nixosModules.default
    ];
  sops.defaultSopsFile = ./serets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/bsuttor/.config/sops/age/key.txt";

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-04135b17-0687-4abf-a348-5dd5bc307109".device = "/dev/disk/by-uuid/04135b17-0687-4abf-a348-5dd5bc307109";
  networking.hostName = "nixos-iMio"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.firewall = {
    allowedUDPPorts = [ 51820 ]; # Clients and peers can use the same port, see listenport
  };

  networking.extraHosts =
  ''
    127.0.0.1 local-hobo.example.net local-auth.example.net local-formulaires.example.net local.example.net local-portail-agent.example.net local-documents.example.net local-passerelle.example.net local-agendas.example.net
  '';
  sops.secrets.wireguard_private_key = {
    sopsFile = ../../secrets/secrets.yaml;
  };
  # Enable WireGuard
  networking.wg-quick.interfaces = {
    # "wg0" iMio.
    wg0 = {
      # Determines the IP address and subnet of the client's end of the tunnel interface.
      address = [ "10.9.199.6/32" ];
      listenPort = 51820; # to match firewall allowedUDPPorts (without this wg uses random port numbers)
      privateKeyFile = config.sops.secrets.wireguard_private_key.path;
      dns = [ "10.9.201.53" "10.9.201.184" ];

      peers = [
        {
          publicKey = "PQBPxErikcCD6CgISvJPnw0Oxx6fP+WED0G2Oy1ifg0=";
          # Forward all the traffic via VPN.
          # allowedIPs = [ "0.0.0.0/0" ];
          # Or forward only particular subnets
          allowedIPs = [ "10.9.199.0/24" "10.9.201.0/24" "10.9.128.0/22" "10.9.200.0/24" "10.7.0.0/16" "10.8.0.0/16" "10.9.0.0/17" "10.10.0.0/16" ];

          # Set this to the server IP and port.
          endpoint = "188.165.186.184:51820"; # ToDo: route to endpoint not automatically configured https://wiki.archlinux.org/index.php/WireGuard#Loop_routing https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577
          persistentKeepalive = 16;
          presharedKey = "QucPplZhDxhb8KDdv593lVX0+7c5SWYVjrbSkIBYOOU=";
        }
      ];
    };
  };

  # Set your time zone.
  time.timeZone = "Europe/Brussels";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Enable auto login, 4 lines needed because of https://github.com/NixOS/nixpkgs/issues/103746
  services.displayManager.autoLogin.user = "bsuttor";
  services.displayManager.autoLogin.enable = true;
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  services.xserver.xautolock.time = 480;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "be";
    # xkbVariant = "nodeadkeys";
  };
  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;


  # Configure console keymap
  console.keyMap = "be-latin1";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  #environment.systemPackages = [
  #  pkgs.maestral
  #  pkgs.maestral-gui
  #];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.bsuttor = {
    isNormalUser = true;
    description = "Benoit Suttor";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    # packages = with pkgs; [
    #   firefox
    #   #  thunderbird
    # ];
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "bsuttor" = import ./home.nix;
    };
  };
  virtualisation.docker.enable = true;
  #users.users.bsuttor.useDefaultShell = true;
  programs.zsh.enable = true;
  users.extraUsers.bsuttor.shell = pkgs.zsh;


  # List packages installed in system profile. To search, run:
  # $ nix search wget

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  


  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
