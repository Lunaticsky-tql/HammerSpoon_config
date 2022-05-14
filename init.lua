
wf=hs.window.filter
hyper = hs.hotkey.modal.new({}, 'F19')
hyper2 = hs.hotkey.modal.new({}, 'F16')
firefox = hs.application.get("Firefox")

-- Enter Hyper Mode when F18 (Hyper/Capslock) is pressed
function enterHyperMode()
  hyper.triggered = false
  hyper:enter()
end

function enterHyperMode2()
  hyper2.triggered = false
  hyper2:enter()
end


-- Leave Hyper Mode when F18 (Hyper/Capslock) is pressed,
-- send ESCAPE if no other keys are pressed.
function exitHyperMode()
  hyper:exit()
  if not hyper.triggered then
    --if the firefox is open, close the current tab
    if firefox:isFrontmost() then
      --close the current tab more conviniently
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
      hs.eventtap.keyStroke({"cmd"}, "t")
    else
      hs.eventtap.keyStrokes('`')
    end
  end
end

hs.hotkey.bind({"shift"}, "F15", function()
  hs.eventtap.keyStrokes('~')
end)



-- Bind the Hyper key
F18 = hs.hotkey.bind({}, 'F18', enterHyperMode, exitHyperMode)
F15 = hs.hotkey.bind({}, 'F15', enterHyperMode2, exitHyperMode2)


hyper:bind({}, "a", function()
  hs.application.open("/System/Library/CoreServices/Finder.app")
  hyper.triggered = true
end)

hyper:bind({}, "w", function()
  hs.application.open("/Applications/Typora.app")
  hyper.triggered = true
end)

--[translate in deepl]
hyper:bind({}, "d", function()
  hyper.triggered = true
  hs.eventtap.keyStroke({'cmd'}, 'c')
  --get the text in the pasteboard
  local text = hs.pasteboard.getContents() 
  local translate_script=[[
    global translation_result
    tell application "System Events"
      tell process "DeepL"
        local previous_result     
        set previous_result to value of text area 1 of group 5 of group 4 of group 1 of UI element 1 of scroll area 1 of group 1 of group 1 of window "DeepL"
        set value of text area 1 of group 4 of group 2 of group 1 of UI element 1 of scroll area 1 of group 1 of group 1 of window "DeepL" to "]]..text..[["
        repeat until value of text area 1 of group 5 of group 4 of group 1 of UI element 1 of scroll area 1 of group 1 of group 1 of window "DeepL" is not equal to previous_result and value of text area 1 of group 5 of group 4 of group 1 of UI element 1 of scroll area 1 of group 1 of group 1 of window "DeepL" is not equal to ""
          #get the translated text
        end repeat
        return value of text area 1 of group 5 of group 4 of group 1 of UI element 1 of scroll area 1 of group 1 of group 1 of window "DeepL"
      end tell
    end tell
    ]]
  local app=hs.application.get('DeepL')
  local main_win = app:mainWindow()
    if not main_win then
      hs.application.open('/Applications/DeepL.app')
      hs.timer.doAfter(0.5, function()
        local success,result=hs.osascript.applescript(translate_script)
        if success then
          hs.alert.show("translate success")
          hs.pasteboard.setContents(result)
        end
        end)
      -- hs.eventtap.keyStroke({'cmd'}, '0')
    else
    local success,result=hs.osascript.applescript(translate_script)
    if success then
      hs.alert.show("translate success")
      -- app:activate()
      hs.pasteboard.setContents(result)
    end
  end
end)

--[add sql code block in typora]
hyper:bind({},"q", function()

  local sql_input=[[```sql]]
  local typora=hs.application.get('Typora')
  if typora:isFrontmost() then
    local temp_clipboard = hs.pasteboard.uniquePasteboard()
    hs.pasteboard.writeAllData(temp_clipboard,hs.pasteboard.readAllData(nil))
    hs.pasteboard.writeObjects(sql_input)
    hs.eventtap.keyStroke({'cmd'}, 'v')
    hs.pasteboard.writeAllData(nil,hs.pasteboard.readAllData(temp_clipboard))
    hs.pasteboard.deletePasteboard(temp_clipboard)
    hs.eventtap.keyStroke({}, 'return')
  else
    local ssh = hs.application.open('Termius')
  end
  hyper.triggered = true
end)

hyper:bind({},"t", function()
  --copy path and open in terminal
  local finder=hs.application.get('访达')
  if(finder:isFrontmost()) then
    hs.eventtap.keyStroke({'cmd','alt'}, 'c')
    --get the path of current file
    local path = hs.pasteboard.getContents()
    -- open in terminal
    local terminal = hs.application.open('Terminal')
    --open terminal in given path
    local temp_clipboard = hs.pasteboard.uniquePasteboard()
    hs.pasteboard.writeAllData(temp_clipboard,hs.pasteboard.readAllData(nil))
    local terminal_path = 'cd '..path
    hs.pasteboard.writeObjects(terminal_path)
    hs.eventtap.keyStroke({'cmd'}, 'v')
    hs.pasteboard.writeAllData(nil,hs.pasteboard.readAllData(temp_clipboard))
    hs.pasteboard.deletePasteboard(temp_clipboard)
    hs.eventtap.keyStroke({}, 'return')
  end
  hyper.triggered = true
end)

--[change the color of selected select text in typora]
hyper:bind({}, "c", function()
  local app=hs.application.get('Typora')
  local color=""
  local text=""
  if app:isFrontmost() then
    menubar = hs.menubar.new(false)
    menubar:setTitle("Hidden Menu")
    menubar:setMenu( {
        { title = "red", fn = function() color="Apricot" end},
        { title = "green", fn = function() color="green" end},
        { title = "blue", fn = function() color="blue" end}, })
    menubar:popupMenu(hs.mouse.getAbsolutePosition(),true)
    if color~="" then
      hs.eventtap.keyStroke({'cmd'}, 'x')
      local temp_clipboard = hs.pasteboard.uniquePasteboard()
      hs.pasteboard.writeAllData(temp_clipboard,hs.pasteboard.readAllData(nil))
      text=hs.pasteboard.readString()
      local html="<font color=\'"..color.."\'"..">"..text.."</font>"
      -- local latex="$\\textcolor{"..color.."}{"..text.."}$"
      hs.pasteboard.clearContents()
      hs.pasteboard.writeObjects(html)
      hs.eventtap.keyStroke({'cmd'}, 'v')
      hs.pasteboard.writeAllData(nil,hs.pasteboard.readAllData(temp_clipboard))
      hs.pasteboard.deletePasteboard(temp_clipboard)
      -- hs.eventtap.keyStroke({}, 'return')
    end
  end
  hyper.triggered = true
end)



------------(hyper 2 keybindings)-----------------------------------------------------

--[sign my homework]
hyper2:bind({}, "n", function()
  hs.eventtap.keyStrokes('2013599_田佳业_')
  hyper2.triggered = true
end)

hyper2:bind({}, "m", function()
  hs.eventtap.keyStrokes('2013599@mail.nankai.edu.cn')
  hyper2.triggered = true
end)

--[pin the current window]
hyper2:bind({}, "q", function()
  Win = hs.window.focusedWindow()
  hs.alert.show(Win:title().."  is saved",0.5)
  hyper2.triggered = true
end)

hyper2:bind({}, "1", function()
  Win1 = hs.window.focusedWindow()
  hs.alert.show(Win1:title().."  is saved as window 1",0.5)
  hyper2.triggered = true
end)

hyper2:bind({}, "2", function()
  Win2 = hs.window.focusedWindow()
  hs.alert.show(Win2:title().."  is saved as window 2",0.5)
  hyper2.triggered = true
end)

--[show the pinned window]
hyper2:bind({}, "q", function()
  --focus the window saved in parameter win
  Win1:focus()
  hyper2.triggered = true
end)

hyper2:bind({}, "w", function()
  --focus the window saved in parameter win
  Win2:focus()
  hyper2.triggered = true
end)

hyper2:bind({}, "s", function()
  hs.application.open('/Applications/QQ.app')
  --wait until the app is opened
  hs.timer.doAfter(0.3, function()
    local send_script=[[
    #bring the qq window to front
    tell application "QQ" to activate
    tell application "System Events"
      tell process "QQ"
        select row 1 of table 1 of scroll area 1 of splitter group 1 of window 2
        select text area 1 of scroll area 2 of splitter group 1 of splitter group 1 of window 2
        #wait for the window to be ready
        #paste contents
        keystroke "v" using command down
        #send
        keystroke return
        click button 8 of window 2
      end tell
    end tell
  ]]
  hs.osascript.applescript(send_script)
  hs.alert.show("send to QQ",0.5)
  hyper2.triggered = true
  
  end)
  
end)



--test module
-- hyper:bind({}, "c", function()
--   -- menubar = hs.menubar.new(false)
--   -- menubar:setTitle("Hidden Menu")
--   -- menubar:setMenu( {
--   --     { title = "菜单", fn = function() hs.alert.show("you clicked the item!") end },
--   --     { title = "444" },
--   --   {title="555"}} )
--   -- menubar:popupMenu(hs.mouse.getAbsolutePosition(), true)
--   local table=hs.pasteboard.allContentTypes()
--   for i=1,#table[1] do
--     print(type(table[1][i]))
--   end
--   print(#table[1])
--   local nowcontent=hs.pasteboard.getContents()
--   hs.alert.show(nowcontent)
--   hyper.triggered = true
-- end)


-- hyper:bind({}, "b", function()
--   local applescript=[[
-- display dialog "表单" default answer "输入框内容" buttons {"按钮1", "按钮2", "按钮3"} default button 1 with icon caution
-- copy the result as list to {text_returned, button_pressed} --返回一个列表{文本,按钮}


--     ]]
--     --get the list of the result applescript returns
--     local response
--     local list
--     response,list = hs.osascript.applescript(applescript)
--     print(response)
--     print(type(list))     
--     print(list[1])
--     print(list[2])
--   hyper.triggered = true
-- end)



hyper:bind({}, "s", function()
  hyper.triggered = true
  Win = hs.window.focusedWindow()
  hs.eventtap.keyStroke({'cmd'}, 'c')
  local text=hs.pasteboard.readString()
  --if there is quotation marks in the text, escape them
  if string.find(text, '"') then
    local temp1="%%22"
    text=string.gsub(text, '["]', temp1)
  end
  if string.find(text, "'") then
    local temp2="%%27"
    text=string.gsub(text, "[']", temp2)
  end
  local shell_command = "open " .."'https://www.baidu.com/baidu?tn=monline_3_dg&ie=utf-8&wd="..text.."'"
  hs.execute(shell_command)
end)

-- a potentially useful demo
-- function newWindow() 
--   local app =hs.application.find("Firefox")
--   app:selectMenuItem({"文件", "新建窗口"})
-- end
-- hs.hotkey.bind({'alt', 'ctrl', 'cmd'}, 'n', newWindow)
--make a hot key enables in a certain window

------------(firefox shortcut)-----------------------------------------------------

tab_open=hs.hotkey.new({}, 'tab', function()
  local now_win = hs.window.focusedWindow()
  --get title
  local title = now_win:title()
  --if the title contains "Notebook", which means it is a notebook window, do not bind the hotkeys
  if string.find(title, "Notebook") then
    hs.eventtap.keyStrokes('    ')
    else
    hs.eventtap.keyStroke({'cmd'}, 't')
    end
  end)

function enable_firefox_binds()
    --bind the hotkeys
     tab_open:enable()
end

function disable_firefox_binds()
    --disable the hotkeys
 tab_open:disable()
end
-- function enable_finder_binds()
--   hs.alert.show("finder binds enabled")
--   cut:enable()
-- end
-- function disable_finder_binds()
--   hs.alert.show("finder binds disabled")
--   cut:disable()
-- end

wf_firefox=wf.new{'Firefox'}
wf_firefox:subscribe(wf.windowFocused, enable_firefox_binds)
wf_firefox:subscribe(wf.windowUnfocused, disable_firefox_binds)
-- wf_finder=wf.new{'访达'}
-- wf_finder:subscribe(wf.windowFocused, enable_finder_binds)
-- wf_finder:subscribe(wf.windowUnfocused, disable_finder_binds)

hs.hotkey.bind({"ctrl"}, "W", function()
  --open word
  local word=hs.application.find("Microsoft Word")
  word:activate(true)
end)

hs.hotkey.bind({"alt"}, "s", function()
  --copy the text
  hs.alert.show("search google")
  hs.eventtap.keyStroke({'cmd'}, 'c')
  local default=hs.pasteboard.readString()
  local script=[[
    display dialog "Google search" default answer "]]..default..[[" buttons {"cancel", "go"} default button 2 giving up after 5
copy the result as list to {text_returned, button_pressed}
  ]]
  local response,list = hs.osascript.applescript(script)
  if list[1]=="go" then
    local text=list[2]
    --if there is quotation marks in the text, escape them
    if string.find(text, '"') then
      local temp1="%%22"
      text=string.gsub(text, '["]', temp1)
    end
    if string.find(text, "'") then
      local temp2="%%27"
      text=string.gsub(text, "[']", temp2)
    end
    local shell_command = "open " .."'https://www.google.com/search?q="..text.."'"
    hs.execute(shell_command)
  end
end)

------------(reload config)-----------------------------------------------------
hyper:bind({}, "r", function()
  hs.eventtap.keyStroke({'cmd'}, 's')
  hs.reload()
  hyper.triggered = true
end)
hs.alert("Config loaded")
