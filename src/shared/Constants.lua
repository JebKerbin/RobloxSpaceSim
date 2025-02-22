local Constants = {
    -- Planetary System Constants
    PLANETS = {
        KERBIN = {
            SIZE = 16384, -- studs (2D world)
            GRAVITY = 9.81,
            HAS_ATMOSPHERE = true,
            ATMOSPHERE_HEIGHT = 70000,
        },
        MUN = {
            SIZE = 512,
            GRAVITY = 1.63,
            HAS_ATMOSPHERE = false,
        },
        MINMUS = {
            SIZE = 256,
            GRAVITY = 0.49,
            HAS_ATMOSPHERE = false,
        },
        DUNA = {
            SIZE = 1024,
            GRAVITY = 2.94,
            HAS_ATMOSPHERE = true,
            ATMOSPHERE_HEIGHT = 50000,
        },
        EVE = {
            SIZE = 2048,
            GRAVITY = 16.7,
            HAS_ATMOSPHERE = true,
            ATMOSPHERE_HEIGHT = 90000,
        },
        JOOL = {
            SIZE = 2048,
            GRAVITY = 7.85,
            HAS_ATMOSPHERE = true,
            ATMOSPHERE_HEIGHT = 200000,
        },
        LAYTHE = {
            SIZE = 512,
            GRAVITY = 5.82,
            HAS_ATMOSPHERE = true,
            ATMOSPHERE_HEIGHT = 50000,
        }
    },

    -- Physics Constants
    DRAG_COEFFICIENT = 0.2,
    GRAVITY = 9.81,
    ATMOSPHERE_HEIGHT = 70000, -- meters

    -- Part Types
    PART_TYPES = {
        COMMAND_MODULE = "Command Module",
        ENGINE = "Engine",
        FUEL_TANK = "Fuel Tank",
        PARACHUTE = "Parachute"
    },

    -- UI Colors
    UI_COLORS = {
        BACKGROUND = Color3.fromRGB(36, 36, 36),
        TEXT = Color3.fromRGB(255, 255, 255),
        BUTTON = Color3.fromRGB(48, 48, 48),
        WARNING = Color3.fromRGB(255, 165, 0),
        ERROR = Color3.fromRGB(255, 0, 0),
        SUCCESS = Color3.fromRGB(0, 255, 0)
    }
}

return Constants