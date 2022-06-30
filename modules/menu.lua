local menubar = require 'hs.menubar'

local menu_table = {
       { title = "∑ my menu item", fn = function() print("you clicked my menu item!") end },
       { title = "-" },
       { title = "🎹other item", fn = some_function },
       { title = "disabled item", disabled = true },
       { title = "checked item", checked = true },
   }

-- http://xqt2.com/asciiIcons.html
local iconASCII = [[ASCII:
..........A.
.A..........
.B.....ED...
...E........
...F..IH....
.....I......
........H...
........G...
....FG...D..
.........C..
..BC........
............
]]

local function init_module()
  local menu = menubar.new()
  menu:setTitle("∑⚛︎")
  menu:setIcon(iconASCII) 
  menu:setMenu(menu_table)

  local monitoring_menu = menubar.new()
  monitoring_menu:setTitle("Dynamic")
  monitoring_menu:setClickCallback(
    function (modifier)
        hs.alert(hs.inspect(modifier))

  end)
end

return {
    init = init_module
}
