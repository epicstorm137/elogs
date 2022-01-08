elogs = elogs or {}
elogs.Config = elogs.Config or {}
elogs.Log = elogs.Log or {}

elogs.Categories = {
    "Connect / Disconnect",
    "Physgun",
    "Toolgun",
    "Deaths",
    "Damage",
    "Chat",
    "DarkRP Money",
    "Entity Spawning",
    "Lockpick",
    "Doors",
}

if CLIENT then
    local function LoadCats()
        for k,v in ipairs(elogs.Categories) do
            elogs.Log[v] = {}
        end
    end

    hook.Add("Initialize","elogs:loadcategories",LoadCats)
end

-- DO NOT TOUCH ANYTHING ABOVE -- 

elogs.Config.AllowedRanks = {
    ["superadmin"] = true,
    ["admin"] = true,
}

elogs.Config.Commands = {
    ["/logs"] = true,
    ["!logs"] = true,
}