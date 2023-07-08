--
--
--
-- OPTIONAL CONFIG END
-- DON'T CHANGE ANYTHING BELOW THIS LINE UNLESS YOU KNOW WHAT YOU'RE DOING
--
--
--

local convertRadarTable = false

local testRayVehicle = nil
local radarIsOpen = false
local StaticradarIsOpen = false
local currentlyInFirstPerson = false
local canOpenRadar = false
local localRadarData = {} --TODO: Populate this
local _radarEnabledVehicles = {} -- Init only table
local lastRadarUpdate = 0
local quickRadarInfoUpdate = false

debugMode = false -- Bad things happen if you touch this.


--[[ 
Values: radarRange, radarType, radarUpdateFreq
radarTypes:
1 - Civilian Standard Radar
2 - Military Standard Radar
3 - SONAR
--]]

-- AIRPLANES

_radarEnabledVehicles["ah64d"] = {2000, 1, 300} --3.33Hz
_radarEnabledVehicles["f16c"] = {4000, 1, 200} --5.00Hz
_radarEnabledVehicles["f22a"] = {5000, 1, 143} --6.99Hz
_radarEnabledVehicles["a10at"] = {2500, 1, 400} --2.50Hz
_radarEnabledVehicles["osprey"] = {3000, 1, 500} --2.00Hz
_radarEnabledVehicles["globe"] = {4500, 1, 160} --6.25Hz
_radarEnabledVehicles["ac130u"] = {8000, 1, 125} --8.00Hz
_radarEnabledVehicles["kc135r"] = {3500, 1, 300} --3.33Hz
_radarEnabledVehicles["kc10"] = {4000, 1, 300} --3.33Hz
_radarEnabledVehicles["ah1z"] = {2000, 1, 300} --3.33Hz
_radarEnabledVehicles["bone"] = {6000, 1, 250} --4.0Hz
_radarEnabledVehicles["f15ce"] = {3500, 1, 250} --5.00Hz
_radarEnabledVehicles["f35bl"] = {7000, 1, 125} --8.00Hz
_radarEnabledVehicles["galaxy"] = {3500, 1, 500} --2.00Hz
_radarEnabledVehicles["mh6"] = {3000, 1, 250} --4.00Hz
_radarEnabledVehicles["mh60lbh"] = {3500, 1, 250} --4.00Hz
_radarEnabledVehicles["mh60s"] = {3500, 1, 250} --4.00Hz
_radarEnabledVehicles["fa18f1"] = {4000, 1, 200} --5.00Hz
_radarEnabledVehicles["f14d2"] = {3500, 1, 250} --4.00Hz
_radarEnabledVehicles["f14a2"] = {3500, 1, 250} --4.00Hz
_radarEnabledVehicles["f15c2"] = {3500, 1, 250} --4.00Hz
_radarEnabledVehicles["mhx"] = {5000, 1, 250} --4.00Hz
_radarEnabledVehicles["ahx"] = {5000, 1, 250} --4.00Hz
_radarEnabledVehicles["euro"] = {3000, 1, 250} --4.00Hz
_radarEnabledVehicles["mh60mv"] = {3500, 1, 250} --4.00Hz
_radarEnabledVehicles["ciatec135"] = {3000, 1, 250} --4.00Hz
_radarEnabledVehicles["mi26"] = {3000, 1, 500} --2.00Hz
_radarEnabledVehicles["mig29a"] = {4000, 1, 200} --5.00Hz
_radarEnabledVehicles["mig31"] = {4500, 1, 181} --5.52Hz
_radarEnabledVehicles["mi24p"] = {3000, 1, 300} --3.33Hz
_radarEnabledVehicles["mi28"] = {3000, 1, 300} --3.33Hz
_radarEnabledVehicles["ka60"] = {2000, 1, 400} --2.50Hz
_radarEnabledVehicles["mig23"] = {3000, 1, 250} --4.00Hz
_radarEnabledVehicles["su24m"] = {4500, 1, 181} --5.52Hz
_radarEnabledVehicles["flankerf"] = {4000, 1, 200} --5.00Hz
_radarEnabledVehicles["su75"] = {8000, 1, 111} --9.01Hz
_radarEnabledVehicles["tu95"] = {5000, 1, 500} --2.00Hz
_radarEnabledVehicles["ka52"] = {2000, 1, 300} --3.33Hz
_radarEnabledVehicles["tu22m3"] = {5000, 1, 300} --3.33Hz
_radarEnabledVehicles["il76"] = {4500, 1, 160} --6.25Hz
_radarEnabledVehicles["su34"] = {3500, 1, 250} --4.00Hz



_radarEnabledVehicles["titan"] = {6000, 2, 1500}
_radarEnabledVehicles["lazer"] = {3500, 2, 250}
_radarEnabledVehicles["hydra"] = {4000, 2, 500}
_radarEnabledVehicles["besra"] = {3500, 2, 500}
_radarEnabledVehicles["jet"] = {3000, 1, 1000}
_radarEnabledVehicles["cargoplane"] = {3500, 1, 1000}
_radarEnabledVehicles["luxor"] = {2250, 1, 1000}
_radarEnabledVehicles["luxor2"] = {2250, 1, 1000}
_radarEnabledVehicles["shamal"] = {2250, 1, 1000}
_radarEnabledVehicles["nimbus"] = {2250, 1, 1000}
_radarEnabledVehicles["miljet"] = {3250, 2, 1000}

-- HELICOPTERS
_radarEnabledVehicles["savage"] = {3800, 2, 750}
_radarEnabledVehicles["buzzard"] = {2800, 2, 1000}
_radarEnabledVehicles["valkyrie"] = {2500, 2, 1000}
_radarEnabledVehicles["valkyrie2"] = {2500, 2, 1000}
_radarEnabledVehicles["annihilator"] = {3500, 2, 1000}
_radarEnabledVehicles["skylift"] = {2000, 1, 1000}
_radarEnabledVehicles["cargobob"] = {2500, 2, 1000}
_radarEnabledVehicles["cargobob2"] = {2000, 1, 1000}
_radarEnabledVehicles["cargobob3"] = {2500, 2, 1000}
_radarEnabledVehicles["cargobob4"] = {2500, 2, 1000}

-- BOATS
_radarEnabledVehicles["predator"] = {2500, 1, 4000}
_radarEnabledVehicles["tug"] = {2500, 1, 4000}

-- SUBS
_radarEnabledVehicles["submersible"] = {2000, 3, 3000}
_radarEnabledVehicles["submersible2"] = {2000, 3, 3000}

validRadarTargets = {}
validRadarTargets[1] = {14, 15, 16} -- Boats, helicopters, planes
validRadarTargets[2] = {14, 15, 16} -- Boats, helicopters, planes
validRadarTargets[3] = {14} -- Boats

radarNames = {}
radarNames[1] = "radar"
radarNames[2] = "radar"
radarNames[3] = "sonar"


radarEnabledVehicles = {} -- Real table, do not touch

if convertRadarTable then
	for k, v in pairs(_radarEnabledVehicles) do -- Convert our init table to our real table with hashes
		hashKey = GetHashKey(k, _r)
		radarEnabledVehicles[hashKey] = v
	end
else
	radarEnabledVehicles = _radarEnabledVehicles
end

function searchTable(t, searchValue)
	for k,v in pairs(t) do
		if v == searchValue then
			return k
		end
	end
	return nil
end

function contains(t, searchValue)
	if searchTable(t, searchValue) ~= nil then
		return true
	end
	return false
end

function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

function output(obj)
	obj = tostring(obj)
	TriggerEvent("chatMessage", "", { 0, 0, 0 }, "" .. obj)
end

function displayNotification(msg)
	SetNotificationTextEntry("STRING");
	AddTextComponentString(tostring(msg))
	DrawNotification(false, true);
end

function getRadarEntry(vehicle)
	for k, v in pairs(radarEnabledVehicles) do
		if IsVehicleModel(vehicle, GetHashKey(k, _r)) then
			return radarEnabledVehicles[k]
		end
	end
	return nil -- obv superfluous
end

function isRadarCapable(vehicle)
	local radarEntry = getRadarEntry(vehicle)
	if radarEntry ~= nil then
		--TriggerEvent("chatMessage", "", { 0, 0, 0 }, "Radar range: "..radarEntry[1])
		return true
	end
	return false
end

function getRadarRange(vehicle)
	local radarEntry = getRadarEntry(vehicle)
	if radarEntry ~= nil then
		return radarEntry[1] * Config.globalRangeModifier
	end
	return 0
end

function getRadarType(vehicle)
	local radarEntry = getRadarEntry(vehicle)
	if radarEntry ~= nil then
		return radarEntry[2]
	end
	return 0
end

function getRadarName(vehicle)
	local radarType = getRadarType(vehicle)
	if radarType ~= 0 then
		return radarNames[radarType]
	end
	return "RADAR_NO_NAME"
end

function getRadarFrequency(vehicle)
	local radarEntry = getRadarEntry(vehicle)
	if radarEntry ~= nil then
		return radarEntry[3] / Config.globalFrequencyModifier
	end
	return 99999999
end


function getRayTraceFlags(baseFlags)
	local rayTraceFlags = baseFlags or 0
	if not Config.radarPenetrateMap then
		rayTraceFlags = rayTraceFlags + 1
	end
	if not Config.radarPenetrateVehicles then
		rayTraceFlags = rayTraceFlags + 2
	end
	if not Config.radarPenetratePeds then
		rayTraceFlags = rayTraceFlags + 4
	end
	if not Config.radarPenetrateObjects then
		rayTraceFlags = rayTraceFlags + 16
	end
	if not Config.radarPenetrateFoliage then
		rayTraceFlags = rayTraceFlags + 256
	end
	return rayTraceFlags
end
	

function positionTrace(pos1x, pos1y, pos1z, pos2x, pos2y, pos2z, ignoreEntity, expectedTarget)
	rayTraceFlags = getRayTraceFlags()
	rayHandle = CastRayPointToPoint(pos1x, pos1y, pos1z, pos2x, pos2y, pos2z, rayTraceFlags, ignoreEntity, 0)
	_,collisionFlag,_,_,_ = GetRaycastResult(rayHandle)
	collided = (collisionFlag ~= 0)
	--TriggerEvent("chatMessage", "", { 0, 0, 0 }, "a:" .. a .. " b:" .. b .. " c:" .. c .. " d:" .. d .. " e:" .. e)
	if collided then
		--output("Ray did not reach target")
		return false
	else
		--output("Ray reached target")
		return true
	end
end

function trace(entity1, entity2)
	local coords1 = GetEntityCoords(entity1, false)
	local coords2 = GetEntityCoords(entity2, false)
	return positionTrace(coords1.x, coords1.y, coords1.z, coords2.x, coords2.y, coords2.z, entity1, entity2)
end
	
function isEntityUnderwater(entity)
	--local coords1 = GetEntityCoords(entity1, false)
	submergedLevel = GetEntitySubmergedLevel(entity)
	return submergedLevel > 0.9
end

function isActiveSonar()
	return true --TODO
end

function isPedValidRadarTarget(ped, radarType)
	if IsPedSittingInAnyVehicle(ped) then -- TODO: May need to add !IsPedInAnySub?
		local vehicle = GetVehiclePedIsIn(ped, false)
		if DoesEntityExist(vehicle) and isVehicleValidRadarTarget(vehicle, radarType) then
			if GetVehicleEngineHealth(vehicle) ~= -4000.0 and GetVehicleBodyHealth(vehicle) ~= 0.0 and GetVehiclePetrolTankHealth(vehicle) ~= -1000.0 then
				if GetPedInVehicleSeat(vehicle, -1) == ped then -- TODO: incl passengers?
					local isSubmerged = isEntityUnderwater(vehicle)
					if radarType == 3 then -- if SONAR
						if IsEntityInWater(vehicle) then
							if isSubmerged then
								if isActiveSonar() or IsVehicleEngineOn(vehicle) then
									return vehicle
								end
							else
								return vehicle
							end
						end
					else
						if not isSubmerged then
							return vehicle
						end
					end
				end
			end
		end
	end
end

function isVehicleValidRadarTarget(vehicle, radarType)
	local vClass = GetVehicleClass(vehicle)
	local classValid = contains(validRadarTargets[radarType], vClass)
	return classValid
end
	
function radarHasClearPath(sourcePed, targetPed)
	return true -- TODO: Add trace function here
end

function getDistance(x1, y1, z1, x2, y2, z2, onlyHorizontal)
	onlyHorizontal = onlyHorizontal or false
	if onlyHorizontal then
		z1 = z2
	end
	return Vdist(x1, y1, z1, x2, y2, z2)
end

function getVectorDistance(v1, v2, onlyHorizontal)
	x1, y1, z1 = table.unpack(v1)
	x2, y2, z2 = table.unpack(v2)
	return getDistance(x1, y1, z1, x2, y2, z2, onlyHorizontal)
end
	
function isEntityInCapsule(entity, range) --TODO: This.
	local targetCoords = GetEntityCoords(entity, false)
	local playerCoords = GetEntityCoords(GetPlayerPed(-1), false)
	if GetDistanceBetweenCoords(targetCoords.x, targetCoords.y, 0, playerCoords.x, playerCoords.y, 0, false) <= range then
		return true
	end
	return false
end

function getPedsInSession(includeSelf)
	includeSelf = includeSelf or false
	local peds, myPed, pool = {}, GetPlayerPed(-1), GetGamePool('CPed')

	for i=1, #pool do
        if includeSelf or (pool[i] ~= myPed) then
            table.insert(peds, pool[i])
        end
    end

	return peds
end

function isInFirstPerson()
	return (GetFollowPedCamViewMode() == 4) and (IsGameplayCamLookingBehind() ~= 1)
end

-- Safe to be spam called. Checks if your first person status has changed, and if so, tells js about it.
function updateCamera()
	local _fp = isInFirstPerson()
	if _fp ~= currentlyInFirstPerson then -- Check if our camera status changed. No need to send NUI message if not.
		SendNUIMessage({
			command = "updateCamera",
			isInFirstPerson = _fp,
		})
		currentlyInFirstPerson = _fp
		--output(_fp)
	end
end

-- Do not spam call.
function setRadarOpen(enable)
	if enable then
		updateCamera()
	end
	SendNUIMessage({
		command = "setRadarOpen",
		enable = enable,
	})
	radarIsOpen = enable
end

function getTime()
	return GetNetworkTime()
end

function getDeltaEntityCoords(entity1, entity2)
	local coords1 = GetEntityCoords(entity1, false)
	local coords2 = GetEntityCoords(entity2, false)
	return {coords2.x - coords1.x, coords2.y - coords1.y, coords2.z - coords1.z}
end

function getFakeVehicle(vehicle)
	local coords1 = GetEntityCoords(vehicle, false)
	return {vehX = coords1.x, vehY = coords1.y, vehZ = coords1.z, vehClass=14, vehSpeed=230, vehName="KTL915"}
end

function GetPeds(onlyOtherPeds)
	local peds, myPed, pool = {}, GetPlayerPed(-1), GetGamePool('CPed')

	for i=1, #pool do
        if ((onlyOtherPeds and pool[i] ~= myPed) or not onlyOtherPeds) then
            table.insert(peds, pool[i])
        end
    end

	return peds
end

function updateLocalRadarData(vehicle) -- Could use some tidying up tbh, split up into smaller functions.
	localRadarData = {}
	local range = getRadarRange(vehicle)
	local radarType = getRadarType(vehicle)
	local vehName = "UNKNOWN"

	for playerNum, ped in pairs(GetPeds(not debugMode)) do
		-- print(playerNum, ped)
		local otherVehicle = isPedValidRadarTarget(ped, radarType)
		if otherVehicle ~= nil then
			if isEntityInCapsule(otherVehicle, range) then
				if trace(vehicle, otherVehicle) then
					if GetVehiclePedIsIn(PlayerPedId(), false) ~= otherVehicle then
						local vehCoords = getDeltaEntityCoords(vehicle, otherVehicle)
						local vehClass = GetVehicleClass(otherVehicle)
						local vehSpeed = GetEntitySpeed(otherVehicle)
						local csign = string.sub(GetVehicleNumberPlateText(otherVehicle), -3)
						if Config.useCallsign then
							vehName = string.upper(GetDisplayNameFromVehicleModel(GetEntityModel(otherVehicle)) .. " " .. csign)
							if Config.useShortCallsign then
								if #vehName >= 8 then --does this even work?
									vehName = vehName:sub(3)
								end
							end
						else
							vehName = GetPlayerName(playerNum)
						end
						-- print(vehCoords[1], vehCoords[2], vehCoords[3], vehClass, vehSpeed, vehName)
						table.insert(localRadarData, {vehX = vehCoords[1], vehY = vehCoords[2], vehZ = vehCoords[3], vehClass = vehClass, vehSpeed = vehSpeed, vehName = vehName})
					end
				end
			end
		end
	end
	if debugMode then
		table.insert(localRadarData, getFakeVehicle(vehicle))
	end
	return localRadarData
end

function updateRadarInfo(vehicle)
	local range = getRadarRange(vehicle)
	local freq = getRadarFrequency(vehicle)
	local radarType = getRadarType(vehicle)
	local radarName = getRadarName(vehicle)
	local forwardX = GetEntityForwardX(vehicle)
	local forwardY = GetEntityForwardY(vehicle)
	local yaw = math.atan(forwardY, forwardX)

	print(range, freq, radarType, radarName, forwardX, forwardY, yaw)

	SendNUIMessage({
		command = "updateRadarInfo",
		range = range,
		freq = freq,
		yaw = yaw,
		radarType = radarType,
		radarName = radarName,
		radarTargets = #localRadarData,
	})
end
	
function updateRadarData(vehicle)
	updateCamera()
	local curTime = getTime()
	local vehFreq = getRadarFrequency(vehicle)
	if quickRadarInfoUpdate then
		updateRadarInfo(vehicle)
	end
	-- print((curTime - lastRadarUpdate), getRadarFrequency(vehicle), curTime - lastRadarUpdate >= getRadarFrequency(vehicle))
	if curTime - lastRadarUpdate >= getRadarFrequency(vehicle) then
		jsTimerTestStart()
		lastRadarUpdate = curTime
		if not quickRadarInfoUpdate then
			updateRadarInfo(vehicle)
		end
		updateLocalRadarData(vehicle)
		SendNUIMessage({
			command = "updateRadarData",
			radarData = localRadarData,
		})
		--jsTimerTestEnd()
	end
end

function jsTimerTestStart()
	SendNUIMessage({
		command = "radarTimerStart"
	})
end

function jsTimerTestEnd()
	SendNUIMessage({
		command = "radarTimerEnd"
	})
end

function setActiveSonar(active)
	SendNUIMessage({
		command = "setActiveSonar",
		active = active,
	})
end






CreateThread(function()
    if Config.staticRadars then
        for k,v in pairs(Config.staticRadarLocations) do
            if Config.staticRadarLocations[k].blip.enabled then
                local blip = AddBlipForCoord(Config.staticRadarLocations[k].vector)
                SetBlipSprite(blip, Config.staticRadarLocations[k].blip.sprite)
                SetBlipColour(blip, Config.staticRadarLocations[k].blip.colour)
                SetBlipScale(blip, Config.staticRadarLocations[k].blip.scale)
                SetBlipAsShortRange(blip, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(Config.staticRadarLocations[k].blip.name)
                EndTextCommandSetBlipName(blip)
            end
        end
    end
end)













function setStaticRadarOpen(enable, range, freq, radarType, radarName, forwardX, forwardY, yaw)

	print(enable, range, freq, radarType, radarName, forwardX, forwardY, yaw)

	if enable then

		SendNUIMessage({
			command = "updateRadarInfo",
			range = range,
			freq = freq,
			yaw = yaw,
			radarType = radarType,
			radarName = radarName,
			radarTargets = #localRadarData,
		})

	end

	SendNUIMessage({
		command = "setRadarOpen",
		enable = enable,
	})

	StaticradarIsOpen = enable
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(50)
		_canOpenRadar = false
		local vehicle = nil
		if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
			vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
			if DoesEntityExist(vehicle) then
				if GetVehicleEngineHealth(vehicle) ~= -4000.0 and GetVehicleBodyHealth(vehicle) ~= 0.0 and GetVehiclePetrolTankHealth(vehicle) ~= -1000.0 then
					if isRadarCapable(vehicle) then
						-- print("updateRadarData")
						updateRadarData(vehicle)
						_canOpenRadar = true
					end
				end
			end
		else
			if not StaticradarIsOpen then
				setRadarOpen(false)
			end
		end
		-- if canOpenRadar == false and _canOpenRadar == true then -- Just entered radar capable vehicle
		-- 	displayNotification("Vehicle has " .. getRadarName(vehicle) .. " capabilities. Press ~p~".. openRadarHotkeyName.. "~s~ (or "..openRadarHotkeyNameController..") to toggle.")
		-- end
		canOpenRadar = _canOpenRadar
    end
end)


local activestatic

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

		local ped = GetPlayerPed(-1)
		local coords = GetEntityCoords(ped)

		if Config.staticRadars then
			for k,v in pairs(Config.staticRadarLocations) do
				if GetDistanceBetweenCoords(coords, Config.staticRadarLocations[k].vector, true) <= 1.5 and not StaticradarIsOpen then
					SetTextComponentFormat("STRING")
					AddTextComponentString("Press ~INPUT_PICKUP~ to open the static radar")
					DisplayHelpTextFromStringLabel(0, 0, 1, -1)

					if IsControlJustPressed(0, 38) then
						local forwardX = GetEntityForwardX(GetEntityCoords(ped))
						local forwardY = GetEntityForwardY(GetEntityCoords(ped))
						local yaw = math.atan(forwardY, forwardX)

						activestatic = Config.staticRadarLocations[k]

						setStaticRadarOpen(true, Config.staticRadarLocations[k].range, Config.staticRadarLocations[k].frequency, 1, "radar", forwardX, forwardY, yaw)
					end
				elseif activestatic ~= nil then
					if GetDistanceBetweenCoords(coords, activestatic.vector, true) > 1.5 and StaticradarIsOpen then
						setStaticRadarOpen(false)
					end
				end
			end
		end
    end
end)



-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(0)
		
-- 		-- OPEN RADAR TOGGLE
		
-- 		local hasPressed = IsControlJustPressed(0, openRadarHotkey)
-- 		if radarIsOpen then
-- 			if hasPressed or not canOpenRadar then
-- 				setRadarOpen(false)
-- 				--output("Closing radar.")
-- 			end
-- 		elseif hasPressed and canOpenRadar then
-- 			setRadarOpen(true)
-- 			--output("Opening radar.")
-- 		end
		
-- 		-- ACTIVE SONAR TOGGLE
		
-- 		-- local hasPressed = IsControlJustPressed(0, activeSonarHotkey)

--     end
-- end)

RegisterCommand("openRadar", function(source, args, raw)
	if radarIsOpen then
		setRadarOpen(false)
	elseif canOpenRadar then
		setRadarOpen(true)
	end
end, false)
  
RegisterKeyMapping("openRadar", "Open Radar", "keyboard", Config.KeyMapping)

function spawnDebugVehicle(vehicleName, xOffset)
	local xOffset = xOffset or 0
	local vehicleModel = GetHashKey(vehicleName)
	RequestModel(vehicleModel)
	while not HasModelLoaded(vehicleModel) do
		Wait(1)
	end
	firstSpawnCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), xOffset, 10.0, 0)
	testRayVehicle = CreateVehicle(vehicleModel, firstSpawnCoords, GetEntityHeading(myPed), true, false)
	SetVehicleOnGroundProperly(testRayVehicle)
	SetModelAsNoLongerNeeded(vehicle)
	--SetEntityAsNoLongerNeeded(testRayVehicle)
end

AddEventHandler("playerSpawned", function(spawn)
	setRadarOpen(false)
end)
