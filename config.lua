local config = {}

config.modules = {
    "api"
    ,"arrangement"
    ,'auto_reload'
    ,"monitors"
    ,"repl"
    ,"reload"
    ,"arrows"
    ,"lock"
    ,"fullscreen"
    ,"app_selector"
    ,"binds"
    ,"window_watcher"
    ,"keypad"
    ,"menu"
}

-- Maps monitor id -> screen index.
config.monitors = {
    autodiscover = true,
    rows = 1
}

-- Window arrangements.
config.arrangements = {
    fuzzy_search = {
        mash = {"cmd", "ctrl", "alt"},
        key = "Z"
    },
    {
        name = "Diagnose",
        alert = true,
        mash = { "cmd", "ctrl", "alt" },
        key = "Q",
        arrangement = {
            {
                title = "^Diagnose",
                monitor = 1,
                position = "right_two_thirds",
            },
            {
                title = "^Serial",
                monitor = 1,
                position = "left_third",
            }
        }
    },
    {
        name = "zen",
        alert = true,
        mash = { "cmd", "ctrl", "alt" },
        key = "A",
        arrangement = {
            {
                app_title = "^Mail",
                monitor = 1,
                position = "full_screen",
            },
            {
                app_title = "^Slack",
                monitor = 4,
                position = "left"
            },
            {
                app_title = "^Messages",
                monitor = 4,
                position = function(d)
                    return d:translate_from('bottom_right', {
                        y = 42,
                        h = -40
                    })
                end
            },
            {
                app_title = "^ChronoMate",
                monitor = 4,
                position = function(d)
                    return d:translate_from('top_right', {
                        h = 42
                    })
                end
            },
            {
                app_title = "^Spotify",
                monitor = 6,
                position = "full_screen",
            }
        }
    }
}

config.binds = {
    mash = { "cmd", "ctrl", "alt", "shift" },
}

return config
