import XMonad
import XMonad.Util.EZConfig (additionalKeysP)

myConfig = def
  { modMask = mod4Mask -- Use Super instead of Alt
  , terminal = "alacritty"
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

main = getDirectories >>= launch myConfig
