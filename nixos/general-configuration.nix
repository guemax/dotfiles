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
  ######################################################################
  ###                                                                ###
  ###                       --- Bootloader ---                       ###
  ###                                                                ###
  ######################################################################

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
  
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
  ###                         --- HiDPI ---                          ###
  ###                                                                ###
  ######################################################################

  console.font =
    "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
  services.xserver.dpi = 180;

  environment.variables = {
    GDK_SCALE = "1.5";
    GDK_DPI_SCALE = "0.5";
    _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=lcd";
  };


  ######################################################################
  ###                                                                ###
  ###                         --- Users ---                          ###
  ###                                                                ###
  ######################################################################

  users.users.max = {
    isNormalUser = true;
    description = "Max";
    extraGroups = [ "networkmanager" "wheel" ];
  };
}
