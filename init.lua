-- eisu/kana launcher
dofile 'modules/eisu_kana_launcher.lua'
-- browser keybind hack
dofile 'modules/browser_hack.lua'
-- copy and paste key binding
dofile 'modules/copipe.lua'
-- window resizing
dofile 'modules/win_resize.lua'

-- lock key (screen saver)
hs.hotkey.bind({ 'cmd', 'alt' }, 'L', function()
    -- we need short sleep to prevent instant-exit of screensaver
    hs.timer.doAfter(0.5, hs.caffeinate.startScreensaver)
end)

-- config reload
hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "R", function() hs.reload() end)

hs.alert.show("Config loaded")

