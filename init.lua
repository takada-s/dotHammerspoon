-- load configs to global vars
dofile 'config.lua'

function config_override() dofile 'config.local.lua' end

pcall(config_override)

-- eisu/kana launcher
if (not skip_eisu_kana_launcher) then
    dofile 'modules/eisu_kana_launcher.lua'
end
-- browser keybind hack
if (not skip_browser_hack) then
    dofile 'modules/browser_hack.lua'
end
-- copy and paste key binding
if (not skip_copipe) then
    dofile 'modules/copipe.lua'
end
-- window resizing
if (not skip_win_resize) then
    dofile 'modules/win_resize.lua'
end
-- rubymine hack
if (not skip_rubymine_hack) then
    dofile 'modules/rubymine_hack.lua'
end

-- lock key (screen saver)
hs.hotkey.bind({ 'cmd', 'alt' }, 'L', function()
    -- we need short sleep to prevent instant-exit of screensaver
    hs.timer.doAfter(0.5, hs.caffeinate.startScreensaver)
end)

-- config reload
hs.hotkey.bind({ "cmd", "alt", "ctrl" }, "R", function() hs.reload() end)

hs.alert.show("Config loaded")

