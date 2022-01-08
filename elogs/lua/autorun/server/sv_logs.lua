util.AddNetworkString("elogs_sendlog")
util.AddNetworkString("elogs_open")

local function GetAdmins()
    local plytbl = {}
    for _,v in ipairs(player.GetAll()) do
        if elogs.Config.AllowedRanks[v:GetUserGroup()] then
            table.insert(plytbl,v)
        end
    end
    return plytbl
end

local function SendToAdmins(tbl)
    net.Start("elogs_sendlog")
    net.WriteString(util.TableToJSON(tbl))
    net.Send(GetAdmins())
end

hook.Add("PlayerSay","elogs:openmenu",function(ply,txt,bool)
    if elogs.Config.AllowedRanks[ply:GetUserGroup()] and elogs.Config.Commands[string.lower(string.Trim(txt))] then
        net.Start("elogs_open")
        net.Send(ply)
        return ""
    end
end)

/////////////////////////////////
///         Main Logs         ///
/////////////////////////////////

hook.Add("PlayerInitialSpawn","elogs:logspawn",function(ply,bool)
    local log = {}
    log.Players = {}
    log.Players.Player = ply:SteamID()
    log.Category = "Connect / Disconnect"
    log.Data = os.date("[%H:%M:%S]").." "..ply:Nick().." ("..ply:SteamID()..") has connected"
    SendToAdmins(log)
end)

hook.Add("PlayerDisconnected","elogs:logdisconnect",function(ply)
    local log = {}
    log.Players = {}
    log.Players.Player = ply:SteamID()
    log.Category = "Connect / Disconnect"
    log.Data = os.date("[%H:%M:%S]").." "..ply:Nick().." ("..ply:SteamID()..") has disconnected"
    SendToAdmins(log)
end)

hook.Add("PlayerSay","elogs:logsay",function(ply,text,bool)
    local log = {}
    log.Players = {}
    log.Players.Player = ply:SteamID()
    log.Category = "Chat"
    log.Data = os.date("[%H:%M:%S]").." "..ply:Nick()..": "..text
    SendToAdmins(log)
end)

hook.Add("PlayerDeath","elogs:logsdeath",function(ply,inflictor,killer)
    local log = {}
    log.Players = {}
    log.Players.Player = ply:SteamID()
    log.Category = "Deaths"
    if killer:IsPlayer() and killer != ply then
        log.Data = os.date("[%H:%M:%S]").." "..killer:Nick().." killed "..ply:Nick().." using a "..inflictor:GetClass()
        log.Players.Attacker = killer:SteamID()
    elseif killer:IsPlayer() and killer == ply then
        log.Data = os.date("[%H:%M:%S]").." "..ply:Nick().." suicided"
    elseif !killer:IsPlayer() then
        log.Data = os.date("[%H:%M:%S]").." "..ply:Nick().." was killed by "..killer:GetClass()
    else
        log.Data = os.date("[%H:%M:%S]").." DATA ERROR"
    end
    SendToAdmins(log)
end)

hook.Add("PlayerHurt","elogs:logsdmg",function(ply,attacker,remaining,taken)
    taken = math.Round(taken)
    local log = {}
    log.Players = {}
    log.Players.Player = ply:SteamID()
    log.Category = "Damage"
    if attacker:IsPlayer() then
        log.Data = os.date("[%H:%M:%S]").." "..ply:Nick().." took "..taken.." damage from "..attacker:Nick().." using a "..attacker:GetActiveWeapon():GetClass()
        log.Players.Attacker = attacker:SteamID()
    else
        log.Data = os.date("[%H:%M:%S]").." "..ply:Nick().." took "..taken.." damage from "..attacker:GetClass()
    end
    SendToAdmins(log)
end)

hook.Add("OnPhysgunPickup","elogs:physgun",function(ply, ent)
    if ent:CPPIGetOwner() == ply then return end
    local log = {}
    log.Players = {}
    log.Players.Player = ply:SteamID()
    log.Category = "Physgun"
    if ent:IsPlayer() then
        log.Data = os.date("[%H:%M:%S]").." "..ply:Nick().." physgunned "..ent:Nick()
    elseif IsValid(ent:CPPIGetOwner()) then
        log.Data = os.date("[%H:%M:%S]").." "..ply:Nick().." physgunned an entity owned by "..ent:CPPIGetOwner():Nick()
        log.Players.Owner = ent:CPPIGetOwner():SteamID()
    else return end
    SendToAdmins(log)
end)

hook.Add("PlayerSpawnedProp","elogs:propspawn",function(ply,mdl,ent)
    local log = {}
    log.Players = {}
    log.Players.Player = ply:SteamID()
    log.Category = "Entity Spawning"
    log.Data = os.date("[%H:%M:%S]").." "..ply:Nick().." spawned a prop with the model "..mdl
    SendToAdmins(log)
end)

hook.Add("PlayerSpawnedSENT","elogs:entspawn",function(ply,ent)
    local log = {}
    log.Players = {}
    log.Players.Player = ply:SteamID()
    log.Category = "Entity Spawning"
    log.Data = os.date("[%H:%M:%S]").." "..ply:Nick().." spawned a "..ent:GetClass()
    SendToAdmins(log)
end)

hook.Add("CanTool","elogs:toolgun",function(ply,tr,name,tool,num)
    local log = {}
    log.Players = {}
    log.Players.Player = ply:SteamID()
    log.Category = "Toolgun"
    if IsValid(tr.Entity:CPPIGetOwner()) then
        log.Data = os.date("[%H:%M:%S]").." "..ply:Nick().." used the toolgun "..name.." on "..tr.Entity.." owned by "..tr.Entity:CPPIGetOwner():Nick()
        log.Players.Owner = tr.Entity:CPPIGetOwner():SteamID()
    elseif IsValid(tr.Entity) then
        log.Data = os.date("[%H:%M:%S]").." "..ply:Nick().." used the toolgun "..name.." on "..tr.Entity:GetClass()
    else
        log.Data = os.date("[%H:%M:%S]").." "..ply:Nick().." used the toolgun "..name
    end
    SendToAdmins(log)
end)


-- Do Vehicle Damage
-- Toolgun Logs

/////////////////////////////////
///        DarkRP Logs        ///
/////////////////////////////////

-- Money Logs --

hook.Add("playerPickedUpCheque","elogs:darkrp:logchequepickup",function(ply , supposed, amount, success, ent)
    if success and ply != ent:CPPIGetOwner() then
        local log = {}
        log.Players = {}
        log.Players.Player = ply:SteamID()
        log.Category = "DarkRP Money"
        log.Data = os.date("[%H:%M:%S]").." "..ply:Nick().." picked up a check of "..DarkRP.formatMoney(amount)
        SendToAdmins(log)
    end
end)

hook.Add("playerDroppedCheque","elogs:darkrp:logchequedropped",function(ply , supposed, amount, ent)
    local log = {}
    log.Players = {}
    log.Players.Player = ply:SteamID()
    log.Category = "DarkRP Money"
    log.Data = os.date("[%H:%M:%S]").." "..ply:Nick().." dropped a cheque of "..DarkRP.formatMoney(amount)
    SendToAdmins(log)
end)

hook.Add("playerToreUpCheque","elogs:darkrp:logchequetore",function(ply , supposed, amount, ent)
    local log = {}
    log.Players = {}
    log.Players.Player = ply:SteamID()
    log.Category = "DarkRP Money"
    log.Data = os.date("[%H:%M:%S]").." "..ply:Nick().." tore up a check of "..DarkRP.formatMoney(amount)
    SendToAdmins(log)
end)

hook.Add("playerPickedUpMoney","elogs:darkrp:logmoneypickup",function(ply, amount, ent)
    local log = {}
    log.Players = {}
    log.Players.Player = ply:SteamID()
    log.Category = "DarkRP Money"
    log.Data = os.date("[%H:%M:%S]").." "..ply:Nick().." picked up "..DarkRP.formatMoney(amount)
    SendToAdmins(log)
end)

hook.Add("playerDroppedMoney","elogs:darkrp:logmoneydrop",function(ply, amount, ent)
    local log = {}
    log.Players = {}
    log.Players.Player = ply:SteamID()
    log.Category = "DarkRP Money"
    log.Data = os.date("[%H:%M:%S]").." "..ply:Nick().." dropped "..DarkRP.formatMoney(amount)
    SendToAdmins(log)
end)

hook.Add("playerGaveMoney","elogs:darkrp:logmoneygive",function(ply, receiver, amount)
    local log = {}
    log.Players = {}
    log.Players.Player = ply:SteamID()
    log.Category = "DarkRP Money"
    log.Data = os.date("[%H:%M:%S]").." "..ply:Nick().." gave "..receiver:Nick().." "..DarkRP.formatMoney(amount)
    log.Players.Receiver = receiver:SteamID()
    SendToAdmins(log)
end)

-- Lockpick Logs --

hook.Add("lockpickStarted","elogs:darkrp:lockpickstart",function(ply, ent, tr)
    local log = {}
    log.Players = {}
    log.Players.Player = ply:SteamID()
    log.Category = "Lockpick"
    if ent:isDoor() and !IsValid(ent:getDoorOwner()) then
        log.Data = os.date("[%H:%M:%S]").." "..ply:Nick().." started lockpicking an unowned door"
    elseif ent:isDoor() and IsValid(ent:getDoorOwner()) then
        log.Data = os.date("[%H:%M:%S]").." "..ply:Nick().." started lockpicking a door owned by "..ent:getDoorOwner():Nick()
        log.Players.Owner = ent:getDoorOwner():SteamID()
    elseif !ent:isDoor() and IsValid(ent:CPPIGetOwner()) then
        log.Data = os.date("[%H:%M:%S]").." "..ply:Nick().." started lockpicking an entity owned by "..ent:CPPIGetOwner():Nick()
        log.Players.Owner = ent:getDoorOwner():SteamID()
    else
        log.Data = os.date("[%H:%M:%S]").." "..ply:Nick().." started lockpicking an entity"
    end
    SendToAdmins(log)
end)

hook.Add("onLockpickCompleted","elogs:darkrp:lockpickcomplete",function(ply, success, ent)
    if !success then return end
    local log = {}
    log.Players = {}
    log.Players.Player = ply:SteamID()
    log.Category = "Lockpick"
    if ent:isDoor() and !IsValid(ent:getDoorOwner()) then
        log.Data = os.date("[%H:%M:%S]").." "..ply:Nick().." completed lockpicking an unowned door"
    elseif ent:isDoor() and IsValid(ent:getDoorOwner()) then
        log.Data = os.date("[%H:%M:%S]").." "..ply:Nick().." completed lockpicking a door owned by "..ent:getDoorOwner():Nick()
        log.Players.Owner = ent:getDoorOwner():SteamID()
    elseif !ent:isDoor() and IsValid(ent:CPPIGetOwner()) then
        log.Data = os.date("[%H:%M:%S]").." "..ply:Nick().." completed lockpicking an entity owned by "..ent:CPPIGetOwner():Nick()
        log.Players.Owner = ent:getDoorOwner():SteamID()
    else
        log.Data = os.date("[%H:%M:%S]").." "..ply:Nick().." completed lockpicking an entity"
    end
    SendToAdmins(log)
end)

-- Doors Log --

hook.Add("playerBoughtDoor","elogs:darkrp:buydoor",function(ply, ent, cost)
    local log = {}
    log.Players = {}
    log.Players.Player = ply:SteamID()
    log.Category = "Doors"
    log.Data = os.date("[%H:%M:%S]").." "..ply:Nick().." bought a door for "..DarkRP.formatMoney(cost)
    SendToAdmins(log)
end)

hook.Add("playerKeysSold","elogs:darkrp:selldoor",function(ply, ent, cost)
    local log = {}
    log.Players = {}
    log.Players.Player = ply:SteamID()
    log.Category = "Doors"
    if ent:isDoor() then
        log.Data = os.date("[%H:%M:%S]").." "..ply:Nick().." sold a door for "..DarkRP.formatMoney(cost)
    end
    SendToAdmins(log)
end)

hook.Add("onAllowedToOwnAdded","elogs:darkrp:dooradd",function(ply, ent, target)
    local log = {}
    log.Players = {}
    log.Players.Player = ply:SteamID()
    log.Category = "Doors"
    log.Data = os.date("[%H:%M:%S]").." "..ply:Nick().." added "..target:Nick().." to a door"
    log.Players.Target = target:SteamID()
    SendToAdmins(log)
end)

hook.Add("onAllowedToOwnRemoved","elogs:darkrp:doorremove",function(ply, ent, target)
    local log = {}
    log.Players = {}
    log.Players.Player = ply:SteamID()
    log.Category = "Doors"
    log.Data = os.date("[%H:%M:%S]").." "..ply:Nick().." removed "..target:Nick().." from a door"
    log.Players.Target = target:SteamID()
    SendToAdmins(log)
end)