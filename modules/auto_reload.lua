local pathwatcher = require 'hs.pathwatcher'

local M = {}

local function did_lua_file_change(files)
    for _, file in ipairs(files) do
        if file:sub(-4) == ".lua" then
            return true
        end
    end
    return false
end

local function on_files_changed(files)
    if did_lua_file_change(files) then
        hs.reload()
    end
end

function M.init()
    if M._watcher ~= nil then
        M._watcher:stop()
    end
    M._watcher = pathwatcher.new(hs.configdir, on_files_changed):start()
end

return M
