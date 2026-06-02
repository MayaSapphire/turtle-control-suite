local monitor = peripheral.find("monitor")
monitor.clear()
monitor.setCursorPos(1,1)
monitor.write("Reading config...")
local config = {}
local file,err = loadfile("config.txt", "t", config)
if file then
    file()
else
    monitor.clear()
    monitor.setCursorPos(1,1)
    monitor.write("Config read error!")
    monitor.setCursorPos(1,2)
    monitor.write(err)
    error()
end
 
monitor.clear()
monitor.setCursorPos(1,1)
monitor.write("Farming...")
turtle.forward()
turtle.forward()
local blocksMined = 0
function harvest()
    local blockPresent, blockData = turtle.inspectDown()
    if blockPresent == false then return true end
    if config.mode == 'age' then
        if blockData.state.age == nil then return true end
        if blockData.state.age < config.maxCropAge then return true end
        turtle.digDown()
        placeSuccess, err = turtle.placeDown()
        if placeSuccess == false then
            print("Place failed: " .. err)
        end
    elseif config.mode == 'block' then
        if blockData.name == config.targetBlock then
            turtle.digDown()
        end
    end
    blocksMined = blocksMined + 1
end
 
function row()
    for loops=1,8 do
        harvest()
        turtle.forward()
    end
    harvest()
end
 
for loops=1,4 do
    row()
    turtle.turnLeft()
    turtle.forward()
    turtle.turnLeft()
    row()
    turtle.turnRight()
    turtle.forward()
    turtle.turnRight()
end
row()
for loops=1,10 do
    turtle.back()
end
turtle.turnRight()
for loops=1,8 do
    turtle.forward()
end
turtle.turnLeft()
monitor.clear()
monitor.setCursorPos(1,1)
monitor.write("Depositing...")
turtle.forward()
turtle.turnRight()
turtle.forward()
turtle.forward()
if config.skipForward == false then
    turtle.forward()
end
itemsGained = 0
while turtle.getItemCount() > config.slot1Minimum do
   turtle.dropDown(1)
   itemsGained = itemsGained + 1 
end
for selected=2, 16 do
    turtle.select(selected)
    while turtle.getItemCount() > 0 do
        turtle.dropDown(1)
        itemsGained = itemsGained + 1
    end
end
turtle.select(1)
if config.skipForward == false then
    turtle.back()
end
turtle.back()
turtle.back()
turtle.turnLeft()
turtle.back()
monitor.clear()
monitor.setCursorPos(1,1)
monitor.write("Farming complete!\n")
monitor.setCursorPos(1,2)
monitor.write(blocksMined .. " blocks mined.")
monitor.setCursorPos(1,3)
monitor.write(itemsGained .. " items gained.")
monitor.setCursorPos(1,4)
monitor.write("System ready.\n")
 