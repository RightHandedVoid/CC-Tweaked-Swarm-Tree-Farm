--              Global Variables
monitor = peripheral.find("monitor")


--              Basic Functions
function writeLog(text)
    -- Assuming Monitor Peripheral Already Exist
    if text == nil then
        monitor.clear()
        monitor.setCursorPos(1,1)
    end

    monitor.write(text)
    curX, curY = monitor.getCursorPos()
    
    local newX = 1
    local newY = curY + 1
    
    monitor.setCursorPos(newX, newY)
end

function tableLength(T)
    local count = 0

    for _ in pairs(T) do
        count = count + 1
    end

    return count
end

function tableToString(tbl)
    local result = "{"
    for k, v in pairs(tbl) do
        local key = type(k) == "string" and '"' .. k .. '"' or k
        local value = type(v) == "table" and tableToString(v) or '"' .. tostring(v) .. '"'
        result = result .. "[" .. key .. "]=" .. value .. ","
    end
    return result .. "}"
end


--              Pipeline Functions
function getIdleReports()
    local activeProtocol = "IDLE_STATUS"
    local turtleQueue = {}

    rednet.broadcast("Idle Report", activeProtocol)
    
    while true do
        local id, message, protocol = rednet.receive(activeProtocol, 5)

        if not id then
            writeLog("No Messages Received... Continuing Program...")

            return turtleQueue

        end

        if protocol == activeProtocol then
            writeLog("Turtle ID " .. id .. " has reported self status!")

            queueLength = tableLength(turtleQueue)
            turtleQueue[(queueLength + 1)] = {Computer_ID = id, Computer_GPS = message}
        end

    end

end

function verifyActiveBootstrap(workerID)
    local activeProtocol = "BOOTSTRAP_PING"
    rednet.send(workerID, "Are you ready kid?", activeProtocol)

    local id, message, protocol = rednet.receive(activeProtocol, 5)

    if not id then
        writeLog("Turtle ID " .. id .. "is non responsive... Continuing...")

        return false

    end

    if protocol == activeProtocol then
        writeLog("Turtle ID " .. id .. " is ready for tasks!")

        return true

    end

end


--              Main Code
rednet.open("top")

SAPLING_COORDINATE = {X = -1980, Y = 8, Z = -221}
FARM_BOUNDING_COORDINATES = {
    START = {X = -1992, Y = 8, Z = -233},
    END = {X = -1967, Y = 30, Z = -208}
}

writeLog() -- Clear Monitor Screen

-- Find Idle Turtles and Check if They're Ready
idleTurtles = getIdleReports()

for i = 1, #idleTurtles do
    workerTable = idleTurtles[i]

    if not verifyActiveBootstrap(workerTable.Computer_ID) then
        table.remove(idleTurtles, i)

    end

end

print(tableToString(idleTurtles))