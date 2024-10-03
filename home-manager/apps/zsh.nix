{ config, pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    autocd = true;
    shellAliases = {
      ll = "ls -lah";
      switch-home-manager = "home-manager switch --flake ~/nix/#$USER && source ~/.zshrc";
      eset-status = "sudo systemctl status eea.service";
      eset-stop = "sudo systemctl stop eea.service && sudo systemctl stop eraagent.service";
      eset-start = "sudo systemctl start eea.service  && sudo systemctl start eraagent.service";
      # switch-nix = "sudo nixos-rebuild switch --flake /home/bsuttor/nixos#default";
      # clean-nix = "sudo nixos-collect-garbage --delete-older-than 15d";
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
  programs.bash.enable = true;
  programs.bash.initExtra = ''
      $HOME/.nix-profile/bin/zsh
  '';
  # users.defaultUserShell = pkgs.zsh;

}
