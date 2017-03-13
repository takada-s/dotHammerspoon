local function module_init()
    local kana = 0x68
    local eisu = 0x66
    local activateKeyPressed = {}
    local handlerCalled = {}

    activateKeyPressed[kana] = false
    activateKeyPressed[eisu] = false
    handlerCalled[kana] = false
    handlerCalled[eisu] = false

    -- generate handler to activating application
    local function activateApp(appName)
        if (appName == 'ignore') then return function() end end
        return function(e)
            local app = hs.application.get(appName)
            if app then
                -- app found. just activate
                app:activate()
            else
                hs.application.open(appName)
            end
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

    -- convert dic to actual handler
    local function resolveMappingFn(info)
        if info['activateApp'] then
            return activateApp(info['activateApp'])
        elseif info['replaceToKey'] then
            return replaceToKey(info['replaceToKey'])
        elseif info['replaceToSystemKey'] then
            return replaceToSystemKey(info['replaceToSystemKey'])
        else
            return function() hs.alert("not defined: " .. info) end
        end
    end

    local appMapping = { kana = {}, eisu = {} }
    for actkey, map in pairs(EIKANA_MAPPING) do
        for key, info in pairs(map) do
            local keycode = hs.keycodes.map[key]
            local func = resolveMappingFn(info)
            appMapping[actkey][keycode] = func
        end
    end

    local function handlerFor(typeStr, do_repeat)
        local actKeyForType = { kana = kana, eisu = eisu }
        local activateKey = actKeyForType[typeStr]

        return function(e)
            local keyCode = e:getKeyCode()
            local evType = e:getType()
            local handler = appMapping[typeStr][keyCode]

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

            -- combo event: act-key down + other key down: call handler
            if activateKeyPressed[activateKey] then
                -- no handler defined
                if not handler then return end

                if not do_repeat then
                    -- handler has been called: just ignore keydowns
                    if handlerCalled[activateKey] then return true, {} end
                end

                handlerCalled[activateKey] = true
                local ret = handler(e)

                -- cease the combo key
                return true, ret
            end
        end
    end

    -- don't make this local, because GC kills them...
    --noinspection GlobalCreationOutsideO
    eisu_event = hs.eventtap.new({ hs.eventtap.event.types.keyDown, hs.eventtap.event.types.keyUp },
        handlerFor('eisu', false))
    eisu_event:start()
    --noinspection GlobalCreationOutsideO
    kana_event = hs.eventtap.new({ hs.eventtap.event.types.keyDown, hs.eventtap.event.types.keyUp },
        handlerFor('kana', true))
    kana_event:start()
end

module_init()
print("eisu_kana_launcher loaded.")
