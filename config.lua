-- for eisu_kana_launcher
BROWSER1 = 'Firefox'
BROWSER2 = 'Google Chrome'
BROWSER3 = 'Safari'

EIKANA_MAPPING = {
    kana = {
        -- single letter key: launcher
        a = { activateApp = 'Activity Monitor' },
        b = { activateApp = 'Mail' },
        e = { activateApp = 'Emacs' },
        f = { activateApp = BROWSER1 },
        g = { activateApp = BROWSER2 },
        h = { activateApp = BROWSER3 },
        i = { activateApp = 'iTunes' },
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
    eisu = {
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