
local hotkey = require 'hs.hotkey'
local appfinder = require 'hs.appfinder'


local function module_init()
    local mash = config:get("arrows.mash", { "cmd", "ctrl", "alt" , "shift"})
    local keys = config:get("arrows.keys", {
        PAD8 = "hammerspoon://bindings?open=https%3A//meet.google.com&chrome=corp",
        PAD7 = "hammerspoon://bindings?open=chrome-extension%3A//&chrome=corp",
        PAD6 = "hammerspoon://bindings?activate=iTerm2",
        PAD5 = "hammerspoon://bindings?open=https%3A//colab.corp.google.com&chrome=corp",
        PAD4 = "hammerspoon://bindings?open=https%3A//cider.corp.google.com&chrome=corp",
        PAD3 = "hammerspoon://bindings?open=https%3A//source.corp.google.com&chrome=corp",
        PAD2 = "hammerspoon://bindings?open=https%3A//critique-ng.corp.google.com&chrome=corp",
        PAD1 = "hammerspoon://bindings?open=https%3A//b.corp.google.com&chrome=corp"
    })

    for key, url_string in pairs(keys) do

        hotkey.bind(mash, key, function()
            if appfinder.appFromName("Wow") == nil then
              hs.urlevent.openURL(url_string)
            end
        end)

    end

end

return {
    init = module_init
}
