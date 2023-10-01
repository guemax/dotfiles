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
    fadeSteps = [
      0.25
      0.25
    ];
    fadeDelta = 10;
    
    shadow = true;
    shadowOpacity = 0.3;
    shadowOffsets = [
      (-10)
      (-10)
    ];
    shadowExclude = [
      "class_i = 'polybar'"
    ];
    
    settings = {
      blur = {
        method = "dual_kawase";
        strength = 5;
      };
      corner-radius = 12.5;
      round-borders = 3;
      rounded-corners-exclude = [
        "class_i = 'polybar'"
        "class_i = 'emacs'"
        "class_i = 'firefox'"
        "class_i = 'vlc'"
        "class_i = 'keepassxc'"
      ];
    };

    opacityRules = [
      "80:class_i *= 'alacritty' && !focused"
      "80:class_i = 'rofi'"
    ];
  };
}
