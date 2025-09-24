-- Global Variables
TARGET_SAPLING = "lepidodendron:nothofagus_sapling"
TARGET_COORDINATES = arg[1]
CLEAR_ALTITUDE = 12


-- Functions
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

function getPosition()
    x, y, z = gps.locate()
    return {X = x, Y = y, Z = z}
end

function getRotation(coord1)
    turtle.forward()
    coord2 = getPosition()
    turtle.back()

    if coord2.X > coord1.X then
        return "EAST"

    elseif coord2.X < coord1.X then
        return "WEST"

    end

    if coord2.Z > coord1.Z then
        return "SOUTH"

    elseif coord2.Z < coord1.Z then
        return "NORTH"

    end
end

-- Main Code
position = getPosition()
rotation = nil

-- Climb to altitude that clears the farm walls
enoughFuel = turtle.getFuelLevel() > ((2 * (CLEAR_ALTITUDE - position.Y)) + 2)

if enoughFuel then
    startingY = position.Y

    while position.Y < CLEAR_ALTITUDE do
        turtle.up()
        position.Y = position.Y + 1

    end

    rotation = getRotation(position)

    while position.Y > startingY do
        turtle.down()
        position.Y = position.Y - 1

    end

else
    print("Not Enough Fuel: " .. turtle.getFuelLevel())

end

-- Find best coordinate as destination
print(tableToString(position))
print(rotation)