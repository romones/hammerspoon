local hotkey = require 'hs.hotkey'
local window = require 'hs.window'
local mouse = require 'hs.mouse'
local geometry = require 'hs.geometry'
local image = require 'hs.image'

local match_dialogue = import('utils/match_dialogue')

local function module_init()
    local function match_data_source()
        local results = {}

        for _, win in ipairs(window.allWindows()) do
            local title = win:title()
            local app = win:application()

            if title ~= nil and #title > 0 and app ~= nil then
                local app_title = app:title() or ""
                local bundle_id = app:bundleID()
                table.insert(results, {
                    text = title,
                    subText = app_title,
                    image = bundle_id and image.imageFromAppBundle(bundle_id) or nil,
                    window = win,
                })
            end
        end
        return results
    end

    local function match_selected(match)
        if match == nil or match.window == nil then
            return
        end

        match.window:focus()

        if config:get('app_selector.move_mouse', true) then
            local frame = match.window:frame()
            if frame ~= nil then
                local center = geometry.rectMidPoint(frame)
                mouse.absolutePosition(center)
            end
        end
    end

    local matcher = match_dialogue(match_data_source, match_selected, {
        placeholder = "Switch to window...",
    })

    hotkey.bind(
        config:get('app_selector.mash', { "ctrl", "cmd" }),
        config:get('app_selector.key', "tab"),
        function()
            matcher:show()
        end
    )
end

return {
    init = module_init
}
