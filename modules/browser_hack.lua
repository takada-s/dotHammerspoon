local function module_init()
    local browserNames = { "Google Chrome", "Firefox", "Safari" }

    local binds = {}

    local function replaceHandler(keyStr)
        return function()
            local mods = { 'cmd' }
            hs.eventtap.event.newKeyEvent(mods, keyStr, true):post()
            hs.eventtap.event.newKeyEvent(mods, keyStr, false):post()
        end
    end

    local function switchHack(isEnable)
        hs.fnutils.each(binds, function(hkey)
            if isEnable then hkey:enable() else hkey:disable() end
        end)
    end

    local function handleGlobalAppEvent(name, event, _app)
        local activateHack = hs.fnutils.contains(browserNames, name)

        if event == hs.application.watcher.activated then
            switchHack(activateHack)
        end
    end

    hs.application.watcher.new(handleGlobalAppEvent):start()

    binds['tab'] = hs.hotkey.bind({ 'ctrl' }, 't', nil, replaceHandler('t'), nil, nil)
    binds['close'] = hs.hotkey.bind({ 'ctrl' }, 'w', nil, replaceHandler('w'), nil, nil)
end

module_init()
print("browser_hack loaded.")
