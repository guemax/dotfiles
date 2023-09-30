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

{ pkgs, config, ... }:

{
  services.picom = {
    enable = true;
    backend = "glx";

    fade = true;
    fadeDelta = 1;
    fadeSteps = [
      1
      1
    ];
    
    shadow = true;
    shadowOpacity = 0.5;
    
    settings = {
      blur = {
        method = "dual_kawase";
        strength = 5;
      };
      corner-radius = 12.0;
      round-borders = 3;
      rounded-corners-exclude = [
        "class_i = 'xmobar'"
      ];
    };

    inactiveOpacity = 0.8;
    opacityRules = [
      "100:name *= 'rofi'"
      "100:name *= 'KeePassXC'"
      "100:name *= 'Firefox'"
      "100:name *= 'VLC'"
      "0:_NET_WM_STATE@:32a *= '_NET_WM_STATE_HIDDEN'"
    ];
  };
}
