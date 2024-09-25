{ config, pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    shell = "\${pkgs.zsh}/bin/zsh";
    clock24 = true;
    historyLimit = 10000;
    mouse = true;
    extraConfig = '' # used for less common options, intelligently combines if defined in multiple places.
      ...
    '';
  };


}
