local chooser = require 'hs.chooser'

local match_dialogue__proto = {}
local match_dialogue__mt = { __index = match_dialogue__proto }

local function match_dialogue_new(data_source_fn, match_selected_fn, opts)
    local matcher = {}
    setmetatable(matcher, match_dialogue__mt)
    return matcher:init(data_source_fn, match_selected_fn, opts)
end

function match_dialogue__proto:init(data_source_fn, match_selected_fn, opts)
    if type(data_source_fn) ~= "function" then
        error("data_source_fn (parameter 1) must be a function!")
    end

    if type(match_selected_fn) ~= "function" then
        error("match_selected_fn (parameter 2) must be a function!")
    end

    self.opts = opts or {}
    self.data_source_fn = data_source_fn
    self.match_selected_fn = match_selected_fn
    self.items = {}

    self.__chooser = chooser.new(function(choice)
        local items = self.items
        self.items = {}
        if choice == nil then
            return
        end
        local selected = items[choice._index]
        if selected ~= nil then
            self.match_selected_fn(selected)
        end
    end)

    self.__chooser:searchSubText(true)
    if self.opts.placeholder ~= nil then
        self.__chooser:placeholderText(self.opts.placeholder)
    end

    return self
end

function match_dialogue__proto:show()
    if self.__chooser:isVisible() then
        self:hide()
        return
    end

    local raw_items = self.data_source_fn() or {}
    local choices = {}
    self.items = {}

    for _, item in ipairs(raw_items) do
        local text = item.text or item.string
        if text ~= nil and text ~= "" then
            local idx = #self.items + 1
            self.items[idx] = item
            table.insert(choices, {
                text = text,
                subText = item.subText,
                image = item.image,
                _index = idx,
            })
        end
    end

    self.__chooser:choices(choices)
    self.__chooser:query("")
    self.__chooser:show()
end

function match_dialogue__proto:hide()
    self.items = {}
    if self.__chooser ~= nil then
        self.__chooser:hide()
    end
end

return match_dialogue_new
