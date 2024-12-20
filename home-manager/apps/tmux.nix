{ config, pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    # shell = "\${pkgs.zsh}/bin/zsh";
    clock24 = true;
    historyLimit = 100000;
    # mouse = true;
    keyMode = "vi";
    extraConfig = "bind  %  split-window -h -c \"#{pane_current_path}\"\nbind '\"' split-window -v -c \"#{pane_current_path}\"";
  };


}
