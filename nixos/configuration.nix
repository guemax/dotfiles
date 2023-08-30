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

  services.xserver.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
  };
  services.xserver.windowManager.xmonad.config =
    builtins.readFile ../xmonad/xmonad.hs;


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
  hardware.pulseaudio.enable = false;
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
    description = "Max Günther";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  home-manager.users.max = { pkgs, ... }: {
    home.stateVersion = "23.05";
    home.file.".ssh/allowed_signers".text =
      "* ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFdnTBXWsqeMc28vnbWp8sNhrAeKfveb4Ly4aO7nrVK9 git";

    programs.git = {
      enable = true;
      userName = "guemax";
      userEmail = "code-mg@mailbox.org";

      extraConfig = {
        init.defaultBranch = "main";
        commit.gpgsign = true;
        gpg.format = "ssh";
        user.signingkey =
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFdnTBXWsqeMc28vnbWp8sNhrAeKfveb4Ly4aO7nrVK9 git";
        gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
      };
    };
  };

  
  ######################################################################
  ###                                                                ###
  ###                    --- System Packages ---                     ###
  ###                                                                ###
  ######################################################################

  environment.systemPackages = with pkgs; [
    tor-browser-bundle-bin
    firefox
    jetbrains-mono
    alacritty
    keepassxc
    localsend  # Open Source alternative to Air Drop.
    flameshot  # Screenshot software.
    inetutils
    nomacs  # Image viewer with basic image manipulation.
    feh  # Simply an image viewer.
    vlc
    mc  # Midnight Commander: Text based file manager for Unix.
    inkscape
    darktable
    gimp
    anki
    texlive.combined.scheme-medium
    emacs
    git
    gh
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
