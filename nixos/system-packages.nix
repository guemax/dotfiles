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
    ##############
    ## Browser. ##
    ##############
    tor-browser-bundle-bin
    firefox

    ###################
    ## OS utilities. ##
    ###################
    papirus-icon-theme
    phinger-cursors
    pinentry-emacs
    lxappearance
    thunderbird
    libreoffice
    borgbackup
    localsend  # Open Source alternative to Air Drop.
    polybar
    mupdf
    anki
    mons  # Managing multiple monitors.
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
    platformio
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
}
