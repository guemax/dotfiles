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
import XMonad.ManageHook

-- Util.
import XMonad.Util.ClickableWorkspaces
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.Loggers
import XMonad.Util.SpawnOnce

-- Layout.
import XMonad.Layout.Grid
import XMonad.Layout.NoBorders
import XMonad.Layout.Spacing

-- Hooks.
import XMonad.Hooks.DynamicIcons
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

myWorkspaces = [ "I"
               , "II"
               , "III"
               , "IV"
               , "V"
               , "VI"
               , "VII"
               , "VIII"
               , "IX"
               ]


----------------------------------------------------------------------
--                                                                  --
--                         --- Borders ---                          --
--                                                                  --
----------------------------------------------------------------------

myBorderWidth = 1
myNormalBorderColor = "#535353"
myFocusedBorderColor = "#ffffff"


----------------------------------------------------------------------
--                                                                  --
--                          --- Layout ---                          --
--                                                                  --
----------------------------------------------------------------------

myLayoutHook = avoidStruts
               $ smartSpacingWithEdge 10
               $ smartBorders
               $ layoutTall
               ||| layoutGrid
               ||| layoutMirror
               ||| layoutFull
  where
    layoutTall = Tall 1 (3/100) (1/2)
    layoutGrid = Grid
    layoutMirror = Mirror (Tall 1 (3/100) (3/5))
    layoutFull = Full


----------------------------------------------------------------------
--                                                                  --
--                       --- Keybindings ---                        --
--                                                                  --
----------------------------------------------------------------------

myAdditionalKeysP =
  [ -- Miscellaneous.
    ("M-q", spawn "pkill polybar; xmonad --restart")
  , ("M-f", spawn "firefox")
  , ("M-e", spawn "emacs")
  -- Rofi.
  , ("M-w", spawn "rofi -show window")
  , ("M-p", spawn "rofi -show drun")
  , ("M-o", spawn "rofi -show run")
  , ("M-i", spawn "rofi -show calc -modi emoji calc")
  , ("M-s", spawn "rofi -show power-menu -modi power-menu:rofi-power-menu")
    -- Audio.
  , ("<XF86AudioRaiseVolume>",  spawn "amixer set Master 5%+")
  , ("<XF86AudioLowerVolume>",  spawn "amixer set Master 5%-")
  , ("<XF86AudioMute>",         spawn "amixer set Master toggle")
    -- Monitor Brightness.
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
  spawnOnOnce "www"   "firefox"
  spawnOnOnce "emacs" "emacs"
  spawnOnOnce "term"  "alacritty"
  spawnOnOnce "pass"  "keepassxc"
  setWMName "LG3D"


----------------------------------------------------------------------
--                                                                  --
--                       --- Manage Hook ---                        --
--                                                                  --
----------------------------------------------------------------------

myManageHook :: ManageHook
myManageHook = composeAll
  [ className =? "gimp-2.10" --> doFloat
  , className =? "Inkscape"  --> doFloat
  , className =? "Anki"      --> doFloat
  ]


----------------------------------------------------------------------
--                                                                  --
--                      --- Main Function ---                       --
--                                                                  --
----------------------------------------------------------------------

main = xmonad
       . ewmhFullscreen
       . ewmh
       . withEasySB (statusBarProp "polybar -c ~/.dotfiles/.config/polybar/config.ini" (pure xmobarPP)) defToggleStrutsKey
       $ docks
       $ def
       { modMask = myModMask
       , terminal = myTerminal
       , workspaces = myWorkspaces
       , borderWidth = myBorderWidth
       , normalBorderColor  = myNormalBorderColor
       , focusedBorderColor = myFocusedBorderColor
       , layoutHook = myLayoutHook
       , manageHook = manageSpawn <+> myManageHook
       , startupHook = myStartupHook
       }
       `additionalKeysP` myAdditionalKeysP
