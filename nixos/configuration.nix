/* MIT License

Copyright (c) 2023 guemax

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

{ config, pkgs, ... }:

{
  imports = [
    <nixos-hardware/dell/inspiron/7405>
    ./hardware-configuration.nix
    <home-manager/nixos>
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
  ###                    --- LUKS Encryption ---                     ###
  ###                                                                ###
  ######################################################################
  
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  boot.initrd.luks.devices."luks-3822d100-9ab0-4fd3-a51b-4eba9b4e69ef"
    .device = "/dev/disk/by-uuid/3822d100-9ab0-4fd3-a51b-4eba9b4e69ef";
  boot.initrd.luks.devices."luks-3822d100-9ab0-4fd3-a51b-4eba9b4e69ef"
    .keyFile = "/crypto_keyfile.bin";
  

  ######################################################################
  ###                                                                ###
  ###                       --- Networking ---                       ###
  ###                                                                ###
  ######################################################################

  networking.hostName = "nixos";
  networking.wireless.enable = true;

  networking.networkmanager.enable = true;
  networking.networkmanager.unmanaged = [
    "*" "except:type:wwan" "except:type:gsm"
  ];

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

  fonts.fontDir.enable = true;

  services.xserver.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
  };
  services.xserver.windowManager.xmonad.config =
    builtins.readFile /home/max/.xmonad/xmonad.hs;

  services.xserver.displayManager.defaultSession = "none+xmonad";


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
  services.redshift.temperature.day = 5000;
  services.redshift.temperature.night = 2500;


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
  ###                    --- System Packages ---                     ###
  ###                                                                ###
  ######################################################################

  environment.systemPackages = with pkgs; [
    #######################
    ## OS related stuff. ##
    #######################

    tor-browser-bundle-bin
    brightnessctl
    # TODO: Use font.font for specifying fonts.
    font-awesome
    keepassxc
    localsend  # Open Source alternative to Air Drop.
    firefox
    iosevka
    xmobar
    gnupg
    anki
    vlc
    mc  # Midnight Commander: Text based file manager for Unix.

    
    ##########################
    ## Image related stuff. ##
    ##########################

    flameshot  # Screenshot software.
    darktable
    inkscape
    mypaint
    nomacs  # Image viewer with basic image manipulation.
    gimp
    feh  # Simply an image viewer.
    
    
    #######################
    ## Programmer stuff. ##
    #######################

    texlive.combined.scheme-full
    jetbrains-mono
    alacritty
    inetutils
    xorg.xev  # Print contents of X events.
    emacs
    stow
    git
    tea  # Official Gitea CLI.
    gh


    ###################
    ## H4ck3r stuff. ##
    ###################

    neofetch
    cmatrix
    cowsay
    lolcat
    htop
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
