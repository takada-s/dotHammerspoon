local function module_init()
    -- window resizing config
    hs.grid.setGrid('2x2')
    hs.window.animationDuration = 0

    local function setFocusedWindowAs(cell)
        local win = hs.window.focusedWindow()
        hs.grid.set(win, cell)
    end

    local function resizeToLT() setFocusedWindowAs('0,0 1x1') end -- left top
    local function resizeToLB() setFocusedWindowAs('0,1 1x1') end -- left bottom
    local function resizeToRT() setFocusedWindowAs('1,0 1x1') end -- right top
    local function resizeToRB() setFocusedWindowAs('1,1 1x1') end -- right bottom
    local function resizeToLH() setFocusedWindowAs('0,0 1x2') end -- left half
    local function resizeToRH() setFocusedWindowAs('1,0 1x2') end -- right half
    local function maximize() hs.window.focusedWindow():maximize() end -- maxmize
    local function minimize() hs.window.focusedWindow():minimize() end -- minimize

    local mods = { 'cmd', 'alt' }
    -- ins,delete,home,end,pgup/dn
    hs.hotkey.bind(mods, 'help', nil, resizeToLT, nil, nil) -- ins
    hs.hotkey.bind(mods, 'forwarddelete', nil, resizeToLB, nil, nil) -- del
    hs.hotkey.bind(mods, 'home', nil, maximize, nil, nil) -- home
    hs.hotkey.bind(mods, 'end', nil, minimize, nil, nil) -- end
    hs.hotkey.bind(mods, 'pageup', nil, resizeToRT, nil, nil) -- page up
    hs.hotkey.bind(mods, 'pagedown', nil, resizeToRB, nil, nil) -- page down
    -- cursor
    hs.hotkey.bind(mods, 'up', nil, maximize, nil, nil)
    hs.hotkey.bind(mods, 'down', nil, minimize, nil, nil)
    hs.hotkey.bind(mods, 'left', nil, resizeToLH, nil, nil)
    hs.hotkey.bind(mods, 'right', nil, resizeToRH, nil, nil)
end

module_init()
print("win_resize loaded.")
