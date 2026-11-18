local alert = require 'hs.alert'
local hs_hotkey = require 'hs.hotkey'

local M = {}

M.hyper = { "cmd", "ctrl", "alt", "shift" }
M.meh = { "cmd", "ctrl", "alt" }

local mod_aliases = {
    command = "cmd",
    control = "ctrl",
    option = "alt",
    ["⌘"] = "cmd",
    ["⌃"] = "ctrl",
    ["⌥"] = "alt",
    ["⇧"] = "shift",
}

local function format_chord(mods, key)
    local normalized = {}
    local seen = {}

    for _, mod in ipairs(mods or {}) do
        local m = tostring(mod):lower()
        m = mod_aliases[m] or m
        if not seen[m] then
            seen[m] = true
            table.insert(normalized, m)
        end
    end

    table.sort(normalized)
    table.insert(normalized, tostring(key):upper())
    return table.concat(normalized, "+")
end

local by_chord = {}
local bindings = {}

function M.bind(mods, key, desc_or_fn, maybe_fn)
    local desc, fn
    if type(desc_or_fn) == "function" then
        fn = desc_or_fn
    else
        desc = desc_or_fn
        fn = maybe_fn
    end

    if type(fn) ~= "function" then
        error("hotkey.bind requires a callback function for " .. tostring(key))
    end

    local chord = format_chord(mods, key)
    local existing = by_chord[chord]
    if existing ~= nil then
        local msg = string.format(
            "Duplicate keybind %s (%s vs %s)",
            chord,
            existing.desc or "unnamed",
            desc or "unnamed"
        )
        print("[hotkey] WARNING: " .. msg)
        alert.show(msg, 4)
    end

    local handle = hs_hotkey.bind(mods, key, fn)
    local entry = {
        chord = chord,
        mods = mods,
        key = key,
        desc = desc,
        handle = handle,
    }

    by_chord[chord] = entry
    table.insert(bindings, entry)
    return handle
end

function M.list()
    return bindings
end

return M
