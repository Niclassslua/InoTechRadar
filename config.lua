Config = {}

Config.radarPenetrateMap = false -- Default: false
Config.radarPenetrateVehicles = true -- Default: true. NOTE: Might not be working when on false, suggest leaving alone for now
Config.radarPenetratePeds = true -- Default: true
Config.radarPenetrateObjects = false -- Default: false
Config.radarPenetrateFoliage = false -- Default: false

Config.globalRangeModifier = 1.0 -- Allows you to globally tweak ranges on radar. All ranges will be multiplied by this number. (Higher is "better". Default: 1.0
Config.globalFrequencyModifier = 1.0 -- Allows you to globally tweak refresh frequencies on radar. All refresh frequencies will be multiplied by this number (AKA higher is "better"). Please note that too high refresh frequencies may result in poor performance. Default: 1.0

Config.useCallsign = true -- If false, use player name instead of vehicle's callsign (the latter being randomly assigned by the game)
Config.useShortCallsign = false -- If true, uses only the last six letters of the callsign. Only has any effect if useCallsign is also enabled.

Config.KeyMapping = "F5" -- Changes the default openRadar hotkey for 'RegisterKeyMapping'


-- V1.0.1

Config.culling = true
Config.maxCulling = 30000.0 -- Changes the maximum culling radius
Config.minCulling = 1000.0 -- Changes the minimum culling radius
Config.stepCulling = 5000.0 -- Changes the step in which the culling radius is changed

Config.staticRadars = true

Config.staticRadarLocations = {
    {
        name = "Los Santos International Airport", 
        range = 85000, 
        frequency = 3000, 
        vector = vector3(-1237.42, -3199.51, 13.94),
        blip = {
            enabled = true,
            name = "Static Radar #1",
            sprite = 774,
            colour = 3,
            scale = 1.0
        }
    },

    {
        name = "Fort Zancudo", 
        range = 10000, 
        frequency = 3000, 
        vector = vector3(-2500.0, -3300.0, 115.0),
        blip = {
            enabled = true,
            name = "Static Radar #2",
            sprite = 774,
            colour = 3,
            scale = 1.0
        }
    }
}
