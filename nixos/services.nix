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
  ######################################################################
  ###                                                                ###
  ###                         --- Emacs ---                          ###
  ###                                                                ###
  ######################################################################

  services.emacs = {
    enable = true;
    defaultEditor = true;
  };
  

  ######################################################################
  ###                                                                ###
  ###                        --- Xserver ---                         ###
  ###                                                                ###
  ######################################################################

  services.xserver = {
    enable = true;
    videoDrivers = [ "intel" ];

    layout = "de";
    xkbVariant = "";

    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;
      config = builtins.readFile /home/max/.xmonad/xmonad.hs;
    };

    displayManager = {
      defaultSession = "none+xmonad";
      sessionCommands = ''
                          feh --bg-scale ~/.dotfiles/wallpapers/gruber-darker-theme-brown-green.png
                          polybar
                          xmonad &
                        '';
    };
    libinput.enable = true;
  };
  
  console.keyMap = "de";
  

  ######################################################################
  ###                                                                ###
  ###                         --- Picom ---                          ###
  ###                                                                ###
  ######################################################################

  services.picom = {
    enable = true;
    backend = "glx";

    fade = true;
    fadeSteps = [
      0.25
      0.25
    ];
    fadeDelta = 10;
    
    shadow = true;
    shadowOpacity = 0.3;
    shadowOffsets = [
      (-10)
      (-10)
    ];
    shadowExclude = [
      "class_i = 'polybar'"
    ];
    
    settings = {
      blur = {
        method = "dual_kawase";
        strength = 5;
      };
      corner-radius = 12.5;
      round-borders = 3;
      rounded-corners-exclude = [
        "class_i = 'polybar'"
        "class_i = 'emacs'"
        "class_i = 'firefox'"
        "class_i = 'vlc'"
        "class_i = 'keepassxc'"
      ];
    };

    opacityRules = [
      "80:class_i *= 'alacritty' && !focused"
      "80:class_i = 'rofi'"
    ];
  };

  
  ######################################################################
  ###                                                                ###
  ###                        --- Pipewire ---                        ###
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
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem
    (lib.getName pkg) [
      "epson-inkjet-printer-workforce-840-series"
    ];
  
  
  ######################################################################
  ###                                                                ###
  ###                        --- Printing ---                        ###
  ###                                                                ###
  ######################################################################

  services.printing = {
    enable = true;
    drivers = with pkgs; [
      epson-escpr
      # Custom Nix package written by my father, which uses the
      # proprietary Epson driver for the Workforce 840 to enable double
      # sided printing as well. (Not public yet, however.)
      (callPackage /etc/nixos/epson-workforce-840.nix {})
    ];
  };
  

  ######################################################################
  ###                                                                ###
  ###                        --- Redshift ---                        ###
  ###                                                                ###
  ######################################################################

  location.latitude = 48.1;
  location.longitude = 11.6;  # Munich, Germany
  
  services.redshift = {
    enable = true;
    
    temperature = {
      day = 5000;
      night = 2500;
    };
    brightness = {
      day = "0.9";
      night = "0.6";
    };
  };
}