local function module_init()
    local targetNames = { "RubyMine" }

    local binds = {}

    -- do Shift-Alt-w (save to kill ring)
    local function copyHandler()
        local mods = { 'alt', 'shift' }
        local key = 'w'
        hs.eventtap.event.newKeyEvent(mods, key, true):post()
        hs.eventtap.event.newKeyEvent(mods, key, false):post()
    end

    local function switchHack(isEnable)
        hs.fnutils.each(binds, function(hkey)
            if isEnable then hkey:enable() else hkey:disable() end
        end)
    end

    local function handleGlobalAppEvent(name, event, _app)
        local activateHack = hs.fnutils.contains(targetNames, name)

        if event == hs.application.watcher.activated then
            switchHack(activateHack)
        end
    end

    --noinspection GlobalCreationOutsideO
    rm_event = hs.application.watcher.new(handleGlobalAppEvent)
    rm_event:start()

    binds['copy'] = hs.hotkey.bind({ 'alt' }, 'w', nil, copyHandler, nil, nil)
end

module_init()
print("rubymine_hack loaded.")
