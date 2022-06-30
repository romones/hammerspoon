local tab_script = [[tell application "%s"
    set windowTabList to URL of tabs of every window
    set targetURL to "%s"
    set found to false
    set windowIndex to 1

    repeat with thisWindowsTabs in windowTabList
      set TabIndex to 1
      repeat with TabURL in thisWindowsTabs

        if (TabURL as text) contains targetURL then
          set index of window windowIndex to 1
          set active tab index of window 1 to TabIndex
          set found to true
          exit repeat
        end if
        set TabIndex to TabIndex + 1
      end repeat
      if found then exit repeat
      set windowIndex to windowIndex + 1
    end repeat
    if not found then
      make new tab at window 1 with properties {URL:targetURL}
    end if

    activate
    do shell script "open -a Google\\ Chrome"

  end tell]]

local page_script = [[tell application "%s" to tell ¬
  the front window to tell ¬
  the active tab to ¬
  set jsResult to execute javascript "%s"]]

local click_script = [[function findButtonbyTextContent(text) {
  var buttons = document.querySelectorAll('button.gwt-Button');
  for (var i=0, l=buttons.length; i<l; i++) {
    if (buttons[i].firstChild.nodeValue.startsWith(text))
      return buttons[i];
  }
  return null  
}
var target = findButtonbyTextContent(\"%s\")
if (target !== null) {target.click()}
else {alert(\"No button found.\")}]]

local focus_script = [[
var target = document.querySelectorAll('input.CAMNV3C-ob-c.CAMNV3C-W-a');
if (target !== null and target[0] !== null) {
  target[0].focus()
  target[0].select()
}
else {alert(\"No InputField found.\")}]]

local alert_script = [[alert(\"%s\")]]

local chrome = {corp = "Google Chrome", noncorp = "Google Chrome Canary"}

local function module_init()
  hs.urlevent.bind("bindings", function(eventName, params)
    if params["activate"] then
      local target = hs.application.find(params["activate"])
        if target then
           target:activate(true)
        else
          hs.application.launchOrFocus(params["activate"])
        end
    end

    if params["open"] then
      if chrome[params["chrome"]] then
        hs.osascript.applescript(string.format(
          tab_script, chrome[params["chrome"]], params["open"]))
      end
      if params["click"] then
        hs.osascript.applescript(string.format(
          page_script, chrome[params["chrome"]], string.format(click_script, params["click"])))
      end
    end
  end)
end

return {
    init = module_init
}
