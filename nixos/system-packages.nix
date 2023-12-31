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

{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    ########################
    ## Images and Videos. ##
    ########################
    obs-studio
    flameshot  # Screenshot software.
    darktable
    (inkscape.overrideAttrs {
      version = "1.3.0";
    })
    dconf
    mypaint
    nomacs  # Basic image manipulation.
    gimp
    feh
    vlc

    ############
    ## Games. ##
    ############
    extremetuxracer
    superTuxKart
    sauerbraten
    superTux
    minetest
    
    ####################
    ## Miscellaneous. ##
    ####################
    tor-browser-bundle-bin
    libreoffice
    thunderbird
    borgbackup
    keepassxc
    localsend  # Open Source alternative to Air Drop.
    musescore
    librewolf
    sonic-pi
    zathura
    firefox
    yewtube
    mupdf
    tmux
    tree
    anki
    mons  # Managing multiple monitors.
    mc  # Midnight Commander: Text based file manager for Unix.
    
    ##################
    ## Programming. ##
    ##################
    texlive.combined.scheme-full
    cargo-tarpaulin
    rust-analyzer
    platformio
    alacritty
    python311
    neofetch
    cmatrix
    rustfmt
    cowsay
    lolcat
    rustup
    tokei
    stow
    gdb
    vim
    gcc
    git
    tea  # Official Gitea CLI.
    gh

    ###################
    ## OS utilities. ##
    ###################
    hunspellDicts.de-de
    hunspellDicts.en_US
    papirus-icon-theme
    phinger-cursors
    pinentry-emacs
    brightnessctl
    lxappearance
    imagemagick
    inetutils
    hunspell
    xorg.xev  # Print contents of X events.
    polybar
    xdotool  # For having clickable workspaces in Xmobar.
    xmobar
    ffmpeg
    dunst
    gnupg
    sshfs
    htop
    zip
    unzip
    rofi-power-menu
    (rofi.override {
      plugins = [
        rofi-calc
        rofi-emoji
      ];
    })
  ];
}
