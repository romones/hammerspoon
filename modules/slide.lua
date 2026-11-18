local window = require 'hs.window'

local nudge_util = import('utils/nudge')

local function nudge(direction_string)
    local nudge_fn = nudge_util[direction_string]
    if nudge_fn == nil then
        error("slide: " .. tostring(direction_string) .. " is not a valid direction")
    end

    return function()
        local win = window.focusedWindow()
        if win == nil then
            return
        end

        local dimensions = win:frame()
        local newframe = nudge_fn(dimensions)

        win:setFrame(newframe)
    end
end

return {
    nudge = nudge,
}
