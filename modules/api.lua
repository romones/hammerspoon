local application = require 'hs.application'
local osascript = require 'hs.osascript'
local urlevent = require 'hs.urlevent'

local tab_script = [[tell application "%s"
  set targetURL to "%s"
  if (count of windows) = 0 then
    make new window
    set URL of active tab of window 1 to targetURL
  else
    set windowTabList to URL of tabs of every window
    set found to false
    set windowIndex to 1

    repeat with thisWindowsTabs in windowTabList
      set tabIndex to 1
      repeat with tabURL in thisWindowsTabs
        if (tabURL as text) contains targetURL then
          set index of window windowIndex to 1
          set active tab index of window 1 to tabIndex
          set found to true
          exit repeat
        end if
        set tabIndex to tabIndex + 1
      end repeat
      if found then exit repeat
      set windowIndex to windowIndex + 1
    end repeat

    if not found then
      make new tab at window 1 with properties {URL:targetURL}
    end if
  end if

  activate
end tell]]

local page_script = [[tell application "%s" to tell ¬
  the front window to tell ¬
  the active tab to ¬
  set jsResult to execute javascript "%s"]]

local click_script = [[(function(text) {
  var buttons = document.querySelectorAll('button.gwt-Button');
  for (var i = 0; i < buttons.length; i++) {
    if (buttons[i].textContent && buttons[i].textContent.startsWith(text)) {
      buttons[i].click();
      return true;
    }
  }
  alert('No button found.');
  return false;
})('%s');]]

local default_browsers = {
    default = "Google Chrome",
    chrome = "Google Chrome",
    canary = "Google Chrome Canary",
}

local function get_browser_app(browser_key)
    local key = browser_key or "default"
    local configured = config:get("api.browsers", nil)
    if type(configured) == "table" and configured[key] ~= nil then
        return configured[key]
    end
    return default_browsers[key]
end

local function escape_applescript(str)
    return (tostring(str):gsub('\\', '\\\\'):gsub('"', '\\"'))
end

local function escape_js_single_quoted(str)
    return (tostring(str):gsub('\\', '\\\\'):gsub("'", "\\'"):gsub('\n', '\\n'):gsub('\r', '\\r'))
end

local function activate_app(target_name, bundle_id)
    if bundle_id ~= nil then
        if application.launchOrFocusByBundleID(bundle_id) then
            return true
        end
    end

    if target_name ~= nil then
        local target = application.find(target_name, true, true)
        if target ~= nil then
            return target:activate(true)
        end
        return application.launchOrFocus(target_name)
    end

    return false
end

local function open_tab(url, browser_key, click_text)
    local app_name = get_browser_app(browser_key)
    if app_name == nil then
        return false
    end

    local ok = osascript.applescript(string.format(
        tab_script,
        escape_applescript(app_name),
        escape_applescript(url)
    ))
    application.launchOrFocus(app_name)

    if ok and click_text ~= nil then
        local js = string.format(click_script, escape_js_single_quoted(click_text))
        osascript.applescript(string.format(
            page_script,
            escape_applescript(app_name),
            escape_applescript(js)
        ))
    end

    return ok
end

local function handle(params)
    if params == nil then
        return
    end

    if params.bundle_id ~= nil then
        if application.launchOrFocusByBundleID(params.bundle_id) then
            return
        end
        if params.fallback_open ~= nil then
            open_tab(params.fallback_open, params.chrome, params.click)
            return
        end
    end

    if params.activate ~= nil then
        activate_app(params.activate)
    end

    if params.open ~= nil then
        open_tab(params.open, params.chrome, params.click)
    end
end

local function module_init()
    urlevent.bind("bindings", function(_, params)
        handle(params)
    end)
end

return {
    init = module_init,
    handle = handle,
    activate_app = activate_app,
    open_tab = open_tab,
}
