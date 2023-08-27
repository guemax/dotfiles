# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-3822d100-9ab0-4fd3-a51b-4eba9b4e69ef".device = "/dev/disk/by-uuid/3822d100-9ab0-4fd3-a51b-4eba9b4e69ef";
  boot.initrd.luks.devices."luks-3822d100-9ab0-4fd3-a51b-4eba9b4e69ef".keyFile = "/crypto_keyfile.bin";

  networking.hostName = "nixos"; # Define your hostname.
  networking.wireless.enable = true;
  # networking.wireless = {
  #   enable = true;
  #   userControlled.enable = true;
  #   networks = {
  #     "FRITZ!Box 7490" = {
  #       pskRaw = "12f358b548da48c32c1cbec22aaf08a04d0c0dd79593f803d8fce119f3f47d23";
  #     };
  #   };
  # };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.networkmanager.unmanaged = [
    "*" "except:type:wwan" "except:type:gsm"
  ];

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
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

  console.font =
    "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";

  services.xserver.enable = true;
  services.xserver.dpi = 180;

  services.xserver.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
  };
  
  services.xserver.videoDrivers = [ "intel" ];

  environment.variables = {
    GDK_SCALE = "1.5";
    GDK_DPI_SCALE = "0.5";
    _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
  };

  services.xserver.windowManager.xmonad.config = builtins.readFile ../xmonad/xmonad.hs;

  boot.supportedFilesystems = [ "ntfs" ];
  services.devmon.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "de";
    xkbVariant = "";
  };

  # Configure console keymap
  console.keyMap = "de";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.max = {
    isNormalUser = true;
    description = "Max Günther";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    ];
  };

#   home-manager.programs.ssh.startAgent = true;

#   xdg.autostart.enable = true;
#   services.gnome.gnome-keyring.enable = true;
#   environment.sessionVariables = {
#     SSH_AUTH_SOCK = "/run/usr/1000/keyring/ssh";
#   };

  home-manager.users.max = { pkgs, ... }: {
    home.packages = with pkgs; [
    ];
    home.stateVersion = "23.05";
#     home.sessionVariables.SSH_AUTH_SOCK = "/run/user/1000/keyring/ssh";
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
#    services.ssh-agent.enable = true;
#     programs.ssh.startAgent = true;
  };

  programs.ssh.startAgent = true;


  environment.systemPackages = with pkgs; [
    firefox
    emacs
    keepassxc
    alacritty
    git
    inkscape
    mc
    gh
  ];

  services.emacs.enable = true;
  services.emacs.defaultEditor = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
#   services.opensshd.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
