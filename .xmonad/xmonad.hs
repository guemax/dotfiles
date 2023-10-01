{- MIT License

Copyright (c) 2023 guemax

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
-}

import XMonad

-- Util.
import XMonad.Util.ClickableWorkspaces
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.Loggers
import XMonad.Util.SpawnOnce

-- Layout.
import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing

-- Hooks.
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.SetWMName
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP

----------------------------------------------------------------------
--                                                                  --
--                      --- Miscellaneous ---                       --
--                                                                  --
----------------------------------------------------------------------

myModMask = mod4Mask -- Use Super instead of Alt.
myTerminal = "alacritty"

myWorkspaces = [ "1: www"
               , "2: emacs"
               , "3: term"
               , "4: docs"
               , "5: man"
               , "6: pass"
               , "7: vid"
               , "8: mus"
               , "9: else"
               ]


----------------------------------------------------------------------
--                                                                  --
--                         --- Borders ---                          --
--                                                                  --
----------------------------------------------------------------------

myBorderWidth = 5
myNormalBorderColor = "#95a99f"
myFocusedBorderColor = "#ffdd33"


----------------------------------------------------------------------
--                                                                  --
--                          --- Layout ---                          --
--                                                                  --
----------------------------------------------------------------------

myLayoutHook = avoidStruts
               $ spacingWithEdge 10
               $ layoutTall
               ||| layoutMirror
               ||| layoutFull
  where
    layoutTall = Tall 1 (3/100) (1/2)
    layoutMirror = Mirror (Tall 1 (3/100) (3/5))
    layoutFull = Full


----------------------------------------------------------------------
--                                                                  --
--                       --- Keybindings ---                        --
--                                                                  --
----------------------------------------------------------------------

myAdditionalKeysP =
  [ -- Miscellaneous
    ("M-q", spawn "pkill xmobar; xmonad --restart")
  , ("M-f", spawn "firefox")
  , ("M-w", spawn "rofi -show window")
  , ("M-p", spawn "rofi -show drun")
  , ("M-l", spawn "rofi -show run")
  , ("M-e", spawn "emacs")
    -- Audio
  , ("<XF86AudioRaiseVolume>",  spawn "amixer set Master 5%+")
  , ("<XF86AudioLowerVolume>",  spawn "amixer set Master 5%-")
  , ("<XF86AudioMute>",         spawn "amixer set Master toggle")
    -- Monitor Brightness
  , ("<XF86MonBrightnessUp>",   spawn "brightnessctl set +10%")
  , ("<XF86MonBrightnessDown>", spawn "brightnessctl set 10%-")
  ]


----------------------------------------------------------------------
--                                                                  --
--                       --- Startup Hook ---                       --
--                                                                  --
----------------------------------------------------------------------

myStartupHook :: X ()
myStartupHook = do
  spawnOnOnce "1: www"   "firefox"
  spawnOnOnce "2: emacs" "emacs"
  spawnOnOnce "3: term"  "alacritty"
  spawnOnOnce "6: pass"  "keepassxc"
  setWMName "LG3D"
  spawnOnce "feh --bg-scale ~/.dotfiles/wallpapers/gruber-darker-theme-brown-green.png"


----------------------------------------------------------------------
--                                                                  --
--                      --- Main Function ---                       --
--                                                                  --
----------------------------------------------------------------------

main = xmonad
       . ewmhFullscreen
       . ewmh
       . withEasySB (statusBarProp "xmobar" (clickablePP xmobarPP)) defToggleStrutsKey
       $ docks
       $ def
       { modMask = myModMask
       , terminal = myTerminal
       , workspaces = myWorkspaces
       , borderWidth = myBorderWidth
       , normalBorderColor  = myNormalBorderColor
       , focusedBorderColor = myFocusedBorderColor
       , layoutHook = myLayoutHook
       , manageHook = manageSpawn <+> manageHook def
       , startupHook = myStartupHook
       }
       `additionalKeysP` myAdditionalKeysP
