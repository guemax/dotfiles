#!/usr/bin/env bash
# MIT License

# Copyright (c) 2023 guemax

# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation files
# (the "Software"), to deal in the Software without restriction,
# including without limitation the rights to use, copy, modify, merge,
# publish, distribute, sublicense, and/or sell copies of the Software,
# and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:

# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
# BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
# ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

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

printf "Stowing config files... "
stow .
echo "done."

printf "Applying X defaults... "
xrdb -merge ~/.Xdefaults

printf "Building NixOS... "
nixos-rebuild switch
echo "done."

echo "Wonderful, you are now all set. Have fun with your system!"
