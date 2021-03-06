wf = hs.window.filter
timer = require("hs.timer")
hyper = hs.hotkey.modal.new({}, 'F19')
hyper2 = hs.hotkey.modal.new({}, 'F16')
hyper3 = hs.hotkey.modal.new({}, 'F20')
firefox = hs.application.get("Firefox")
word = hs.application.get("Microsoft Word")
--load modules
ctrlDoublePress = require("ctrlDoublePress")
------------(hyper mode config)------------------------------------------
-- Enter Hyper Mode
function enterHyperMode()
    hyper.triggered = false
    hyper:enter()
end
function enterHyperMode2()
    hyper2.triggered = false
    hyper2:enter()
end
function enterHyperMode3()
    hyper3.triggered = false
    hyper3:enter()
end

-- Leave Hyper Mode
function exitHyperMode()
    hyper:exit()
    if not hyper.triggered then
        -- if the firefox is open, close the current tab
        if firefox:isFrontmost() then
            -- close the current tab more conviniently
            hs.eventtap.keyStroke({"cmd"}, "w")
        else
            hs.eventtap.keyStroke({}, "escape")
        end
    end
end
function exitHyperMode2()
    hyper2:exit()
    if not hyper2.triggered then
        if firefox:isFrontmost() then
            hs.eventtap.keyStroke({'alt', 'ctrl'}, "w")
        else
            hs.eventtap.keyStrokes('`')
        end
    end
end
function exitHyperMode3()
    hyper3:exit()
end
hs.hotkey.bind({"shift"}, "F15", function()
    hs.eventtap.keyStrokes('~')
end)
-- Bind the Hyper key
F18 = hs.hotkey.bind({}, 'F18', enterHyperMode, exitHyperMode)
F15 = hs.hotkey.bind({}, 'F15', enterHyperMode2, exitHyperMode2)
F13 = hs.hotkey.bind({}, 'F13', enterHyperMode3, exitHyperMode3)

------------(hyper keybindings)-----------------------------------------------------
hyper:bind({}, "a", function()
    hs.application.open("/System/Library/CoreServices/Finder.app")
    hyper.triggered = true
end)

hyper:bind({}, "w", function()
    hs.application.open("/Applications/Typora.app")
    hyper.triggered = true
end)

-- [translate in deepl]
hyper:bind({}, "d", function()
    hyper.triggered = true
    hs.eventtap.keyStroke({'cmd'}, 'c')
    -- get the text in the pasteboard
    local text = hs.pasteboard.getContents()
    local translate_script = [[
    global translation_result
    tell application "System Events"
      tell process "DeepL"
        local previous_result     
        set previous_result to value of text area 1 of group 5 of group 4 of group 1 of UI element 1 of scroll area 1 of group 1 of group 1 of window "DeepL"
        set value of text area 1 of group 4 of group 2 of group 1 of UI element 1 of scroll area 1 of group 1 of group 1 of window "DeepL" to "]] ..
                                 text .. [["
        repeat until value of text area 1 of group 5 of group 4 of group 1 of UI element 1 of scroll area 1 of group 1 of group 1 of window "DeepL" is not equal to previous_result and value of text area 1 of group 5 of group 4 of group 1 of UI element 1 of scroll area 1 of group 1 of group 1 of window "DeepL" is not equal to ""
          #get the translated text
        end repeat
        return value of text area 1 of group 5 of group 4 of group 1 of UI element 1 of scroll area 1 of group 1 of group 1 of window "DeepL"
      end tell
    end tell
    ]]
    local app = hs.application.get('DeepL')
    local main_win = app:mainWindow()
    if not main_win then
        hs.application.open('/Applications/DeepL.app')
        hs.timer.doAfter(0.5, function()
            local success, result = hs.osascript.applescript(translate_script)
            if success then
                hs.alert.show("translate success")
                hs.pasteboard.setContents(result)
            end
        end)
    else
        local success, result = hs.osascript.applescript(translate_script)
        if success then
            hs.alert.show("translate success")
            hs.pasteboard.setContents(result)
        end
    end
end)
-- [add sql code block in typora]
hyper:bind({}, "q", function()
    local sql_input = [[```sql]]
    local typora = hs.application.get('Typora')
    if typora:isFrontmost() then
        local temp_clipboard = hs.pasteboard.uniquePasteboard()
        hs.pasteboard.writeAllData(temp_clipboard, hs.pasteboard.readAllData(nil))
        hs.pasteboard.writeObjects(sql_input)
        hs.eventtap.keyStroke({'cmd'}, 'v')
        hs.pasteboard.writeAllData(nil, hs.pasteboard.readAllData(temp_clipboard))
        hs.pasteboard.deletePasteboard(temp_clipboard)
        hs.eventtap.keyStroke({}, 'return')
    else
        local ssh = hs.application.open('Termius')
    end
    hyper.triggered = true
end)

hyper:bind({}, "z", function()
    if word:isFrontmost() then
        hs.eventtap.keyStroke({'cmd', 'shift'}, 'c')
    end
    hyper.triggered = true
end)

hyper:bind({}, "p", function()
    local PasteNow=hs.application.get('PasteNow')
    if PasteNow~=nil then
        hs.eventtap.keyStroke({'cmd', 'alt','control'}, 'c')
        local script=[[
            tell application "System Events"
            tell process "PasteNow"
                click button 2 of window 1
                delay 0.5
                click button 2 of window 1
            end tell
        end tell
        ]]
        hs.osascript.applescript(script)
    else
        hs.application.open("/Applications/PasteNow.app")
        hs.timer.doAfter(0.3, function()
            hs.eventtap.keyStroke({'cmd', 'alt','control'}, 'c')
            local script=[[
                tell application "System Events"
                tell process "PasteNow"
                    click button 2 of window 1
                    delay 0.3
                    click button 2 of window 1
                end tell
            end tell
            ]]
            hs.osascript.applescript(script)
        end)
    end
    hyper.triggered = true
end)

hyper:bind({}, "x", function()
    if word:isFrontmost() then
        hs.eventtap.keyStroke({'cmd', 'shift'}, 'v')
    end
    hyper.triggered = true
end)

hyper:bind({}, "t", function()
    -- copy path and open in terminal
    local finder = hs.application.get('??????')
    if (finder:isFrontmost()) then
        hs.eventtap.keyStroke({'cmd', 'alt'}, 'c')
        -- get the path of current file
        local path = hs.pasteboard.getContents()
        -- open in terminal
        local terminal = hs.application.open('Terminal')
        -- open terminal in given path
        local temp_clipboard = hs.pasteboard.uniquePasteboard()
        hs.pasteboard.writeAllData(temp_clipboard, hs.pasteboard.readAllData(nil))
        local terminal_path = 'cd ' .. path
        hs.pasteboard.writeObjects(terminal_path)
        hs.eventtap.keyStroke({'cmd'}, 'v')
        hs.pasteboard.writeAllData(nil, hs.pasteboard.readAllData(temp_clipboard))
        hs.pasteboard.deletePasteboard(temp_clipboard)
        hs.eventtap.keyStroke({}, 'return')
    end
    hyper.triggered = true
end)

-- [change the color of selected select text in typora]
hyper:bind({}, "c", function()
    local app = hs.application.get('Typora')
    local color = ""
    local text = ""
    if app:isFrontmost() then
        menubar = hs.menubar.new(false)
        menubar:setTitle("Hidden Menu")
        menubar:setMenu({{
            title = "red",
            fn = function()
                color = "Apricot"
            end
        }, {
            title = "green",
            fn = function()
                color = "green"
            end
        }, {
            title = "blue",
            fn = function()
                color = "blue"
            end
        }})
        menubar:popupMenu(hs.mouse.getAbsolutePosition(), true)
        if color ~= "" then
            hs.eventtap.keyStroke({'cmd'}, 'x')
            local temp_clipboard = hs.pasteboard.uniquePasteboard()
            hs.pasteboard.writeAllData(temp_clipboard, hs.pasteboard.readAllData(nil))
            text = hs.pasteboard.readString()
            local html = "<font color=\'" .. color .. "\'" .. ">" .. text .. "</font>"
            -- local latex="$\\textcolor{"..color.."}{"..text.."}$"
            hs.pasteboard.clearContents()
            hs.pasteboard.writeObjects(html)
            hs.eventtap.keyStroke({'cmd'}, 'v')
            hs.pasteboard.writeAllData(nil, hs.pasteboard.readAllData(temp_clipboard))
            hs.pasteboard.deletePasteboard(temp_clipboard)
        end
    end
    hyper.triggered = true
end)
------------(hyper 2 keybindings)-----------------------------------------------------

-- [sign my homework]
hyper2:bind({}, "n", function()
    hs.eventtap.keyStrokes('2013599_?????????_')
    hyper2.triggered = true
end)

hyper2:bind({}, "m", function()
    hs.eventtap.keyStrokes('2013599@mail.nankai.edu.cn')
    hyper2.triggered = true
end)

-- [pin the current window]
hyper2:bind({}, "1", function()
    Win1 = hs.window.focusedWindow()
    Win1:focus()
    hyper2.triggered = true
end)

hyper2:bind({}, "2", function()
    Win2 = hs.window.focusedWindow()
    Win2:focus()
    hyper2.triggered = true
end)

-- [show the pinned window]
hyper2:bind({}, "q", function()
    -- focus the window saved in parameter win
    Win1:focus()
    hyper2.triggered = true
end)

hyper2:bind({}, "w", function()
    local applescript=[[
        tell application "Finder" to activate
        tell application "Finder" to open ("/Users/tianjiaye/Downloads" as POSIX file)
    ]]
    hs.osascript.applescript(applescript)
    hyper2.triggered = true
end)

hyper2:bind({}, "a", function()
    -- open finder with the path of the current file
    local applescript=[[
        tell application "Finder" to activate
        tell application "Finder" to open ("/Users/tianjiaye/??????" as POSIX file)
    ]]
    hs.osascript.applescript(applescript)
    hyper2.triggered = true
end)
hyper2:bind({}, "q", function()
    -- open finder with the path of the current file
    local applescript=[[
        tell application "Finder" to activate
        tell application "Finder" to open ("/Users/tianjiaye/QQ??????" as POSIX file)
    ]]
    hs.osascript.applescript(applescript)
    hyper2.triggered = true
end)

hyper2:bind({}, "tab", function()
    -- open finder with the path of the current file
    local applescript=[[
        tell application "Finder" to activate
        tell application "Finder" to open ("/Users/tianjiaye/????????????" as POSIX file)
    ]]
    hs.osascript.applescript(applescript)
    hyper2.triggered = true
end)

hyper:bind({}, "s", function()

    Win = hs.window.focusedWindow()
    hs.eventtap.keyStroke({'cmd'}, 'c')
    local text = hs.pasteboard.readString()
    -- if there is quotation marks in the text, escape them
    if string.find(text, '"') then
        local temp1 = "%%22"
        text = string.gsub(text, '["]', temp1)
    end
    if string.find(text, "'") then
        local temp2 = "%%27"
        text = string.gsub(text, "[']", temp2)
    end
    local shell_command = "open " .. "'https://www.baidu.com/baidu?tn=monline_3_dg&ie=utf-8&wd=" .. text .. "'"
    hs.execute(shell_command)
    hyper.triggered = true
end)

-- [cut the current line]

------------(firefox shortcut)-----------------------------------------------------

tab_open = hs.hotkey.new({}, 'tab', function()
    local now_win = hs.window.focusedWindow()
    -- get title
    local title = now_win:title()
    -- if the title contains "Notebook", which means it is a notebook window, do not bind the hotkeys
    if string.find(title, "Notebook") then
        hs.eventtap.keyStrokes('    ')
    else
        hs.eventtap.keyStroke({'cmd'}, 't')
    end
end)
tab_restore = hs.hotkey.new({'alt'}, 'tab', function()
    hs.eventtap.keyStroke({'cmd', 'shift'}, 't')
end)

tab_clone = hs.hotkey.new({'alt'}, 'c', function()
    hs.eventtap.keyStroke({}, 'f6')
    hs.eventtap.keyStroke({'cmd'}, 'c')
    local url = hs.pasteboard.readString()
    local shell_command = "open " .. "'" .. url .. "'"
    hs.execute(shell_command)
end)

section = hs.hotkey.new({'alt'}, '1', function()
  local now_win = hs.window.focusedWindow()
  local title = now_win:title()
  if string.find(title, "LaTeX") then
    hs.eventtap.keyStrokes('\\section{}')
    hs.eventtap.keyStroke({}, 'return')
  end
end)

subsection = hs.hotkey.new({'alt'}, '2', function()
  local now_win = hs.window.focusedWindow()
  local title = now_win:title()
  if string.find(title, "LaTeX") then
    hs.eventtap.keyStrokes('\\subsection{}')
    hs.eventtap.keyStroke({}, 'return')
  end
end)
subsubsection= hs.hotkey.new({'alt'}, '3', function()
  local now_win = hs.window.focusedWindow()
  local title = now_win:title()
  if string.find(title, "LaTeX") then
    hs.eventtap.keyStrokes('\\subsubsection{}')
    hs.eventtap.keyStroke({}, 'return')
  end
end)

function enable_firefox_binds()
    -- bind the hotkeys
    tab_open:enable()
    tab_restore:enable()
    tab_clone:enable()
    section:enable()
    subsection:enable()
    subsubsection:enable()
end

function disable_firefox_binds()
    -- disable the hotkeys
    tab_open:disable()
    tab_restore:disable()
    tab_clone:disable()
    section:disable()
    subsection:disable()
    subsubsection:disable()
end

wf_firefox = wf.new {'Firefox'}
wf_firefox:subscribe(wf.windowFocused, enable_firefox_binds)
wf_firefox:subscribe(wf.windowUnfocused, disable_firefox_binds)

----------(global hotkey)-----------------------------------------------------
hs.hotkey.bind({"ctrl"}, "W", function()
    -- open word
    local word = hs.application.find("Microsoft Word")
    word:activate(true)
end)

hs.hotkey.bind({"alt"}, "b", function()
    hs.eventtap.keyStrokes('\\begin{equation}')
end)
hs.hotkey.bind({"alt"}, "n", function()
    hs.eventtap.keyStrokes('\\end{equation}')
end)

hs.hotkey.bind({}, 44, function()
    hs.eventtap.keyStrokes('/')
end)

hs.hotkey.bind({'shift'}, 27, function()
  hs.eventtap.keyStrokes('_')
end)

hs.hotkey.bind({}, 42, function()
  hs.eventtap.keyStrokes('\\')
end)

hs.hotkey.bind({'shift'}, 42, function()
  --get the current imput layout
  local layout=hs.keycodes.currentLayout()
  if layout=="ABC" then
    hs.eventtap.keyStrokes('|')
  else
    hs.eventtap.keyStrokes('???')
    end
end)

-- [I do not want to see ?????? when I am typing formula in latex!]
hs.hotkey.bind({'shift'}, '4', function()
  hs.eventtap.keyStrokes('$')
end)

-- [search google]
hs.hotkey.bind({"alt"}, "s", function()
    local previous_text = hs.pasteboard.readString()
    hs.eventtap.keyStroke({'cmd'}, 'c')
    -- but if the clipboard is not changed do not set default text
    local now_text = hs.pasteboard.readString()
    local default
    if (now_text == previous_text) then
        default = ''
    else
        default = now_text
    end
    local script = [[
    display dialog "Google search" default answer "]] .. default ..
                       [[" buttons {"cancel", "go"} default button 2 giving up after 50
    copy the result as list to {text_returned, button_pressed}
  ]]
    local response, list = hs.osascript.applescript(script)
    if list[1] == "go" then
        local text = list[2]
        -- if there is quotation marks in the text, escape them
        if string.find(text, '"') then
            local temp1 = "%%22"
            text = string.gsub(text, '["]', temp1)
        end
        if string.find(text, "'") then
            local temp2 = "%%27"
            text = string.gsub(text, "[']", temp2)
        end
        local shell_command = "open " .. "'https://www.google.com/search?q=" .. text .. "'"
        hs.execute(shell_command)
    end
end)

------------(reload config)-----------------------------------------------------
function reloadConfig(files)
    doReload = false
    for _,file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end
myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.alert.show("Config loaded")

