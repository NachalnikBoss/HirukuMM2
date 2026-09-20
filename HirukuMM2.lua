-- // HIRUKU MM2 FULL SCRIPT v3.0 // --
-- Silent Aim (hookmetamethod) | Spin | Particle | Full ESP | China Hat | Fling

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local Debris = game:GetService("Debris")
local StarterGui = game:GetService("StarterGui")
local LP = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local T = {
    bg = Color3.fromRGB(8, 8, 12),
    side = Color3.fromRGB(12, 12, 16),
    row = Color3.fromRGB(20, 20, 26),
    rowHov = Color3.fromRGB(30, 30, 38),
    stroke = Color3.fromRGB(45, 45, 58),
    text = Color3.fromRGB(245, 245, 250),
    textDim = Color3.fromRGB(135, 135, 150),
    textCat = Color3.fromRGB(105, 105, 125),
    accent = Color3.fromRGB(110, 145, 255),
    accent2 = Color3.fromRGB(160, 110, 255),
    on = Color3.fromRGB(110, 145, 255),
    off = Color3.fromRGB(48, 48, 60),
    red = Color3.fromRGB(235, 70, 80),
    blue = Color3.fromRGB(65, 145, 255),
    green = Color3.fromRGB(80, 220, 130),
    gold = Color3.fromRGB(255, 200, 70),
}

local FontList = {"Gotham","GothamMedium","GothamBold","GothamBlack","Code","Roboto","RobotoMono","RobotoCondensed","Ubuntu","Oswald","SourceSans","SourceSansBold","SourceSansSemibold","SourceSansLight","SciFi","Arcade","Fantasy","Antique","Bangers","Creepster","FredokaOne","IndieFlower","PatrickHand","SpecialElite","Bodoni","Garamond","Highway","Merriweather","AmaticSC","JosefinSans","Kalam","LuckiestGuy","Sarpanch","TitilliumWeb"}
local CurrentFont = "Gotham"

local F = {
    killAura=false, killAuraRange=40,
    knifeSilent=false, fastThrow=false, noThrowAnim=false, killAll=false,
    silentAim=false, silentAimFov=250, silentAimPart="Head", wallBang=false,
    autoShot=false, autoGrabGun=false, gunDropNotify=false,
    esp=false, espName=true, espRole=true, espDist=false, espHealth=false,
    roleChams=false, chamsTransp=0.4, chamsOutlineTransp=0.1,
    selfChams=false, gunChams=false, itemChams=false,
    fullbright=false, bloom=false, bloomIntensity=1.2, colorCorrect=false,
    sunRays=false, vignette=false, fog=false, fogEnd=200,
    chinaHat=false, chinaHatColor=Color3.fromRGB(220,50,50),
    bulletTracers=false, tracerColor=Color3.fromRGB(255,210,70),
    crosshair=false, crosshairColor=Color3.fromRGB(255,255,255),
    crosshairSize=8, crosshairGap=4, crosshairThick=2,
    fovCircle=false, fovCircleColor=Color3.fromRGB(110,145,255), fovCircleSize=120,
    speed=32, speedGlitch=false,
    jumpPowerVal=100, jumpPower=false, infiniteJump=false,
    noclip=false, fly=false, flySpeed=50, flyKey=Enum.KeyCode.F,
    spin=false, spinSpeed=6,
    particle=false, particleRate=50, particleSize=0.5,
    fling=false, flingPower=4000,
    killMurd=false, headSit=false, loopTP=false, bang=false, mouthBang=false, orbit=false, orbitSpeed=3,
    antiFling=false, antiVoid=false,
    transparency=0, menuScale=1, font="Gotham",
    targetPlayer=nil,
}

local function loadCfg()
    if readfile and isfile("HirukuMM2.json") then
        local ok,d=pcall(function() return HttpService:JSONDecode(readfile("HirukuMM2.json")) end)
        if ok and d then
            for k,v in pairs(d) do
                if type(v)~="userdata" and type(v)~="table" then F[k]=v end
            end
        end
    end
end
local function saveCfg()
    if writefile then
        local out={}
        for k,v in pairs(F) do if type(v)~="userdata" and type(v)~="table" then out[k]=v end end
        pcall(function() writefile("HirukuMM2.json",HttpService:JSONEncode(out)) end)
    end
end
loadCfg()
CurrentFont = F.font or "Gotham"

local gui = Instance.new("ScreenGui")
gui.Name="HirukuMM2"
gui.ResetOnSpawn=false
gui.IgnoreGuiInset=true
gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
pcall(function() gui.Parent=game:GetService("CoreGui") end)
if not gui.Parent then gui.Parent=LP:WaitForChild("PlayerGui") end

local function nw(c,p) local o=Instance.new(c); for k,v in pairs(p or {}) do o[k]=v end; return o end
local function crn(p,r) return nw("UICorner",{CornerRadius=UDim.new(0,r or 12),Parent=p}) end
local function strk(p,c,t,tr) return nw("UIStroke",{Color=c or T.stroke,Thickness=t or 1,Transparency=tr or 0,ApplyStrokeMode=Enum.ApplyStrokeMode.Border,Parent=p}) end
local function pad(p,a,b,c,d) return nw("UIPadding",{PaddingTop=UDim.new(0,a),PaddingBottom=UDim.new(0,b or a),PaddingLeft=UDim.new(0,c or a),PaddingRight=UDim.new(0,d or a),Parent=p}) end
local function fontOf() local ok,f=pcall(function() return Enum.Font[CurrentFont] end); return ok and f or Enum.Font.Gotham end

local function applyFont(inst)
    for _,d in ipairs(inst:GetDescendants()) do
        if d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") then
            pcall(function() d.Font=fontOf() end)
        end
    end
end

local ICON_SPRITE = "rbxassetid://15269177520"
local ICON_SIZE = 48
local iconMap = {
    main={1,1}, visuals={1,2}, movement={1,3},
    target={1,4}, player={1,5}, settings={1,6},
    gear={1,7}, search={1,8}, close={1,9},
}
local function lucideIcon(parent, name, size, pos, color)
    local m = iconMap[name]
    if not m then
        return nw("TextLabel",{Parent=parent,BackgroundTransparency=1,Size=size,Position=pos,Font=fontOf(),TextSize=14,TextColor3=color or T.textDim,Text="●"})
    end
    return nw("ImageLabel",{
        BackgroundTransparency=1,
        Image=ICON_SPRITE,
        ImageRectOffset=Vector2.new((m[2]-1)*ICON_SIZE,(m[1]-1)*ICON_SIZE),
        ImageRectSize=Vector2.new(ICON_SIZE,ICON_SIZE),
        Size=size, Position=pos,
        ImageColor3=color or T.textDim,
        Parent=parent,
    })
end

-- WATERMARK
local wm = nw("Frame",{Parent=gui,BackgroundColor3=T.bg,BackgroundTransparency=0.08,Size=UDim2.new(0,360,0,32),Position=UDim2.new(0,12,0,12),BorderSizePixel=0})
crn(wm,10); strk(wm,T.accent,1,0.4)
local wmBar = nw("Frame",{Parent=wm,BackgroundColor3=T.accent,Size=UDim2.new(0,3,1,-12),Position=UDim2.new(0,6,0,6),BorderSizePixel=0})
crn(wmBar,2)
local wmDot = nw("Frame",{Parent=wm,BackgroundColor3=T.green,Size=UDim2.new(0,7,0,7),Position=UDim2.new(0,14,0.5,-3.5),BorderSizePixel=0})
crn(wmDot,99)
nw("TextLabel",{Parent=wm,BackgroundTransparency=1,Position=UDim2.new(0,28,0,0),Size=UDim2.new(0,80,1,0),Font=fontOf(),TextSize=12,TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,Text="Hiruku Lua"})
local wmText = nw("TextLabel",{Parent=wm,BackgroundTransparency=1,Position=UDim2.new(0,110,0,0),Size=UDim2.new(1,-120,1,0),Font=fontOf(),TextSize=11,TextColor3=T.textDim,TextXAlignment=Enum.TextXAlignment.Left,Text=""})

task.spawn(function()
    while wm.Parent do
        TweenService:Create(wmDot,TweenInfo.new(0.8),{BackgroundColor3=T.accent}):Play()
        task.wait(0.8)
        TweenService:Create(wmDot,TweenInfo.new(0.8),{BackgroundColor3=T.green}):Play()
        task.wait(0.8)
    end
end)

-- TOGGLE BUTTON
local btn = nw("TextButton",{Parent=gui,BackgroundColor3=T.bg,BackgroundTransparency=0.1,Size=UDim2.new(0,130,0,34),Position=UDim2.new(0.5,-65,0,56),BorderSizePixel=0,Text="",AutoButtonColor=false})
crn(btn,17); strk(btn,T.accent,1.2,0.3)
nw("TextLabel",{Parent=btn,BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),Font=fontOf(),TextSize=13,TextColor3=T.text,Text="✦  Hiruku"})

local function drag(frame,handle)
    handle=handle or frame
    local dg,ds,sp
    handle.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            dg=true; ds=i.Position; sp=frame.Position
            i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then dg=false end end)
        end
    end)
    handle.InputChanged:Connect(function(i)
        if dg and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
            local d=i.Position-ds
            frame.Position=UDim2.new(sp.X.Scale,sp.X.Offset+d.X,sp.Y.Scale,sp.Y.Offset+d.Y)
        end
    end)
end
drag(wm); drag(btn)

-- MAIN WINDOW
local win = nw("Frame",{Parent=gui,BackgroundColor3=T.bg,Size=UDim2.new(0,680,0,430),Position=UDim2.new(0.5,-340,0.5,-215),BorderSizePixel=0,Visible=false,ClipsDescendants=true})
crn(win,14); strk(win,T.stroke,1,0.3); drag(win)
local winScale = nw("UIScale",{Parent=win,Scale=F.menuScale})

-- SIDEBAR
local side = nw("Frame",{Parent=win,BackgroundColor3=T.side,Size=UDim2.new(0,175,1,0),BorderSizePixel=0,ClipsDescendants=true})
crn(side,14)
local sideBg = nw("ImageLabel",{Parent=side,BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),Image="rbxassetid://1228955960",ImageTransparency=0.6,ScaleType=Enum.ScaleType.Crop,ZIndex=0})
local sideOv = nw("Frame",{Parent=side,BackgroundColor3=T.side,BackgroundTransparency=0.35,Size=UDim2.new(1,0,1,0),BorderSizePixel=0,ZIndex=1})
nw("Frame",{Parent=win,BackgroundColor3=T.stroke,Size=UDim2.new(0,1,1,-40),Position=UDim2.new(0,175,0,20),BorderSizePixel=0,ZIndex=3})

local prof = nw("Frame",{Parent=side,BackgroundTransparency=1,Size=UDim2.new(1,0,0,52),Position=UDim2.new(0,0,0,0),ZIndex=2})
nw("TextLabel",{Parent=prof,BackgroundTransparency=1,Position=UDim2.new(0,14,0,10),Size=UDim2.new(1,-20,0,16),Font=fontOf(),TextSize=13,TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,Text=LP.DisplayName,ZIndex=2})
nw("TextLabel",{Parent=prof,BackgroundTransparency=1,Position=UDim2.new(0,14,0,28),Size=UDim2.new(1,-20,0,12),Font=fontOf(),TextSize=9,TextColor3=T.accent2,TextXAlignment=Enum.TextXAlignment.Left,Text="Hiruku Lua v3.0",ZIndex=2})

local profBot = nw("Frame",{Parent=side,BackgroundTransparency=1,Size=UDim2.new(1,0,0,48),Position=UDim2.new(0,0,1,-48),ZIndex=2})
local av = nw("ImageLabel",{Parent=profBot,BackgroundColor3=T.row,Position=UDim2.new(0,14,0,10),Size=UDim2.new(0,28,0,28),BorderSizePixel=0,Image="rbxthumb://type=AvatarHeadShot&id="..LP.UserId.."&w=48&h=48",ZIndex=2})
crn(av,14)
nw("TextLabel",{Parent=profBot,BackgroundTransparency=1,Position=UDim2.new(0,48,0,10),Size=UDim2.new(1,-56,0,14),Font=fontOf(),TextSize=11,TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,Text=LP.Name,ZIndex=2})
nw("TextLabel",{Parent=profBot,BackgroundTransparency=1,Position=UDim2.new(0,48,0,24),Size=UDim2.new(1,-56,0,12),Font=fontOf(),TextSize=9,TextColor3=T.textDim,TextXAlignment=Enum.TextXAlignment.Left,Text="Hiruku",ZIndex=2})

local nav = nw("Frame",{Parent=side,BackgroundTransparency=1,Position=UDim2.new(0,0,0,52),Size=UDim2.new(1,0,1,-100),ZIndex=2})
nw("UIListLayout",{Parent=nav,Padding=UDim.new(0,4),SortOrder=Enum.SortOrder.LayoutOrder,HorizontalAlignment=Enum.HorizontalAlignment.Center})
pad(nav,4,0,10,10)

local cont = nw("Frame",{Parent=win,BackgroundTransparency=1,Position=UDim2.new(0,175,0,0),Size=UDim2.new(1,-175,1,0),ZIndex=2})
local top = nw("Frame",{Parent=cont,BackgroundTransparency=1,Size=UDim2.new(1,0,0,46)})
nw("TextButton",{Parent=top,BackgroundColor3=T.row,Position=UDim2.new(0,12,0.5,-14),Size=UDim2.new(0,64,0,28),Font=fontOf(),TextSize=11,TextColor3=T.text,Text="e3  ▾",BorderSizePixel=0,AutoButtonColor=false})
local search = nw("TextBox",{Parent=top,BackgroundColor3=T.row,Position=UDim2.new(1,-200,0.5,-14),Size=UDim2.new(0,188,0,28),Font=fontOf(),TextSize=11,TextColor3=T.text,PlaceholderText="Search...",PlaceholderColor3=T.textDim,Text="",ClearTextOnFocus=false,BorderSizePixel=0})
crn(search,8); pad(search,0,0,32,10)
lucideIcon(search,"search",UDim2.new(0,14,0,14),UDim2.new(0,10,0.5,-7),T.textDim)

local scroll = nw("ScrollingFrame",{Parent=cont,BackgroundTransparency=1,Position=UDim2.new(0,0,0,46),Size=UDim2.new(1,0,1,-46),CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,ScrollBarThickness=4,ScrollBarImageColor3=T.accent,ScrollBarImageTransparency=0.3,BorderSizePixel=0,ClipsDescendants=true})
nw("UIListLayout",{Parent=scroll,Padding=UDim.new(0,5),SortOrder=Enum.SortOrder.LayoutOrder})
pad(scroll,0,12,12,12)

local function clear()
    for _,c in ipairs(scroll:GetChildren()) do
        if not c:IsA("UIListLayout") and not c:IsA("UIPadding") then c:Destroy() end
    end
end

local function slideIn(frame)
    local target=frame.Position
    frame.Position=UDim2.new(target.X.Scale,target.X.Offset-24,target.Y.Scale,target.Y.Offset)
    frame.BackgroundTransparency=1
    TweenService:Create(frame,TweenInfo.new(0.3,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Position=target,BackgroundTransparency=0}):Play()
end

local function cat(t)
    local h=nw("TextLabel",{Parent=scroll,BackgroundTransparency=1,Size=UDim2.new(1,0,0,24),Font=fontOf(),TextSize=11,TextColor3=T.accent2,TextXAlignment=Enum.TextXAlignment.Left,Text=t})
    h.LayoutOrder=#scroll:GetChildren()
    h.TextTransparency=1
    TweenService:Create(h,TweenInfo.new(0.4),{TextTransparency=0}):Play()
end

local function rowBase(label)
    local r=nw("Frame",{Parent=scroll,BackgroundColor3=T.row,Size=UDim2.new(1,0,0,34),BorderSizePixel=0})
    r.LayoutOrder=#scroll:GetChildren(); crn(r,8); strk(r,T.stroke,1,0.6)
    slideIn(r)
    nw("TextLabel",{Parent=r,BackgroundTransparency=1,Position=UDim2.new(0,14,0,0),Size=UDim2.new(1,-80,1,0),Font=fontOf(),TextSize=12,TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,Text=label})
    return r
end

local function toggle(label,default,cb)
    local r=rowBase(label)
    local sw=nw("TextButton",{Parent=r,BackgroundColor3=default and T.on or T.off,Size=UDim2.new(0,36,0,18),Position=UDim2.new(1,-46,0.5,-9),BorderSizePixel=0,Text=""})
    crn(sw,99)
    local kn=nw("Frame",{Parent=sw,BackgroundColor3=Color3.fromRGB(255,255,255),Size=UDim2.new(0,14,0,14),Position=default and UDim2.new(1,-16,0.5,-7) or UDim2.new(0,2,0.5,-7),BorderSizePixel=0})
    crn(kn,99)
    local st=default
    sw.MouseButton1Click:Connect(function()
        st=not st
        TweenService:Create(sw,TweenInfo.new(0.2),{BackgroundColor3=st and T.on or T.off}):Play()
        TweenService:Create(kn,TweenInfo.new(0.2),{Position=st and UDim2.new(1,-16,0.5,-7) or UDim2.new(0,2,0.5,-7)}):Play()
        if cb then cb(st) end
        saveCfg()
    end)
end

local function slider(label,mn,mx,def,stp,cb)
    local r=nw("Frame",{Parent=scroll,BackgroundColor3=T.row,Size=UDim2.new(1,0,0,44),BorderSizePixel=0})
    r.LayoutOrder=#scroll:GetChildren(); crn(r,8); strk(r,T.stroke,1,0.6)
    slideIn(r)
    nw("TextLabel",{Parent=r,BackgroundTransparency=1,Position=UDim2.new(0,14,0,6),Size=UDim2.new(1,-80,0,14),Font=fontOf(),TextSize=12,TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,Text=label})
    local vl=nw("TextLabel",{Parent=r,BackgroundTransparency=1,Position=UDim2.new(1,-64,0,6),Size=UDim2.new(0,50,0,14),Font=fontOf(),TextSize=11,TextColor3=T.accent,TextXAlignment=Enum.TextXAlignment.Right,Text=tostring(def)})
    local tr=nw("Frame",{Parent=r,BackgroundColor3=T.off,Position=UDim2.new(0,14,0,30),Size=UDim2.new(1,-28,0,5),BorderSizePixel=0})
    crn(tr,99)
    local fl=nw("Frame",{Parent=tr,BackgroundColor3=T.accent,Size=UDim2.new((def-mn)/(mx-mn),0,1,0),BorderSizePixel=0})
    crn(fl,99)
    local v=def; local dg=false
    local function ap(i)
        local rl=math.clamp((i.Position.X-tr.AbsolutePosition.X)/tr.AbsoluteSize.X,0,1)
        v=math.floor((mn+(mx-mn)*rl)/stp+0.5)*stp; v=math.clamp(v,mn,mx)
        fl.Size=UDim2.new((v-mn)/(mx-mn),0,1,0); vl.Text=tostring(v)
        if cb then cb(v) end
    end
    tr.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dg=true; ap(i) end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then if dg then saveCfg() end; dg=false end end)
    UserInputService.InputChanged:Connect(function(i) if dg and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then ap(i) end end)
end

local function btnAct(label,cb)
    local b=nw("TextButton",{Parent=scroll,BackgroundColor3=T.row,Size=UDim2.new(1,0,0,32),Font=fontOf(),TextSize=12,TextColor3=T.text,Text=label,BorderSizePixel=0,AutoButtonColor=false})
    b.LayoutOrder=#scroll:GetChildren(); crn(b,8); strk(b,T.stroke,1,0.6)
    slideIn(b)
    b.MouseEnter:Connect(function() TweenService:Create(b,TweenInfo.new(0.18),{BackgroundColor3=T.rowHov}):Play() end)
    b.MouseLeave:Connect(function() TweenService:Create(b,TweenInfo.new(0.18),{BackgroundColor3=T.row}):Play() end)
    b.MouseButton1Click:Connect(function() if cb then cb() end end)
    return b
end

local function dropdown(label,options,current,cb)
    local r=nw("Frame",{Parent=scroll,BackgroundColor3=T.row,Size=UDim2.new(1,0,0,36),BorderSizePixel=0})
    r.LayoutOrder=#scroll:GetChildren(); crn(r,8); strk(r,T.stroke,1,0.6)
    slideIn(r)
    nw("TextLabel",{Parent=r,BackgroundTransparency=1,Position=UDim2.new(0,14,0,0),Size=UDim2.new(0,100,1,0),Font=fontOf(),TextSize=12,TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,Text=label})
    local sel=nw("TextButton",{Parent=r,BackgroundColor3=T.off,Position=UDim2.new(1,-150,0.5,-14),Size=UDim2.new(0,138,0,28),Font=fontOf(),TextSize=11,TextColor3=T.text,Text=current,BorderSizePixel=0,AutoButtonColor=false})
    crn(sel,6); strk(sel,T.stroke,1,0.5)
    local open=false
    local list=nw("Frame",{Parent=sel,BackgroundColor3=T.side,Position=UDim2.new(0,0,1,4),Size=UDim2.new(1,0,0,math.min(#options*26,220)),Visible=false,BorderSizePixel=0,ZIndex=10,ClipsDescendants=true})
    crn(list,8); strk(list,T.stroke,1,0.3)
    local sc=nw("ScrollingFrame",{Parent=list,BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),CanvasSize=UDim2.new(0,0,0,#options*26),ScrollBarThickness=3,ScrollBarImageColor3=T.accent,BorderSizePixel=0})
    for i,o in ipairs(options) do
        local ob=nw("TextButton",{Parent=sc,BackgroundColor3=T.side,BackgroundTransparency=1,Size=UDim2.new(1,0,0,26),Font=fontOf(),TextSize=11,TextColor3=T.text,Text=o,AutoButtonColor=false,LayoutOrder=i,ZIndex=11})
        ob.MouseEnter:Connect(function() ob.BackgroundTransparency=0.6 end)
        ob.MouseLeave:Connect(function() ob.BackgroundTransparency=1 end)
        ob.MouseButton1Click:Connect(function()
            sel.Text=o; list.Visible=false; open=false
            if cb then cb(o) end
            saveCfg()
        end)
    end
    sel.MouseButton1Click:Connect(function() open=not open; list.Visible=open end)
end

local function keybind(label,current,cb)
    local r=rowBase(label)
    local kb=nw("TextButton",{Parent=r,BackgroundColor3=T.off,Position=UDim2.new(1,-90,0.5,-13),Size=UDim2.new(0,78,0,26),Font=fontOf(),TextSize=11,TextColor3=T.text,Text=current.Name,BorderSizePixel=0,AutoButtonColor=false})
    crn(kb,6); strk(kb,T.stroke,1,0.5)
    local listening=false
    kb.MouseButton1Click:Connect(function()
        listening=true; kb.Text="..."; kb.TextColor3=T.accent
    end)
    UserInputService.InputBegan:Connect(function(i,gp)
        if listening and not gp then
            listening=false
            kb.Text=i.KeyCode.Name
            kb.TextColor3=T.text
            if cb then cb(i.KeyCode) end
            saveCfg()
        end
    end)
end

-- ROLE DETECTION
local function getRole(p)
    if not p or not p.Character then return "Innocent" end
    local c=p.Character
    local bp=p:FindFirstChild("Backpack")
    if c:FindFirstChild("Knife") or (bp and bp:FindFirstChild("Knife")) then return "Murderer" end
    if c:FindFirstChild("Gun") or (bp and bp:FindFirstChild("Gun")) then return "Sheriff" end
    return "Innocent"
end
local function myRole() return getRole(LP) end
local function alive(p) local c=p.Character; local h=c and c:FindFirstChildOfClass("Humanoid"); return h and h.Health>0 end
local function hrp(p) local c=p.Character; return c and c:FindFirstChild("HumanoidRootPart") end
local function roleColor(r)
    if r=="Murderer" then return T.red end
    if r=="Sheriff" then return T.blue end
    return T.green
end

-- SILENT AIM HOOK (from user file)
local RaycastParameters = RaycastParams.new()
RaycastParameters.IgnoreWater = true
RaycastParameters.FilterType = Enum.RaycastFilterType.Exclude
RaycastParameters.FilterDescendantsInstances = {LP.Character}

local SilentAIMEnabled = false

local function GetClosestPlayer()
    local closest = nil
    local dist = math.huge
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and alive(p) then
            local d = (LP.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
            if d < dist then
                dist = d
                closest = p
            end
        end
    end
    return closest
end

pcall(function()
    local mt = getrawmetatable(game)
    local oldNamecall = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        if SilentAIMEnabled and (method == "InvokeServer" or method == "FireServer") then
            local name = tostring(self)
            if name == "ShootGun" then
                local closest = GetClosestPlayer()
                if closest and closest.Character then
                    local part = closest.Character:FindFirstChild(F.silentAimPart) or closest.Character:FindFirstChild("HumanoidRootPart")
                    if part then args[2] = part.Position end
                end
            elseif name == "Throw" then
                local closest = GetClosestPlayer()
                if closest and closest.Character and closest.Character.PrimaryPart then
                    local pp = closest.Character.PrimaryPart
                    local vel = pp.AssemblyLinearVelocity * Vector3.new(1,0,1)
                    local mag = (pp.Position - LP.Character.PrimaryPart.Position).Magnitude
                    local pred = vel * 0.5 * mag / 100
                    local result = workspace:Raycast(LP.Character.PrimaryPart.Position, (pp.Position - (LP.Character.PrimaryPart.Position + pred)).Unit * 200, RaycastParameters)
                    if result then args[2] = result.Position end
                end
            end
        end
        return oldNamecall(self, unpack(args))
    end)
    setreadonly(mt, true)
end)

-- KILL AURA (Murderer auto equip + kill)
RunService.Heartbeat:Connect(function()
    if not (F.killAura or F.knifeSilent) or myRole() ~= "Murderer" or not LP.Character then return end
    local knife = LP.Character:FindFirstChild("Knife") or (LP:FindFirstChild("Backpack") and LP.Backpack:FindFirstChild("Knife"))
    if knife then
        local h = LP.Character:FindFirstChildOfClass("Humanoid")
        if h and h:FindFirstChildOfClass("Tool") ~= knife then
            pcall(function() h:EquipTool(knife) end)
        end
    end
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LP and alive(p) and hrp(p) and hrp(LP) then
            local d = (hrp(p).Position - hrp(LP).Position).Magnitude
            if d <= F.killAuraRange then
                local ph = p.Character:FindFirstChildOfClass("Humanoid")
                if ph then ph.Health = 0 end
            end
        end
    end
end)

-- KILL ALL
RunService.Heartbeat:Connect(function()
    if not F.killAll or myRole() ~= "Murderer" then return end
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LP and alive(p) then
            local h = p.Character:FindFirstChildOfClass("Humanoid")
            if h then h.Health = 0 end
        end
    end
end)

-- FAST THROW
RunService.Heartbeat:Connect(function()
    if not F.fastThrow or myRole() ~= "Murderer" then return end
    local knife = LP.Character and LP.Character:FindFirstChild("Knife")
    if knife then pcall(function() knife:Activate() end) end
end)

-- NO THROW ANIM
RunService.Heartbeat:Connect(function()
    if not F.noThrowAnim or myRole() ~= "Murderer" then return end
    local animator = LP.Character and LP.Character:FindFirstChildOfClass("Animator")
    if animator then
        for _,t in ipairs(animator:GetPlayingAnimationTracks()) do
            if t.Animation and t.Animation.AnimationId then
                pcall(function() t:Stop() end)
            end
        end
    end
end)

-- AUTO SHOT
RunService.Heartbeat:Connect(function()
    if not F.autoShot or myRole() ~= "Sheriff" or not LP.Character then return end
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LP and getRole(p) == "Murderer" and alive(p) and hrp(p) and hrp(LP) then
            local gun = LP.Character:FindFirstChild("Gun")
            if gun then
                local save = Camera.CFrame
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, hrp(p).Position)
                pcall(function() gun:Activate() end)
                Camera.CFrame = save
            end
        end
    end
end)

-- AUTO GRAB GUN
RunService.Heartbeat:Connect(function()
    if not F.autoGrabGun then return end
    for _,o in ipairs(Workspace:GetDescendants()) do
        if o.Name == "Gun" and o:IsA("Tool") and o.Parent == Workspace and LP.Character then
            o.Parent = LP.Character
        end
    end
end)

-- GUN DROP NOTIFY
local lastNotify = 0
RunService.Heartbeat:Connect(function()
    if not F.gunDropNotify then return end
    for _,o in ipairs(Workspace:GetDescendants()) do
        if o.Name == "Gun" and o:IsA("Tool") and o.Parent == Workspace and tick()-lastNotify > 5 then
            lastNotify = tick()
            pcall(function()
                StarterGui:SetCore("SendNotification", {
                    Title = "Gun Drop",
                    Text = "Sheriff's gun dropped!",
                    Duration = 3,
                })
            end)
        end
    end
end)

-- FLING (мощный)
local function flingTarget(target)
    if not target or not target.Character then return end
    local tHrp = target.Character:FindFirstChild("HumanoidRootPart")
    if not tHrp then return end
    for _,v in ipairs(tHrp:GetChildren()) do
        if v:IsA("BodyVelocity") or v:IsA("BodyAngularVelocity") or v:IsA("BodyThrust") or v:IsA("BodyForce") then
            v:Destroy()
        end
    end
    local bv = Instance.new("BodyVelocity")
    bv.Velocity = Vector3.new(math.random(-F.flingPower, F.flingPower), F.flingPower, math.random(-F.flingPower, F.flingPower))
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Parent = tHrp
    Debris:AddItem(bv, 0.5)
    local bav = Instance.new("BodyAngularVelocity")
    bav.AngularVelocity = Vector3.new(math.random(-200,200), math.random(-200,200), math.random(-200,200))
    bav.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bav.Parent = tHrp
    Debris:AddItem(bav, 0.5)
end

RunService.Heartbeat:Connect(function()
    if F.fling and F.targetPlayer then
        local t = Players:FindFirstChild(F.targetPlayer)
        if t then flingTarget(t) end
    end
end)

-- KILL MURD
RunService.Heartbeat:Connect(function()
    if not F.killMurd or myRole() ~= "Murderer" then return end
    if F.targetPlayer then
        local t = Players:FindFirstChild(F.targetPlayer)
        if t and t.Character then
            local h = t.Character:FindFirstChildOfClass("Humanoid")
            if h then h.Health = 0 end
        end
    end
end)

-- HEAD SIT
RunService.Heartbeat:Connect(function()
    if not F.headSit or not F.targetPlayer then return end
    local t = Players:FindFirstChild(F.targetPlayer)
    if not t or not hrp(t) or not hrp(LP) then return end
    hrp(LP).CFrame = hrp(t).CFrame * CFrame.new(0,2.5,0)
end)

-- LOOP TP
RunService.Heartbeat:Connect(function()
    if not F.loopTP or not F.targetPlayer then return end
    local t = Players:FindFirstChild(F.targetPlayer)
    if not t or not hrp(t) or not hrp(LP) then return end
    hrp(LP).CFrame = hrp(t).CFrame * CFrame.new(0,0,3)
end)

-- BANG
RunService.Heartbeat:Connect(function()
    if not F.bang or not F.targetPlayer then return end
    local t = Players:FindFirstChild(F.targetPlayer)
    if not t or not hrp(t) or not hrp(LP) then return end
    hrp(LP).CFrame = hrp(t).CFrame * CFrame.new(math.sin(tick()*25)*2, 2, math.cos(tick()*25)*2)
end)

-- MOUTH BANG
RunService.Heartbeat:Connect(function()
    if not F.mouthBang or not F.targetPlayer then return end
    local t = Players:FindFirstChild(F.targetPlayer)
    if not t or not hrp(t) or not hrp(LP) then return end
    hrp(LP).CFrame = hrp(t).CFrame * CFrame.new(0,1,-0.5) * CFrame.Angles(0,tick()*5,0)
end)

-- ORBIT
RunService.Heartbeat:Connect(function()
    if not F.orbit or not F.targetPlayer then return end
    local t = Players:FindFirstChild(F.targetPlayer)
    if not t or not hrp(t) or not hrp(LP) then return end
    local ang = tick() * F.orbitSpeed
    hrp(LP).CFrame = hrp(t).CFrame * CFrame.new(math.sin(ang)*5, 2, math.cos(ang)*5)
end)

-- ANTI FLING
RunService.Stepped:Connect(function()
    if not F.antiFling or not LP.Character then return end
    local h = LP.Character:FindFirstChildOfClass("Humanoid")
    if h then pcall(function() h:SetStateEnabled(Enum.HumanoidStateType.Physics,false) end) end
    for _,v in ipairs(LP.Character:GetDescendants()) do
        if v:IsA("BodyVelocity") or v:IsA("BodyAngularVelocity") or v:IsA("BodyThrust") then v:Destroy() end
    end
end)

-- ANTI VOID
RunService.Heartbeat:Connect(function()
    if not F.antiVoid then return end
    local r = hrp(LP)
    if r and r.Position.Y < -50 then r.CFrame = CFrame.new(0,50,0) end
end)

-- SPEED / JUMP
RunService.Heartbeat:Connect(function()
    local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if h then
        if F.speedGlitch then h.WalkSpeed = F.speed else h.WalkSpeed = 16 end
        if F.jumpPower then h.JumpPower = F.jumpPowerVal; h.UseJumpPower = true else h.JumpPower = 50 end
    end
end)

-- INFINITE JUMP
UserInputService.JumpRequest:Connect(function()
    if F.infiniteJump and LP.Character then
        local h = LP.Character:FindFirstChildOfClass("Humanoid")
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- NOCLIP
RunService.Stepped:Connect(function()
    if F.noclip and LP.Character then
        for _,v in ipairs(LP.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- FLY
RunService.RenderStepped:Connect(function()
    if F.fly and LP.Character then
        local h = LP.Character:FindFirstChildOfClass("Humanoid")
        local r = hrp(LP)
        if h and r then
            h.PlatformStand = true
            local dir = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0,1,0) end
            r.AssemblyLinearVelocity = dir.Magnitude > 0 and dir.Unit * F.flySpeed or Vector3.zero
        end
    end
end)

UserInputService.InputBegan:Connect(function(i,gp)
    if gp then return end
    if i.KeyCode == F.flyKey then F.fly = not F.fly end
end)

-- SPIN (вращение вокруг себя)
RunService.Heartbeat:Connect(function()
    if not F.spin or not LP.Character then return end
    local r = hrp(LP)
    if r then
        local existing = r:FindFirstChild("HirukuSpin")
        if not existing then
            existing = Instance.new("BodyAngularVelocity")
            existing.Name = "HirukuSpin"
            existing.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            existing.Parent = r
        end
        existing.AngularVelocity = Vector3.new(0, F.spinSpeed, 0)
    end
end)

-- PARTICLE (снежинки)
local particlePart = nil
local particleEmitter = nil
local function manageParticle()
    if not F.particle then
        if particlePart then particlePart:Destroy(); particlePart = nil; particleEmitter = nil end
        return
    end
    if not particlePart or not particlePart.Parent then
        particlePart = Instance.new("Part")
        particlePart.Name = "HirukuParticles"
        particlePart.Size = Vector3.new(80, 1, 80)
        particlePart.Transparency = 1
        particlePart.CanCollide = false
        particlePart.Anchored = true
        particlePart.Parent = Workspace
        particleEmitter = Instance.new("ParticleEmitter")
        particleEmitter.Texture = "rbxassetid://16400268732"
        particleEmitter.Rate = F.particleRate
        particleEmitter.Lifetime = NumberRange.new(5, 10)
        particleEmitter.Speed = NumberRange.new(8, 15)
        particleEmitter.SpreadAngle = Vector2.new(15, 15)
        particleEmitter.Rotation = NumberRange.new(0, 360)
        particleEmitter.RotSpeed = NumberRange.new(-30, 30)
        particleEmitter.Size = NumberSequence.new(F.particleSize, F.particleSize)
        particleEmitter.Transparency = NumberSequence.new(0.3, 0.6)
        particleEmitter.Parent = particlePart
    end
    if LP.Character then
        local r = hrp(LP)
        if r then particlePart.CFrame = CFrame.new(r.Position + Vector3.new(0,30,0)) end
    end
end
RunService.Heartbeat:Connect(manageParticle)

-- CHINA HAT
local function manageChinaHat()
    if not LP.Character then return end
    local head = LP.Character:FindFirstChild("Head")
    if not head then return end
    local existing = head:FindFirstChild("HirukuChinaHat")
    if F.chinaHat then
        if not existing then
            local cone = Instance.new("Part")
            cone.Name = "HirukuChinaHat"
            cone.Size = Vector3.new(1.5, 1, 1.5)
            cone.Color = F.chinaHatColor
            cone.Material = Enum.Material.SmoothPlastic
            cone.CanCollide = false
            cone.Massless = true
            cone.Anchored = false
            cone.Parent = LP.Character
            local mesh = Instance.new("SpecialMesh")
            mesh.MeshType = Enum.MeshType.FileMesh
            mesh.MeshId = "rbxassetid://1033714"
            mesh.Scale = Vector3.new(1.5, 0.7, 1.5)
            mesh.Parent = cone
            local weld = Instance.new("WeldConstraint")
            weld.Part0 = head
            weld.Part1 = cone
            weld.Parent = cone
            cone.CFrame = head.CFrame * CFrame.new(0, 1.2, 0)
        else
            existing.Color = F.chinaHatColor
        end
    elseif existing then
        existing:Destroy()
    end
end
RunService.Heartbeat:Connect(manageChinaHat)

-- BULLET TRACERS
local lastTracer = 0
RunService.Heartbeat:Connect(function()
    if not F.bulletTracers or tick() - lastTracer < 0.1 then return end
    lastTracer = tick()
    local c = LP.Character; if not c then return end
    local gun = c:FindFirstChild("Gun"); if not gun then return end
    local handle = gun:FindFirstChild("Handle"); if not handle then return end
    local ray = Ray.new(handle.Position, handle.CFrame.LookVector * 500)
    local hit, pos = Workspace:FindPartOnRay(ray, c)
    local beam = Instance.new("Part")
    beam.Size = Vector3.new(0.08, 0.08, (handle.Position - pos).Magnitude)
    beam.CFrame = CFrame.lookAt(handle.Position, pos)
    beam.Anchored = true
    beam.CanCollide = false
    beam.Material = Enum.Material.Neon
    beam.Color = F.tracerColor
    beam.Parent = Workspace
    Debris:AddItem(beam, 0.15)
end)

-- CHAMS / ESP (полный цикл, работает на новых игроках)
local chamsFolder = Instance.new("Folder")
chamsFolder.Name = "HirukuChams"
chamsFolder.Parent = Workspace
local billboards = {}

local function clearChams()
    for _,c in ipairs(chamsFolder:GetChildren()) do c:Destroy() end
    for _,b in ipairs(billboards) do if b.Parent then b:Destroy() end end
    billboards = {}
end

local function refreshChams()
    if not (F.esp or F.roleChams) then
        if #chamsFolder:GetChildren() > 0 or #billboards > 0 then clearChams() end
        return
    end
    for _,p in ipairs(Players:GetPlayers()) do
        if p ~= LP and alive(p) and p.Character then
            local r = getRole(p)
            local col = roleColor(r)
            local existing = chamsFolder:FindFirstChild(p.Name)
            if not existing then
                local hl = Instance.new("Highlight")
                hl.Name = p.Name
                hl.Adornee = p.Character
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                hl.FillColor = col
                hl.OutlineColor = col
                hl.FillTransparency = F.chamsTransp
                hl.OutlineTransparency = F.chamsOutlineTransp
                hl.Parent = chamsFolder
            else
                existing.FillColor = col
                existing.OutlineColor = col
                existing.FillTransparency = F.chamsTransp
            end
            if F.esp and p.Character:FindFirstChild("Head") then
                local hasB = false
                for _,b in ipairs(billboards) do
                    if b.Parent == p.Character.Head then hasB = true; break end
                end
                if not hasB then
                    local bg = Instance.new("BillboardGui")
                    bg.Parent = p.Character.Head
                    bg.Size = UDim2.new(0, 180, 0, 44)
                    bg.StudsOffset = Vector3.new(0, 2.8, 0)
                    bg.AlwaysOnTop = true
                    local yOff = 0
                    if F.espName then
                        local nm = Instance.new("TextLabel")
                        nm.Parent = bg; nm.BackgroundTransparency = 1
                        nm.Position = UDim2.new(0,0,0,yOff)
                        nm.Size = UDim2.new(1,0,0,16)
                        nm.Font = fontOf(); nm.TextSize = 12
                        nm.TextColor3 = col; nm.Text = p.Name
                        nm.TextStrokeTransparency = 0.3
                        yOff = yOff + 14
                    end
                    if F.espRole then
                        local rl = Instance.new("TextLabel")
                        rl.Parent = bg; rl.BackgroundTransparency = 1
                        rl.Position = UDim2.new(0,0,0,yOff)
                        rl.Size = UDim2.new(1,0,0,14)
                        rl.Font = fontOf(); rl.TextSize = 10
                        rl.TextColor3 = col; rl.Text = r
                        rl.TextStrokeTransparency = 0.4
                        yOff = yOff + 14
                    end
                    if F.espDist and hrp(p) and hrp(LP) then
                        local dl = Instance.new("TextLabel")
                        dl.Parent = bg; dl.BackgroundTransparency = 1
                        dl.Position = UDim2.new(0,0,0,yOff)
                        dl.Size = UDim2.new(1,0,0,12)
                        dl.Font = fontOf(); dl.TextSize = 9
                        dl.TextColor3 = col
                        dl.Text = math.floor((hrp(p).Position - hrp(LP).Position).Magnitude) .. " studs"
                    end
                    table.insert(billboards, bg)
                end
            end
        end
    end
end

RunService.Heartbeat:Connect(refreshChams)

Players.PlayerAdded:Connect(function() task.wait(1); refreshChams() end)
Players.PlayerRemoving:Connect(function(p)
    local c = chamsFolder:FindFirstChild(p.Name)
    if c then c:Destroy() end
end)

-- FULLBRIGHT / EFFECTS
local bloomInst, ccInst, srInst, vigInst
local function setFullbright(on)
    if on then
        Lighting.Ambient = Color3.fromRGB(255,255,255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255,255,255)
        Lighting.Brightness = 2
    else
        Lighting.Ambient = Color3.fromRGB(70,70,70)
        Lighting.OutdoorAmbient = Color3.fromRGB(128,128,128)
        Lighting.Brightness = 1
    end
end
RunService.Heartbeat:Connect(function()
    if F.bloom then
        if not bloomInst then bloomInst = Instance.new("BloomEffect"); bloomInst.Parent = Lighting end
        bloomInst.Intensity = F.bloomIntensity
        bloomInst.Size = 24
        bloomInst.Threshold = 0.9
    elseif bloomInst then bloomInst:Destroy(); bloomInst = nil end

    if F.colorCorrect then
        if not ccInst then ccInst = Instance.new("ColorCorrectionEffect"); ccInst.Parent = Lighting end
        ccInst.Saturation = 0.3
        ccInst.Contrast = 0.15
    elseif ccInst then ccInst:Destroy(); ccInst = nil end

    if F.sunRays then
        if not srInst then srInst = Instance.new("SunRaysEffect"); srInst.Parent = Lighting end
        srInst.Intensity = 0.15
        srInst.Spread = 1
    elseif srInst then srInst:Destroy(); srInst = nil end

    if F.vignette then
        if not vigInst then vigInst = Instance.new("ColorCorrectionEffect"); vigInst.Parent = Lighting end
        vigInst.Contrast = 0.25
    elseif vigInst then vigInst:Destroy(); vigInst = nil end

    if F.fog then
        Lighting.FogEnd = F.fogEnd
        Lighting.FogStart = 0
    else
        Lighting.FogEnd = 100000
    end
end)

-- CROSSHAIR
local crosshair = nw("Frame",{Parent=gui,BackgroundTransparency=1,Size=UDim2.new(0,60,0,60),Position=UDim2.new(0.5,-30,0.5,-30),Visible=false,ZIndex=100})
local chLines = {}
for i=1,4 do
    chLines[i] = nw("Frame",{Parent=crosshair,BackgroundColor3=T.text,BorderSizePixel=0})
end
local function buildCrosshair()
    crosshair.Visible = F.crosshair
    local s,g,t = F.crosshairSize,F.crosshairGap,F.crosshairThick
    for _,l in ipairs(chLines) do l.BackgroundColor3 = F.crosshairColor end
    chLines[1].Size = UDim2.new(0,t,0,s); chLines[1].Position = UDim2.new(0.5,-t/2,0.5,-g-s)
    chLines[2].Size = UDim2.new(0,t,0,s); chLines[2].Position = UDim2.new(0.5,-t/2,0.5,g)
    chLines[3].Size = UDim2.new(0,s,0,t); chLines[3].Position = UDim2.new(0.5,-g-s,0.5,-t/2)
    chLines[4].Size = UDim2.new(0,s,0,t); chLines[4].Position = UDim2.new(0.5,g,0.5,-t/2)
end

-- FOV CIRCLE
local fovCircle = nw("Frame",{Parent=gui,BackgroundTransparency=1,Size=UDim2.new(0,240,0,240),Position=UDim2.new(0.5,-120,0.5,-120),Visible=false,ZIndex=1})
crn(fovCircle,999)
local fovStroke = nw("UIStroke",{Color=F.fovCircleColor,Thickness=1,Transparency=0.4,Parent=fovCircle})

RunService.RenderStepped:Connect(function()
    crosshair.Visible = F.crosshair
    fovCircle.Visible = F.fovCircle
    if F.fovCircle then
        local r = F.fovCircleSize
        fovCircle.Size = UDim2.new(0,r*2,0,r*2)
        fovCircle.Position = UDim2.new(0.5,-r,0.5,-r)
        fovStroke.Color = F.fovCircleColor
    end
end)

-- WATERMARK UPDATE
task.spawn(function()
    while wm.Parent do
        local t = os.date("%H:%M:%S")
        local ping = math.floor(Players:GetNetworkPing() * 1000)
        local fps = math.floor(1/math.max(RunService.RenderStepped:Wait(),1e-6))
        wmText.Text = string.format("● %s   ◈ %d ms   ◉ %s   ✦ %d fps", t, ping, LP.Name, fps)
        task.wait(0.5)
    end
end)

-- SECTIONS
local builders = {
    main = function()
        cat("Murderer")
        toggle("Kill Aura", F.killAura, function(v) F.killAura = v end)
        slider("Aura Range", 5, 150, F.killAuraRange, 1, function(v) F.killAuraRange = v end)
        toggle("Knife Silent", F.knifeSilent, function(v) F.knifeSilent = v end)
        toggle("Fast Throw", F.fastThrow, function(v) F.fastThrow = v end)
        toggle("No Throw Anim", F.noThrowAnim, function(v) F.noThrowAnim = v end)
        toggle("Kill All", F.killAll, function(v) F.killAll = v end)
        cat("Sheriff")
        toggle("Silent Aim", F.silentAim, function(v) F.silentAim = v; SilentAIMEnabled = v end)
        slider("Silent FOV", 50, 500, F.silentAimFov, 10, function(v) F.silentAimFov = v end)
        toggle("Wall Bang", F.wallBang, function(v) F.wallBang = v end)
        toggle("Auto Shot", F.autoShot, function(v) F.autoShot = v end)
        cat("Innocent")
        toggle("Auto Grab Gun", F.autoGrabGun, function(v) F.autoGrabGun = v end)
        toggle("Gun Drop Notify", F.gunDropNotify, function(v) F.gunDropNotify = v end)
        cat("Anti")
        toggle("Anti Fling", F.antiFling, function(v) F.antiFling = v end)
        toggle("Anti Void", F.antiVoid, function(v) F.antiVoid = v end)
    end,
    visuals = function()
        cat("Chams")
        toggle("ESP", F.esp, function(v) F.esp = v; clearChams() end)
        toggle("Role Chams", F.roleChams, function(v) F.roleChams = v; clearChams() end)
        slider("Fill Transparency", 0, 90, F.chamsTransp*100, 1, function(v) F.chamsTransp = v/100 end)
        slider("Outline Transparency", 0, 90, F.chamsOutlineTransp*100, 1, function(v) F.chamsOutlineTransp = v/100 end)
        cat("ESP Options")
        toggle("Show Name", F.espName, function(v) F.espName = v; clearChams() end)
        toggle("Show Role", F.espRole, function(v) F.espRole = v; clearChams() end)
        toggle("Show Distance", F.espDist, function(v) F.espDist = v; clearChams() end)
        cat("HUD")
        toggle("Crosshair", F.crosshair, function(v) F.crosshair = v; buildCrosshair() end)
        slider("Cross Size", 2, 30, F.crosshairSize, 1, function(v) F.crosshairSize = v; buildCrosshair() end)
        slider("Cross Gap", 0, 30, F.crosshairGap, 1, function(v) F.crosshairGap = v; buildCrosshair() end)
        slider("Cross Thick", 1, 8, F.crosshairThick, 1, function(v) F.crosshairThick = v; buildCrosshair() end)
        toggle("FOV Circle", F.fovCircle, function(v) F.fovCircle = v end)
        slider("FOV Size", 40, 500, F.fovCircleSize, 10, function(v) F.fovCircleSize = v end)
        cat("World")
        toggle("Fullbright", F.fullbright, function(v) F.fullbright = v; setFullbright(v) end)
        toggle("Bloom", F.bloom, function(v) F.bloom = v end)
        slider("Bloom Intensity", 0, 30, F.bloomIntensity*10, 1, function(v) F.bloomIntensity = v/10 end)
        toggle("Color Correction", F.colorCorrect, function(v) F.colorCorrect = v end)
        toggle("Sun Rays", F.sunRays, function(v) F.sunRays = v end)
        toggle("Vignette", F.vignette, function(v) F.vignette = v end)
        toggle("Fog", F.fog, function(v) F.fog = v end)
        slider("Fog Distance", 50, 500, F.fogEnd, 10, function(v) F.fogEnd = v end)
        cat("Effects")
        toggle("China Hat", F.chinaHat, function(v) F.chinaHat = v end)
        toggle("Bullet Tracers", F.bulletTracers, function(v) F.bulletTracers = v end)
        toggle("Spin", F.spin, function(v) F.spin = v end)
        slider("Spin Speed", 1, 30, F.spinSpeed, 1, function(v) F.spinSpeed = v end)
        toggle("Particle", F.particle, function(v) F.particle = v end)
        slider("Particle Rate", 5, 100, F.particleRate, 5, function(v) F.particleRate = v; if particleEmitter then particleEmitter.Rate = v end end)
        slider("Particle Size", 0.2, 3, F.particleSize*10, 1, function(v) F.particleSize = v/10 end)
    end,
    movement = function()
        cat("Speed")
        toggle("Speed Glitch", F.speedGlitch, function(v) F.speedGlitch = v end)
        slider("Speed", 16, 500, F.speed, 1, function(v) F.speed = v end)
        cat("Jump")
        toggle("Jump Power", F.jumpPower, function(v) F.jumpPower = v end)
        slider("Jump Value", 50, 500, F.jumpPowerVal, 5, function(v) F.jumpPowerVal = v end)
        toggle("Infinite Jump", F.infiniteJump, function(v) F.infiniteJump = v end)
        cat("Collision")
        toggle("Noclip", F.noclip, function(v) F.noclip = v end)
        toggle("Fly", F.fly, function(v) F.fly = v end)
        keybind("Fly Key", F.flyKey, function(k) F.flyKey = k end)
        slider("Fly Speed", 10, 300, F.flySpeed, 5, function(v) F.flySpeed = v end)
    end,
    target = function()
        cat("Actions")
        toggle("Fling", F.fling, function(v) F.fling = v end)
        slider("Fling Power", 1000, 8000, F.flingPower, 100, function(v) F.flingPower = v end)
        toggle("Kill (Murderer)", F.killMurd, function(v) F.killMurd = v end)
        toggle("HeadSit", F.headSit, function(v) F.headSit = v end)
        toggle("LoopTP", F.loopTP, function(v) F.loopTP = v end)
        toggle("Bang", F.bang, function(v) F.bang = v end)
        toggle("Mouth Bang", F.mouthBang, function(v) F.mouthBang = v end)
        toggle("Orbit", F.orbit, function(v) F.orbit = v end)
        slider("Orbit Speed", 1, 20, F.orbitSpeed, 1, function(v) F.orbitSpeed = v end)
        cat("Players")
        for _,p in ipairs(Players:GetPlayers()) do
            if p~=LP then
                local b = btnAct(p.Name, function()
                    F.targetPlayer = p.Name
                    for _,other in ipairs(scroll:GetChildren()) do
                        if other:IsA("TextButton") and other ~= b then
                            TweenService:Create(other,TweenInfo.new(0.15),{BackgroundColor3=T.row}):Play()
                        end
                    end
                    TweenService:Create(b,TweenInfo.new(0.15),{BackgroundColor3=T.accent}):Play()
                end)
            end
        end
    end,
    player = function()
        cat("Teleport")
        btnAct("TP to Murderer", function()
            for _,p in ipairs(Players:GetPlayers()) do
                if p~=LP and getRole(p)=="Murderer" and hrp(p) and hrp(LP) then
                    hrp(LP).CFrame = hrp(p).CFrame + Vector3.new(0,3,0)
                    break
                end
            end
        end)
        btnAct("TP to Sheriff", function()
            for _,p in ipairs(Players:GetPlayers()) do
                if p~=LP and getRole(p)=="Sheriff" and hrp(p) and hrp(LP) then
                    hrp(LP).CFrame = hrp(p).CFrame + Vector3.new(0,3,0)
                    break
                end
            end
        end)
        cat("Self")
        btnAct("Reset Character", function()
            local c = LP.Character
            if c then local h = c:FindFirstChildOfClass("Humanoid"); if h then h.Health = 0 end end
        end)
    end,
    settings = function()
        cat("Menu")
        slider("Transparency", 0, 80, F.transparency, 1, function(v) F.transparency = v; win.BackgroundTransparency = v/100 end)
        slider("Menu Scale", 70, 130, F.menuScale*100, 1, function(v) F.menuScale = v/100; winScale.Scale = v/100 end)
        dropdown("Font", FontList, CurrentFont, function(v)
            CurrentFont = v; F.font = v
            applyFont(gui)
            saveCfg()
        end)
        cat("Config")
        btnAct("Save Config", saveCfg)
        btnAct("Load Config", function()
            loadCfg()
            applyFont(gui)
            CurrentFont = F.font or "Gotham"
        end)
        btnAct("Reset Config", function()
            for k,v in pairs(F) do if type(v)=="boolean" then F[k]=false end end
            saveCfg()
        end)
        btnAct("Unload", function()
            gui:Destroy()
            chamsFolder:Destroy()
            if particlePart then particlePart:Destroy() end
            if bloomInst then bloomInst:Destroy() end
            if ccInst then ccInst:Destroy() end
            if srInst then srInst:Destroy() end
            if vigInst then vigInst:Destroy() end
        end)
    end,
}

local sections = {
    {id="main", name="Main", icon="main"},
    {id="visuals", name="Visuals", icon="visuals"},
    {id="movement", name="Movement", icon="movement"},
    {id="target", name="Target", icon="target"},
    {id="player", name="Player", icon="player"},
    {id="settings", name="Settings", icon="settings"},
}

local currentSec = "main"
local sectionBtns = {}

local function selectSection(s)
    currentSec = s.id
    clear()
    if builders[s.id] then builders[s.id]() end
    applyFont(gui)
end

for i,s in ipairs(sections) do
    local b = nw("TextButton",{Parent=nav,BackgroundColor3=T.row,BackgroundTransparency=1,Size=UDim2.new(1,0,0,32),Text="",AutoButtonColor=false,LayoutOrder=i,ZIndex=2})
    crn(b,8)
    local ic = lucideIcon(b,s.icon,UDim2.new(0,16,0,16),UDim2.new(0,10,0.5,-8),T.textDim)
    local lb = nw("TextLabel",{Parent=b,BackgroundTransparency=1,Position=UDim2.new(0,34,0,0),Size=UDim2.new(1,-44,1,0),Font=fontOf(),TextSize=11,TextColor3=T.textDim,TextXAlignment=Enum.TextXAlignment.Left,Text=s.name,ZIndex=2})
    sectionBtns[s.id] = {btn=b, icon=ic, label=lb}
    b.MouseButton1Click:Connect(function()
        for _,data in pairs(sectionBtns) do
            TweenService:Create(data.btn,TweenInfo.new(0.2),{BackgroundTransparency=1,BackgroundColor3=T.row}):Play()
            if data.icon and data.icon.ImageColor3 then data.icon.ImageColor3 = T.textDim end
            data.label.TextColor3 = T.textDim
        end
        TweenService:Create(b,TweenInfo.new(0.2),{BackgroundTransparency=0.3,BackgroundColor3=T.accent}):Play()
        if ic and ic.ImageColor3 then ic.ImageColor3 = T.text end
        lb.TextColor3 = T.text
        selectSection(s)
    end)
    if i==1 then
        task.defer(function()
            b.BackgroundTransparency=0.3
            b.BackgroundColor3=T.accent
            if ic and ic.ImageColor3 then ic.ImageColor3 = T.text end
            lb.TextColor3 = T.text
            selectSection(s)
        end)
    end
end

-- SEARCH
search:GetPropertyChangedSignal("Text"):Connect(function()
    local q = search.Text:lower()
    if q=="" then selectSection(sections[1]); return end
    clear()
    cat("Results")
    local all = {
        {"Kill Aura","main"},{"Silent Aim","main"},{"Auto Shot","main"},
        {"ESP","visuals"},{"Role Chams","visuals"},{"Fullbright","visuals"},
        {"Crosshair","visuals"},{"FOV Circle","visuals"},{"China Hat","visuals"},
        {"Spin","visuals"},{"Particle","visuals"},{"Bloom","visuals"},
        {"Fly","movement"},{"Noclip","movement"},{"Speed","movement"},
        {"Jump Power","movement"},{"Infinite Jump","movement"},
        {"Fling","target"},{"Kill (Murderer)","target"},{"HeadSit","target"},
        {"Bang","target"},{"Mouth Bang","target"},{"Orbit","target"},
        {"TP to Murderer","player"},{"TP to Sheriff","player"},{"Reset","player"},
    }
    for _,item in ipairs(all) do
        if item[1]:lower():find(q) then
            btnAct(item[1], function()
                for _,s in ipairs(sections) do
                    if s.id==item[2] then
                        for _,data in pairs(sectionBtns) do
                            TweenService:Create(data.btn,TweenInfo.new(0.15),{BackgroundTransparency=1,BackgroundColor3=T.row}):Play()
                            if data.icon and data.icon.ImageColor3 then data.icon.ImageColor3 = T.textDim end
                            data.label.TextColor3 = T.textDim
                        end
                        local d = sectionBtns[s.id]
                        TweenService:Create(d.btn,TweenInfo.new(0.15),{BackgroundTransparency=0.3,BackgroundColor3=T.accent}):Play()
                        if d.icon and d.icon.ImageColor3 then d.icon.ImageColor3 = T.text end
                        d.label.TextColor3 = T.text
                        selectSection(s)
                        return
                    end
                end
            end)
        end
    end
end)

-- OPEN/CLOSE
local open = false
local function toggleMenu()
    open = not open
    if open then
        win.Visible = true
        win.Size = UDim2.new(0,0,0,0)
        win.Position = UDim2.new(0.5,0,0.5,0)
        TweenService:Create(win,TweenInfo.new(0.3,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{
            Size = UDim2.new(0,680,0,430),
            Position = UDim2.new(0.5,-340,0.5,-215),
        }):Play()
    else
        TweenService:Create(win,TweenInfo.new(0.22,Enum.EasingStyle.Quart,Enum.EasingDirection.In),{
            Size = UDim2.new(0,0,0,0),
            Position = UDim2.new(0.5,0,0.5,0),
        }):Play()
        task.wait(0.22)
        win.Visible = false
    end
end
btn.MouseButton1Click:Connect(toggleMenu)
UserInputService.InputBegan:Connect(function(i,gp)
    if not gp and i.KeyCode == Enum.KeyCode.RightShift then toggleMenu() end
end)

game:BindToClose(saveCfg)