EIKANA_MAPPING = {
    eisu = {
        -- single letter key: launcher
        a = { activateApp = 'Activity Monitor' },
        b = { activateApp = 'Mail' },
        c = { activateApp = 'Microsoft Teams' },
        e = { activateApp = 'Emacs' },
        f = { activateApp = 'Firefox' },
        g = { activateApp = 'Google Chrome' },
        h = { activateApp = 'Safari' },
        i = { activateApp = 'iTunes' },
        n = { activateApp = 'Thunderbird' },
        q = { activateApp = 'OmniFocus' },
        r = { activateApp = 'RubyMine' },
        s = { activateApp = 'Calendar' },
        t = { activateApp = 'iTerm' },
        v = { activateApp = 'Messages' },
        w = { activateApp = 'Wunderlist' },
        -- PgUp/Dn: volume control
        pageup = { replaceToSystemKey = 'SOUND_UP' },
        pagedown = { replaceToSystemKey = 'SOUND_DOWN' },
        -- PrintSc/ScLock/Pause (f13,f14,f15): audio control
        f13 = { replaceToSystemKey = 'PREVIOUS' },
        f14 = { replaceToSystemKey = 'PLAY' },
        f15 = { replaceToSystemKey = 'NEXT' },
    },
    kana = {
        -- hjkl: move cursor
        h = { replaceToKey = 'left' },
        j = { replaceToKey = 'down' },
        k = { replaceToKey = 'up' },
        l = { replaceToKey = 'right' },
        -- a,e: home / end
        a = { replaceToKey = 'home' },
        e = { replaceToKey = 'end' },
    }
}

skip_eisu_kana_launcher = false
skip_browser_hack = false
skip_copipe = false
skip_win_resize = false
skip_rubymine_hack = false

eisu_kana_launcher_exclude_names = {
    "Microsoft Remote Desktop", "Microsoft Remote Desktop Beta"
}
