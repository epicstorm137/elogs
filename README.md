# ELogs
Epicstorm's Logs Addon

Features:
- Log anything you like using a hook
- Logs are stored on the client for minimal networking and to prevent networking large tables
- Stores the steamid's of the players involved and able to copy them by right clicking on the line
- Config in the "sh_loader.lua" file
- Custom UI for the logs


Instructions:

1) Download File
2) Place in Addons folder of Garry's Mod
3) Load Server and test addon!!!

Example of hook:

Make sure to put the category in the "sh_loader.lua" folder before creating the hook

Create a Hook and include the following inside the hook:

    local log = {} -- Clears the Log table
    log.Players = {} -- Clears the Log of players involved table
    log.Players.Player = ply:SteamID() -- Adds a SteamID to be added to the right click menu, e.g. "log.Players.Owner = ply:SteamID()" will add a rightclick for the Owner
    log.Category = "ENTER_CATEGORY" -- Category must be the same as the category in the "sh_loader.lua" file
    log.Data = os.date("[%H:%M:%S]").." "..ply:Nick().." did something!" -- This will be the line that comes up in the log menu
    SendToAdmins(log) -- Sends the log to the clients

Then it should be done!
