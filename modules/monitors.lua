local window = require 'hs.window'
local geometry = require 'hs.geometry'
local mouse = require 'hs.mouse'

local position = import('utils/position')
local monitors_util = import('utils/monitors')

local function focus_mouse(monitor)
    return function()
        local midpoint = geometry.rectMidPoint(monitor.dimensions)
        mouse.absolutePosition(midpoint)
    end
end

local function snap_window(monitor, position_string)
    local position_fn = position[position_string]
    if position_fn == nil then
        error("monitors: " .. tostring(position_string) .. " is not a valid position")
    end

    return function()
        local win = window.focusedWindow()
        if win ~= nil then
            win:setFrame(position_fn(monitor.dimensions))
        end
    end
end

local function move_window_relative(monitor)
    return function()
        local win = window.focusedWindow()
        if win ~= nil then
            win:setFrame(monitor.dimensions:relative_window_position(win))
        end
    end
end

local function focus_next_screen()
    local screen = mouse.getCurrentScreen()
    if screen == nil then return end
    local nextScreen = screen:next()
    if nextScreen == nil then return end
    local center = geometry.rectMidPoint(nextScreen:fullFrame())
    mouse.absolutePosition(center)
end

local function move_window_east()
    local win = window.focusedWindow()
    if win ~= nil then
        win:moveOneScreenEast(false, true)
    end
end

local function move_window_west()
    local win = window.focusedWindow()
    if win ~= nil then
        win:moveOneScreenWest(false, true)
    end
end

return {
    configured_monitors = monitors_util.configured_monitors,
    focus_mouse = focus_mouse,
    snap_window = snap_window,
    move_window_relative = move_window_relative,
    focus_next_screen = focus_next_screen,
    move_window_east = move_window_east,
    move_window_west = move_window_west,
}
