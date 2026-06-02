monitor = peripheral.find("monitor")
monitor.setCursorPos(1,1)
monitor.clear()
 
local config = {}
local file,err = loadfile("config.txt", "t", config)
if file then
    file()
    print("Farm Configuration")
    print("Max crop age: "..config.maxCropAge)
    print("Slot 1 minimum: "..config.slot1Minimum)
    if config.skipForward then
        print("Skip forward: ENABLED")
    else
        print("Skip forward: DISABLED")
    end
    print("Mode: "..config.mode)
    print("Target block: "..config.targetBlock)
else
    monitor.write("Config read error!")
    error()
    print(err)
end
 
monitor.write("System ready.")
while true do
    :: continue ::
    
    local eventData = {os.pullEvent()}
    local event = eventData[1]
    if event == "monitor_touch" then
        os.run({continuous=false},"farm.lua")
    elseif event == "terminate" then 
        monitor.setCursorPos(1,1)
        monitor.clear()
        monitor.write("Program terminated.")
    end
end
 