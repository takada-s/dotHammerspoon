local function module_init()
    local kana = 0x66
    local eisu = 0x68
    local activateKeyPressed = {}
    local handlerCalled = {}

    activateKeyPressed[kana] = false
    activateKeyPressed[eisu] = false
    handlerCalled[kana] = false
    handlerCalled[eisu] = false

    -- generate handler to activating application (via osascript)
    local function activateApp(appName)
        return function(e)
            -- hs.alert.show("App launcher: " .. appName)
            local command = 'tell application "' .. appName .. '" to activate'
            hs.osascript.applescript(command)
            return {}
        end
    end

    -- generate handler to map other key
    local function replaceToKey(keyName)
        return function(e)
            local ev = hs.eventtap.event.newKeyEvent({}, hs.keycodes.map[keyName], true)
            ev:setProperty(hs.eventtap.event.properties.keyboardEventAutorepeat,
                e:getProperty(hs.eventtap.event.properties.keyboardEventAutorepeat))

            return { ev }
        end
    end

    -- generate handler to map system key
    local function replaceToSystemKey(sysKeyName)
        return function(e)
            local ev_dn = hs.eventtap.event.newSystemKeyEvent(sysKeyName, true)
            local ev_up = hs.eventtap.event.newSystemKeyEvent(sysKeyName, false)

            return { ev_dn, ev_up }
        end
    end

    local mapping = {
        kana = {
            -- single letter key: launcher
            a = activateApp('Activity Monitor'),
            c = activateApp('Microsoft Teams'),
            e = activateApp('Emacs'),
            f = activateApp(BROWSER1),
            g = activateApp(BROWSER2),
            h = activateApp(BROWSER3),
            i = activateApp('iTunes'),
            q = activateApp('OmniFocus'),
            r = activateApp('RubyMine'),
            s = activateApp('Calendar'),
            t = activateApp('iTerm'),
            w = activateApp('Wunderlist'),
            -- PgUp/Dn: volume control
            pageup = replaceToSystemKey('SOUND_UP'),
            pagedown = replaceToSystemKey('SOUND_DOWN'),
            -- PrintSc/ScLock/Pause (f13,f14,f15): audio control
            f13 = replaceToSystemKey('PREVIOUS'),
            f14 = replaceToSystemKey('PLAY'),
            f15 = replaceToSystemKey('NEXT'),
        },
        eisu = {
            -- hjkl: move cursor
            h = replaceToKey('left'),
            j = replaceToKey('down'),
            k = replaceToKey('up'),
            l = replaceToKey('right'),
            -- a,e: home / end
            a = replaceToKey('home'),
            e = replaceToKey('end'),
        },
    }

    -- convert above human-readable form into keycode style
    local appMapping = { kana = {}, eisu = {} }
    for actkey, map in pairs(mapping) do
        for key, fn in pairs(map) do
            appMapping[actkey][hs.keycodes.map[key]] = fn
        end
    end

    -- Kana+x Handler for Launcher
    --   key repeat: NO
    --   timing:     keyUp
    local function kanaHandler(e)
        local keyCode = e:getKeyCode()
        local evType = e:getType()
        local activateKey = kana
        local handler = appMapping['kana'][keyCode]

        -- print("keyCode:" .. tostring(keyCode) .. ", evtype: " .. evType .. ", actPress: " .. tostring(activateKeyPressed[activateKey]) .. ", called: " .. tostring(handlerCalled[activateKey]))

        -- down event
        if evType == hs.eventtap.event.types.keyDown then
            if (keyCode == activateKey) then
                activateKeyPressed[activateKey] = true
                return true
            end

            return (activateKeyPressed[activateKey] and handler)
        end

        -- up event
        if (keyCode == activateKey) then
            activateKeyPressed[activateKey] = false

            if handlerCalled[activateKey] then
                handlerCalled[activateKey] = false
                return true
            end

            -- activate key pressed one-shot
            local one_shot_act = {
                -- down
                hs.eventtap.event.newKeyEvent({}, activateKey, true),
                -- up
                hs.eventtap.event.newKeyEvent({}, activateKey, false),
            }

            return true, one_shot_act
        end

        -- combo event
        if activateKeyPressed[activateKey] then
            -- up + other key: call handler
            if handler then
                handlerCalled[activateKey] = true
                local ret = handler(e)

                -- cease the combo key
                return true, ret
            end
        end
    end

    -- Eisu+x Handler for Cursor Control
    --   key repeat: YES
    --   timing:     keyDown
    local function eisuHandler(e)
        local keyCode = e:getKeyCode()
        local evType = e:getType()
        local activateKey = eisu
        local handler = appMapping['eisu'][keyCode]

        -- print("keyCode:" .. tostring(keyCode) .. ", evtype: " .. evType .. ", actPress: " .. tostring(activateKeyPressed[activateKey]) .. ", called: " .. tostring(handlerCalled[activateKey]))

        -- up event
        if evType == hs.eventtap.event.types.keyUp then
            if (keyCode == activateKey) then
                activateKeyPressed[activateKey] = false

                if handlerCalled[activateKey] then
                    handlerCalled[activateKey] = false
                    return true
                end

                -- activate key pressed one-shot
                local one_shot_act = {
                    -- down
                    hs.eventtap.event.newKeyEvent({}, activateKey, true),
                    -- up
                    hs.eventtap.event.newKeyEvent({}, activateKey, false),
                }

                return true, one_shot_act
            end

            -- other key's up event
            return false
        end

        -- down event
        if (keyCode == activateKey) then
            activateKeyPressed[activateKey] = true
            return true
        end

        -- combo event
        if activateKeyPressed[activateKey] then
            -- down + other key: call handler
            if handler then
                handlerCalled[activateKey] = true
                local ret = handler(e)

                -- cease the combo key
                return true, ret
            end
        end
    end

    hs.eventtap.new({ hs.eventtap.event.types.keyDown, hs.eventtap.event.types.keyUp }, kanaHandler):start()
    hs.eventtap.new({ hs.eventtap.event.types.keyDown, hs.eventtap.event.types.keyUp }, eisuHandler):start()
end

module_init()
print("eisu_kana_launcher loaded.")
