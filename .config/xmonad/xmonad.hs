import XMonad

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP

import XMonad.Util.EZConfig
import XMonad.Util.Loggers
import XMonad.Util.Ungrab

import XMonad.Layout.Magnifier
import XMonad.Layout.ThreeColumns

import XMonad.Hooks.EwmhDesktops
import XMonad.Util.SpawnOnce

 -- ColorScheme module (SET ONLY ONE!)
      -- Possible choice are:
      -- DoomOne
      -- Dracula
      -- GruvboxDark
      -- MonokaiPro
      -- Nord
      -- OceanicNext
      -- Palenight
      -- SolarizedDark
      -- SolarizedLight
      -- TomorrowNight
import Colors.DoomOne

myFont :: String
myFont = "xft:SauceCodePro Nerd Font Mono:regular:size=9:antialias=true:hinting=true"

myModMask :: KeyMask
myModMask = mod4Mask        -- Sets modkey to super/windows key

myTerminal :: String
myTerminal = "kitty"    -- Sets default terminal

myBrowser :: String
myBrowser = "firefox"  -- Sets qutebrowser as browser

myLauncher :: String
myLauncher = "~/.config/rofi/launchers/misc/launcher.sh"  -- Sets custom rofi as laucher

--myEmacs :: String
--myEmacs :: String
--myEmacs = "emacsclient -c -a 'emacs' "  -- Makes emacs keybindings easier to type

--myEditor :: String
--myEditor = "emacsclient -c -a 'emacs' "  -- Sets emacs as editor
-- myEditor = myTerminal ++ " -e vim "    -- Sets vim as editor

myBorderWidth :: Dimension
myBorderWidth = 2           -- Sets border width for windows

myNormColor :: String       -- Border color of normal windows
myNormColor   = colorBack   -- This variable is imported from Colors.THEME

myFocusColor :: String      -- Border color of focused windows
myFocusColor  = color15     -- This variable is imported from Colors.THEME

mySoundPlayer :: String
mySoundPlayer = "ffplay -nodisp -autoexit " -- The program that will play system sounds

--windowCount :: X (Maybe String)
--windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset


  -- START_KEYS
myKeys :: [(String, X ())]
myKeys =
    -- KB_GROUP Xmonad
--        [ ("M-C-r", spawn "xmonad --recompile")       -- Recompiles xmonad
--        , ("M-S-r", spawn "xmonad --restart")         -- Restarts xmonad
--        , ("M-S-q", sequence_ [spawn (mySoundPlayer ++ shutdownSound)
--                              , io exitSuccess]) -- Quits xmonad

    -- KB_GROUP Get Help
 --       , ("M-S-/", spawn "~/.xmonad/xmonad_keys.sh") -- Get list of keybindings

        [ ("M-S-z",           spawn   "xscreensaver-command -lock"               )
        , ("M-<Return>",      spawn   myTerminal                                 )
        , ("M-d",             spawn   myLauncher                                 )
        , ("M-C-s",           unGrab  *> spawn "scrot -s"                        )
        , ("M-f"  ,           spawn   myBrowser                                  )
        ]


myStartupHook = do
  spawnOnce "feh --bg-scale ~/.config/wallpapers/cthulhu_draw.jpg"
  spawnOnce "picom"
  setWMName "LG3D"

myManageHook :: ManageHook
myManageHook = composeAll
    [ className =? "Gimp" --> doFloat
    , isDialog            --> doFloat
    ]

myLayout = tiled ||| Mirror tiled ||| Full ||| threeCol
  where
    threeCol = magnifiercz' 1.3 $ ThreeColMid nmaster delta ratio
    tiled    = Tall nmaster delta ratio
    nmaster  = 1      -- Default number of windows in the master pane
    ratio    = 1/2    -- Default proportion of screen occupied by master pane
    delta    = 3/100  -- Percent of screen to increment by when resizing panes



-- myWorkspaces = [" 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 ", " 9 "]
myWorkspaces = [" dev ", " www ", " sys ", " doc ", " vbox ", " chat ", " mus ", " vid ", " gfx "]

myWorkspaceIndices = M.fromList $ zipWith (,) myWorkspaces [1..] -- (,) == \x y -> (x,y)

clickable ws = "<action=xdotool key super+"++show i++">"++ws++"</action>"
    where i = fromJust $ M.lookup ws myWorkspaceIndices


myXmobarPP :: PP
myXmobarPP = def
    { ppSep             = magenta " • "
    , ppTitleSanitize   = xmobarStrip
    , ppCurrent         = wrap " " "" . xmobarBorder "Top" "#8be9fd" 2
    , ppHidden          = white . wrap " " ""
    , ppHiddenNoWindows = lowWhite . wrap " " ""
    , ppUrgent          = red . wrap (yellow "!") (yellow "!")
    , ppOrder           = \[ws, l, _, wins] -> [ws, l, wins]
    , ppExtras          = [logTitles formatFocused formatUnfocused]
    }
  where
    formatFocused   = wrap (white    "[") (white    "]") . magenta . ppWindow
    formatUnfocused = wrap (lowWhite "[") (lowWhite "]") . blue    . ppWindow

    -- | Windows should have *some* title, which should not not exceed a
    -- sane length.
    ppWindow :: String -> String
    ppWindow = xmobarRaw . (\w -> if null w then "untitled" else w) . shorten 30

    blue, lowWhite, magenta, red, white, yellow :: String -> String
    magenta  = xmobarColor "#ff79c6" ""
    blue     = xmobarColor "#bd93f9" ""
    white    = xmobarColor "#f8f8f2" ""
    yellow   = xmobarColor "#f1fa8c" ""
    red      = xmobarColor "#ff5555" ""
    lowWhite = xmobarColor "#bbbbbb" ""


main :: IO ()
main = xmonad
     . ewmhFullscreen
     . ewmh
     . withEasySB (statusBarProp "xmobar" (pure myXmobarPP)) defToggleStrutsKey
     $ myConfig

myConfig = def
    { modMask            = myModMask         -- Rebind Mod to the Super key
    , terminal           = myTerminal
    , borderWidth        = myBorderWidth
    , workspaces         = myWorkspaces
    , normalBorderColor  = myNormColor
    , layoutHook         = myLayout          -- Use custom layouts
    , startupHook        = myStartupHook     -- Use custom layouts
    , manageHook         = myManageHook      -- Match on certain windows
    , focusedBorderColor = myFocusColor
    }
  `additionalKeysP` myKeys
