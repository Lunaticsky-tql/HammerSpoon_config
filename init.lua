-- A global variable for the Hyper Mode
hyper = hs.hotkey.modal.new({}, 'F19')
hyper2 = hs.hotkey.modal.new({}, 'F16')
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
    local firefox = hs.application.get("Firefox")
    if firefox:isFrontmost() then
      hs.eventtap.keyStroke({"cmd"}, "w")
    else
      hs.eventtap.keyStroke({}, "escape")
    end
  end
end

function exitHyperMode2()
  hyper2:exit()
  if not hyper2.triggered then
    hs.eventtap.keyStrokes('`')
  end
end

-- Bind the Hyper key
f18 = hs.hotkey.bind({}, 'F18', enterHyperMode, exitHyperMode)
f15 = hs.hotkey.bind({}, 'F15', enterHyperMode2, exitHyperMode2)

hyper:bind({}, "a", function()
  x = hs.application.open("/System/Library/CoreServices/Finder.app")
  hyper.triggered = true
end)

hyper:bind({}, "w", function()
  x = hs.application.open("/Applications/Typora.app")
  hyper.triggered = true
end)

hyper:bind({}, "d", function()
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
  if not app then
    local deepl = hs.application.launchOrFocus('DeepL')
    --wait for the DeepL to launch
    hs.timer.doAfter(0.5, function()
    local success,result=hs.osascript.applescript(translate_script)
    if success then
      hs.pasteboard.setContents(result)
    end
    end)
  else
    print(translate_script)
    local success,result=hs.osascript.applescript(translate_script)
    hs.alert.show(result)
    if success then
      hs.alert.show("translate success")
      hs.pasteboard.setContents(result)
    end
  end  

  hyper.triggered = true
end)

sql_input=[[```sql]]

hyper:bind({},"q", function()

  local app=hs.application.get('Typora')
  if app:isFrontmost() then
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

hyper:bind({}, "c", function()
  --change the color of selected select text in typora
  local app=hs.application.get('Typora')
  local color=""
  local text=""
  if app:isFrontmost() then
    menubar = hs.menubar.new(false)
    menubar:setTitle("Hidden Menu")
    menubar:setMenu( {
        { title = "red", fn = function() color="red" end},
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

hyper2:bind({}, "2", function()
  hs.eventtap.keyStrokes('2013599_田佳业_')
  hyper2.triggered = true
end)

hyper2:bind({}, "q", function()
  --save the information of the window focused and activate it later
  win = hs.window.focusedWindow()
  hs.alert.show(win:title().."  is saved",0.5)
  -- win_id = win:id()
  -- hs.alert.show("Window ID: "..win_id)
  hyper2.triggered = true
end)


-- hyper2:bind({}, "a", function()
--   --activate the deepL
--   local app=hs.application.get('Deepl')
--   hs.application.open("/Applications/Deepl.app")
--   --enter the text in deepl input box
--   local text="aaaa"
--   local applescript=[[
--     tell application "System Events"
--       tell process "DeepL"
--       set value of text area 1 of group 4 of group 2 of group 1 of UI element1 of scroll area 1 of group 1 of group 1 of window 1 of application process "DeepL" to "]]..text..[["
--       end tell

--   ]]
--   local response=hs.osascript.applescript(applescript)
--   hs.alert.show(response,0.5)

--   hyper2.triggered = true
-- end)

hyper:bind({}, "b", function()
  local applescript=[[
display dialog "表单" default answer "输入框内容" buttons {"按钮1", "按钮2", "按钮3"} default button 1 with icon caution
copy the result as list to {text_returned, button_pressed} --返回一个列表{文本,按钮}


    ]]
    --get the list of the result applescript returns
    local response
    local list
    response,list = hs.osascript.applescript(applescript)
    print(response)
    print(type(list))     
    print(list[1])
    print(list[2])
  hyper.triggered = true
end)


hyper:bind({}, "z", function()
  --activate text scanner and scan the text
  --if the text scanner is not running, start it
  local app=hs.application.get('Text Scanner')
  if not app then
    local scanner = hs.application.launchOrFocus('Text Scanner')
    --wait for the text scanner to launch
    hs.timer.doAfter(0.5, function()
      hs.eventtap.keyStroke({'ctrl','cmd'}, '0')
    end)
  else
    hs.eventtap.keyStroke({'ctrl','cmd'}, '0')
  end  
  hyper.triggered = true
end)

hyper:bind({}, "s", function()
  local text=hs.pasteboard.readString()
 --open search url in the terminal
  local applescript=[[
    tell application "Terminal"
      do script "open 'https://www.baidu.com/baidu?tn=monline_3_dg&ie=utf-8&wd=]]..text..[['"
    end tell
    #wait for the command to finish
    delay 0.5
    #quit the terminal
    tell application "Terminal" to quit
  ]]
  local response=hs.osascript.applescript(applescript)
  hyper.triggered = true
end)

  -- to activate an applescript
--   local script=[[
--     -- ignoring application responses
-- tell application "Keyboard Maestro Engine"
-- 	do script "B0620731-234E-4757-AC8B-D1E595F9FC0A"
-- 	-- or: do script "Search the Baidu"
-- 	-- or: do script "B0620731-234E-4757-AC8B-D1E595F9FC0A" with parameter "Whatever"
-- end tell
-- -- end ignoring
--   ]]
--   hs.osascript.applescript(script)

-- a potentially useful demo
-- function newWindow() 
--   local app =` hs.application.find("Firefox")
--   app:selectMenuItem({"文件", "新建窗口"})
-- end
-- hs.hotkey.bind({'alt', 'ctrl', 'cmd'}, 'n', newWindow)

hyper:bind({}, "r", function()
  hs.eventtap.keyStroke({'cmd'}, 's')
  hs.reload()
  hyper.triggered = true
end)

hs.alert("Config loaded")
