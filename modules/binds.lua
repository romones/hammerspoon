local application = require 'hs.application'
local hotkey = require 'hs.hotkey'

local function module_init()
    local mash = config:get('binds.mash', { "cmd", "ctrl" })

    hotkey.bind(mash, "H", function()
        local chat = application.find("Chat")
        if chat ~= nil then
            chat:activate(true)
        end
    end)
end

return {
    init = module_init
}
