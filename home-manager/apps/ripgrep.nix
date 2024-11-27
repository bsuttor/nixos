{ ... }:
{
  programs.ripgrep = {
    enable = true;
    arguments = "-L --no-ignore";
  };
}