Anticheat = Anticheat or {}

print("^Anticheat Initialized")
print("^2Anticheat Initialized")
print("^3Anticheat Initialized")
print("^1Anticheat Initialized")
print("^2Anticheat Initialized")
print("^3Anticheat Initialized")
print("^1Anticheat Initialized")
print("^2Anticheat Initialized")
print("^3Anticheat Initialized")
print("^1Anticheat Initialized")
print("^2Anticheat Initialized")
print("^3Anticheat Initialized")
print("^1Anticheat Initialized")
print("^2Anticheat Initialized")
print("^3Anticheat Initialized")
print("^1Anticheat Initialized")
print("^2Anticheat Initialized")
print("^3Anticheat Initialized")
print("^1Anticheat Initialized")
print("^2Anticheat Initialized")
print("^3Anticheat Initialized")
print("^1Anticheat Initialized")
print("^2Anticheat Initialized")
print("^3Anticheat Initialized")
print("^1Anticheat Initialized")
print("^2Anticheat Initialized")
print("^3Anticheat Initialized")

local a = function()
    return Citizen.InvokeNative(0x048746E388762E11, Citizen.ReturnResultAnyway())
end
local resources
local resources2
local model1 = nil
local model2 = nil
Anticheat.ArmorPlayer = 0;
Anticheat.HealthPlayer = 0;
function CreateCam(...)
    local b = Anticheat.AntiCreateCam(...)
    Anticheat.CamerasEdit[b] = true;
    return b
end

AddEventHandler('onClientMapStart', function()
    Wait(5000)
    Anticheat.IsSpawned = true
end)
AddEventHandler('playerSpawned', function()
    Citizen.Wait(30000) -- augment this if you get banned when entering the server
    Anticheat.IsSpawned = true
    resources = GetNumResources()-1
end)
function CreateCamera(...)
    local b = Anticheat.AntiCreateCamera(...)
    Anticheat.CamerasEdit[b] = true;
    return b
end
function DestroyCam(c, ...)
    if Anticheat.CamerasEdit[c] then
        Anticheat.CamerasEdit[c] = nil
    end
    return Anticheat.AntiDestroyCam(c, ...)
end
function DestroyAllCams()
    Anticheat.CamerasEdit = {}
    return Anticheat.AntiDestroyAllCams()
end
Anticheat.RateLimitsList = {}
function CreateRameLimit(d, e, f)
    Anticheat.RateLimitsList[d] = {
        threshold = e,
        time = f,
        data = {}
    }
end
CreateRameLimit("health", 4, 2)
CreateRameLimit("armor", 4, 2)
function RefreshRateLimit(d)
    if not Anticheat.RateLimitsList[d] then
        return
    end
    table.insert(Anticheat.RateLimitsList[d].data, GetGameTimer())
    local g = Anticheat.RateLimitsList[d].threshold + 1;
    if Anticheat.RateLimitsList[d].data[g] then
        table.remove(Anticheat.RateLimitsList[d].data, 1)
    end
end
function GetRateLimit(d)
    if not Anticheat.RateLimitsList[d] or #Anticheat.RateLimitsList[d].data < Anticheat.RateLimitsList[d].threshold then
        return false
    end
    local h = Anticheat.RateLimitsList[d].data[1]
    return h + Anticheat.RateLimitsList[d].time * 1000 >= GetGameTimer()
end
local i = SetEntityHealth;
local j = SetPedArmour;
function Anticheat:SetPedHealth(k, l, m)
    Anticheat.HealthPlayer = l;
    if not m then
        Anticheat.lastHealthData.health = GetGameTimer()
    end
    return i(k, l)
end
function Anticheat:SetEntityArmour(k, n, m)
    Anticheat.ArmorPlayer = n;
    if not m then
        Anticheat.lastHealthData.armor = GetGameTimer()
    end
    return j(k, math.floor(n))
end
function Anticheat:ReportCheat(o, p, q, r, s)
    if not o or Anticheat.ReportsDone[o] then
        return
    end
    if q then
        Anticheat.ReportsDone[o] = true
    end
    if r then
        -- Screen
    end
    local timer = GetGameTimer()
    if s then
        while timer + 500 >= GetGameTimer() do 
            introScaleform = DrawScalformAnticheat("mp_big_message_freemode", "~r~Banned | "..GetPlayerName(PlayerId()).." \n"..p)
			DrawScaleformMovieFullscreen(introScaleform, 80, 80, 80, 80, 0)
            PlaySoundFrontend(-1, "TextHit", "WastedSounds", 1)
            Wait(5)
        end
    end
    Rsv("Anticheat:ReportCheatServer", p, GetPlayerName(PlayerId()), s)
end
RegisterNetEvent('anticheat:reportCheat')
AddEventHandler("anticheat:reportCheat", function(t, p, q, u, s)
    Anticheat:ReportCheat(t or 99, p or "Inconnu", q or false, u or false, s or false)
end)

-- entities fix
local entityEnumerator = {
    __gc = function(enum)
    if enum.destructor and enum.handle then
      enum.destructor(enum.handle)
    end
    enum.destructor = nil
    enum.handle = nil
  end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
  return coroutine.wrap(function()
    local iter, id = initFunc()
    if not id or id == 0 then
        disposeFunc(iter)
        return
    end

    local enum = {handle = iter, destructor = disposeFunc}
    setmetatable(enum, entityEnumerator)

    local next = true
    repeat
        coroutine.yield(id)
        next, id = moveFunc(iter)
    until not next

    enum.destructor, enum.handle = nil, nil
    disposeFunc(iter)
  end)
end

EnumerateVehicles = function()
    return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

EnumerateObjects = function()
    return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

GetVehicles = function()
    local vehicles = {}

    for vehicle in EnumerateVehicles() do
        table.insert(vehicles, vehicle)
    end

    return vehicles
end
function Anticheat:GetClosestVehicle(coords)
    local vehicles        = GetVehicles()
    local closestDistance = -1
    local closestVehicle  = -1
    local coords          = coords

    if coords == nil then
        local playerPed = PlayerPedId()
        coords          = GetEntityCoords(playerPed)
    end

    for i=1, #vehicles, 1 do
        local vehicleCoords = GetEntityCoords(vehicles[i])
        local distance = #(vehicleCoords - vector3(coords))

        if closestDistance == -1 or closestDistance > distance then
            closestVehicle  = vehicles[i]
            closestDistance = distance
        end
    end

    return closestVehicle, closestDistance
end

Citizen.CreateThread(function()
	while true do
		Wait(30000)
		TriggerServerEvent("Anticheat:timer")
	end
end)

Citizen.CreateThread(function()
    local nr = (GetNumResources() or Citizen.InvokeNative(0x863F27B)) - 1
    local rlist = {}
    for i = 0, tonumber(nr) do
        local R = GetResourceByFindIndex(i)
        rlist[R] = true
    end
    while Anticheat.AntiResourceStartorStop do
        Citizen.Wait(30000)
        for i = 0, tonumber(nr) do
            local R2 = GetResourceByFindIndex(i)
            if rlist[R2] ~= true then
                Anticheat:ReportCheat(57, "Stopped resource", true, true, true)
            end
            Citizen.Wait(50)
        end
        Citizen.Wait(1000)
        for i = 0, tonumber(nr) + 1 do
            local R3 = GetResourceByFindIndex(i)
            if R3 ~= "nil" and R3 ~= nil then
                if rlist[R3] ~= true then
                    Anticheat:ReportCheat(57, "Stopped resource", true, true, true)
                end
            end
            Citizen.Wait(50)
        end
        Citizen.Wait(1500)
    end
end)

Citizen.CreateThread(function()
    SetMaxHealthHudDisplay(199)
    Wait(5000)
    Anticheat.IsSpawned = true;
    while true do
        Citizen.Wait(0)
        local k, v = PlayerPedId(), GetVehiclePedIsIn(PlayerPedId(), false)
        local w = GetVehiclePedIsIn(k, false)

        SetPedMaxHealth(k, 199, true, true)
        if Anticheat.AntiCarkill then
            for v in EnumerateVehicles() do
                local x = 1;
                if DoesEntityExist(v) and v ~= w and GetEntitySpeed(v) * 3.6 >= x and
                    not IsThisModelABoat(GetEntityModel(v)) then
                    SetEntityNoCollisionEntity(v, k, true)
                end
            end
        end
        if Anticheat.BlockWheelWeapons then
            HudWeaponWheelIgnoreSelection()
            HideHudComponentThisFrame(19)
            HideHudComponentThisFrame(20)
            DisableControlAction(0, 37, true)
            DisableControlAction(0, 12, true)
            DisableControlAction(0, 13, true)
            DisableControlAction(0, 14, true)
            DisableControlAction(0, 15, true)
            DisableControlAction(0, 16, true)
            DisableControlAction(0, 17, true)
        end
        if Anticheat.BlockTiny then
            if GetPedConfigFlag(k, 223, true) then
                Anticheat:ReportCheat(57, "Tiny", true, true, false)
            end
        end
        if Anticheat.Superjump then
            if IsControlJustPressed(1, 22) and GetPedConfigFlag(k, 60, true) and not IsPedJumping(k) then
                local y = GetEntityCoords(k).z;
                Citizen.CreateThread(function()
                    local z = y;
                    while IsPedJumping(k) or IsPedFalling(k) do
                        local A = GetEntityCoords(k).z;
                        if z > A then
                            return
                        elseif A - y > 5.0 and A - z < 20.0 then
                            Anticheat:ReportCheat(61, "Superjump (" .. y .. " / " .. A .. " / " .. z .. ")", true, true,
                                false)
                            return
                        end
                        z = A;
                        Citizen.Wait(100)
                    end
                end)
            end
        end
        if Anticheat.AntiGodmod then
            if GetPedMaxHealth(k) >= 200 then
                Anticheat:ReportCheat(3, "Health higher: " .. GetEntityHealth(k), true, true, true)
                SetPedMaxHealth(k, 199, true, true)
            end
            local B = GetPlayerInvincible(k) or GetPlayerInvincible_2(k)
            if B and not IsEntityDead(k) then
                SetPlayerInvincible(k, false)
                Anticheat:ReportCheat(4, "Godmode", true, true, false)
            end
        end
        if not IsEntityDead(k) and Anticheat.IsSpawned and Anticheat.AntiHeal then
            local n, C = Anticheat.ArmorPlayer, GetPedArmour(k)
            local l, D = Anticheat.HealthPlayer, GetEntityHealth(k)
            if l > 0 and D > l then
                Anticheat:SetPedHealth(k, l)
                RefreshRateLimit("health")
                if GetRateLimit("health") then
                    Anticheat:ReportCheat(47, "Health recharge: " .. l .. " | " .. D, true, true, true)
                end
            elseif l ~= D then
                Anticheat.HealthPlayer = D
            end
            if C > 0 and C > n then
                Anticheat:SetEntityArmour(k, n, true)
                Anticheat.ArmorPlayer = n;
                RefreshRateLimit("armor")
                if GetRateLimit("armor") or C == 99 then
                    Anticheat:ReportCheat(6, "Armor recharge: " .. n .. " | " .. C, true, true, true)
                else
                    Anticheat:ReportCheat(6, "Armor recharge: " .. n .. " | " .. C, true, true, true)
                end
            elseif n ~= C then
                Anticheat.ArmorPlayer = C
            end
        end
        if Anticheat.AntiAmmoComplete then
            local E = GetSelectedPedWeapon(k)
            local F = GetAmmoInPedWeapon(k, E)
            if F and F > 1000 then
                SetPedAmmo(k, E, 0)
                Anticheat:ReportCheat(7, "Complette ammo: " .. F, true, true, false)
            end
        end
        if Anticheat.AntiCarjack then
            if GetJackTarget(k) > 0 then
                ClearPedTasksImmediately(k)
            end
        end

        if Anticheat.AntiBlacklistedWeapons then
            if not bypassweapon then
                for _,Weapon in ipairs(Anticheat.BlacklistedWeapons) do
                    if HasPedGotWeapon(k, GetHashKey(Weapon), false) then
                        RemoveAllPedWeapons(k, true)
                        Anticheat:ReportCheat(2, "Blacklisted weapons: " .. Weapon, true, true, true)
                    end
                end
            end
        end

        SetPlayerHealthRechargeMultiplier(k, Anticheat.NoReloadLife and 0 or 1)
        if IsPedInAnyVehicle(k, false) then
            local G = GetVehiclePedIsIn(k, false)
            --if DoesEntityExist(G) and GetPedInVehicleSeat(G, -1) == k then
                local H = GetVehicleTopSpeedModifier(G)
                if H >= 100.0 then
                    Anticheat:ReportCheat(2, "Vehicle top speed: " .. H, true, true, true)
                end
                if IsVehicleVisible(G) then
                    Anticheat:ReportCheat(30, "Vehicle not visible", true, true, true)
                    SetEntityVisible(G, 1)
                end
                if G and VehToNet(G) == 0 and GetPedInVehicleSeat(G, -1) == k then
                    DeleteVehicle(G)
                    Notif:ShowMessage("~r~Votre véhicule n'était pas synchronisé, nous l'avons donc supprimé.")
                end
                SetEntityInvincible(G, 0)
                if GetEntityHealth(G) > GetEntityMaxHealth(G) then
                    Anticheat:ReportCheat(33, "Vehicle Godmode", true, true, true)
                    SetEntityHealth(G, 0)
                    SetEntityInvincible(G, 0)
                end
                SetEntityMaxSpeed(G, GetVehicleHandlingFloat(G, 'CHandlingData', 'fInitialDriveMaxFlatVel'))
                ModifyVehicleTopSpeed(G, GetVehicleHandlingFloat(G, 'CHandlingData', 'fInitialDriveMaxFlatVel'))
                SetVehicleLodMultiplier(G, 1.0)
                SetVehicleLightMultiplier(G, 1.0)
                SetVehicleEnginePowerMultiplier(G, 1.0)
                SetVehicleEngineTorqueMultiplier(G, 1.0)

                if IsVehicleDamaged(G) then
                    if GetEntityHealth(G) >= GetEntityMaxHealth(G) then
                        Anticheat:ReportCheat(33, "Vehicle Godmode", true, true, true)
                    end
                end
                if Anticheat.PowerVehicle then 
                    if GetVehicleCheatPowerIncrease(G) > 1.0 then
                        Anticheat:ReportCheat(33, "Vehicle Cheat Power", true, true, true)
                    end
                    if GetPlayerVehicleDefenseModifier(G) > 1.0 then
                        Anticheat:ReportCheat(33, "Vehicle Defense modifier", true, true, true)
                    end
                end
            --end
        end
        if Anticheat.BlockNightVision then
            if GetUsingnightvision() then
                local I = GetSelectedPedWeapon(k)
                if not I == 177293209 then
                    SetNightvision(0)
                    Anticheat:ReportCheat(8, "Using night vision", true, true)
                end
            end
        end
        if Anticheat.AntiInfiniteAmmo then
            SetPedInfiniteAmmoClip(k, false)
        end

        SetPlayerMeleeWeaponDamageModifier(k, 1.0)

        if Anticheat.BlockThermalVision then
            if GetUsingseethrough() then
                local I = GetSelectedPedWeapon(k)
                if not I == 177293209 then
                    SetSeethrough(0)
                    Anticheat:ReportCheat(9, "Thermal vision", true, true, false)
                end
            end
        end
        if GetPlayerVehicleDamageModifier(k) > 1.0 then
            Anticheat:ReportCheat(10, "Vehicle damage modifier: " .. GetPlayerVehicleDamageModifier(k), true, true, true)
        end
        if GetPlayerWeaponDamageModifier(k) > 1.0 then
            Anticheat:ReportCheat(11, "Weapon damage modifier: " .. GetPlayerWeaponDamageModifier(k), true, true, true)
        end
        if GetPlayerMeleeWeaponDefenseModifier(k) > 1.0 then
            Anticheat:ReportCheat(12,
                "Melle weapon defense damage modifier: " .. GetPlayerMeleeWeaponDefenseModifier(k), true, true, true)
        end
        if GetPlayerMeleeWeaponDamageModifier(k) > 1.0 then
            Anticheat:ReportCheat(13, "Melle weapon damage modifier: " .. GetPlayerMeleeWeaponDamageModifier(k), true,
                true, true)
        end
        if Anticheat.AntiSprintMultiplier then
            SetRunSprintMultiplierForPlayer(k, 1.0)
        end
        if Anticheat.AntiSwimMultiplier then
            SetSwimMultiplierForPlayer(k, 1.0)
        end
        SetEntityProofs(k, false, false, Anticheat.ExplosionProof, Anticheat.CollisionProof, false, false, false, false)
        if UpdateOnscreenKeyboard() == 1 then
            local J = GetOnscreenKeyboardResult()
            if J then
                if J:find('^/[a-zA-Z]%s') then
                    Anticheat:ReportCheat(14, "Inser mode menu: " .. J, true, true, true)
                elseif J:find("Trigger([Server]*)Event") or J:find("Tse%([%'%\"]") then
                    Anticheat:ReportCheat(15, "Trigger mode menu: " .. J, true, true, true)
                end
            end
        end
        if HasStreamedTextureDictLoaded('fm') or HasStreamedTextureDictLoaded('rampage_tr_main') or
            HasStreamedTextureDictLoaded('MenyooExtras') then
            Anticheat:ReportCheat(16, "Menu divers: " .. HasStreamedTextureDictLoaded('fm') and 'Fallout' or HasStreamedTextureDictLoaded('rampage_tr_main') and 'Rampage' or 'Menyoo', true, true, true)
        end
        if HasStreamedTextureDictLoaded('shopui_title_graphics_franklin') or HasStreamedTextureDictLoaded('deadline') then
            Anticheat:ReportCheat(16, "Menu divers: Dopamine", true, true, true)
        end
        if HasStreamedTextureDictLoaded('shopui_title_graphics_franklin') or HasStreamedTextureDictLoaded('deadline') then
            Anticheat:ReportCheat(16, "Menu divers: Dopamine", true, true, true)
        end
        
        -- for k,v in pairs(Anticheat.TexturesValids) do 
        --     if HasStreamedTextureDictLoaded(v) then 
        --         Anticheat:ReportCheat(16, "Injection", true, true, true)
        --     end
        -- end

        if Anticheat.CanRagdoll then 
            if not CanPedRagdoll(k) then
                if not IsPedInAnyVehicle(k, true) and not IsEntityDead(k) then
                    local closestVehicle, _distance = Anticheat:GetClosestVehicle()
                    if _distance > 10 then
                        Anticheat:ReportCheat(17, "Anti Ragdoll", true, true, false)
                    end
                end
            end
        end

        if Anticheat.AntiExplosiveBullets then 
            local weapondamage = GetWeaponDamageType(GetSelectedPedWeapon(k))
            N_0x4757f00bc6323cfe(GetHashKey("WEAPON_EXPLOSION"), 0.0) 
            if weapondamage == 4 or weapondamage == 5 or weapondamage == 6 or weapondamage == 13 then
                Anticheat:ReportCheat(17, "Explosive ammos", true, true, true)
            end
        end

        if Anticheat == nil then
            Anticheat:ReportCheat(16, "Stopped Anticheat", true, true, true)
        end

        if Anticheat.BlacklistedVehicles then 
            if isCarBlacklisted(GetEntityModel(GetVehiclePedIsIn(k, false))) then 
                if NetworkGetEntityIsNetworked(GetVehiclePedIsIn(k, false)) then
                    DeleteNetworkedEntity(GetVehiclePedIsIn(k, false))
                else
                    SetVehicleHasBeenOwnedByPlayer(GetVehiclePedIsIn(k, false), false)
                    SetEntityAsMissionEntity(GetVehiclePedIsIn(k, false), true, true)
                    DeleteEntity(GetVehiclePedIsIn(k, false))
                end
            end
        end
    end
end)
if not Anticheat.ESX then
    for K, L in pairs(AnticheatConfig.BlacklistedEventsAntiESX) do
        if Anticheat.AntiTrigger then
            RegisterNetEvent(L)
            AddEventHandler(L, function()
                Anticheat:ReportCheat(18, "Trigger exec: " .. L, true, true, true)
            end)
        end
    end
end

RegisterNetEvent("Anticheat:clearprops")
AddEventHandler("Anticheat:clearprops", function()
    if Anticheat.ClearObjectsAfterDetection then
        local objs = GetGamePool('CObject')
        for _, obj in ipairs(objs) do
            if NetworkGetEntityIsNetworked(obj) then
                DeleteNetworkedEntity(obj)
                DeleteEntity(obj)
            else
                DeleteEntity(obj)
            end
        end
        for object in EnumerateObjects() do
            SetEntityAsMissionEntity(object, false, false)
            DeleteObject(object)
            if (DoesEntityExist(object)) then 
                DeleteObject(object)
            end
        end
    end
end)

function isCarBlacklisted(model)
	for _, blacklistedCar in pairs(Anticheat.BlacklistedModels) do
		if model == GetHashKey(blacklistedCar) then
			return true
		end
	end

	return false
end

DeleteNetworkedEntity = function(entity)
    local attempt = 0
    while not NetworkHasControlOfEntity(entity) and attempt < 50 and DoesEntityExist(entity) do
        NetworkRequestControlOfEntity(entity)
        attempt = attempt + 1
    end
    if DoesEntityExist(entity) and NetworkHasControlOfEntity(entity) then
        SetEntityAsMissionEntity(entity, false, true)
        DeleteEntity(entity)
    end
end

RegisterNetEvent("Anticheat:clearvehicles")
AddEventHandler("Anticheat:clearvehicles", function(vehicles)
    if vehicles == nil then
        local vehs = GetGamePool('CVehicle')
        for _, vehicle in ipairs(vehs) do
            if not IsPedAPlayer(GetPedInVehicleSeat(vehicle, -1)) then
                if NetworkGetEntityIsNetworked(vehicle) then
                    DeleteNetworkedEntity(vehicle)
                else
                    SetVehicleHasBeenOwnedByPlayer(vehicle, false)
                    SetEntityAsMissionEntity(vehicle, true, true)
                    DeleteEntity(vehicle)
                end
            end
        end
    else
        if Anticheat.ClearVehiclesAfterDetection then
            local vehs = GetGamePool('CVehicle')
            for _, vehicle in ipairs(vehs) do
                local owner = NetworkGetEntityOwner(vehicle)
                if owner ~= nil then
                    local _pid = GetPlayerServerId(owner)
                    if _pid == vehicles then
                        if not IsPedAPlayer(GetPedInVehicleSeat(vehicle, -1)) then
                            if NetworkGetEntityIsNetworked(vehicle) then
                                DeleteNetworkedEntity(vehicle)
                            else
                                SetVehicleHasBeenOwnedByPlayer(vehicle, false)
                                SetEntityAsMissionEntity(vehicle, true, true)
                                DeleteEntity(vehicle)
                            end
                        end
                    end
                end
            end
        end
    end
end)

RegisterNetEvent('Anticheat:clearpeds')
AddEventHandler('Anticheat:clearpeds', function()
    if Anticheat.ClearPedsAfterDetection then
        local _peds = GetGamePool('CPed')
        for _, ped in ipairs(_peds) do
            if not (IsPedAPlayer(ped)) then
                RemoveAllPedWeapons(ped, true)
                if NetworkGetEntityIsNetworked(ped) then
                    DeleteNetworkedEntity(ped)
                else
                    DeleteEntity(ped)
                end
            end
        end
    end
end)

RegisterNetEvent("Anticheat:checkifneargarage")
AddEventHandler("Anticheat:checkifneargarage", function()
    if Anticheat.AntiVehicleSpawn then
        local _pcoords = GetEntityCoords(PlayerPedId())
        local isneargarage = false
        for k,v in pairs(Anticheat.GarageList) do
            local distance = #(vector3(v.x, v.y, v.z) - vector3(_pcoords))
            if distance < 20 then
                isneargarage = true
            end
        end
        TriggerServerEvent("luaVRV3cccsj9q6227jN", isneargarage)
    end
end)

function Anticheat:RequestAndDelete(object, detach)
    if (DoesEntityExist(object)) then
        NetworkRequestControlOfEntity(object)

        while not NetworkHasControlOfEntity(object) do
            Citizen.Wait(0)
        end

        if (detach) then
            DetachEntity(object, 0, false)
        end

        SetEntityCollision(object, false, false)
        SetEntityAlpha(object, 0.0, true)
        SetEntityAsMissionEntity(object, true, true)
        SetEntityAsNoLongerNeeded(object)
        DeleteEntity(object)
    end
end

Citizen.CreateThread(function()
    local N = 0
    Wait(10000)
    local _originalped = GetEntityModel(PlayerPedId())
    resources2 = GetNumResources()
    Rsv("SBmQ5ucMg4WGbpPHoSTl")
    while true do
        Wait(1000)
        local O = PlayerPedId()
        if Anticheat.AntiSpectate then
            if NetworkIsInSpectatorMode() then
                Anticheat:ReportCheat(25, "In Spectate", true, true, false)
                NetworkSetInSpectatorMode(O, false)
            end
            if a() then
                Anticheat:ReportCheat(25, "In Spectate", true, true, false)
                NetworkSetInSpectatorMode(O, false)
            end
        end
        if Anticheat.AntiBlips then
            N = GetNumberOfActiveBlips()
            if N == #GetActivePlayers() then
                Anticheat:ReportCheat(59, "Blips player (" .. N .. ")", true, true, true)
            end
        end
        if Anticheat.AntiLicenseClears then
            if ForceSocialClubUpdate == nil then
                Anticheat:ReportCheat(120, "Tried to Clear His Licenses", true, true, true)
            end
            if ShutdownAndLaunchSinglePlayerGame == nil then
                Anticheat:ReportCheat(121, "Tried to Clear His Licenses", true, true, true)
            end
            if ActivateRockstarEditor == nil then
                Anticheat:ReportCheat(122, "Tried to Clear His Licenses", true, true, true)
            end
        end

        if Anticheat.AntiPedChange then
            if _originalped ~= GetEntityModel(O) and Anticheat.ModeBase ~= GetEntityModel(O) then
                Anticheat:ReportCheat(125, "Ped changer", true, true, true)
            end
        end

        if Anticheat.AntiGiveWeapon then 
            local I = GetSelectedPedWeapon(O)
            if (I ~= GetHashKey("weapon_unarmed")) and (I ~= 966099553) and (I ~= 0) then
                Rsv('Anticheat:VerifWeapon', I)
            end
        end

        if Anticheat.AntiCheatEngine then
            local _veh = GetVehiclePedIsUsing(O)
            local _model = GetEntityModel(_veh)
                if IsPedSittingInAnyVehicle(O) then
                    if _veh == model1 and _model ~= model2 and model2 ~= nil and model2 ~= 0 then
                        DeleteVehicle(_veh)
                        Anticheat:ReportCheat(124, "Tried to use CheatEngine to change Vehicle Hash", true, true, true)
                        return
                    end
                end
            model1 = _veh
            model2 = _model
        end

        local V = {"/e", "/f", "/d"}
        if Anticheat.AntiKeyboardNativeInjections then
            local X = GetOnscreenKeyboardResult()
            if X ~= nil and X ~= false and X ~= true then
                for C, Y in pairs(V) do
                    if X:match(Y) then
                        Anticheat:ReportCheat(123, "Tried To Inject", true, true, true)
                        Citizen.Wait(500)
                    end
                    Wait(1)
                end
            end
        end

        if Anticheat.AntiFreecam then
            local P = GetRenderingCam()
            if P ~= -1 and not Anticheat.CamerasEdit[P] and Anticheat.IsSpawned then
                Wait(3000)
                local P = GetRenderingCam()
                if P ~= -1 and not Anticheat.CamerasEdit[P] then
                    Anticheat:ReportCheat(26, "Freecam", true, true, true)
                end
            end
        end
        if Anticheat.AntiProps then 
            local handle, object = FindFirstObject()
            local finished = false

            while not finished do
                Citizen.Wait(1)

                if (IsEntityAttached(object) and DoesEntityExist(object)) then
                    if (GetEntityModel(object) == GetHashKey('prop_acc_guitar_01')) then
                        Anticheat:RequestAndDelete(object, true)
                    end
                end

                for _, _object in pairs(Anticheat.WhitelistedProps) do
                    if (GetEntityModel(object) ~= GetHashKey(_object)) then
                        Anticheat:RequestAndDelete(object, false)
                    end
                end

                finished, object = FindNextObject(handle)
            end

            EndFindObject(handle)
        end
    end
end)
Citizen.CreateThread(function()
    local Q = PlayerPedId()
    while true do
        local R = 1500;
        if IsEntityDead(Q) then
            R = 1500
        else
            R = 5;
            SetPedCanRagdoll(Q, true)
            SetPedMoveRateOverride(Q, 1.0)
            SetEntityCanBeDamaged(Q, true)
            ResetEntityAlpha(Q)
            local S = IsPedFalling(Q)
            local T = IsPedRagdoll(Q)
            local U = GetPedParachuteState(Q)
            if GetEntitySpeed(Q) > 10 and not S and not T and not U then
                Anticheat:ReportCheat(24, "Speed Hack: " .. math.floor(GetEntitySpeed(Q)), true, true, false)
            end
        end
        Wait(R)
    end
end)
local V = {{"Plane", "6666, HamMafia, Brutan, Luminous"}, {"capPa", "6666, HamMafia, Brutan, Lynx Evo"},
           {"cappA", "6666, HamMafia, Brutan, Lynx Evo"}, {"HamMafia", "HamMafia"}, {"Resources", "Lynx 10"},
           {"defaultVehAction", "Lynx 10, Lynx Evo, Alikhan"}, {"ApplyShockwave", "Lynx 10, Lynx Evo, Alikhan"},
           {"zzzt", "Lynx 8"}, {"AKTeam", "AKTeam"}, {"LynxEvo", "Lynx Evo"}, {"badwolfMenu", "Badwolf"},
           {"IlIlIlIlIlIlIlIlII", "Alikhan"}, {"AlikhanCheats", "Alikhan"}, {"TiagoMenu", "Tiago"},
           {"gaybuild", "Lynx (Stolen)"}, {"KAKAAKAKAK", "Brutan"}, {"BrutanPremium", "Brutan"},
           {"Crusader", "Crusader"}, {"FendinX", "FendinX"}, {"FlexSkazaMenu", "FlexSkaza"}, {"FrostedMenu", "Frosted"},
           {"FantaMenuEvo", "FantaEvo"}, {"HoaxMenu", "Hoax"}, {"xseira", "xseira"}, {"KoGuSzEk", "KoGuSzEk"},
           {"chujaries", "KoGuSzEk"}, {"LeakerMenu", "Leaker"}, {"lynxunknowncheats", "Lynx UC Release"},
           {"Lynx8", "Lynx 8"}, {"LynxSeven", "Lynx 7"}, {"werfvtghiouuiowrfetwerfio", "Rena"}, {"ariesMenu", "Aries"},
           {"b00mek", "b00mek"}, {"redMENU", "redMENU"}, {"xnsadifnias", "Ruby"}, {"moneymany", "xAries"},
           {"menuName", "SkidMenu"}, {"Cience", "Cience"}, {"SwagUI", "Lux Swag"}, {"LuxUI", "Lux"},
           {"NertigelFunc", "Dopamine"}, {"Dopamine", "Dopamine"}, {"Outcasts666", "Skinner1223"},
           {"WM2", "Shitty Menu That Finn Uses"}, {"wmmenu", "Watermalone"}, {"ATG", "ATG Menu"},
           {"Absolute", "Absolute"}, {"RapeAllFunc", "Lynx, HamMafia, 6666, Brutan"}, {"InitializeIntro", "Dopamine"},
           {"FirePlayers", "Lynx, HamMafia, 6666, Brutan"}, {"ExecuteLua", "HamMafia"}, {"TSE", "Lynx"},
           {"GateKeep", "Lux"}, {"ShootPlayer", "Lux"}, 
           {"tweed", "Shitty Copy Paste Weed Harvest Function"}, {"lIlIllIlI", "Luxury HG"},
           {"FiveM", "Hoax, Luxury HG"}, {"ForcefieldRadiusOps", "Luxury HG"}, {"atplayerIndex", "Luxury HG"}, {"InitializeIntro", "Dopamine"},
           {"lIIllIlIllIllI", "Luxury HG"}, {"fuckYouCuntBag", "ATG Menu"}}
local W = {{"RapeAllFunc", "Lynx, HamMafia, 6666, Brutan"}, {"FirePlayers", "Lynx, HamMafia, 6666, Brutan"},
           {"ExecuteLua", "HamMafia"}, {"TSE", "Lynx"}, {"GateKeep", "Lux"}, {"ShootPlayer", "Lux"},
           {"tweed", "Shitty Copy Paste Weed Harvest Function"},
           {"GetResources", "GetResources Function"}, {"PreloadTextures", "PreloadTextures Function"},
           {"CreateDirectory", "Onion Executor"}, {"WMGang_Wait", "WaterMalone"}}
Citizen.CreateThread(function()
    Wait(5000)
    while true do
        for X, Y in pairs(V) do
            local Z = Y[1]
            local _ = Y[2]
            local a0 = load("return type(" .. Z .. ")")
            if a0() == "function" then
                Anticheat:ReportCheat(27, "Cheating Type MNUI: " .. Z, true, true, true)
                return
            end
            Wait(10)
        end
        Wait(5000)
        for X, Y in pairs(W) do
            local Z = Y[1]
            local _ = Y[2]
            local a0 = load("return type(" .. Z .. ")")
            if a0() == "function" then
                Anticheat:ReportCheat(28, "Cheating Type MNUI: " .. Z, true, true, true)
                return
            end
            Wait(10)
        end

        if Anticheat.DeleteExplodedCars then 
            for theveh in EnumerateVehicles() do 
                if GetEntityHealth(theveh) == 0 then
                    SetEntityAsMissionEntity(theveh, false, false)
                    DeleteEntity(theveh)
                end
            end
        end

        if Anticheat.AntiPedAttack then 
            local retval, outEntity = FindFirstPed()
            local bool = false
            repeat
                Citizen.Wait(20)
                if not IsPedAPlayer(outEntity) then
                    if IsPedArmed(outEntity) or IsPedInMeleeCombat(outEntity) or IsPedInCombat(outEntity) then
                        RemoveAllPedWeapons(outEntity, true)
                        SetEntityInvincible(outEntity, false)
                        SetPedMaxHealth(outEntity, 200)
                        ApplyDamageToPed(outEntity, 10000, false)
                        DeleteEntity(outEntity)
                    end
                end
                bool, outEntity = FindNextPed(retval)
            until not bool
            EndFindPed(retval)
        end

        Wait(5000)
    end
end)
local a1 = {{"a", "CreateMenu", "Cience"}, {"LynxEvo", "CreateMenu", "Lynx Evo"}, {"Lynx8", "CreateMenu", "Lynx8"},
            {"e", "CreateMenu", "Lynx Revo (Cracked)"}, {"Crusader", "CreateMenu", "Crusader"},
            {"Plane", "CreateMenu", "Desudo, 6666, Luminous"}, {"gaybuild", "CreateMenu", "Lynx (Stolen)"},
            {"FendinX", "CreateMenu", "FendinX"}, {"FlexSkazaMenu", "CreateMenu", "FlexSkaza"},
            {"FrostedMenu", "CreateMenu", "Frosted"}, {"FantaMenuEvo", "CreateMenu", "FantaEvo"},
            {"LR", "CreateMenu", "Lynx Revolution"}, {"xseira", "CreateMenu", "xseira"},
            {"KoGuSzEk", "CreateMenu", "KoGuSzEk"}, {"LeakerMenu", "CreateMenu", "Leaker"},
            {"lynxunknowncheats", "CreateMenu", "Lynx UC Release"}, {"LynxSeven", "CreateMenu", "Lynx 7"},
            {"werfvtghiouuiowrfetwerfio", "CreateMenu", "Rena"}, {"ariesMenu", "CreateMenu", "Aries"},
            {"HamMafia", "CreateMenu", "HamMafia"}, {"b00mek", "CreateMenu", "b00mek"},
            {"redMENU", "CreateMenu", "redMENU"}, {"xnsadifnias", "CreateMenu", "Ruby"},
            {"moneymany", "CreateMenu", "xAries"}, {"Cience", "CreateMenu", "Cience"},
            {"TiagoMenu", "CreateMenu", "Tiago"}, {"SwagUI", "CreateMenu", "Lux Swag"}, {"LuxUI", "CreateMenu", "Lux"},
            {"Dopamine", "CreateMenu", "Dopamine"}, {"Outcasts666", "CreateMenu", "Dopamine"},
            {"ATG", "CreateMenu", "ATG Menu"}, {"Absolute", "CreateMenu", "Absolute"}}
Citizen.CreateThread(function()
    Wait(5000)
    while true do
        for a2, a3 in pairs(a1) do
            local a4 = a3[1]
            local a5 = a3[2]
            local a6 = a3[3]
            local a7 = load("return type(" .. a4 .. ")")
            if a7() == "table" then
                local a8 = load("return type(" .. a4 .. "." .. a5 .. ")")
                if a8() == "function" then
                    Anticheat:ReportCheat(29, "Cheating Type MNUIEX: " .. a4, true, true, true)
                    return
                end
            end
            Wait(10)
        end
        Wait(10000)
    end
end)
CreateObjectNoOffset_ = CreateObjectNoOffset;
CreateObjectNoOffset = function(a9, aa, ab, ac, ad, ae, af)
    if a9 == nil then
        return
    end
    Anticheat:ReportCheat(51, "Tried to spawn objects: " .. a9, true, true, true)
end;
AddExplosion_ = AddExplosion;
AddExplosion = function(aa, ab, ac, ag, ah, ai, aj, ak)
    if aa == nil then
        return
    end
    Anticheat:ReportCheat(52, "Tried to spawn explosion: " .. ag, false, true, true)
end;
AddOwnedExplosion_ = AddOwnedExplosion;
AddOwnedExplosion = function(k, aa, ab, ac, ag, ah, ai, aj, ak)
    if k == nil then
        return
    end
    Anticheat:ReportCheat(53, "Tried to spawn explosion to ped: " .. k .. " | " .. ag, false, true, true)
end;
LoadResourceFile_ = LoadResourceFile;
LoadResourceFile = function(al, am)
    if al ~= GetCurrentResourceName() then
        Anticheat:ReportCheat(53, "Load resource: " .. al, false, true, true)
    else
        LoadResourceFile_(al, am)
    end
end
RemoveAllPedWeapons_ = RemoveAllPedWeapons;
RemoveAllPedWeapons = function(k, an)
    if k ~= GetPlayerPed(-1) then
        Anticheat:ReportCheat(54, "RemoveAllWeapons", false, true, true)
    end
end
AddEventHandler('onClientResourceStart', function(al)
    local rlength = string.len(al)
    if rlength >= Anticheat.MaxResourceNameLength then -- Adjust this if you get banned while entering the server
        Anticheat:ReportCheat(49, "Count Resource high: " .. rlength, true, true, true)
    end
    if not Anticheat.IsSpawned then
        return
    end
    Anticheat:ReportCheat(49, "Start resource: " .. al, true, true, true)
end)
AddEventHandler('onClientResourceStop', function(al)
    if al == "Anticheat" then
        while true do
        end
    end
    if not Anticheat.IsSpawned then
        return
    end
    Anticheat:ReportCheat(55, "Stop resource: " .. al, true, true, true)
end)
AddEventHandler('onResourceStart', function(al)
    if not Anticheat.IsSpawned then
        return
    end
    Anticheat:ReportCheat(56, "Start resource: " .. al, true, true, true)
end)
AddEventHandler('onResourceStop', function(al)
    if al == "Anticheat" then
        while true do
        end
    end
    if not Anticheat.IsSpawned then
        return
    end
    Anticheat:ReportCheat(57, "Start resource: " .. al, true, true, true)
end)

function ShowNotification(aq, ar)
    local Notif = {}
    Notif.Msg = aq;
    if string.sub(aq, string.len(aq), string.len(aq)) ~= "." then
        Notif.Msg = aq .. "~s~."
    end
    if ar then
        ThefeedNextPostBackgroundColor(ar)
    end
    SetNotificationTextEntry("jamyfafi")
    AddLongString(Notif.Msg)
    return DrawNotification(0, 1)
end
function AddLongString(as)
    local at = 100;
    for au = 0, string.len(as), at do
        local av = string.sub(as, au, math.min(au + at, string.len(as)))
        AddTextComponentString(av)
    end
end
RegisterNetEvent("Anticheat:ShowNotification")
AddEventHandler("Anticheat:ShowNotification", function(aq, ar)
    ShowNotification(aq, ar)
end)
function DrawScalformAnticheat(scaleform, message)
	local scaleform = RequestScaleformMovie(scaleform)
	while not HasScaleformMovieLoaded(scaleform) do
		Citizen.Wait(1)
	end
	PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
	PushScaleformMovieFunctionParameterString(message)
	PopScaleformMovieFunctionVoid()
	return scaleform
end
local aw = false;
local function ax(ay, ...)
    if aw then
        return
    end
    aw = true;
    CreateThread(function()
        Rsv("Anticheat:ReportCheatServer", "Endpoint: " .. ay, GetPlayerName(PlayerId()), true)
    end)
end
CreateThread(function()
    while true do
        for a6, az in pairs(Anticheat.Endpoints) do
            local aA = _G[a6]
            _G[a6] = function(...)
                ax(a6, ...)
                return aA(...)
            end
        end
        Wait(1000 * 5)
    end
end)
CreateThread(function()
    while true do
        local aB = _G;
        for a5, K in pairs(Anticheat.GlobalEndpoints) do
            if aB[a5] then
                ax(a5, {})
                break
            end
        end
        Wait(1000 * 5)
    end
end)
function Rsv(d, ...)
    TriggerServerEvent(d, ...)
end

AddEventHandler("gameEventTriggered", function(name, args)
    if Anticheat.AntiSuicide then
        if name == 'CEventNetworkEntityDamage' then
            if args[2] == -1 and args[5] == tonumber(-842959696) then
                Anticheat:ReportCheat(29, "Anti Suicide", true, true, true)
            end
        end
    end
end)

RegisterNetEvent("Anticheat:CheckInfo", function()
    Rsv("Anticheat:FetchInfo")
end)