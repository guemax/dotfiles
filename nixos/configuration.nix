/* MIT License

Copyright (c) 2023 guemax

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall.n be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

{ config, pkgs, lib, ... }:

{
  imports = [
    <nixos-hardware/dell/inspiron/7405>
    ./hardware-configuration.nix
    ./additional-hardware-configuration.nix
    <home-manager/nixos>
  ];

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem
    (lib.getName pkg) [
      "epson-inkjet-printer-workforce-840-series"
    ];

  
  ######################################################################
  ###                                                                ###
  ###                       --- Bootloader ---                       ###
  ###                                                                ###
  ######################################################################

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.supportedFilesystems = [ "ntfs" ];
  services.devmon.enable = true;  # Automatic device mounting.
  

  ######################################################################
  ###                                                                ###
  ###                       --- Networking ---                       ###
  ###                                                                ###
  ######################################################################

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 53317 ];  # 53317 required for localsend.
    allowedUDPPorts = [ 53317 ];
  };
  

  ######################################################################
  ###                                                                ###
  ###                      --- Localisation ---                      ###
  ###                                                                ###
  ######################################################################

  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };
  

  ######################################################################
  ###                                                                ###
  ###                     --- X11 and XMonad ---                     ###
  ###                                                                ###
  ######################################################################

  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "intel" ];

  console.keyMap = "de";
  services.xserver = {
    layout = "de";
    xkbVariant = "";
  };

  services.xserver.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
  };
  services.xserver.windowManager.xmonad.config =
    builtins.readFile /home/max/.xmonad/xmonad.hs;

  services.xserver.displayManager.defaultSession = "none+xmonad";

  # Touchpad support.
  services.xserver.libinput.enable = true;


  ######################################################################
  ###                                                                ###
  ###                      --- HiDPI Screen ---                      ###
  ###                                                                ###
  ######################################################################

  console.font =
    "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
  services.xserver.dpi = 180;

  environment.variables = {
    GDK_SCALE = "1.5";
    GDK_DPI_SCALE = "0.5";
    _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
  };
  

  ######################################################################
  ###                                                                ###
  ###                      --- Night Light ---                       ###
  ###                                                                ###
  ######################################################################

  location.latitude = 48.1;
  location.longitude = 11.6;  # Munich, Germany
  
  services.redshift.enable = true;
  services.redshift = {
    temperature = {
      day = 5000;
      night = 2500;
    };
    brightness = {
      day = "0.9";
      night = "0.6";
    };
  };


  ######################################################################
  ###                                                                ###
  ###                         --- Sound ---                          ###
  ###                                                                ###
  ######################################################################

  sound.enable = true;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  

  ######################################################################
  ###                                                                ###
  ###                          --- CUPS ---                          ###
  ###                                                                ###
  ######################################################################

  services.printing.enable = true;
  services.printing.drivers = with pkgs; [
    epson-escpr
    # Custom Nix package written by my father, which uses the
    # proprietary Epson driver for the Workforce 840 to enable double
    # sided printing as well.
    (callPackage /etc/nixos/epson-workforce-840.nix {})
  ];

  
  ######################################################################
  ###                                                                ###
  ###                     --- User Accounts ---                      ###
  ###                                                                ###
  ######################################################################

  users.users.max = {
    isNormalUser = true;
    description = "Max";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  home-manager.users.max = { pkgs, ... }: {
    home.stateVersion = "23.05";
    
    programs.git = {
      enable = true;
      userName = "guemax";
      userEmail = "code-mg@mailbox.org";

      extraConfig = {
        init.defaultBranch = "main";
        commit.gpgsign = true;
        user.signingkey = "85916548E34D20A0!";
      };
    };

    services.gpg-agent = {
      enable = true;
      enableBashIntegration = true;
      defaultCacheTtl = 1800;  # 30 minutes.
      extraConfig = ''
        allow-emacs-pinentry
        allow-loopback-pinentry
      '';
      pinentryFlavor = "curses";  # Pinentry TUI.
    };
  };
  

  ######################################################################
  ###                                                                ###
  ###                         --- Fonts ---                          ###
  ###                                                                ###
  ######################################################################

  fonts.fontDir.enable = true;
  
  fonts.fonts = with pkgs; [
    font-awesome
    iosevka
    nerdfonts
    jetbrains-mono
  ];

  
  ######################################################################
  ###                                                                ###
  ###                    --- System Packages ---                     ###
  ###                                                                ###
  ######################################################################

  environment.systemPackages = with pkgs; [
    ##############
    ## Browser. ##
    ##############
    tor-browser-bundle-bin
    firefox

    ###################
    ## OS utilities. ##
    ###################
    thunderbird
    libreoffice
    borgbackup
    localsend  # Open Source alternative to Air Drop.
    anki
    vlc
    mc  # Midnight Commander: Text based file manager for Unix.

    ##################################
    ## Secret management utilities. ##
    ##################################
    keepassxc
    gnupg

    ##############################
    ## XMonad/Xmobar utilities. ##
    ##############################
    xdotool  # For having clickable workspaces in Xmobar.
    xmobar
    rofi
    
    #########################
    ## SysAdmin utilities. ##
    #########################
    brightnessctl
    inetutils
    xorg.xev  # Print contents of X events.
    htop

    ####################
    ## Image viewers. ##
    ####################
    nomacs  # With basic image manipulation.
    feh

    ####################
    ## Image editors. ##
    ####################
    darktable
    inkscape
    mypaint
    gimp

    ################################
    ## Screen recording software. ##
    ################################
    obs-studio
    flameshot  # Screenshot software.

    ############################
    ## Programming languages. ##
    ############################
    texlive.combined.scheme-full
    python311
    rustfmt
    rustc
    cargo
    gcc

    ##########################
    ## Terminal and editor. ##
    ##########################
    alacritty
    emacs

    ######################
    ## Version control. ##
    ######################
    git
    tea  # Official Gitea CLI.
    gh

    ##################################
    ## Other programming utilities. ##
    ##################################
    tokei
    stow
    
    ###################
    ## H4ck3r stuff. ##
    ###################
    neofetch
    cmatrix
    cowsay
    lolcat
  ];


  ######################################################################
  ###                                                                ###
  ###                     --- Miscellaneous ---                      ###
  ###                                                                ###
  ######################################################################

  services.emacs.enable = true;
  services.emacs.defaultEditor = true;

  programs.ssh.startAgent = true;

  system.stateVersion = "23.05";
}
