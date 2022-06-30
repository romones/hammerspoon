local hotkey = require 'hs.hotkey'
local window = require 'hs.window'

local function module_init()
    local mash = config:get('binds.mash', { "cmd", "ctrl" })
    local key = config:get('binds.key', "A")

	hs.hotkey.bind( mash, "H", function ()
	       local hangouts = hs.application.find("Chat")
         if hangouts ~= nil then
	         hangouts:activate(true)
         end
	end)

	hs.hotkey.bind( mash, "G", function ()
    hs.osascript.applescript('return "OK"')
	end)
end

return {
    init = module_init
}
