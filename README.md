# Dotfiles

Dotfiles&mdash;A place for combining all my GNU/Linux configuration files.

## Preparation

You need to create two symlinks before running `sudo nixos-rebuild switch`:

```shell
# In /etc/nixos
sudo ln -s ~/.dotfiles/nixos/configuration.nix .
sudo ln -s ~/.dotfiles/xmonad/ .
```

Don't forget to enable scaling for HiDPI screens in Firefox (if you need that),
by going to `about:config` and searching for `layout.css.devPixelsPerPx`.
I set the value to `1.5`.

Have fun!
