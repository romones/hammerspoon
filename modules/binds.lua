local application = require 'hs.application'

local hotkey = import('utils/hotkey')
local app_selector = import('modules/app_selector')
local arrangement = import('modules/arrangement')
local arrows = import('modules/arrows')
local fullscreen = import('modules/fullscreen')
local lock = import('modules/lock')
local monitors = import('modules/monitors')
-- Optional action modules (not bound by default):
-- local hop = import('modules/hop')
-- local slide = import('modules/slide')

local hyper = hotkey.hyper -- { "cmd", "ctrl", "alt", "shift" }
local meh = hotkey.meh     -- { "cmd", "ctrl", "alt" }
local bind = hotkey.bind

local function focus_running_app(app_name)
    return function()
        local app = application.find(app_name)
        if app ~= nil then
            app:activate(true)
        end
    end
end

local function module_init()
    -- System & Hammerspoon
    bind(meh, "E", "Reload Hammerspoon", hs.reload)
    bind(meh, "R", "Open Hammerspoon console", hs.openConsole)
    bind({}, "F13", "Lock screen", lock.lock)

    -- Applications & window switcher
    bind({ "ctrl", "cmd" }, "TAB", "Switch window", app_selector.show)
    bind(hyper, "H", "Focus Chat", focus_running_app("Chat"))

    -- Window snapping & fullscreen
    bind({ "cmd", "ctrl" }, "A", "Toggle fullscreen", fullscreen.toggle)
    bind(hyper, "UP", "Snap window top", arrows.snap("top"))
    bind(hyper, "DOWN", "Snap window bottom", arrows.snap("bottom"))
    bind(hyper, "LEFT", "Snap window left", arrows.snap("left"))
    bind(hyper, "RIGHT", "Snap window right", arrows.snap("right"))
    bind(hyper, "SPACE", "Snap window full", arrows.snap("full"))

    -- Window arrangements
    bind(meh, "Z", "Search arrangements", arrangement.fuzzy_search)
    bind(meh, "Q", "Arrange: Diagnose", arrangement.by_name("Diagnose"))
    bind(meh, "A", "Arrange: zen", arrangement.by_name("zen"))

    -- Multi-monitor navigation & window movement
    bind(hyper, "TAB", "Move cursor to next screen", monitors.focus_next_screen)
    bind(hyper, "=", "Move window one screen east", monitors.move_window_east)
    bind(hyper, "/", "Move window one screen west", monitors.move_window_west)

    for id, mon in pairs(monitors.configured_monitors) do
        local pad_key = "PAD" .. id
        bind({ "cmd", "ctrl" }, pad_key, "Cursor to monitor " .. id, monitors.focus_mouse(mon))
        bind(meh, pad_key, "Window full on monitor " .. id, monitors.snap_window(mon, "full"))
        bind({ "ctrl", "alt" }, pad_key, "Window left on monitor " .. id, monitors.snap_window(mon, "left"))
        bind({ "cmd", "alt" }, pad_key, "Window right on monitor " .. id, monitors.snap_window(mon, "right"))
        bind({ "shift", "ctrl", "alt" }, pad_key, "Window to monitor " .. id, monitors.move_window_relative(mon))
    end

    -- Window resizing (slide) - disabled by default
    -- bind(meh, "UP", "Shrink window height", slide.nudge("shorter"))
    -- bind(meh, "DOWN", "Grow window height", slide.nudge("taller"))
    -- bind(meh, "LEFT", "Shrink window width", slide.nudge("narrower"))
    -- bind(meh, "RIGHT", "Grow window width", slide.nudge("wider"))

    -- Directional window focus (hop) - disabled by default
    -- bind(hyper, "UP", "Focus window north", hop.focus("north"))
    -- bind(hyper, "DOWN", "Focus window south", hop.focus("south"))
    -- bind(hyper, "LEFT", "Focus window west", hop.focus("west"))
    -- bind(hyper, "RIGHT", "Focus window east", hop.focus("east"))
end

return {
    init = module_init,
}
