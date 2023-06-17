Config = {}

Config.UsingESXAbove12 = false -- Are you using ESX above 1.2?

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
