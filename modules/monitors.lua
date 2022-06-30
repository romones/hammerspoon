local hotkey = require 'hs.hotkey'
local window = require 'hs.window'
local geometry = require 'hs.geometry'
local mouse = require 'hs.mouse'

local position = import('utils/position')
local monitors = import('utils/monitors')

local function init_module()
    local mash = config:get('binds.mash', { "cmd", "ctrl" })

    for id, monitor in pairs(monitors.configured_monitors) do

        hotkey.bind({ "cmd", "ctrl" }, "PAD" .. id, function()
            local midpoint = geometry.rectMidPoint(monitor.dimensions)
            mouse.set(midpoint)
        end)

        hotkey.bind({ "cmd", "ctrl", "alt" }, "PAD" .. id, function()
            local win = window.focusedWindow()
        if win ~= nil then
                win:setFrame(position.full(monitor.dimensions))
            end
        end)

        hotkey.bind({ "ctrl", "alt" }, "PAD" .. id, function()
            local win = window.focusedWindow()
            if win ~= nil then
                win:setFrame(position.left(monitor.dimensions))
            end
        end)

        hotkey.bind({ "cmd", "alt" }, "PAD" .. id, function()
            local win = window.focusedWindow()
            if win ~= nil then
                win:setFrame(position.right(monitor.dimensions))
            end
        end)
        hotkey.bind({ "shift", "ctrl", "alt" }, "PAD" .. id, function()
            local win = window.focusedWindow()
            if win ~= nil then
                win:setFrame(monitor.dimensions:relative_window_position(win))
            end
        end)
    end
  
  
    hotkey.bind(mash, '1', function() MoveWindowToSpace(1) end)

    hotkey.bind(mash, 'TAB', function()
        local screen = hs.mouse.getCurrentScreen()
        local nextScreen = screen:next()
        local rect = nextScreen:fullFrame()
        local center = hs.geometry.rectMidPoint(rect)
        -- hs.mouse.setRelativePosition(center, nextScreen)
        hs.mouse.setAbsolutePosition(center)
    end)

    hotkey.bind(mash, '=', function () 
        window.focusedWindow():moveOneScreenEast(
            {noResize=false, ensureInScreenBounds=true})
    end)

    hotkey.bind(mash, '/', function () 
        window.focusedWindow():moveOneScreenWest(
            {noResize=false, ensureInScreenBounds=true})
    end)

    -- hotkey.bind(mash, '', hs.window.focusedWindow():moveOneScreenNorth())
    -- hotkey.bind(mash, '', hs.window.focusedWindow():moveOneScreenSouth())
   
end

return {
    init = init_module
}
