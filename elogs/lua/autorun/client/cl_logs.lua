net.Receive("elogs_sendlog",function()
    local data = util.JSONToTable(net.ReadString())
    table.insert(elogs.Log[data.Category],data)
end)

net.Receive("elogs_open",function()
    elogs.OpenLogs()
end)

function elogs.OpenLogs()
    local scrw,scrh = ScrW(),ScrH()

    local frame = vgui.Create("DFrame")
	frame:SetSize(0,0)
	frame:Center()
	frame:MakePopup()
	frame:SetVisible(true)
	frame:DockPadding(10,30,10,10)
	elogs.MakeFrame(frame,"ELogs Menu",scrw*.5,scrh*.5)

    local cats = vgui.Create("DListView",frame)
    cats:Dock(LEFT)
    cats:SetMultiSelect(false)
    cats:SetWide(scrw*.075)
    cats:AddColumn("Category",1)
    cats:SortByColumn(1,true)
    elogs.MakeList(cats)
    for k,v in SortedPairsByValue(elogs.Categories,false) do
        cats:AddLine(v)
    end

    local logs = vgui.Create("DListView",frame)
    logs:Dock(FILL)
    logs:SetMultiSelect(false)
    logs:DockMargin(5,0,0,0)
    logs:AddColumn("Logs",1)
    elogs.MakeList(logs)

    cats.OnRowSelected = function( panel, index, row )
        logs:Clear()
        local categorytype = row:GetValue(1)
        for k,v in ipairs(elogs.Log[categorytype]) do
            local line = logs:AddLine(v.Data)
            
            line.OnRightClick = function()
                local rightclick = DermaMenu()
                rightclick:AddOption("Copy Line",function() SetClipboardText(line:GetColumnText(1)) end)

                for t,a in pairs(v.Players) do
                    rightclick:AddOption("Copy "..t.."'s SteamID",function() SetClipboardText(a) end)
                end

                rightclick:Open(gui.MouseX(),gui.MouseY())
            end

        end
        logs:SortByColumn(1,true)
    end
end