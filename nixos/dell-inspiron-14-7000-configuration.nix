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

let
  stateVersion = import ./state-version.nix;
in
{
  imports = [
    # Hardware configuration.
    <nixos-hardware/dell/inspiron/7405>
    ./hardware-configuration.nix
    # Modules.
    ./modules/bootloader.nix
    ./modules/networking.nix
    ./modules/localisation.nix
    ./modules/system-packages.nix
    ./modules/users.nix
    ./modules/hdpi.nix
    ./modules/fonts.nix
    # Services.
    ./services/xserver.nix
    ./services/redshift.nix
    ./services/pipewire.nix
    ./services/printing.nix
    ./services/emacs.nix
    ./services/picom.nix
    # Programs.
    ./programs/ssh.nix
    # Home Manager.
    <home-manager/nixos>
    ./modules/home.nix
  ];

  #####################
  ## LUKS Encryption ##
  #####################
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  boot.initrd.luks.devices."luks-3822d100-9ab0-4fd3-a51b-4eba9b4e69ef"
    .device = "/dev/disk/by-uuid/3822d100-9ab0-4fd3-a51b-4eba9b4e69ef";
  boot.initrd.luks.devices."luks-3822d100-9ab0-4fd3-a51b-4eba9b4e69ef"
    .keyFile = "/crypto_keyfile.bin";

  ###################
  ## State Version ##
  ###################
  system.stateVersion = stateVersion;
}
