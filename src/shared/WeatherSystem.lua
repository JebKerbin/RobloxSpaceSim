local WeatherSystem = {}

-- Weather effect types
local WEATHER_TYPES = {
    CLEAR = "Clear",
    RAIN = "Rain",
    DUST_STORM = "DustStorm",
    HEAVY_WIND = "HeavyWind"
}

-- Planet-specific weather configurations
local PLANET_WEATHER = {
    Kerbin = {
        possibleWeather = {WEATHER_TYPES.CLEAR, WEATHER_TYPES.RAIN},
        windStrength = {min = 0, max = 20}, -- m/s
        changeInterval = 300 -- seconds
    },
    Duna = {
        possibleWeather = {WEATHER_TYPES.CLEAR, WEATHER_TYPES.DUST_STORM},
        windStrength = {min = 5, max = 50},
        changeInterval = 600
    },
    Eve = {
        possibleWeather = {WEATHER_TYPES.HEAVY_WIND},
        windStrength = {min = 30, max = 100},
        changeInterval = 900
    }
}

function WeatherSystem.new(planetName)
    local self = {}
    self.planetName = planetName
    self.currentWeather = WEATHER_TYPES.CLEAR
    self.currentWindSpeed = 0
    
    function self:updateWeather()
        local planetConfig = PLANET_WEATHER[self.planetName]
        if not planetConfig then return end
        
        -- Randomly select weather
        local weatherIndex = math.random(1, #planetConfig.possibleWeather)
        self.currentWeather = planetConfig.possibleWeather[weatherIndex]
        
        -- Update wind speed
        self.currentWindSpeed = math.random(
            planetConfig.windStrength.min,
            planetConfig.windStrength.max
        )
        
        -- Create weather effects
        self:createWeatherEffects()
    end
    
    function self:createWeatherEffects()
        local effects = Instance.new("Folder")
        effects.Name = "WeatherEffects"
        
        if self.currentWeather == WEATHER_TYPES.RAIN then
            -- Create rain particles
            local rain = Instance.new("ParticleEmitter")
            rain.Rate = 100
            rain.Speed = NumberRange.new(50, 70)
            rain.Color = ColorSequence.new(Color3.fromRGB(200, 200, 255))
            rain.Parent = effects
        elseif self.currentWeather == WEATHER_TYPES.DUST_STORM then
            -- Create dust storm particles
            local dust = Instance.new("ParticleEmitter")
            dust.Rate = 50
            dust.Speed = NumberRange.new(30, 50)
            dust.Color = ColorSequence.new(Color3.fromRGB(255, 200, 150))
            dust.Parent = effects
        end
        
        effects.Parent = workspace
        return effects
    end
    
    -- Start weather system
    local function startWeatherCycle()
        while true do
            self:updateWeather()
            wait(PLANET_WEATHER[self.planetName].changeInterval)
        end
    end
    
    spawn(startWeatherCycle)
    return self
end

return WeatherSystem
