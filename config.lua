local config = {}

config.modules = {
    "api"
    ,"arrangement"
    ,'auto_reload'
    ,"monitors"
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
    {
        name = "Diagnose",
        alert = true,
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

return config
