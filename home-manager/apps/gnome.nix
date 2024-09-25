{
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
}