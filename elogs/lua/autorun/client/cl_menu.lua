elogs.bgdark     = Color(69,81,97)
elogs.bglight    = Color(118,134,165)
elogs.grey       = Color(150,150,150)
elogs.hghlight   = Color(141,141,190)
elogs.white      = Color(255,255,255)
elogs.blackhud   = Color(20,20,20,253)
elogs.green      = Color(94,214,94)
elogs.red        = Color(204,117,117)
elogs.blue       = Color(110,117,212)
elogs.wfgreen    = Color(0,255,0)
elogs.rfgreen    = Color(0,255,0,50)

local PNL = FindMetaTable("Panel")

surface.CreateFont("ELogsFont",{font = "Roboto",size = 255, antialias = true})
surface.CreateFont("ELogsFontUI",{font = "Roboto",size = 20, antialias = true})
surface.CreateFont("ELogsFontUISmall",{font = "Roboto",size = 15, antialias = true})

function elogs.MakeFrame(pnl,txt,width,height)
    pnl:SetTitle("")
    pnl.IsMoving = true
    pnl:SizeTo(width,height,1,0,.1,function()
        pnl.IsMoving = false
    end)
    pnl.Paint = function(s,w,h)
        if pnl.IsMoving == true then
            pnl:Center()
        end
        surface.SetDrawColor(elogs.bgdark)
        surface.DrawRect(0,0,w,h)
        draw.SimpleText(txt,"ELogsFontUISmall",10,7,elogs.white,TEXT_ALIGN_LEFT,TEXT_ALIGN_TOP)
    end
end

function elogs.MakeButton(pnl,txt,col)
    pnl:SetText("")
    local speed,barstatus = 4,0
    pnl.Paint = function(s,w,h)
        if pnl:IsHovered() then
            barstatus = math.Clamp(barstatus + speed * FrameTime(), 0, 1)
        else
            barstatus = math.Clamp(barstatus - speed * FrameTime(), 0, 1)
        end
        surface.SetDrawColor(elogs.bglight)
        surface.DrawRect(0,0,w,h)
        surface.SetDrawColor(col)
        surface.DrawRect(0,h * .9,w * barstatus,h * .1)
        draw.SimpleText(txt,"ELogsFontUI",w/2,h/2,col,TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
    end
end
    
function elogs.MakeInput(pnl,txt)
    pnl:SetFont("ELogsFontUISmall")
    pnl.Paint = function(s,w,h)
        surface.SetDrawColor(elogs.bglight)
        surface.DrawRect(0,0,w,h)
        if pnl:GetText() == "" then
            draw.SimpleText(txt,"ELogsFontUISmall",5,h/2,elogs.grey,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
        end
        pnl:DrawTextEntryText(elogs.white,elogs.hghlight,elogs.white)
    end
end
    
function elogs.MakeCombo(pnl,txt)
    pnl:SetFont("ELogsFontUISmall")
    pnl:SetColor(elogs.white)
    pnl.Paint = function(s,w,h)
        surface.SetDrawColor(elogs.bglight)
        surface.DrawRect(0,0,w,h)
        if pnl:GetSelected() == nil and pnl:GetText() == "" then
            draw.SimpleText(txt,"ELogsFontUISmall",5,h/2,elogs.grey,TEXT_ALIGN_LEFT,TEXT_ALIGN_CENTER)
        end
    end
end

function elogs.MakeList(pnl)
    pnl.Paint = function(s,w,h)
        surface.SetDrawColor(elogs.bglight)
        surface.DrawRect(0,0,w,h)
    end
end