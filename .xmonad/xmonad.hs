import XMonad
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Hooks.EwmhDesktops

import XMonad.Layout.Spacing
import XMonad.Layout.NoBorders

myConfig = def
  { modMask = myModMask
  , terminal = myTerminal
  , borderWidth = myBorderWidth
  , normalBorderColor  = myNormalBorderColor
  , focusedBorderColor = myFocusedBorderColor
  , layoutHook = myLayoutHook
  }
  `additionalKeysP`
  -- Miscellaneous
  [ ("M-q", restart "xmonad" True)
  , ("M-f", spawn "firefox")
  -- Audio
  , ("<XF86AudioRaiseVolume>",  spawn "amixer set Master 5%+")
  , ("<XF86AudioLowerVolume>",  spawn "amixer set Master 5%-")
  , ("<XF86AudioMute>",         spawn "amixer set Master toggle")
  -- Monitor Brightness
  , ("<XF86MonBrightnessUp>",   spawn "brightnessctl set +10%")
  , ("<XF86MonBrightnessDown>", spawn "brightnessctl set 10%-")
  ]

myModMask = mod4Mask -- Use Super instead of Alt
myTerminal = "alacritty"

myBorderWidth = 5
myNormalBorderColor = "#303540"
myFocusedBorderColor = "#565f73"

-- myLayoutHook = spacingRaw False (Border 10 0 10 0) True (Border 0 10 0 10) True $ Tall 1 (3/100) (1/2) ||| Full
myLayoutHook = smartSpacingWithEdge 10 $ smartBorders $ Tall 1 (3/100) (1/2) ||| Full

main = xmonad $ ewmhFullscreen $ ewmh $ myConfig
