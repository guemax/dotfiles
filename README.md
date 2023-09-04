<!-- MIT License

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
-->

# Dotfiles

Dotfiles&mdash;A place for combining all my GNU/Linux configuration
files.

![Screenshot of my desktop.](./resources/screenshot-2.png)

## Setup

Setting up my dotfiles is pretty much straightforward, as I have
automated it almost completely:

```shell
$ # Create a nix-shell with git and stow available.
$ nix-shell -p git stow

[nix-shell] $ git clone https://codeberg.org/guemax/dotfiles .dotfiles
[nix-shell] $ cd .dotfiles/
[nix-shell] $ # Make the setup script executable
[nix-shell] $ chmod +x setup.sh
[nix-shell] $ sudo ./setup.sh
```

That's it, have fun with your system!

## Permanently enabling Redshift

For permanently enabling Redshift, create the following file:

```shell
~/.config/systemd/user/default.target.wants/redshift.service
```

## HiDPI screen settings

Don't forget to enable scaling for HiDPI screens in Firefox (if you
need that), by going to `about:config` and searching for
`layout.css.devPixelsPerPx`.  I set the value to `1.5`.
