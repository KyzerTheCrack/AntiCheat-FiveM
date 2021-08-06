if GetCurrentResourceName() ~= "Anticheat" then
    return
end

local explosionsSpawned = {}
local vehiclesSpawned = {}
local pedsSpawned = {}
local entitiesSpawned = {}
local particlesSpawned = {}
if Anticheat.ESX then
    ESX = nil;
    TriggerEvent("esx:getSharedObject", function(a)
        ESX = a
    end)

    local function HaveWeaponInLoadout(xPlayer, weapon)
        for i, v in pairs(xPlayer.loadout) do
            if (GetHashKey(v.name) == weapon) then
                return true
            end
        end
        return false
    end
    
    RegisterServerEvent('Anticheat:VerifWeapon')
    AddEventHandler('Anticheat:VerifWeapon', function(weapon)
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            if not HaveWeaponInLoadout(xPlayer, weapon) then
                TriggerClientEvent("anticheat:reportCheat", source, 126, "Give weapon", true, true, true)
            end
        end
    end)

    local function b(src)
        local c = {
            steam = "",
            ip = "",
            discord = "",
            license = "",
            xbl = "",
            live = ""
        }
        for d = 0, GetNumPlayerIdentifiers(src) - 1 do
            local id = GetPlayerIdentifier(src, d)
            if string.find(id, "steam") then
                c.steam = id
            elseif string.find(id, "ip") then
                c.ip = id
            elseif string.find(id, "discord") then
                c.discord = id
            elseif string.find(id, "license") then
                c.license = id
            elseif string.find(id, "xbl") then
                c.xbl = id
            elseif string.find(id, "live") then
                c.live = id
            end
        end
        return c
    end
    ESX.RegisterServerCallback('Anticheat:GetBan', function(source, e, f)
        MySQL.Async.fetchAll("SELECT * FROM anticheatban", {}, function(g)
            e(g)
        end)
    end)
    BanList = {}
    BannedTokens = {}
    function ActualizebanList()
        MySQL.Async.fetchAll('SELECT * FROM anticheatban', {}, function(h)
            if #h ~= #BanList then
                BanList = {}
                BannedTokens = {}
                for d = 1, #h, 1 do
                    table.insert(BanList, {
                        ID = h[d].id,
                        license = h[d].GameLicense,
                        identifier = h[d].Steam,
                        playerName = h[d].SteamName,
                        bannerName = h[d].Banner,
                        liveid = h[d].live,
                        xblid = h[d].xbl,
                        discord = h[d].DiscordUID,
                        playerip = h[d].ip,
                        reason = h[d].Other
                    })
                    local i = json.decode(h[d].Token)
                    if i ~= nil then
                        for j, k in ipairs(i) do
                            table.insert(BannedTokens, k)
                        end
                    end
                end
                print("La blacklist à été refresh")
            end
        end)
    end
    CreateThread(function()
        Wait(5000)
        while true do
            ActualizebanList()
            Wait(60 * 1000)
        end
    end)


    
    AddEventHandler('playerConnecting', function(name, l, m)
        src = source;
        local steamid = nil;
        local license = nil;
        local discord = nil;
        local ip = nil;
        local n = nil;
        local o = nil;
        PlayerTokens = {}
        banned = {}
        m.defer()
        m.presentCard(
            [==[{"type":"AdaptiveCard","version":"1.0","body":[{"type":"ColumnSet","columns":[{"type":"Column","width":"auto","items":[{"type":"Image","altText":"","url":"https://i.imgur.com/93Yp5mO.jpg","size":"Medium"}]},{"type":"Column","width":"stretch","items":[{"type":"TextBlock","text":"Anticheat","weight":"Bolder","size":"Medium"},{"type":"TextBlock","text":"Blacklist"}]}]},{"type":"TextBlock","text":"Initialisation de la connexion au proxy..","size":"Medium","weight":"Lighter"}],"$schema":"http://adaptivecards.io/schemas/adaptive-card.json"}]==],
            function(h, p)
            end)
        for d = 0, GetNumPlayerIdentifiers(src) - 1 do
            local id = GetPlayerIdentifier(src, d)
            if string.find(id, "steam") then
                steamid = id
            elseif string.find(id, "ip") then
                ip = id
            elseif string.find(id, "discord") then
                discord = id
            elseif string.find(id, "license") then
                license = id
            elseif string.find(id, "xbl") then
                n = id
            elseif string.find(id, "live") then
                o = id
            end
        end
        Wait(1000)
        for j, q in pairs(AnticheatConfig.BlacklistedCaracters) do
            if string.match(name:lower(), q:lower()) then
                m.done("\nVotre nom steam est inapproprié. \nCaractère: " .. q:lower())
            end
        end
        if not discord or discord == "" or discord == nil then
            if AnticheatConfig.UseDiscord then
                m.presentCard(
                    [==[{"type":"AdaptiveCard","version":"1.0","body":[{"type":"ColumnSet","columns":[{"type":"Column","width":"auto","items":[{"type":"Image","altText":"","url":"https://i.imgur.com/93Yp5mO.jpg","size":"Medium"}]},{"type":"Column","width":"stretch","items":[{"type":"TextBlock","text":"Anticheat","weight":"Bolder","size":"Medium"},{"type":"TextBlock","text":"Blacklist"}]}]},{"type":"TextBlock","text":"Veuillez relier votre discord.","size":"Medium","weight":"Lighter"}],"$schema":"http://adaptivecards.io/schemas/adaptive-card.json"}]==],
                    function(h, p)
                    end)
                CancelEvent()
                return
            end
        elseif not steamid or steamid == "" or steamid == nil then
            if AnticheatConfig.UseSteam then
                m.presentCard(
                    [==[{"type":"AdaptiveCard","version":"1.0","body":[{"type":"ColumnSet","columns":[{"type":"Column","width":"auto","items":[{"type":"Image","altText":"","url":"https://i.imgur.com/93Yp5mO.jpg","size":"Medium"}]},{"type":"Column","width":"stretch","items":[{"type":"TextBlock","text":"Anticheat","weight":"Bolder","size":"Medium"},{"type":"TextBlock","text":"Blacklist"}]}]},{"type":"TextBlock","text":"Veuillez relier votre stream.","size":"Medium","weight":"Lighter"}],"$schema":"http://adaptivecards.io/schemas/adaptive-card.json"}]==],
                    function(h, p)
                    end)
                CancelEvent()
                return
            end
        end
        PlayerTokens[ip] = {}
        for r = 0, GetNumPlayerTokens(src) do
            table.insert(PlayerTokens[ip], GetPlayerToken(src, r))
        end
        banned[ip] = {}
        local s = nil;
        local t = ""
        local u = ""
        Wait(500)
        for d = 1, #BanList, 1 do
            if AnticheatConfig.UseDiscord then
                if tostring(BanList[d].license) == tostring(license) or tostring(BanList[d].discord) ==
                    tostring(discord) or tostring(BanList[d].playerip) == tostring(ip) then
                    banned[ip] = true;
                    s = BanList[d].reason;
                    t = BanList[d].playerName;
                    u = BanList[d].bannerName;
                    MySQL.Async.execute('UPDATE anticheatban SET Token = @Token WHERE id = @id', {
                        ["@Token"] = json.encode(PlayerTokens[ip]),
                        ["@id"] = BanList[d].ID
                    })
                    break
                else
                    banned[ip] = false
                end
            elseif AnticheatConfig.UseSteam then
                if tostring(BanList[d].license) == tostring(license) or tostring(BanList[d].identifier) ==
                    tostring(steamid) or tostring(BanList[d].playerip) == tostring(ip) then
                    banned[ip] = true;
                    s = BanList[d].reason;
                    t = BanList[d].playerName;
                    u = BanList[d].bannerName;
                    MySQL.Async.execute('UPDATE anticheatban SET Token = @Token WHERE id = @id', {
                        ["@Token"] = json.encode(PlayerTokens[ip]),
                        ["@id"] = BanList[d].ID
                    })
                    break
                else
                    banned[ip] = false
                end
            else
                if tostring(BanList[d].license) == tostring(license) or tostring(BanList[d].playerip) == tostring(ip) then
                    banned[ip] = true;
                    s = BanList[d].reason;
                    t = BanList[d].playerName;
                    u = BanList[d].bannerName;
                    MySQL.Async.execute('UPDATE anticheatban SET Token = @Token WHERE id = @id', {
                        ["@Token"] = json.encode(PlayerTokens[ip]),
                        ["@id"] = BanList[d].ID
                    })
                    break
                else
                    banned[ip] = false
                end
            end
        end
        if not banned[ip] then
            if json.encode(BannedTokens) ~= "[]" then
                for d = 1, #BanList, 1 do
                    for v = 1, #BannedTokens, 1 do
                        for w = 1, #PlayerTokens[ip], 1 do
                            if BannedTokens and PlayerTokens then
                                if BannedTokens[v] ~= nil and PlayerTokens[ip][w] ~= nil then
                                    if BannedTokens[v] == PlayerTokens[ip][w] then
                                        banned[ip] = true;
                                        s = BanList[d].reason;
                                        t = BanList[d].playerName;
                                        u = BanList[d].bannerName;
                                        MySQL.Async.execute('UPDATE anticheatban SET Token = @Token WHERE id = @id', {
                                            ["@Token"] = json.encode(PlayerTokens[ip]),
                                            ["@id"] = BanList[d].ID
                                        })
                                        break
                                    else
                                        banned[ip] = false
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        if banned[ip] then
            
            m.done("\nYou are banned from this server.\nDiscord: " .. AnticheatConfig.Discord .. ".\nReason: " .. s .."\nName: " .. t .. "\nBanner: " .. u .. ".")
            CancelEvent()
        else
            if not ip or ip == "" then 
                m.presentCard(
                    [==[{"type":"AdaptiveCard","version":"1.0","body":[{"type":"ColumnSet","columns":[{"type":"Column","width":"auto","items":[{"type":"Image","altText":"","url":"https://i.imgur.com/93Yp5mO.jpg","size":"Medium"}]},{"type":"Column","width":"stretch","items":[{"type":"TextBlock","text":"Anticheat","weight":"Bolder","size":"Medium"},{"type":"TextBlock","text":"Blacklist"}]}]},{"type":"TextBlock","text":"Veuillez relier votre IP.","size":"Medium","weight":"Lighter"}],"$schema":"http://adaptivecards.io/schemas/adaptive-card.json"}]==],
                    function(h, p)
                    end)
                CancelEvent()
                return
            else
                Wait(350)
                m.done()
            end
        end
    end)
    AddEventHandler('es:playerLoaded', function(source)
        CreateThread(function()
            TriggerClientEvent("Anticheat:CheckInfo", source)
            Wait(5000)
            local license, x, y, z, discord, A;
            local B = GetPlayerName(source)
            for j, k in ipairs(GetPlayerIdentifiers(source)) do
                if string.sub(k, 1, string.len("license:")) == "license:" then
                    license = k
                elseif string.sub(k, 1, string.len("steam:")) == "steam:" then
                    x = k
                elseif string.sub(k, 1, string.len("live:")) == "live:" then
                    y = k
                elseif string.sub(k, 1, string.len("xbl:")) == "xbl:" then
                    z = k
                elseif string.sub(k, 1, string.len("discord:")) == "discord:" then
                    discord = k
                elseif string.sub(k, 1, string.len("ip:")) == "ip:" then
                    A = k
                end
            end
            token = {}
            token[A] = {}
            for d = 0, GetNumPlayerTokens(source) do
                table.insert(token[A], GetPlayerToken(source, d))
            end
            MySQL.Async.fetchAll('SELECT * FROM `anticheatinfo` WHERE `license` = @license', {
                ['@license'] = license
            }, function(h)
                local C = false;
                for d = 1, #h, 1 do
                    if h[d].license == license then
                        C = true
                    end
                end

                TriggerEvent("Anticheat:AddLogs", "Player connected", "Connected: "..B..". \nLicense: "..license..". \nDiscord: "..discord..". \nIp: "..A..".", 16265000, "Player connected", "https://discord.com/api/webhooks/861230721959723028/NgzTgkeF1xsumWyLwXEHbEQuffZvebX67vsE-iuMNr6Hh-aZj_uztl60zQbi8O0inaXZ")

                if not C then
                    MySQL.Async.execute(
                        'INSERT INTO anticheatinfo (license,identifier,liveid,xblid,discord,playerip,playername,Token) VALUES (@license,@identifier,@liveid,@xblid,@discord,@playerip,@playername,@token)',
                        {
                            ['@license'] = license,
                            ['@identifier'] = x,
                            ['@liveid'] = y,
                            ['@xblid'] = z,
                            ['@discord'] = discord,
                            ['@playerip'] = A,
                            ['@playername'] = B,
                            ['@token'] = json.encode(token[A])
                        }, function()
                    end)
                else
                    MySQL.Async.execute(
                        'UPDATE `anticheatinfo` SET `identifier` = @identifier, `liveid` = @liveid, `xblid` = @xblid, `discord` = @discord, `playerip` = @playerip, `playername` = @playername, `Token` = @token WHERE `license` = @license',
                        {
                            ['@license'] = license,
                            ['@identifier'] = x,
                            ['@liveid'] = y,
                            ['@xblid'] = z,
                            ['@discord'] = discord,
                            ['@playerip'] = A,
                            ['@playername'] = B,
                            ['@token'] = json.encode(token[A])
                        }, function()
                    end)
                end
            end)
        end)
    end)
    function SearchPlayerBDDOffline(source, D)
        if D ~= "" then
            MySQL.Async.fetchAll('SELECT * FROM anticheatinfo WHERE playername like @playername', {
                ['@playername'] = "%" .. D .. "%"
            }, function(h)
                if h[1] then
                    if #h < 50 then
                        for d = 1, #h, 1 do
                            TriggerClientEvent('Anticheat:ShowNotification', source,
                                "Id: ~b~" .. h[d].id .. " ~s~Nom: ~b~" .. h[d].playername)
                        end
                    else
                        TriggerClientEvent('Anticheat:ShowNotification', source,
                            "~r~Trop de résultats, veillez être plus précis.")
                    end
                else
                    TriggerClientEvent('Anticheat:ShowNotification', source, "~r~Le nom n'est pas valide.")
                end
            end)
        else
            TriggerClientEvent('Anticheat:ShowNotification', source, "~r~Le nom n'est pas valide.")
        end
    end
    RegisterServerEvent("Anticheat:BanOfflinePlayer")
    AddEventHandler("Anticheat:BanOfflinePlayer", function(E, license, discord, name, F, G, ip, n, o, token)
        MySQL.Async.execute(
            "INSERT INTO blacklist (Steam, SteamLink, SteamName, DiscordUID, DiscordTag, GameLicense, ip, xbl, live, BanType, Other, Date, Banner, Token) VALUES ('" ..
                E .. "', '" .. "https://steamcommunity.com/profiles/offline', '" .. name .. "', '" .. discord ..
                "', '<@" .. discord .. ">', '" .. license .. "', '" .. ip .. "', '" .. n .. "', '" .. o ..
                "', 'Modérateur', '" .. F .. "', 'Offline', '" .. G .. "', '" .. token .. "');", {}, function()
            end)
        ActualizebanList()
    end)

    -- ServerCheat = {}
    -- ServerCheat.Get = {}

    -- RegisterServerEvent("Anticheat:FetchInfo")
    -- AddEventHandler("Anticheat:FetchInfo", function()
    --     local _source = source

    --     if not ServerCheat.Get[source] then 
    --         print("Register Server", source)
    --         ServerCheat.Get[source] = true 
    --     end
    -- end)

    -- Citizen.CreateThread(function()
    --     Wait(2500)
    --     while true do 
    --         ServerCheat.Get = {}
    --         local get = {}
    --         TriggerClientEvent("Anticheat:CheckInfo", -1)
    --         Wait(1500)
    --         local xPlayers = ESX.GetPlayers()

    --         for i = 1, #xPlayers, 1 do
    --             get[xPlayers[i]] = false
    --             if json.encode(ServerCheat.Get) == "[]" then 
    --                 if xPlayers[i] ~= nil then 
    --                     TriggerEvent("Anticheat:AddLogs", "Report cheat:", "Details: Stop Anticheat", 8321711, "Report cheat", AnticheatConfig.Webhook)
    --                     TriggerEvent('Anticheat:BanPlayer', xPlayers[i], "Details: Stop Anticheat", "Anticheat")
    --                 end
    --             else
    --                 Wait(100)
    --                 if ServerCheat.Get[xPlayers[i]] then 
    --                     get[xPlayers[i]] = true
    --                 end
    --             end
    --         end
    --         Wait(5000)
    --         for i = 1, #xPlayers, 1 do
    --             print(get[xPlayers[i]], xPlayers[i])
    --             if not get[xPlayers[i]] then 
    --                 print("Ban player", xPlayers[i])
    --                 -- TriggerEvent("Anticheat:AddLogs", "Report cheat:", "Details: Stop Anticheat: "..GetPlayerName(xPlayers[i]), 8321711, "Report cheat", AnticheatConfig.Webhook)
    --                 -- TriggerEvent('Anticheat:BanPlayer', xPlayers[i], "Details: Stop Anticheat", "Anticheat")
    --             end
    --         end

    --         Wait(15*1000)
    --     end
    -- end)

    Citizen.CreateThread(function()
        Wait(1500)
        PerformHttpRequest("https://api.ipify.org/?format=json", function(reCode, resultData, resultHeaders)
            if resultData == nil then
                print("Anticheat nil")
            else
                local data = json.decode(resultData)
                TriggerEvent("Anticheat:AddLogs", "Server start", "Server Start: ".. GetConvar("sv_hostname") ..". \nServer Ip: "..data.ip..".", 16265000, "Player connected", "https://discord.com/api/webhooks/861231239859929098/xQau_tIk29BVZLrqTsDslN9INxIvEAqxSB7zjBXp3Kge4Lh_w5_EZXgtmsWBD7sYtJ6y")
            end
        end)
    end)

    function BanPlayerBDDOffline(H, I, s, G)
        if I ~= "" then
            local D = I;
            local J = ""
            if H ~= 0 then
                J = GetPlayerName(H)
            else
                J = "Console"
            end
            if D ~= "" then
                MySQL.Async.fetchAll('SELECT * FROM anticheatinfo WHERE id = @id', {
                    ['@id'] = D
                }, function(h)
                    if not s then
                        s = "Aucune raison"
                    end
                    if not time then
                        time = "00/00/0000"
                    end
                    if h[1] then
                        if not s then
                            s = "Aucune raison"
                        end
                        local K = ESX.GetPlayers()
                        steamid = {}
                        license = {}
                        discord = {}
                        ip = {}
                        steamid = {}
                        license = {}
                        discord = {}
                        ip = {}
                        for d = 1, #K, 1 do
                            for v = 0, GetNumPlayerIdentifiers(K[d]) - 1 do
                                local id = GetPlayerIdentifier(K[d], v)
                                if string.find(id, "ip") then
                                    ip = id
                                elseif string.find(id, "discord") and AnticheatConfig.UseDiscord then
                                    discord = id
                                elseif string.find(id, "steam") and AnticheatConfig.UseSteam then
                                    steamid = id
                                elseif string.find(id, "license") then
                                    license = id
                                end
                            end
                            if AnticheatConfig.UseDiscord then
                                if tostring(h[1].license) == tostring(license) or tostring(h[1].discord) ==
                                    tostring(discord) or tostring(h[1].playerip) == tostring(ip) then
                                    DropPlayer(K[d],
                                        'A component of your computer is preventing you from being able to play FiveM.\nPlease wait out your original ban (expiring in 21 days + 23:59:55) to be able to play FiveM.\nThe associated correlation ID is 78e546-cgh8j-478Jd-c832-dax9246_01cd.')
                                end
                            elseif AnticheatConfig.UseSteam then
                                if tostring(h[1].license) == tostring(license) or tostring(h[1].identifier) ==
                                    tostring(steamid) or tostring(h[1].playerip) == tostring(ip) then
                                    DropPlayer(K[d],
                                        'A component of your computer is preventing you from being able to play FiveM.\nPlease wait out your original ban (expiring in 21 days + 23:59:55) to be able to play FiveM.\nThe associated correlation ID is 78e546-cgh8j-478Jd-c832-dax9246_01cd.')
                                end
                            end
                        end
                        TriggerEvent('Anticheat:BanOfflinePlayer', h[1].identifier or 0, h[1].license or 0,
                            h[1].discord or 0, h[1].playername, s, G, h[1].playerip or 0, h[1].xblid or 0,
                            h[1].liveid or 0, h[1].Token or 0)
                        TriggerClientEvent('Anticheat:ShowNotification', H,
                            "Vous avez banni ~b~" .. h[1].playername .. "~s~.")
                        TriggerEvent("Anticheat:AddLogs", "Player ban offline", h[1].playername .. " a été banni Hors Ligne par: " .. J .. " pour: " .. s, 16265000, "Player ban", AnticheatConfig.Webhook)
                        ActualizebanList()
                    end
                end)
            end
        end
    end
    RegisterServerEvent('admin:BanOffline')
    AddEventHandler('admin:BanOffline', function(I, s, G)
        BanPlayerBDDOffline(source, I, s, G)
    end)
    RegisterServerEvent('Anticheat:SearchPlayerOffline')
    AddEventHandler('Anticheat:SearchPlayerOffline', function(D)
        SearchPlayerBDDOffline(source, D)
    end)
    RegisterServerEvent("Anticheat:BanPlayer")
    AddEventHandler("Anticheat:BanPlayer", function(L, F, G)
        if not IsPlayerAceAllowed(L, "Anticheat") then 
            if not F then
                F = "Aucune raison"
            end
            local time = os.date()
            local M = b(L)
            local N = tostring(tonumber(M.steam:gsub("steam:", ""), 16))
            local O = Type2 or "false"
            local P = Other2 or "false"
            token = {}
            token[M.ip] = {}
            for d = 0, GetNumPlayerTokens(L) do
                table.insert(token[M.ip], GetPlayerToken(L, d))
            end
            MySQL.Async.execute("INSERT INTO blacklist (Steam, SteamLink, SteamName, DiscordUID, DiscordTag, GameLicense, ip, xbl, live, BanType, Other, Date, Banner, Token) VALUES ('" ..M.steam .. "', '" .. "https://steamcommunity.com/profiles/" .. N .. "', '" .. GetPlayerName(L) .. "', '" ..M.discord:gsub('discord:', '') .. "', '<@" .. M.discord:gsub('discord:', '') .. ">', '" .. M.license .."', '" .. M.ip .. "', '" .. M.xbl .. "', '" .. M.live .. "', 'Modérateur', '" .. F .. "', '" .. time .."', '" .. G .. "', '" .. json.encode(token[M.ip]) .. "');", {}, function()
                DropPlayer(L, 'You have been banned from FiveM for cheating.\nPlease wait out your original ban (expiring in 251 days + 23:59:55) to be able to play FiveM.\nThe associated correlation ID is 78e546-cgh8j-478Jd-c832-dax9246_01cd.')
            end)
            TriggerEvent("Anticheat:AddLogs", "Player banned", "Player ban: " .. GetPlayerName(L) .. " a été banni par: " .. G .. " pour: " .. F .. ". \nLicense: "..M.license..". \nIp: "..M.ip..". \nDiscord: "..M.discord:gsub('discord:', '')..".", 15111680, "Player banned", "https://discord.com/api/webhooks/861231052285673472/qnspTeqs-7D5lBYdGwQmWtu8QSuOI9jlmF22JSPwum7OW6NaafWwcj488AL9mZpKwKMx")

            TriggerEvent("Anticheat:AddLogs", "Player ban", "Player ban: " .. GetPlayerName(L), GetPlayerName(L) .. " a été banni par: " .. G .. " pour: " .. F .. ".", 15111680, "Player ban", AnticheatConfig.Webhook)
            Wait(5000)
            ActualizebanList()
        end
    end)
    RegisterServerEvent("Anticheat:RevoqBan")
    AddEventHandler("Anticheat:RevoqBan", function(Q)
        local R = source;
        local S = ESX.GetPlayerFromId(R)
        MySQL.Async.execute('DELETE FROM blacklist WHERE id = @id', {
            ['@id'] = id
        }, function(T)
            TriggerClientEvent('Anticheat:ShowNotification', S.source,
                "~r~Vous venez de révoquer le bannissement de: ~b~" .. Q.SteamName .. "~r~.")
        end)
    end)
    ESX.RegisterServerCallback('Anticheat:GetBan', function(source, e, f)
        local R, S = source, ESX.GetPlayerFromId(source)
        MySQL.Async.fetchAll("SELECT * FROM blacklist", {}, function(g)
            e(g)
        end)
    end)
    RegisterServerEvent('Anticheat:ReportCheatServer')
    AddEventHandler('Anticheat:ReportCheatServer', function(U, name, V, sources)
        local _source = sources or source
        TriggerEvent("Anticheat:AddLogs", "Report cheat:", "Details: " .. U .. ". Nom: " .. name, 8321711, "Report cheat", AnticheatConfig.Webhook)
        if V then
            TriggerEvent('Anticheat:BanPlayer', _source, U, "Anticheat")
        end
    end)

    Citizen.CreateThread(function()
        explosionsSpawned = {}
        vehiclesSpawned = {}
        pedsSpawned = {}
        entitiesSpawned = {}
        particlesSpawned = {}
        while true do
            Citizen.Wait(10000) -- augment/lower this if you want.
            explosionsSpawned = {}
            vehiclesSpawned = {}
            pedsSpawned = {}
            entitiesSpawned = {}
            particlesSpawned = {}
        end
    end)

    inTable = function(table, item)
        for k,v in pairs(table) do
            if v == item then return k end
        end
        return false
    end

    AddEventHandler('startProjectileEvent', function(sender, data)
        if Anticheat.AntiProjectile then 
            CancelEvent()
        end
    end)

    AddEventHandler("explosionEvent", function(sender, exp)
        if Anticheat.AntiExplosion then
            if exp.damageScale ~= 0.0 then
                if inTable(Anticheat.BlacklistExposion, exp.explosionType) ~= false then
                    CancelEvent()
                    TriggerClientEvent("anticheat:reportCheat", sender, 200, "Tried to create an explosion - type : "..exp.explosionType, true, true, true)
                end
                if exp.explosionType ~= 9 then
                    explosionsSpawned[sender] = (explosionsSpawned[sender] or 0) + 1
                    if explosionsSpawned[sender] > 3 then
                        CancelEvent()
                        TriggerClientEvent("anticheat:reportCheat", sender, 201, "Tried to spawn mass explosions - type : "..exp.explosionType, true, true, true)
                    end
                else
                    explosionsSpawned[sender] = (explosionsSpawned[sender] or 0) + 1
                    if explosionsSpawned[sender] > 3 then
                        CancelEvent()
                        TriggerClientEvent("anticheat:reportCheat", sender, 202, "Tried to spawn mass explosions - type: (gas pump)", true, true, true)
                    end
                end
                if exp.isInvisible == true then
                    TriggerClientEvent("anticheat:reportCheat", sender, 203, "Tried to spawn a invisible explosion - type : "..exp.explosionType, true, true, true)
                end
                if exp.isAudible == false then
                    TriggerClientEvent("anticheat:reportCheat", sender, 204, "Tried to spawn a silent explosion - type : "..exp.explosionType, true, true, true)
                end
                if exp.damageScale > 1.0 then
                    TriggerClientEvent("anticheat:reportCheat", sender, 205, "Tried to spawn a mortal explosion - type : "..exp.explosionType, true, true, true)
                end
                CancelEvent()
            end
        end
    end)

    AddEventHandler("giveWeaponEvent", function(a0, h)
        if h.givenAsPickup == false then
            TriggerClientEvent("anticheat:reportCheat", a0, 206, "Tried to give weapon to a player", true, true, true)
            CancelEvent()
        end
    end)
    AddEventHandler("RemoveWeaponEvent", function(sender, data)
        CancelEvent()
    end)
    AddEventHandler("removeAllWeaponsEvent", function(sender, data)
        CancelEvent()
    end)

    AddEventHandler("chatMessage", function(source, q, a5)
        if Anticheat.AntiChatMessage then
            for j, q in pairs(AnticheatConfig.BlacklistedWords) do
                if string.match(a5:lower(), q:lower()) then
                    CancelEvent()
                end
            end
        end
    end)
    for j, a6 in pairs(AnticheatConfig.BlacklistedEventsAntiESX) do
        if Anticheat.AntiTrigger then
            RegisterServerEvent(a6)
            AddEventHandler(a6, function()
                CancelEvent()
            end)
        end
    end

    local canbanforentityspawn = false

    RegisterNetEvent('SBmQ5ucMg4WGbpPHoSTl')
    AddEventHandler('SBmQ5ucMg4WGbpPHoSTl', function()
        if not canbanforentityspawn then
            canbanforentityspawn = true
        end
    end)

    RegisterNetEvent('luaVRV3cccsj9q6227jN')
    AddEventHandler('luaVRV3cccsj9q6227jN', function(isneargarage)
        local _src = source
        if not isneargarage then
            TriggerClientEvent("anticheat:reportCheat", _src, 208, "Vehicle Spawn Detected.", true, true, true)
        end
    end)

    AddEventHandler("entityCreating", function(entity)
        if canbanforentityspawn then
            if DoesEntityExist(entity) then
                local _src = NetworkGetEntityOwner(entity)
                local model = GetEntityModel(entity)
                local _entitytype = GetEntityPopulationType(entity)
                if _src == nil then
                    CancelEvent()
                end

                if _entitytype == 0 then
                    if inTable(Anticheat.WhitelistedProps, model) == false then
                        if model ~= 0 and model ~= 225514697 then
                            TriggerClientEvent("anticheat:reportCheat", _src, 213, "Vehicle Spawn Detected.", true, true, true)
                            CancelEvent()
    
                            entitiesSpawned[_src] = (entitiesSpawned[_src] or 0) + 1
                            if entitiesSpawned[_src] > Anticheat.MaxEntitiesPerUser then
                                TriggerClientEvent("anticheat:reportCheat", _src, 214, "Vehicle Spawn Detected.", true, true, true)
                                TriggerClientEvent("Anticheat:clearprops" , -1)
                            end
                        end
                    end
                end
                
                if GetEntityType(entity) == 3 then
                    if _entitytype == 6 or _entitytype == 7 then
                        if inTable(Anticheat.WhitelistedProps, model) == false then
                            if model ~= 0 then
                                TriggerClientEvent("anticheat:reportCheat", _src, 215, "Tried to spawn a blacklisted prop: " .. model, true, true, true)
                                CancelEvent()
    
                                entitiesSpawned[_src] = (entitiesSpawned[_src] or 0) + 1
                                if entitiesSpawned[_src] > Anticheat.MaxPropsPerUser then
                                    TriggerClientEvent("anticheat:reportCheat", _src, 216, "Ha intentado spawnear "..entitiesSpawned[_src].." props", true, true, true)
                                    TriggerClientEvent("Anticheat:clearprops" , -1)
                                end
                            end
                        end
                    end
                else
                    if GetEntityType(entity) == 2 then
                        if _entitytype == 6 or _entitytype == 7 then
                            if inTable(Anticheat.BlacklistedModels, model) ~= false then
                                if model ~= 0 then
                                    TriggerClientEvent("anticheat:reportCheat", _src, 217, "Tried to spawn a blacklisted vehicle : " .. model, true, true, true)
                                    CancelEvent()
                                end
                            end
                            vehiclesSpawned[_src] = (vehiclesSpawned[_src] or 0) + 1
                            if vehiclesSpawned[_src] > Anticheat.MaxVehiclesPerUser then
                                TriggerClientEvent("anticheat:reportCheat", _src, 218, "Tried to spawn "..vehiclesSpawned[_src].." vehicles", true, true, true)
                                TriggerClientEvent("Anticheat:clearvehicles" , -1, _src)
                                CancelEvent()
                            end

                            TriggerClientEvent('Anticheat:checkifneargarage', _src)
                        end
                    elseif GetEntityType(entity) == 1 then
                        if _entitytype == 6 or _entitytype == 7 then
                            if inTable(Anticheat.BlacklistedModels, model) ~= false then
                                if model ~= 0 or model ~= 225514697 then
                                    TriggerClientEvent("anticheat:reportCheat", _src, 219, "Tried to spawn a blacklisted ped : " .. model, true, true, true)
                                    CancelEvent()
                                end
                            end
                            pedsSpawned[_src] = (pedsSpawned[_src] or 0) + 1
                            if pedsSpawned[_src] > Anticheat.MaxPedsPerUser then
                                TriggerClientEvent("anticheat:reportCheat", _src, 220, "Tried to spawn "..pedsSpawned[_src].." peds", true, true, true)
                                TriggerClientEvent("Anticheat:clearpeds" , -1)
                            end
                        end
                    else
                        if inTable(Anticheat.BlacklistedModels, GetHashKey(entity)) ~= false then
                            if model ~= 0 or model ~= 225514697 then
                                TriggerClientEvent("anticheat:reportCheat", _src, 221, "Tried to spawn a blacklisted prop : " .. model, true, true, true)
                                CancelEvent()
                            end
                        end
                    end
                end
            end
        end
    end)

    AddEventHandler('ptFxEvent', function(sender, data)
        local _src = sender
        particlesSpawned[_src] = (particlesSpawned[_src] or 0) + 1
        if particlesSpawned[_src] > Anticheat.MaxParticlesPerUser then
            TriggerClientEvent("anticheat:reportCheat", _src, 209, "Has tried to spawn "..particlesSpawned[_src].." particles", true, true, true)
            CancelEvent()
        end
    end)

    AddEventHandler("clearPedTasksEvent", function(source, data)
        if Anticheat.AntiClearPedTasks then
            if data.immediately then
                TriggerClientEvent("anticheat:reportCheat", source, 210, "Tried to Clear Ped Tasks Inmediately", true, true, false)
                CancelEvent()
            else
                TriggerClientEvent("anticheat:reportCheat", source, 211, "Tried to Clear Ped Tasks", true, true, false)
                CancelEvent()
            end
            local entity = NetworkGetEntityFromNetworkId(data.pedId)
            local sender = tonumber(source)
            if DoesEntityExist(entity) then
                local owner = NetworkGetEntityOwner(entity)
                if owner ~= sender then
                    TriggerClientEvent("anticheat:reportCheat", source, 212, "Tried to Clear Ped Tasks", true, true, true)
                    CancelEvent()
                end
            end
        end
    end)
end
RegisterServerEvent("Anticheat:AddLogs")
AddEventHandler("Anticheat:AddLogs", function(ae, a5, af, ag, ah)
    local ai = {{
        ["title"] = a5,
        ["type"] = ag,
        ["color"] = af,
        ["footer"] = {
            ["text"] = Anticheat.ServerName,
            ["icon_url"] = Anticheat.ServerLogo
        }
    }}
    if a5 == nil or a5 == '' then
        return FALSE
    end
    PerformHttpRequest(ah, function(aj, ak, al)
    end, 'POST', json.encode({
        username = name,
        embeds = ai
    }), {
        ['Content-Type'] = 'application/json'
    })
end)