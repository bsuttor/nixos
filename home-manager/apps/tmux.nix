{ config, pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    # shell = "\${pkgs.zsh}/bin/zsh";
    clock24 = true;
    historyLimit = 100000;
    # mouse = true;
    # keyMode = "vi";
    extraConfig = '' # used for less common options, intelligently combines if defined in multiple places.
    '';
  };


}
