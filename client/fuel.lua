local vehicles = {}
local lastNitro = 0
local nitroCooldown = 2500

local nitroFuelSize = 100
local nitroFuelDrainRate = 3.3
local nitroPurgeFuelDrainRate = nitroFuelDrainRate * 1.4
local nitroRechargeRate = nitroFuelDrainRate / 1.3

function InitNitroFuel(vehicle)
  if not vehicles[vehicle] then
    vehicles[vehicle] = nitroFuelSize
  end
end

function DrainNitroFuel(vehicle, purge)
  if not purge then
    purge = false
  end

  if not vehicles[vehicle] then
    vehicles[vehicle] = nitroFuelSize
  end

  if vehicles[vehicle] > 0 then
    if purge then
      vehicles[vehicle] = vehicles[vehicle] - nitroPurgeFuelDrainRate * 2
    else
      vehicles[vehicle] = vehicles[vehicle] - nitroFuelDrainRate
    end

    lastNitro = GetGameTimer()
  end
end

function RechargeNitroFuel(vehicle)
  if not vehicles[vehicle] then
    vehicles[vehicle] = nitroFuelSize
  end

  if vehicles[vehicle] and vehicles[vehicle] < nitroFuelSize then
    vehicles[vehicle] = vehicles[vehicle] + nitroRechargeRate
  end
end

function RechargeNitroFuelVNX(paramVehicle)
  if not vehicles[paramVehicle] then
    vehicles[paramVehicle] = nitroFuelSize
  end

  if vehicles[paramVehicle] and vehicles[paramVehicle] < nitroFuelSize then
    vehicles[paramVehicle] = vehicles[paramVehicle] + nitroFuelSize
  end
end

exports("RechargeNitroFuelVNX", RechargeNitroFuelVNX)

function GetNitroFuelLevel(vehicle)
  if vehicles[vehicle] then
    local nosLevel = math.max(0, vehicles[vehicle]) --exports["str-vehicles"].noslevel()

    print("NOS LEVEL => " .. nosLevel)

    return nosLevel;

    -- return math.max(0, vehicles[vehicle])
  end

  return 0
end

function SetNitroFuelLevel(vehicle, level)
  vehicles[vehicle] = level
end

Citizen.CreateThread(function()
  local function FuelLoop()
    local player = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(player)
    local driver = GetPedInVehicleSeat(vehicle, -1)
    local isRunning = GetIsVehicleEngineRunning(vehicle)
    local isBoosting = IsVehicleNitroBoostEnabled(vehicle)
    local isPurging = IsVehicleNitroPurgeEnabled(vehicle)

    if vehicle == 0 or driver ~= player or not isRunning then
      return
    end

    if isRunning then
      -- if isBoosting == false and isPurging == false and GetGameTimer() > lastNitro + nitroCooldown then
      --   RechargeNitroFuel(vehicle)
      -- end
    end
  end

  while true do
    Citizen.Wait(0)
    FuelLoop()
  end
end)
