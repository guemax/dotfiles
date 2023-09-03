import XMonad
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Hooks.EwmhDesktops

import XMonad.Layout.Spacing
import XMonad.Layout.NoBorders


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
myNormalBorderColor = "#52494e"
myFocusedBorderColor = "#c73c3f"


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
    ("M-q", restart "xmonad" True)
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
--                      --- Main Function ---                       --
--                                                                  --
----------------------------------------------------------------------

main = xmonad
       . ewmhFullscreen
       . ewmh
       $ def
       { modMask = myModMask
       , terminal = myTerminal
       , borderWidth = myBorderWidth
       , normalBorderColor  = myNormalBorderColor
       , focusedBorderColor = myFocusedBorderColor
       , layoutHook = myLayoutHook
       }
       `additionalKeysP` myAdditionalKeysP
