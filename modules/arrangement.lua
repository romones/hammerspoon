local alert = require 'hs.alert'
local fnutils = require 'hs.fnutils'

local find = import('utils/find')
local monitors = import('utils/monitors').configured_monitors
local position = import('utils/position')

local function get_window(arrangement_table)
    if arrangement_table.app_title ~= nil then
        return find.window.by_application_title(arrangement_table.app_title)
    end

    if arrangement_table.title ~= nil then
        return find.window.by_title(arrangement_table.title)
    end

    error("Arrangement table needs: app_title or title to be set")
end


local function arrange(arrangement)
    fnutils.map(arrangement, function(item)

        local window = get_window(item)
        if window == nil then
            return
        end

        local monitor = item.monitor
        local item_position = item.position

        if monitor == nil then
            error("arrangement table does not have monitor")
        end

        if item_position == nil then
            error("arrangement table does not have position")
        end

        if monitors[monitor] == nil then
            error("monitor " .. monitor .. " does not exist")
        end

        local win_full = window:isFullScreen()

        if item_position ~= "full_screen" and win_full then
            window:setFullScreen(false)
        end

        if type(item_position) == "string" then

            if item_position == "full_screen" then
                window:setFrame(monitors[monitor].dimensions.f)

                if not win_full then
                    window:setFullScreen(true)
                end

            else
                if position[item_position] == nil then
                    alert.show("Unknown position: " .. item_position, 1.0)
                else
                    window:setFrame(position[item_position](monitors[monitor].dimensions))
                end
            end

        elseif type(item_position) == "function" then
            window:setFrame(monitors[monitor].dimensions:relative_to(item_position(monitors[monitor].dimensions, {
                monitor = monitors[monitor],
                window = window,
                position = position
            })))

        elseif type(item_position) == "table" then
            window:setFrame(monitors[monitor].dimensions:relative_to(item_position))

        else
            error("position cannot be a " .. type(item_position))
        end
    end)
end

local function handle_arrangement(arrangement)
    arrange(arrangement.arrangement)

    if arrangement.alert == true then
        alert.show("Arranged with profile: " .. (arrangement.name or "unnamed arrangement"), 1.0)
    end
end

local matcher

local function find_arrangement(name)
    local arrangements = config.arrangements or {}
    if type(arrangements[name]) == "table" and arrangements[name].arrangement ~= nil then
        return arrangements[name]
    end
    for _, arrangement in ipairs(arrangements) do
        if arrangement.name == name then
            return arrangement
        end
    end
    return nil
end

local function activate(name)
    local arrangement = find_arrangement(name)
    if arrangement == nil then
        alert.show("Unknown arrangement: " .. tostring(name), 2.0)
        return
    end
    handle_arrangement(arrangement)
end

local function by_name(name)
    if find_arrangement(name) == nil then
        error("Unknown arrangement profile: " .. tostring(name))
    end
    return function()
        activate(name)
    end
end

local function fuzzy_search()
    if matcher == nil then
        local match_dialogue = import('utils/match_dialogue')
        matcher = match_dialogue(function()
            local list = fnutils.filter(config.arrangements or {}, function(arrangement)
                return arrangement.name ~= nil
            end)
            return fnutils.map(list, function(arrangement)
                return {
                    text = arrangement.name,
                    arrangement = arrangement,
                }
            end)
        end, function(match)
            handle_arrangement(match.arrangement)
        end, {
            placeholder = "Select window arrangement...",
        })
    end
    matcher:show()
end

local function init_menu()
    if config.arrangements == nil then
        return
    end

    local menu = {}

    for _, arrangement in ipairs(config.arrangements) do
        if arrangement.menu == true then
            table.insert(menu, {
                title = "Arrange: " .. arrangement.name,
                fn = function()
                    handle_arrangement(arrangement)
                end
            })
        end
    end

    if #menu > 0 then
        return fnutils.concat(menu, { { title = "-" } })
    else
        return menu
    end
end

return {
    arrange = arrange,
    activate = activate,
    by_name = by_name,
    fuzzy_search = fuzzy_search,
    menu = init_menu,
}
