{ config, lib, pkgs, options, ... }:

{

  fonts = {
    # enableDefaultFonts = true;
    # enableGhostscriptFonts = true;
    fontDir.enable = true;
    fonts = with pkgs; [
      # noto-fonts
      # noto-fonts-cjk # chinese japanese and koreans characters
      # noto-fonts-emoji
      # anurati
      fira-code
      fira-code-symbols
    ];
  };

  # default shell for all users
  users.defaultUserShell = pkgs.dash;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.iruzo = {
    # group to users, createHome to true, home to /home/username, useDefaultShell to true, and isSystemUser to false.
    isNormalUser = true;
    shell = pkgs.yash;
    hashedPassword = "$6$y5ndN54phM7X83Dm$WAYAZXcXuMNR.LU6iMHMnT8SeBDhSiWTW4hrhl01g3hx7r6PHqyB1fPmRRJN7DMs0rjcE17unTdydp5zILA7p1";

    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user.
      "networkmanager"
      "video"
      "audio"
      "dialout"
      "feedbackd"
      # "docker" "lxd" # Allow access to the sockets without root
    ];

    packages = with pkgs; [
      man
      curl
      git
      unzip
      keepassxc
      helvum
      pavucontrol

      foot
      neovim
      # qutebrowser

      # phone apps
      chatty              # IM and SMS
      megapixels          # Camera
    ];

  };

  programs.noisetorch.enable = true;

  # phone config
  hardware.sensor.iio.enable = true;

  mobile.beautification = {
    silentBoot = lib.mkDefault true;
    splash = lib.mkDefault true;
  };
  services.xserver.desktopManager.phosh = {
    enable = true;
    group = "users";
    user = "iruzo";
  };
  programs.calls.enable = true;
  assertions = [
    { assertion = options.services.xserver.desktopManager.phosh.user.isDefined;
    message = ''
      `services.xserver.desktopManager.phosh.user` not set.
        When importing the phosh configuration in your system, you need to set `services.xserver.desktopManager.phosh.user` to the username of the session user.
    '';
    }
  ];

  # programs.sway = {
  #   enable = true;
  #   extraPackages = with pkgs; [
  #     swaylock
  #     wl-clipboard
  #     bemenu
  #     grim
  #     slurp
  #   ];
  # };

  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
  };

  # fetching and compiling from source example
  # nixpkgs.overlays = [(self: super: {
  #   xdg-desktop-portal-wlr = super.xdg-desktop-portal-wlr.overrideAttrs(oldAttrs: rec {
  #     src = fetchFromGitHub {
  #       owner = "emersion";
  #       repo = "xdg-desktop-portal-wlr";
  #       sha256 = "";
  #       rev = "a18bea8461bc6f9fda68bf54dd77f2189f644ca5";
  #     };
  #     patches = [];
  #   });
  # })];

  # nixpkgs.config.packageOverrides = pkgs: {
  #   nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
  #     inherit pkgs;
  #   };
  # };

  programs.firefox = {
    enable = true;
    package = pkgs.firefox-wayland;
    # forceWayland = true;
    policies = {
      PasswordManagerEnabled = false;
      DisableFirefoxAccounts = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemtry = true;
      DisplayBookmarksToolbar = "never";
      NoDefaultBookmarks = true;
      SearchSuggestEnabled = true;
      HardwareAcceleration = false;
      SanitizeOnShutdown = {
        Cache = false;
        Cookies = false;
        Downloads = true;
        FormData = true;
        History = true;
        Sessions = true;
        SiteSettings = true;
        OfflineApps = true;
        Locked = true;
      };
      SearchEngines = {
        Default = "DuckDuckGo";
        DefaultPrivate = "DuckDuckGo";
        PreventInstalls = false;
      };
      FirefoxHome = {
        Search = false;
        Pocket = false;
        Snippets = false;
        TopSites = false;
        Highlights = false;
      };
      # Homepage = {
      #   URL = "https://duckduckgo.com";
      #   Locked = true;
      # };
      DefaultDownloadDirectory = "$\{home\}/download";
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      Preferences = {
        browser.theme.content-theme = 0;
        extensions.activeThemeID = "{5ee380f7-abda-467c-ae9a-d30bf8f0d1d6}";
      };
      ExtensionSettings = {
        # ayu
        "{893ac7d8-44d2-4f3c-8a40-d42cef042076}" = {
          allowed_types = "theme";
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ayu-dark-theme/latest.xpi";
        };
        # catppuccin
        # "{15cb5e64-94bd-41aa-91cf-751bb1a84972}" = {
        #   allowed_types = "theme";
        #   installation_mode = "force_installed";
        #   install_url = "https://addons.mozilla.org/firefox/downloads/latest/catppuccin-macchiato-lavender2/latest.xpi";
        # };
        # gruvbox
        # "{08d5243b-4236-4a27-984b-1ded22ce01c3}" = {
        #   allowed_types = "theme";
        #   installation_mode = "force_installed";
        #   install_url = "https://addons.mozilla.org/firefox/downloads/latest/gruvboxgruvboxgruvboxgruvboxgr/latest.xpi";
        # };
        # ublock
        "uBlock0@raymondhill.net" = {
          allowed_types = "extension";
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
        };
        # clearurls
        "{74145f27-f039-47ce-a470-a662b129930a}" = {
          allowed_types = "extension";
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/clearurls/latest.xpi";
        };
        # dark reader
        "addon@darkreader.org" = {
          allowed_types = "extension";
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
        };
        # decentraleyes
        "jid1-BoFifL9Vbdl2zQ@jetpack" = {
          allowed_types = "extension";
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/decentraleyes/latest.xpi";
        };
        # i still dont care about cookies
        "idcac-pub@guus.ninja" = {
          allowed_types = "extension";
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/istilldontcareaboutcookies/latest.xpi";
        };
        # languagetool
        "languagetool-webextension@languagetool.org" = {
          allowed_types = "extension";
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/languagetool/latest.xpi";
        };
        # multi-account-containers
        "@testpilot-containers" = {
          allowed_types = "extension";
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/multi-account-containers/latest.xpi";
        };
        # refined-github
        "{a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad}" = {
          allowed_types = "extension";
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/refined-github-/latest.xpi";
        };
        # temporary-containers
        "{c607c8df-14a7-4f28-894f-29e8722976af}" = {
          allowed_types = "extension";
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/temporary-containers/latest.xpi";
        };
        # vimium-ff
        "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
          allowed_types = "theme";
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/vimium-ff/latest.xpi";
        };
      };
    };
  };

}
