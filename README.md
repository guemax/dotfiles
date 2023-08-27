# Dotfiles

Dotfiles&mdash;A place for combining all my GNU/Linux configuration files.

## Preparation

You need to create a symlink before running `sudo nixos-rebuild switch`:

```shell
# In /etc/nixos
sudo ln -s ~/.dotfiles/nixos/configuration.nix .
sudo ln -s ~/.dotfiles/xmonad/ .
```

Have fun!
