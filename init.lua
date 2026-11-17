local alert = require 'hs.alert'
local fs = require 'hs.fs'

import = require('utils/import')
import.clear_cache()

config = import('config')

local function is_array(t)
    return type(t) == "table" and t[1] ~= nil
end

local function deep_merge(dst, src)
    for k, v in pairs(src) do
        if type(v) == "table" and type(dst[k]) == "table" and not is_array(v) and not is_array(dst[k]) then
            deep_merge(dst[k], v)
        else
            dst[k] = v
        end
    end
    return dst
end

-- Load optional untracked local overrides (e.g. private/work URLs, machine-specific bindings).
local local_config_path = hs.configdir .. "/config.local.lua"
if fs.attributes(local_config_path, "mode") == "file" then
    local ok, local_config = pcall(dofile, local_config_path)
    if ok and type(local_config) == "table" then
        deep_merge(config, local_config)
    elseif not ok then
        alert.show("Error loading config.local.lua (see console)", 4)
        print("config.local.lua error: " .. tostring(local_config))
    else
        alert.show("config.local.lua must return a table", 4)
    end
end

function config:get(key_path, default)
    local root = self
    for part in string.gmatch(key_path, "[^.]+") do
        root = root[part]
        if root == nil then
            return default
        end
    end
    return root
end

local modules = {}

for _, v in ipairs(config.modules) do
    local module_name = 'modules/' .. v
    local module = import(module_name)

    if type(module.init) == "function" then
        module.init()
    end

    table.insert(modules, module)
end

local buf = {}

if hs.wasLoaded == nil then
    hs.wasLoaded = true
    table.insert(buf, "Hammerspoon loaded: ")
else
    table.insert(buf, "Hammerspoon re-loaded: ")
end

table.insert(buf, #modules .. " modules.")

alert.show(table.concat(buf))
