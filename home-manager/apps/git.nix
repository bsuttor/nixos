{
  programs.git = {
    enable = true;
    userName = "Benoît Suttor";
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


}
