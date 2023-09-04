{- MIT License

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
-}

import XMonad
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Hooks.EwmhDesktops

import XMonad.Layout.Spacing
import XMonad.Layout.NoBorders
import XMonad.Hooks.ManageDocks

import XMonad.Util.Loggers

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP

import XMonad.Util.ClickableWorkspaces
import XMonad.Util.WorkspaceCompare


----------------------------------------------------------------------
--                                                                  --
--                      --- Miscellaneous ---                       --
--                                                                  --
----------------------------------------------------------------------

myModMask = mod4Mask -- Use Super instead of Alt.
myTerminal = "alacritty"


----------------------------------------------------------------------
--                                                                  --
--                         --- Borders ---                          --
--                                                                  --
----------------------------------------------------------------------

myBorderWidth = 5
myNormalBorderColor = "#96a6c8"
myFocusedBorderColor = "#ffdd33"


----------------------------------------------------------------------
--                                                                  --
--                          --- Layout ---                          --
--                                                                  --
----------------------------------------------------------------------

myLayoutHook = avoidStruts
               $ smartSpacingWithEdge 10
               $ smartBorders
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
--                          --- Xmobar ---                          --
--                                                                  --
----------------------------------------------------------------------

myXmobarPP :: PP
myXmobarPP = def
    { ppSep             = lowWhite " "
    , ppTitleSanitize   = xmobarStrip
    , ppCurrent         = yellow . wrap " " "" -- . xmobarBorder "Bottom" "#ffdd33" 2
    , ppHidden          = blue . wrap " " ""
    , ppHiddenNoWindows = lowWhite . wrap " " ""
    , ppUrgent          = red . wrap (yellow "!") (yellow "!")
    , ppOrder           = \[ws, _, _, wins] -> [ws, wins]
    , ppExtras          = [logTitles formatFocused formatUnfocused]
    }
  where
    formatFocused   = yellow . wrap " [" "]" . ppWindow
    formatUnfocused = blue   . wrap " [" "]" . ppWindow

    ppWindow :: String -> String
    ppWindow = xmobarRaw . (\w -> if null w then "untitled" else w) . shorten 30

    blue, lowWhite, red, yellow :: String -> String
    blue     = xmobarColor "#96a6c8" ""
    yellow   = xmobarColor "#ffdd33" ""
    red      = xmobarColor "#f43841" ""
    lowWhite = xmobarColor "#52494e" ""

mySort = getSortByXineramaRule


----------------------------------------------------------------------
--                                                                  --
--                      --- Main Function ---                       --
--                                                                  --
----------------------------------------------------------------------

main = xmonad
       . ewmhFullscreen
       . setEwmhWorkspaceSort mySort
       . ewmh
       . withEasySB (statusBarProp "xmobar" (clickablePP myXmobarPP)) defToggleStrutsKey
       $ docks
       $ def
       { modMask = myModMask
       , terminal = myTerminal
       , borderWidth = myBorderWidth
       , normalBorderColor  = myNormalBorderColor
       , focusedBorderColor = myFocusedBorderColor
       , layoutHook = myLayoutHook
       }
       `additionalKeysP` myAdditionalKeysP
