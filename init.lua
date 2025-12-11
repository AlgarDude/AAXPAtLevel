-- AAXPAtLevel by Algar
-- Version 1.0
-- A script to automatically set AAXP to 100% once you reach the desired level.
-- /lua run aaxpatlevel ## to start, where ## is the desired level to reach before turning AAXP on.
local mq = require('mq')
local maxLevel = 999

local args = { ..., }
if args and #args == 1 then
    for _, v in ipairs(args) do
        local level = tonumber(v)
        if level then
            maxLevel = level
        end
        printf("AAXPAtLevel: Now monitoring. Current Level: %s. Desired Level: %s", mq.TLO.Me.Level(), maxLevel)
    end
else
    print("AAXPAtLevel: The desired level to turn AAXP on is required as the sole argument when this script is run. Example: '/lua run aaxpatlevel 65'. Exiting.")
    mq.exit()
end

---@diagnostic disable-next-line: undefined-field --PctExpToAA not in defs
if mq.TLO.Me.Level() < maxLevel and mq.TLO.Me.PctExpToAA() > 0 then
    print("AAXPAtLevel: We aren't at our desired level, turning AAXP off.")
    mq.cmd("/alt off")
    mq.delay(50)
end

while mq.TLO.Me.Level() < maxLevel do
    mq.delay(1000)
end

if mq.TLO.Me.Level() >= maxLevel then
    print("AAXPAtLevel: Max desired level detected, changing to AAXP.")
    mq.cmd("/alt on 100")
    ---@diagnostic disable-next-line: undefined-field --PctExpToAA not in defs
    mq.delay(500, function() return mq.TLO.Me.PctExpToAA() == 100 end)
    ---@diagnostic disable-next-line: undefined-field --PctExpToAA not in defs
    local aaxp = mq.TLO.Me.PctExpToAA()
    if aaxp == 100 then
        print("AAXPAtLevel: AAXP set to 100%, exiting.")
    else
        printf("AAXPAtLevel: Error! It seems we were unsuccesful in setting AAXP to 100%, the current value is %s. Manual adjustment is required!", aaxp)
        mq.exit()
    end
end
