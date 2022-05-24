

local events   = hs.eventtap.event.types
local module   = {}

-- Save this in your Hammerspoon configuration directiorn (~/.hammerspoon/) 
-- You either override timeFrame and action here or after including this file from another, e.g.
--
-- ctrlDoublePress = require("ctrlDoublePress")
-- ctrlDoublePress.timeFrame = 2
-- ctrlDoublePress.action = function()r
--    do something special
-- end

-- how quickly must the two single ctrl taps occur?
module.timeFrame = 0.5

-- what to do when the double tap of ctrl occurs
module.action = function()
    local applescript=[[
        tell application "Finder" to activate
        tell application "Finder" to open ("/Users/tianjiaye/Documents" as POSIX file)

    ]]
    hs.osascript.applescript(applescript)
end

local timeFirstControl, firstDown, secondDown = 0, false, false

-- verify that no keyboard flags are being pressed
local noFlags = function(ev)
    local result = true
    for k,v in pairs(ev:getFlags()) do
        if v then
            result = false
            break
        end
    end
    return result
end


-- verify that *only* the ctrl key flag is being pressed
local onlyCtrl = function(ev)
    local result = ev:getFlags().ctrl
    for k,v in pairs(ev:getFlags()) do
        if k ~= "ctrl" and v then
            result = false
            break
        end
    end
    return result
end

showProperty = function(ev)
    
end


-- the actual workhorse

module.eventWatcher = hs.eventtap.new({events.flagsChanged, events.keyDown}, function(ev)
    -- if it's been too long; previous state doesn't matter
    if (timer.secondsSinceEpoch() - timeFirstControl) > module.timeFrame then
        timeFirstControl, firstDown, secondDown = 0, false, false
    end

    if ev:getType() == events.flagsChanged then
        if noFlags(ev) and firstDown and secondDown then -- ctrl up and we've seen two, so do action
            if module.action then module.action() end
            timeFirstControl, firstDown, secondDown = 0, false, false
        elseif onlyCtrl(ev) and not firstDown then         -- ctrl down and it's a first
            firstDown = true
            timeFirstControl = timer.secondsSinceEpoch()
        elseif onlyCtrl(ev) and firstDown then             -- ctrl down and it's the second
            secondDown = true
        elseif not noFlags(ev) then                        -- otherwise reset and start over
            timeFirstControl, firstDown, secondDown = 0, false, false
        end
    else -- it was a key press, so not a lone ctrl char -- we don't care about it
        timeFirstControl, firstDown, secondDown = 0, false, false
    end
    return false
end):start()

-- module.mouseWatcher = hs.eventtap.new({events.leftMouseDown}, function(em)
--     a=em:getProperty(hs.eventtap.event.properties["mouseEventClickState"])
--     if a==2 then
--         local layout_icon=hs.keycodes.currentLayoutIcon()
--         local finder=hs.application.get("访达")
--         -- if (layout_icon and not finder:isFrontmost())then
--         --     local mouse_position=hs.mouse.getAbsolutePosition()
--         --     local canvas=hs.canvas.new{x=mouse_position.x,y=mouse_position.y-20,h=20,w=20}:appendElements(
--         --         {
--         --             --  type="image",
--         --             -- image=layout_icon,
                    
--         --         }
--         --     ):show()
--         --     hs.timer.doAfter(0.8,function()
--         --         canvas:delete()
--         --     end)
--         -- end
--         local text=""
--         if(layout_icon) then
--             text="A"
--         else
--             text="拼"
--         end
--         if not finder:isFrontmost() then 
--             local mouse_position=hs.mouse.getAbsolutePosition()
--             local canvas=hs.canvas.new{x=mouse_position.x+10,y=mouse_position.y-28,h=18,w=18}:appendElements(
--                 {
--                     type="text",
--                     text=hs.styledtext.new(text,{font={size=18}}),
--                 }
--             ):show()
--             hs.timer.doAfter(0.5,function()
--                 canvas:delete()
--             end)
--         end
--     end
--     return false
-- end):start()

return module