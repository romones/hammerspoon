local window = require 'hs.window'

local function toggle()
    local win = window.focusedWindow()
    if win ~= nil then
        win:setFullScreen(not win:isFullScreen())
    end
end

return {
    toggle = toggle,
}
