local RocketParts = {}

local PARTS = {
    COMMAND_POD = {
        name = "Command Pod",
        mass = 1000,
        size = Vector3.new(2, 2, 2),
        color = Color3.fromRGB(200, 200, 200)
    },
    FUEL_TANK = {
        name = "Fuel Tank",
        mass = 2000,
        size = Vector3.new(2, 4, 2),
        color = Color3.fromRGB(180, 180, 180),
        fuelCapacity = 1000
    },
    ENGINE = {
        name = "Basic Engine",
        mass = 1500,
        size = Vector3.new(2, 3, 2),
        color = Color3.fromRGB(150, 150, 150),
        thrust = 15000,
        fuelConsumption = 10
    }
}

function RocketParts.createPart(partType)
    local partData = PARTS[partType]
    if not partData then return nil end
    
    local part = Instance.new("Part")
    part.Name = partData.name
    part.Size = partData.size
    part.Color = partData.color
    part.Material = Enum.Material.Metal
    
    -- Add custom properties
    local properties = Instance.new("Configuration")
    for k, v in pairs(partData) do
        if k ~= "name" and k ~= "size" and k ~= "color" then
            properties[k] = v
        end
    end
    properties.Parent = part
    
    return part
end

function RocketParts.getPartsList()
    local list = {}
    for partType, data in pairs(PARTS) do
        table.insert(list, {
            type = partType,
            name = data.name,
            mass = data.mass
        })
    end
    return list
end

return RocketParts
