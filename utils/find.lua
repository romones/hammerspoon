local fnutils = require 'hs.fnutils'
local window = require 'hs.window'
local mouse = require 'hs.mouse'
local audio = require 'hs.audiodevice'

local find = {
    window = {},
    windows = {},
    audio_device = {}
}

local geom = import('utils/geometry')

function find.window.by_title(title)
    return fnutils.find(window.allWindows(), function(win)
        local win_title = win:title()
        return win_title ~= nil and string.match(win_title, title) ~= nil
    end)
end

function find.window.underneath_mouse()
    local pos = mouse.absolutePosition()
    return fnutils.find(window.orderedWindows(), function(win)
        return geom.pointInRect(win:frame(), pos)
    end)
end

function find.window.by_application_title(title)
    return fnutils.find(window.allWindows(), function(win)
        local app = win:application()
        local app_title = app and app:title() or nil
        return app_title ~= nil and string.match(app_title, title) ~= nil
    end)
end

function find.windows.by_title(title)
    return fnutils.filter(window.allWindows(), function(win)
        local win_title = win:title()
        return win_title ~= nil and string.match(win_title, title) ~= nil
    end)
end

function find.windows.by_application_title(title)
    return fnutils.filter(window.allWindows(), function(win)
        local app = win:application()
        local app_title = app and app:title() or nil
        return app_title ~= nil and string.match(app_title, title) ~= nil
    end)
end

function find.windows.underneath_mouse()
    local pos = mouse.absolutePosition()
    return fnutils.filter(window.orderedWindows(), function(win)
        return geom.pointInRect(win:frame(), pos)
    end)
end

function find.audio_device.by_name(name)
    return fnutils.find(audio.allOutputDevices(), function(device)
        local device_name = device:name()
        return device_name ~= nil and string.match(device_name, name) ~= nil
    end)
end

return find
