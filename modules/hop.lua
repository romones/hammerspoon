local window = require 'hs.window'

local function focus(direction_string)
    local direction = direction_string:sub(1, 1):upper() .. direction_string:sub(2)
    local fn = window['focusWindow' .. direction]
    if fn == nil then
        error("The direction must be one of north, south, east, or west. Not " .. tostring(direction_string))
    end

    return function()
        local win = window.focusedWindow()
        if win == nil then
            return
        end
        fn(win)
    end
end

return {
    focus = focus,
}
