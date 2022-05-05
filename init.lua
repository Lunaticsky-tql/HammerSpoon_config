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
    hs.eventtap.keyStroke({},'escape')
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
  x = hs.application.open("/Applications/Deepl.app")
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
    menubar = hs.menubar.new(true)
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

hyper2:bind({}, "w", function()
  --activate the window focused before
  -- win = hs.window.find(win_id)
  win:focus()
  -- hs.alert.show("Window ID: "..win_id.." is activated")
  hyper2.triggered = true
end)


-- hyper2:bind({}, "1", function()
-- --keep the current focused window on top
--   while true do
--     local win = hs.window.focusedWindow()
--     if win then
--       win:focus()
--       hs.timer.usleep(100000)
--     else
--       break
--     end
--   end
--   hyper2.triggered = true
-- end)

hyper:bind({}, "s", function()
  hs.eventtap.keyStroke({'ctrl','cmd'}, '0')
  hyper.triggered = true
end)



-- hyper:bind({}, "x", function()
--   --use applescript to create a input dialog
--   local applescript=[[
--     tell application "System Events"
--       set dialog_text to "Please input the name of the file:"
--       set dialog_title to "Input Dialog"
--       set dialog_default to "default"
--       set the_text to "aaa"
--       set the_text to display dialog dialog_text default answer dialog_default
--       return the_text
--     end tell
--   ]]
--   --get the input from the dialog
--   input = hs.osascript.applescript(applescript)
--   hs.alert.show(input)
--   --create a file with the input name
--   file = io.open(input,"w")
--   --close the file
--   file:close()
--   --open the file
--   hs.application.open(input)
--   hyper.triggered = true
-- end)


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
