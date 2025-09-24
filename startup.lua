rednet.open("left")
BASE_ID = nil


-- Bootstrapper Program
while true do
    local id, msg, protocol = rednet.receive()

    if protocol == "IDLE_STATUS" then
        BASE_ID = id
        x, y, z = gps.locate()

        rednet.send(BASE_ID, {X = x, Y = y, Z = z}, "IDLE_STATUS")
        
    end

    if protocol == "BOOTSTRAP_PING" then
        rednet.send(BASE_ID, ("Turtle " .. os.getComputerID() .. " is Ready!"), "BOOTSTRAP_PING")

    end

    if protocol == "BOOTSTRAP_TASK" then
        local f = fs.open("task.lua", "w")

        f.write(msg.code)
        f.close()

        shell.run("task.lua")
        fs.delete("task.lua")

        rednet.send(BASE_ID, ("Turtle " .. os.getComputerID() .. " has Finished the Task!"), "BOOTSTRAP_TASK")

    end

end
