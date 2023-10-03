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

{ config, ... }:

let
  stateVersion = import ./state-version.nix;
in
{
  home-manager.users.max = { pkgs, ... }: {
    home.stateVersion = stateVersion;
    home.pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      package = pkgs.phinger-cursors;
      name = "Phinger Cursors";
      size = 48;
    };
    
    programs.git = {
      enable = true;
      userName = "guemax";
      userEmail = "code-mg@mailbox.org";

      extraConfig = {
        init.defaultBranch = "main";
        commit.gpgsign = true;
        user.signingkey = "85916548E34D20A0!";
      };
    };

    services.gpg-agent = {
      enable = true;
      enableBashIntegration = true;
      defaultCacheTtl = 1800;  # 30 minutes.
      extraConfig = ''
        allow-emacs-pinentry
        allow-loopback-pinentry
      '';
      pinentryFlavor = "emacs";  # Pinentry TUI.
    };
  };
  
  programs.ssh.startAgent = true;
  
  programs.bash.shellAliases = {
    emacsclient = ''emacsclient -c -n -a "" -F "((font . \"Iosevka Nerd Font-13\"))"'';
    ssh = "env TERM=xterm-256color ssh";
  };
}
