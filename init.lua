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
    hs.eventtap.keyStroke({'ctrl','alt','cmd'}, 's')
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
    -- hs.alert('front')
    temp_clipboard = hs.pasteboard.uniquePasteboard()
    hs.pasteboard.writeAllData(temp_clipboard,hs.pasteboard.readAllData(nil))
    hs.pasteboard.writeObjects(sql_input)
    hs.eventtap.keyStroke({'cmd'}, 'v')
    hs.pasteboard.writeAllData(nil,hs.pasteboard.readAllData(temp_clipboard))
    hs.pasteboard.deletePasteboard(temp_clipboard)
    hs.eventtap.keyStroke({}, 'return')
  end
  hyper.triggered = true
end)

hyper2:bind({}, "2", function()
  hs.eventtap.keyStrokes('2013599_田佳业_')
  hyper2.triggered = true
end)

hyper2:bind({}, "1", function()
  local qqq=hs.canvas.defaultTextStyle()

  hyper2.triggered = true
end)

hyper:bind({}, "s", function()
  hs.eventtap.keyStroke({'ctrl','cmd'}, '0')
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
