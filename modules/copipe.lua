local function module_init()
    local excludeNames = {
        "iTerm2", "RubyMine", "Emacs", "VMware Fusion",
        "Microsoft Remote Desktop", "Microsoft Remote Desktop Beta"
    }

    local binds = {}

    local function copipeHandler(keyStr)
        return function()
            local mods = { 'cmd' }
            hs.eventtap.event.newKeyEvent(mods, keyStr, true):post()
            hs.eventtap.event.newKeyEvent(mods, keyStr, false):post()
        end
    end

    local function switchCopipe(isEnable)
        hs.fnutils.each(binds, function(hkey)
            if isEnable then hkey:enable() else hkey:disable() end
        end)
    end

    local function handleGlobalAppEvent(name, event, _app)
        local activateCopipe = not hs.fnutils.contains(excludeNames, name)

        if event == hs.application.watcher.activated then
            switchCopipe(activateCopipe)
        end
    end

    --noinspection GlobalCreationOutsideO
    copipe_event = hs.application.watcher.new(handleGlobalAppEvent)
    copipe_event:start()

    binds['cut'] = hs.hotkey.bind({ 'ctrl' }, 'x', nil, copipeHandler('x'), nil, nil)
    binds['copy'] = hs.hotkey.bind({ 'ctrl' }, 'c', nil, copipeHandler('c'), nil, nil)
    binds['paste'] = hs.hotkey.bind({ 'ctrl' }, 'v', nil, copipeHandler('v'), nil, nil)
end

module_init()
print("copipe loaded.")
