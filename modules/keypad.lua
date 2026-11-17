local application = require 'hs.application'
local hotkey = require 'hs.hotkey'
local urlevent = require 'hs.urlevent'

local api = import('modules/api')

local function module_init()
    local mash = config:get("keypad.mash", { "cmd", "ctrl", "alt", "shift" })
    -- Keep machine/work-specific URLs in untracked config.local.lua (see config.local.example.lua).
    local keys = config:get("keypad.keys", {})
    local ignore_apps = config:get("keypad.ignore_apps", { "Wow" })

    for key, target in pairs(keys) do
        hotkey.bind(mash, key, function()
            for _, app_name in ipairs(ignore_apps) do
                if application.find(app_name, true, true) ~= nil then
                    return
                end
            end

            if type(target) == "table" then
                api.handle(target)
            elseif type(target) == "string" then
                urlevent.openURL(target)
            end
        end)
    end
end

return {
    init = module_init
}
