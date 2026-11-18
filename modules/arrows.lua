local window = require 'hs.window'

local position = import('utils/position')
local monitors = import('utils/monitors')

local function snap(position_string)
    local position_fn = position[position_string]
    if position_fn == nil then
        error("arrows: " .. tostring(position_string) .. " is not a valid position")
    end

    return function()
        local win = window.focusedWindow()
        if win == nil then
            return
        end

        local screen = win:screen()
        local dimensions = monitors.get_screen_dimensions(screen)
        local newframe = position_fn(dimensions)

        win:setFrame(newframe)
    end
end

return {
    snap = snap,
}
