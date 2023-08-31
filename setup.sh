#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
    echo "Please run this script as root."
    exit 1
fi

echo "Setting up NixOS system:"

printf "Adding required nix channels... "

nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.05.tar.gz home-manager
nix-channel --add https://github.com/NixOS/nixos-hardware/archive/master.tar.gz nixos-hardware
nix-channel --update

echo "done."

printf "Creating symlinks... "
ln -s ./nixos/configuration.nix /etc/nixos/
echo "done."

prinft "Stowing config files... "
stow .
echo "done."

printf "Building NixOS... "
nixos-rebuild switch
echo "done."

echo "Wonderful, you are now all set. Have fun with your system!"
