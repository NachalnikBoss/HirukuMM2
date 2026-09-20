local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")
local LP = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local T = {
    bg=Color3.fromRGB(10,10,10), side=Color3.fromRGB(13,13,13),
    row=Color3.fromRGB(18,18,18), stroke=Color3.fromRGB(32,32,32),
    text=Color3.fromRGB(240,240,240), textDim=Color3.fromRGB(120,120,120),
    textCat=Color3.fromRGB(90,90,90), on=Color3.fromRGB(90,130,255),
    off=Color3.fromRGB(45,45,45), accent=Color3.fromRGB(90,130,255),
}

local FontList = {
    "Code", "Gotham", "GothamMedium", "GothamBold", "SourceSans",
    "SourceSansBold", "Roboto", "RobotoMono", "Ubuntu", "Oswald",
    "SciFi", "Arcade", "Fantasy", "Antique", "Bangers", "Creepster",
    "FredokaOne", "IndieFlower", "PatrickHand", "SpecialElite",
}
local CurrentFont = "Code"

local F = {
    killAura=false, killAuraRange=30, fastThrow=false, noThrowAnim=false, killAll=false,
    autoGrabGun=false, gunDropNotify=false, anti=false,
    silentAim=false, wallBang=false, autoShot=false, resolver=false,
    knifeSilent=false, knifeFastThrow=false,
    esp=false, roleChams=false, selfChams=false, itemChams=false,
    gunChams=false, toolChams=false, motionGraph=false, chinaHat=false,
    bulletTracers=false, aura=false, killEffect=false, customSounds=false,
    force=false, shader=false, fog=false,
    speedGlitch=false, speed=32, jumpPower=false, jumpPowerVal=100,
    infiniteJump=false, noclip=false, fly=false, flySpeed=50,
    headSit=false, loopTP=false, fling=false, killMurd=false, bang=false, mouthBang=false,
    antiFling=false, antiVoid=false, transparency=0, sidebarTransp=0.3,
    sidebarImage=false, font="Code",
}

local function loadCfg()
    if readfile and isfile("HirukuMM2.json") then
        local ok,d=pcall(function() return HttpService:JSONDecode(readfile("HirukuMM2.json")) end)
        if ok and d then for k,v in pairs(d) do F[k]=v end end
    end
end
local function saveCfg()
    if writefile then
        local out={}
        for k,v in pairs(F) do if type(v)~="userdata" then out[k]=v end end
        pcall(function() writefile("HirukuMM2.json",HttpService:JSONEncode(out)) end)
    end
end
loadCfg()
CurrentFont = F.font or "Code"

local gui = Instance.new("ScreenGui")
gui.Name="HirukuMM2"; gui.ResetOnSpawn=false; gui.IgnoreGuiInset=true
pcall(function() gui.Parent=game:GetService("CoreGui") end)
if not gui.Parent then gui.Parent=LP:WaitForChild("PlayerGui") end

local function nw(c,p) local o=Instance.new(c); for k,v in pairs(p or {}) do o[k]=v end; return o end
local function crn(p,r) return nw("UICorner",{CornerRadius=UDim.new(0,r or 5),Parent=p}) end
local function strk(p,c,t,tr) return nw("UIStroke",{Color=c or T.stroke,Thickness=t or 1,Transparency=tr or 0,ApplyStrokeMode=Enum.ApplyStrokeMode.Border,Parent=p}) end

local function applyFont(inst)
    for _,d in ipairs(inst:GetDescendants()) do
        if d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") then
            pcall(function() d.Font = Enum.Font[CurrentFont] end)
        end
    end
end

local wm = nw("Frame",{Parent=gui,BackgroundColor3=T.bg,BackgroundTransparency=0.1,Size=UDim2.new(0,420,0,28),Position=UDim2.new(0,12,0,12),BorderSizePixel=0})
crn(wm,4); strk(wm,T.stroke,1,0.5)
nw("Frame",{Parent=wm,BackgroundColor3=T.accent,Size=UDim2.new(0,3,1,0),BorderSizePixel=0})
local wmText = nw("TextLabel",{Parent=wm,BackgroundTransparency=1,Position=UDim2.new(0,10,0,0),Size=UDim2.new(1,-16,1,0),Font=Enum.Font[CurrentFont],TextSize=11,TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,Text="Hiruku Lua"})

local btn = nw("TextButton",{Parent=gui,BackgroundColor3=T.bg,BackgroundTransparency=0.15,Size=UDim2.new(0,120,0,28),Position=UDim2.new(0.5,-60,0,50),BorderSizePixel=0,Text="",AutoButtonColor=false})
crn(btn,14); strk(btn,T.stroke,1,0.3)
nw("TextLabel",{Parent=btn,BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),Font=Enum.Font[CurrentFont],TextSize=12,TextColor3=T.text,Text="Hiruku"})

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

local win = nw("Frame",{Parent=gui,BackgroundColor3=T.bg,Size=UDim2.new(0,620,0,380),Position=UDim2.new(0.5,-310,0.5,-190),BorderSizePixel=0,Visible=false,ClipsDescendants=true})
crn(win,8); strk(win,T.stroke,1,0.3)
drag(win)

local side = nw("Frame",{Parent=win,BackgroundColor3=T.side,Size=UDim2.new(0,155,1,0),BorderSizePixel=0,ClipsDescendants=true})
crn(side,8)
local sideBg = nw("ImageLabel",{Parent=side,BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),Image=F.sidebarImage and "rbxassetid://1228955960" or "",ImageTransparency=0.5,ScaleType=Enum.ScaleType.Crop,ZIndex=0})
local sideOv = nw("Frame",{Parent=side,BackgroundColor3=T.side,BackgroundTransparency=0.3,Size=UDim2.new(1,0,1,0),BorderSizePixel=0,ZIndex=1})
nw("Frame",{Parent=win,BackgroundColor3=T.stroke,Size=UDim2.new(0,1,1,-40),Position=UDim2.new(0,155,0,20),BorderSizePixel=0,ZIndex=3})

local prof = nw("Frame",{Parent=side,BackgroundTransparency=1,Size=UDim2.new(1,0,0,46),Position=UDim2.new(0,0,0,0),ZIndex=2})
nw("TextLabel",{Parent=prof,BackgroundTransparency=1,Position=UDim2.new(0,12,0,8),Size=UDim2.new(1,-16,0,14),Font=Enum.Font[CurrentFont],TextSize=12,TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,Text=LP.DisplayName,ZIndex=2})
nw("TextLabel",{Parent=prof,BackgroundTransparency=1,Position=UDim2.new(0,12,0,24),Size=UDim2.new(1,-16,0,12),Font=Enum.Font[CurrentFont],TextSize=9,TextColor3=T.textDim,TextXAlignment=Enum.TextXAlignment.Left,Text="Hiruku Lua",ZIndex=2})

local profBot = nw("Frame",{Parent=side,BackgroundTransparency=1,Size=UDim2.new(1,0,0,40),Position=UDim2.new(0,0,1,-40),ZIndex=2})
local av = nw("ImageLabel",{Parent=profBot,BackgroundColor3=T.row,Position=UDim2.new(0,12,0,6),Size=UDim2.new(0,26,0,26),BorderSizePixel=0,Image="rbxthumb://type=AvatarHeadShot&id="..LP.UserId.."&w=48&h=48",ZIndex=2})
crn(av,13)
nw("TextLabel",{Parent=profBot,BackgroundTransparency=1,Position=UDim2.new(0,46,0,6),Size=UDim2.new(1,-52,0,13),Font=Enum.Font[CurrentFont],TextSize=10,TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,Text=LP.Name,ZIndex=2})
nw("TextLabel",{Parent=profBot,BackgroundTransparency=1,Position=UDim2.new(0,46,0,20),Size=UDim2.new(1,-52,0,12),Font=Enum.Font[CurrentFont],TextSize=8,TextColor3=T.textDim,TextXAlignment=Enum.TextXAlignment.Left,Text="Hiruku",ZIndex=2})

local nav = nw("Frame",{Parent=side,BackgroundTransparency=1,Position=UDim2.new(0,0,0,46),Size=UDim2.new(1,0,1,-86),ZIndex=2})
nw("UIListLayout",{Parent=nav,Padding=UDim.new(0,2),SortOrder=Enum.SortOrder.LayoutOrder,HorizontalAlignment=Enum.HorizontalAlignment.Center})
nw("UIPadding",{Parent=nav,PaddingTop=UDim.new(0,4),PaddingLeft=UDim.new(0,8),PaddingRight=UDim.new(0,8),PaddingBottom=UDim.new(0,4)})

local cont = nw("Frame",{Parent=win,BackgroundTransparency=1,Position=UDim2.new(0,155,0,0),Size=UDim2.new(1,-155,1,0),ZIndex=2})
local top = nw("Frame",{Parent=cont,BackgroundTransparency=1,Size=UDim2.new(1,0,0,36)})
nw("TextButton",{Parent=top,BackgroundColor3=T.row,Position=UDim2.new(0,10,0.5,-12),Size=UDim2.new(0,55,0,24),Font=Enum.Font[CurrentFont],TextSize=10,TextColor3=T.text,Text="e3  ▾",BorderSizePixel=0,AutoButtonColor=false})
local search = nw("TextBox",{Parent=top,BackgroundColor3=T.row,Position=UDim2.new(1,-180,0.5,-12),Size=UDim2.new(0,170,0,24),Font=Enum.Font[CurrentFont],TextSize=10,TextColor3=T.text,PlaceholderText="Search",PlaceholderColor3=T.textDim,Text="",ClearTextOnFocus=false,BorderSizePixel=0})
crn(search,5)

local scroll = nw("ScrollingFrame",{Parent=cont,BackgroundTransparency=1,Position=UDim2.new(0,0,0,36),Size=UDim2.new(1,0,1,-36),CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,ScrollBarThickness=3,ScrollBarImageColor3=T.textDim,BorderSizePixel=0,ClipsDescendants=true})
nw("UIListLayout",{Parent=scroll,Padding=UDim.new(0,3),SortOrder=Enum.SortOrder.LayoutOrder})
nw("UIPadding",{Parent=scroll,PaddingTop=UDim.new(0,6),PaddingLeft=UDim.new(0,10),PaddingRight=UDim.new(0,10),PaddingBottom=UDim.new(0,8)})

local function clear()
    for _,c in ipairs(scroll:GetChildren()) do
        if not c:IsA("UIListLayout") and not c:IsA("UIPadding") then c:Destroy() end
    end
end

local function cat(t)
    local h=nw("TextLabel",{Parent=scroll,BackgroundTransparency=1,Size=UDim2.new(1,0,0,20),Font=Enum.Font[CurrentFont],TextSize=9,TextColor3=T.textCat,TextXAlignment=Enum.TextXAlignment.Left,Text=t})
    h.LayoutOrder=#scroll:GetChildren()
end

local function base(label,def)
    local r=nw("Frame",{Parent=scroll,BackgroundColor3=T.row,Size=UDim2.new(1,0,0,30),BorderSizePixel=0})
    r.LayoutOrder=#scroll:GetChildren(); crn(r,5)
    nw("TextLabel",{Parent=r,BackgroundTransparency=1,Position=UDim2.new(0,10,0,0),Size=UDim2.new(1,-70,1,0),Font=Enum.Font[CurrentFont],TextSize=10,TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,Text=label})
    return r
end

local function toggle(label,default,cb)
    local r=base(label,default)
    local sw=nw("TextButton",{Parent=r,BackgroundColor3=default and T.on or T.off,Size=UDim2.new(0,30,0,16),Position=UDim2.new(1,-36,0.5,-8),BorderSizePixel=0,Text=""})
    crn(sw,99)
    local kn=nw("Frame",{Parent=sw,BackgroundColor3=Color3.fromRGB(255,255,255),Size=UDim2.new(0,12,0,12),Position=default and UDim2.new(1,-14,0.5,-6) or UDim2.new(0,2,0.5,-6),BorderSizePixel=0})
    crn(kn,99)
    local st=default
    sw.MouseButton1Click:Connect(function()
        st=not st
        TweenService:Create(sw,TweenInfo.new(0.15),{BackgroundColor3=st and T.on or T.off}):Play()
        TweenService:Create(kn,TweenInfo.new(0.15),{Position=st and UDim2.new(1,-14,0.5,-6) or UDim2.new(0,2,0.5,-6)}):Play()
        if cb then cb(st) end
        saveCfg()
    end)
end

local function slider(label,mn,mx,def,stp,cb)
    local r=nw("Frame",{Parent=scroll,BackgroundColor3=T.row,Size=UDim2.new(1,0,0,40),BorderSizePixel=0})
    r.LayoutOrder=#scroll:GetChildren(); crn(r,5)
    nw("TextLabel",{Parent=r,BackgroundTransparency=1,Position=UDim2.new(0,10,0,4),Size=UDim2.new(1,-70,0,13),Font=Enum.Font[CurrentFont],TextSize=10,TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,Text=label})
    local vl=nw("TextLabel",{Parent=r,BackgroundTransparency=1,Position=UDim2.new(1,-50,0,4),Size=UDim2.new(0,40,0,13),Font=Enum.Font[CurrentFont],TextSize=10,TextColor3=T.textDim,TextXAlignment=Enum.TextXAlignment.Right,Text=tostring(def)})
    local tr=nw("Frame",{Parent=r,BackgroundColor3=T.off,Position=UDim2.new(0,10,0,24),Size=UDim2.new(1,-20,0,4),BorderSizePixel=0})
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
    local b=nw("TextButton",{Parent=scroll,BackgroundColor3=T.row,Size=UDim2.new(1,0,0,28),Font=Enum.Font[CurrentFont],TextSize=10,TextColor3=T.text,Text=label,BorderSizePixel=0,AutoButtonColor=false})
    b.LayoutOrder=#scroll:GetChildren(); crn(b,5)
    b.MouseButton1Click:Connect(function() if cb then cb() end end)
    return b
end

local function dropdown(label,options,current,cb)
    local r=nw("Frame",{Parent=scroll,BackgroundColor3=T.row,Size=UDim2.new(1,0,0,28),BorderSizePixel=0})
    r.LayoutOrder=#scroll:GetChildren(); crn(r,5)
    nw("TextLabel",{Parent=r,BackgroundTransparency=1,Position=UDim2.new(0,10,0,0),Size=UDim2.new(0,90,1,0),Font=Enum.Font[CurrentFont],TextSize=10,TextColor3=T.text,TextXAlignment=Enum.TextXAlignment.Left,Text=label})
    local sel=nw("TextButton",{Parent=r,BackgroundColor3=T.off,Position=UDim2.new(1,-120,0.5,-11),Size=UDim2.new(0,110,0,22),Font=Enum.Font[CurrentFont],TextSize=10,TextColor3=T.text,Text=current,BorderSizePixel=0,AutoButtonColor=false})
    crn(sel,4)
    local open=false
    local list=nw("Frame",{Parent=sel,BackgroundColor3=T.row,Position=UDim2.new(0,0,1,2),Size=UDim2.new(1,0,0,#options*20),Visible=false,BorderSizePixel=0,ZIndex=10})
    crn(list,4); strk(list,T.stroke,1,0.5)
    for i,o in ipairs(options) do
        local ob=nw("TextButton",{Parent=list,BackgroundColor3=T.row,BackgroundTransparency=1,Size=UDim2.new(1,0,0,20),Font=Enum.Font[CurrentFont],TextSize=9,TextColor3=T.text,Text=o,AutoButtonColor=false,LayoutOrder=i,ZIndex=11})
        ob.MouseButton1Click:Connect(function()
            sel.Text=o; list.Visible=false; open=false
            if cb then cb(o) end
            saveCfg()
        end)
    end
    sel.MouseButton1Click:Connect(function() open=not open; list.Visible=open end)
end

local function role(p)
    local c=p.Character; if not c then return "Innocent" end
    if c:FindFirstChild("Knife") then return "Murderer" end
    if c:FindFirstChild("Gun") then return "Sheriff" end
    return "Innocent"
end
local function myRole() return role(LP) end
local function alive(p) local c=p.Character; local h=c and c:FindFirstChildOfClass("Humanoid"); return h and h.Health>0 end
local function hrp(p) local c=p.Character; return c and c:FindFirstChild("HumanoidRootPart") end

local function equipKnife()
    local c=LP.Character; if not c then return end
    local knife=c:FindFirstChild("Knife")
    if knife and knife:IsA("Tool") then
        local h=c:FindFirstChildOfClass("Humanoid")
        if h then h:EquipTool(knife) end
    end
end

local function killAuraMurderer()
    if not F.killAura or myRole()~="Murderer" then return end
    equipKnife()
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LP and alive(p) and hrp(p) and hrp(LP) then
            local dist=(hrp(p).Position-hrp(LP).Position).Magnitude
            if dist <= F.killAuraRange then
                local h=p.Character:FindFirstChildOfClass("Humanoid")
                if h then h.Health=0 end
            end
        end
    end
end

RunService.Heartbeat:Connect(killAuraMurderer)

local function flingTarget(target)
    if not target or not target.Character then return end
    local tHrp=target.Character:FindFirstChild("HumanoidRootPart")
    if not tHrp then return end
    local bv=Instance.new("BodyVelocity")
    bv.Velocity=Vector3.new(math.random(-1500,1500), 1500, math.random(-1500,1500))
    bv.MaxForce=Vector3.new(math.huge, math.huge, math.huge)
    bv.Parent=tHrp
    task.delay(0.3, function() if bv then bv:Destroy() end end)
    local bav=Instance.new("BodyAngularVelocity")
    bav.AngularVelocity=Vector3.new(math.random(-50,50), math.random(-50,50), math.random(-50,50))
    bav.MaxTorque=Vector3.new(math.huge, math.huge, math.huge)
    bav.Parent=tHrp
    task.delay(0.3, function() if bav then bav:Destroy() end end)
end

local targetPlayer=nil
local function applyFling()
    if F.fling and targetPlayer and targetPlayer.Character then
        flingTarget(targetPlayer)
    end
end
RunService.Heartbeat:Connect(applyFling)

local function antiFlingLoop()
    if not F.antiFling then return end
    local c=LP.Character
    if not c then return end
    local h=c:FindFirstChildOfClass("Humanoid")
    if h then
        h:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
    end
    for _,v in ipairs(c:GetDescendants()) do
        if v:IsA("BodyVelocity") or v:IsA("BodyAngularVelocity") then
            v:Destroy()
        end
    end
end
RunService.Stepped:Connect(antiFlingLoop)

local function autoVoid()
    if not F.antiVoid then return end
    local r=hrp(LP)
    if r and r.Position.Y < -50 then
        r.CFrame=CFrame.new(0,50,0)
    end
end
RunService.Heartbeat:Connect(autoVoid)

RunService.Heartbeat:Connect(function()
    local h=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if h then
        if F.speedGlitch then h.WalkSpeed=F.speed else h.WalkSpeed=16 end
        if F.jumpPower then h.JumpPower=F.jumpPowerVal; h.UseJumpPower=true else h.JumpPower=50 end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if F.infiniteJump and LP.Character then
        local h=LP.Character:FindFirstChildOfClass("Humanoid")
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

RunService.Stepped:Connect(function()
    if F.noclip and LP.Character then
        for _,v in ipairs(LP.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide=false end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if F.fly and LP.Character then
        local h=LP.Character:FindFirstChildOfClass("Humanoid")
        local r=hrp(LP)
        if h and r then
            h.PlatformStand=true
            local dir=Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir+=Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir-=Camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir-=Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir+=Camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir+=Vector3.new(0,1,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir-=Vector3.new(0,1,0) end
            r.AssemblyLinearVelocity=dir.Magnitude>0 and dir.Unit*F.flySpeed or Vector3.zero
        end
    end
end)

local function tpToRole(want)
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LP and role(p)==want and hrp(p) and hrp(LP) then
            hrp(LP).CFrame=hrp(p).CFrame+Vector3.new(0,3,0)
            return
        end
    end
end

RunService.Heartbeat:Connect(function()
    for _,o in ipairs(Workspace:GetDescendants()) do
        if o.Name=="Gun" and o:IsA("Tool") and o.Parent==Workspace then
            if F.autoGrabGun and LP.Character then o.Parent=LP.Character end
        end
    end
end)

local function findMurderer()
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LP and role(p)=="Murderer" and alive(p) then return p end
    end
end

RunService.Heartbeat:Connect(function()
    if F.autoShot and myRole()=="Sheriff" and LP.Character then
        local m=findMurderer()
        if m and hrp(m) and hrp(LP) then
            local gun=LP.Character:FindFirstChild("Gun")
            if gun then
                hrp(LP).CFrame=CFrame.new(hrp(LP).Position, hrp(m).Position)
                gun:Activate()
            end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if F.silentAim and myRole()=="Sheriff" then
        local best,bd=nil,math.huge
        local center=Camera.ViewportSize/2
        for _,p in ipairs(Players:GetPlayers()) do
            if p~=LP and alive(p) then
                local t=hrp(p)
                if t then
                    local sp,on=Camera:WorldToViewportPoint(t.Position)
                    if on then
                        local d=(Vector2.new(sp.X,sp.Y)-center).Magnitude
                        if d<bd then best,bd=t,d end
                    end
                end
            end
        end
        if best then
            local r=hrp(LP)
            if r then Camera.CFrame=CFrame.new(r.Position, best.Position) end
        end
    end
end)

local chamsFolder=Instance.new("Folder"); chamsFolder.Name="HirukuChams"; chamsFolder.Parent=Workspace
local billboards={}
local function clearChams()
    for _,c in ipairs(chamsFolder:GetChildren()) do c:Destroy() end
    for _,b in ipairs(billboards) do if b.Parent then b:Destroy() end end
    billboards={}
end

local function applyChams()
    clearChams()
    if not (F.esp or F.roleChams) then return end
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LP and alive(p) then
            local r=role(p)
            local col=Color3.fromRGB(80,220,120)
            if r=="Murderer" then col=Color3.fromRGB(230,60,60) end
            if r=="Sheriff" then col=Color3.fromRGB(60,140,255) end
            if F.roleChams or F.esp then
                local hl=Instance.new("Highlight")
                hl.Adornee=p.Character
                hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
                hl.FillColor=col; hl.OutlineColor=col
                hl.FillTransparency=0.55; hl.OutlineTransparency=0.1
                hl.Parent=chamsFolder
            end
            if F.esp and p.Character:FindFirstChild("Head") then
                local bg=Instance.new("BillboardGui")
                bg.Parent=p.Character.Head
                bg.Size=UDim2.new(0,160,0,32)
                bg.StudsOffset=Vector3.new(0,2.4,0)
                bg.AlwaysOnTop=true
                local n=Instance.new("TextLabel")
                n.Parent=bg; n.BackgroundTransparency=1
                n.Size=UDim2.new(1,0,0,16)
                n.Font=Enum.Font[CurrentFont]; n.TextSize=11
                n.TextColor3=col; n.Text=p.Name; n.TextStrokeTransparency=0.4
                local rl=Instance.new("TextLabel")
                rl.Parent=bg; rl.BackgroundTransparency=1
                rl.Position=UDim2.new(0,0,0,16)
                rl.Size=UDim2.new(1,0,0,14)
                rl.Font=Enum.Font[CurrentFont]; rl.TextSize=9
                rl.TextColor3=col; rl.Text=r; rl.TextStrokeTransparency=0.5
                table.insert(billboards,bg)
            end
        end
    end
end

RunService.Heartbeat:Connect(applyChams)

local function chinaHat()
    if not F.chinaHat or not LP.Character then return end
    local head=LP.Character:FindFirstChild("Head")
    if not head then return end
    if head:FindFirstChild("HirukuHat") then return end
    local hat=Instance.new("Part")
    hat.Name="HirukuHat"; hat.Size=Vector3.new(2,0.3,2)
    hat.Color=Color3.fromRGB(200,50,50)
    hat.Material=Enum.Material.Neon
    hat.CanCollide=false; hat.Anchored=false
    hat.Parent=LP.Character
    local weld=Instance.new("WeldConstraint")
    weld.Part0=head; weld.Part1=hat
    weld.Parent=hat
    hat.CFrame=head.CFrame*CFrame.new(0,1.2,0)
end

RunService.Heartbeat:Connect(chinaHat)

local function bulletTracers()
    if not F.bulletTracers then return end
    local c=LP.Character
    if not c then return end
    local gun=c:FindFirstChild("Gun")
    if not gun then return end
    local handle=gun:FindFirstChild("Handle")
    if not handle then return end
    local ray=Ray.new(handle.Position, handle.CFrame.LookVector*500)
    local hit,pos=Workspace:FindPartOnRay(ray, c)
    local beam=Instance.new("Part")
    beam.Size=Vector3.new(0.1,0.1,(handle.Position-pos).Magnitude)
    beam.CFrame=CFrame.lookAt(handle.Position, pos)
    beam.Anchored=true; beam.CanCollide=false
    beam.Material=Enum.Material.Neon
    beam.Color=Color3.fromRGB(255,200,50)
    beam.Parent=Workspace
    task.delay(0.1, function() beam:Destroy() end)
end

RunService.Heartbeat:Connect(bulletTracers)

local function killSelected()
    if not F.killMurd or myRole()~="Murderer" then return end
    if targetPlayer and targetPlayer.Character then
        local h=targetPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then h.Health=0 end
    end
end

RunService.Heartbeat:Connect(killSelected)

local function headSit()
    if not F.headSit or not targetPlayer then return end
    local tHrp=hrp(targetPlayer)
    local myHrp=hrp(LP)
    if tHrp and myHrp then
        myHrp.CFrame=tHrp.CFrame*CFrame.new(0,2.5,0)
    end
end
RunService.Heartbeat:Connect(headSit)

local function loopTP()
    if not F.loopTP or not targetPlayer then return end
    local tHrp=hrp(targetPlayer)
    local myHrp=hrp(LP)
    if tHrp and myHrp then
        myHrp.CFrame=tHrp.CFrame*CFrame.new(0,0,3)
    end
end
RunService.Heartbeat:Connect(loopTP)

local function bangLoop()
    if not F.bang or not targetPlayer then return end
    local tHrp=hrp(targetPlayer)
    local myHrp=hrp(LP)
    if tHrp and myHrp then
        myHrp.CFrame=tHrp.CFrame*CFrame.new(math.sin(tick()*20)*2, 2, math.cos(tick()*20)*2)
    end
end
RunService.Heartbeat:Connect(bangLoop)

local function motionGraph()
    if not F.motionGraph then return end
    local c=LP.Character
    if not c then return end
    local h=c:FindFirstChildOfClass("Humanoid")
    if h then
        h.CameraOffset=Vector3.new(math.sin(tick()*10)*0.1, 0, 0)
    end
end
RunService.Heartbeat:Connect(motionGraph)

local function fogEffect()
    if F.fog then
        Lighting.FogEnd=200
        Lighting.FogStart=0
    else
        Lighting.FogEnd=100000
        Lighting.FogStart=0
    end
end
RunService.Heartbeat:Connect(fogEffect)

local function forceField()
    if not F.force or not LP.Character then return end
    if LP.Character:FindFirstChildOfClass("ForceField") then return end
    local ff=Instance.new("ForceField")
    ff.Parent=LP.Character
end
RunService.Heartbeat:Connect(forceField)

local function autoPickup()
    if not F.autoGrabGun then return end
    for _,o in ipairs(Workspace:GetDescendants()) do
        if o.Name=="Gun" and o:IsA("Tool") and o.Parent==Workspace then
            if LP.Character then o.Parent=LP.Character end
        end
    end
end
RunService.Heartbeat:Connect(autoPickup)

local function knifeSilent()
    if not F.knifeSilent or myRole()~="Murderer" then return end
    local c=LP.Character
    if not c then return end
    local knife=c:FindFirstChild("Knife")
    if not knife then return end
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LP and alive(p) and hrp(p) and hrp(LP) then
            local dist=(hrp(p).Position-hrp(LP).Position).Magnitude
            if dist<=10 then
                local h=p.Character:FindFirstChildOfClass("Humanoid")
                if h then h.Health=0 end
            end
        end
    end
end
RunService.Heartbeat:Connect(knifeSilent)

local function fastThrow()
    if not F.fastThrow or myRole()~="Murderer" then return end
    local c=LP.Character
    if not c then return end
    local knife=c:FindFirstChild("Knife")
    if knife then knife:Activate() end
end
RunService.Heartbeat:Connect(fastThrow)

local function noThrowAnim()
    if not F.noThrowAnim or myRole()~="Murderer" then return end
    local c=LP.Character
    if not c then return end
    local animator=c:FindFirstChildOfClass("Animator")
    if animator then
        for _,t in ipairs(animator:GetPlayingAnimationTracks()) do
            t:Stop()
        end
    end
end
RunService.Heartbeat:Connect(noThrowAnim)

local function killAllMurderer()
    if not F.killAll or myRole()~="Murderer" then return end
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LP and alive(p) then
            local h=p.Character:FindFirstChildOfClass("Humanoid")
            if h then h.Health=0 end
        end
    end
end
RunService.Heartbeat:Connect(killAllMurderer)

local function updateWatermark()
    local time=os.date("%H:%M:%S")
    local ping=math.floor(Players:GetNetworkPing()*1000)
    local fps=math.floor(1/RunService.RenderStepped:Wait())
    wmText.Text=string.format("Hiruku Lua  |  %s  |  %d ms  |  %s  |  %d fps", time, ping, LP.Name, fps)
end

task.spawn(function()
    while wm.Parent do
        pcall(updateWatermark)
        task.wait(0.5)
    end
end)

local builders = {
    main=function()
        cat("Murderer")
        toggle("Kill Aura", F.killAura, function(v) F.killAura=v end)
        slider("Aura Range", 5, 100, F.killAuraRange, 1, function(v) F.killAuraRange=v end)
        toggle("Knife Silent", F.knifeSilent, function(v) F.knifeSilent=v end)
        toggle("Fast Throw", F.fastThrow, function(v) F.fastThrow=v end)
        toggle("No Throw Anim", F.noThrowAnim, function(v) F.noThrowAnim=v end)
        toggle("Kill All", F.killAll, function(v) F.killAll=v end)
        cat("Sheriff")
        toggle("Silent Aim", F.silentAim, function(v) F.silentAim=v end)
        toggle("Auto Shot", F.autoShot, function(v) F.autoShot=v end)
        cat("Innocent")
        toggle("Auto Grab Gun", F.autoGrabGun, function(v) F.autoGrabGun=v end)
        cat("Anti")
        toggle("Anti Fling", F.antiFling, function(v) F.antiFling=v end)
        toggle("Anti Void", F.antiVoid, function(v) F.antiVoid=v end)
    end,
    visuals=function()
        cat("Chams")
        toggle("ESP", F.esp, function(v) F.esp=v end)
        toggle("Role Chams", F.roleChams, function(v) F.roleChams=v end)
        toggle("China Hat", F.chinaHat, function(v) F.chinaHat=v end)
        toggle("Bullet Tracers", F.bulletTracers, function(v) F.bulletTracers=v end)
        cat("Effects")
        toggle("Motion Graph", F.motionGraph, function(v) F.motionGraph=v end)
        toggle("Fog", F.fog, function(v) F.fog=v end)
        toggle("Force", F.force, function(v) F.force=v end)
    end,
    movement=function()
        cat("Speed")
        toggle("Speed Glitch", F.speedGlitch, function(v) F.speedGlitch=v end)
        slider("Speed", 16, 200, F.speed, 1, function(v) F.speed=v end)
        cat("Jump")
        toggle("Jump Power", F.jumpPower, function(v) F.jumpPower=v end)
        slider("Jump Value", 50, 300, F.jumpPowerVal, 5, function(v) F.jumpPowerVal=v end)
        toggle("Infinite Jump", F.infiniteJump, function(v) F.infiniteJump=v end)
        cat("Collision")
        toggle("Noclip", F.noclip, function(v) F.noclip=v end)
        toggle("Fly", F.fly, function(v) F.fly=v end)
        slider("Fly Speed", 10, 200, F.flySpeed, 5, function(v) F.flySpeed=v end)
    end,
    target=function()
        cat("Actions")
        toggle("Fling", F.fling, function(v) F.fling=v end)
        toggle("Kill (Murd)", F.killMurd, function(v) F.killMurd=v end)
        toggle("HeadSit", F.headSit, function(v) F.headSit=v end)
        toggle("LoopTP", F.loopTP, function(v) F.loopTP=v end)
        toggle("Bang", F.bang, function(v) F.bang=v end)
        toggle("Mouth Bang", F.mouthBang, function(v) F.mouthBang=v end)
        cat("Players")
        for _,p in ipairs(Players:GetPlayers()) do
            if p~=LP then
                local b=btnAct(p.Name, function()
                    targetPlayer=p
                end)
                b.BackgroundColor3=targetPlayer==p and T.accent or T.row
            end
        end
    end,
    player=function()
        cat("Teleport")
        btnAct("TP to Murderer", function() tpToRole("Murderer") end)
        btnAct("TP to Sheriff", function() tpToRole("Sheriff") end)
        cat("Self")
        btnAct("Reset Character", function()
            local c=LP.Character
            if c then local h=c:FindFirstChildOfClass("Humanoid"); if h then h.Health=0 end end
        end)
    end,
    settings=function()
        cat("Menu")
        slider("Transparency", 0, 80, F.transparency, 1, function(v)
            F.transparency=v; win.BackgroundTransparency=v/100
        end)
        dropdown("Font", FontList, CurrentFont, function(v)
            CurrentFont=v; F.font=v
            applyFont(gui)
            saveCfg()
        end)
        cat("Config")
        btnAct("Save Config", saveCfg)
        btnAct("Load Config", loadCfg)
        btnAct("Reset Config", function()
            F={killAura=false,killAuraRange=30,fastThrow=false,noThrowAnim=false,killAll=false,autoGrabGun=false,gunDropNotify=false,anti=false,silentAim=false,wallBang=false,autoShot=false,resolver=false,knifeSilent=false,knifeFastThrow=false,esp=false,roleChams=false,selfChams=false,itemChams=false,gunChams=false,toolChams=false,motionGraph=false,chinaHat=false,bulletTracers=false,aura=false,killEffect=false,customSounds=false,force=false,shader=false,fog=false,speedGlitch=false,speed=32,jumpPower=false,jumpPowerVal=100,infiniteJump=false,noclip=false,fly=false,flySpeed=50,headSit=false,loopTP=false,fling=false,killMurd=false,bang=false,mouthBang=false,antiFling=false,antiVoid=false,transparency=0,sidebarTransp=0.3,sidebarImage=false,font="Code"}
            saveCfg()
        end)
    end,
}

local sections={
    {id="main",name="Main"},
    {id="visuals",name="Visuals"},
    {id="movement",name="Movement"},
    {id="target",name="Target"},
    {id="player",name="Player"},
    {id="settings",name="Settings"},
}

local currentSec="main"

local function selectSection(s)
    currentSec=s.id; clear()
    if builders[s.id] then builders[s.id]() end
    applyFont(gui)
end

for i,s in ipairs(sections) do
    local b=nw("TextButton",{Parent=nav,BackgroundColor3=T.row,BackgroundTransparency=1,Size=UDim2.new(1,0,0,28),Text="",AutoButtonColor=false,LayoutOrder=i,ZIndex=2})
    crn(b,5)
    nw("TextLabel",{Parent=b,BackgroundTransparency=1,Position=UDim2.new(0,10,0,0),Size=UDim2.new(1,-16,1,0),Font=Enum.Font[CurrentFont],TextSize=10,TextColor3=T.textDim,TextXAlignment=Enum.TextXAlignment.Left,Text=s.name,ZIndex=2})
    b.MouseButton1Click:Connect(function()
        for _,o in ipairs(nav:GetChildren()) do
            if o:IsA("TextButton") then
                TweenService:Create(o,TweenInfo.new(0.1),{BackgroundTransparency=1,BackgroundColor3=T.row}):Play()
                local l=o:FindFirstChildOfClass("TextLabel"); if l then l.TextColor3=T.textDim end
            end
        end
        TweenService:Create(b,TweenInfo.new(0.1),{BackgroundTransparency=0.3,BackgroundColor3=T.accent}):Play()
        b:FindFirstChildOfClass("TextLabel").TextColor3=T.text
        selectSection(s)
    end)
    if i==1 then
        task.defer(function()
            b.BackgroundTransparency=0.3; b.BackgroundColor3=T.accent
            b:FindFirstChildOfClass("TextLabel").TextColor3=T.text
            selectSection(s)
        end)
    end
end

search:GetPropertyChangedSignal("Text"):Connect(function()
    local q=search.Text:lower()
    if q=="" then selectSection(sections[1]); return end
    clear()
    cat("Results")
    local all={
        {"Kill Aura","main"},{"Silent Aim","main"},{"Auto Shot","main"},
        {"ESP","visuals"},{"Role Chams","visuals"},{"Fly","movement"},
        {"Noclip","movement"},{"Speed","movement"},{"Fling","target"},
        {"Kill (Murd)","target"},{"HeadSit","target"},{"Bang","target"},
        {"TP to Murderer","player"},{"TP to Sheriff","player"},
    }
    for _,item in ipairs(all) do
        if item[1]:lower():find(q) then
            btnAct(item[1], function()
                for _,s in ipairs(sections) do
                    if s.id==item[2] then selectSection(s) end
                end
            end)
        end
    end
end)

local open=false
local function toggleMenu()
    open=not open
    if open then
        win.Visible=true
        win.Size=UDim2.new(0,0,0,0)
        win.Position=UDim2.new(0.5,0,0.5,0)
        TweenService:Create(win,TweenInfo.new(0.25,Enum.EasingStyle.Quart),{
            Size=UDim2.new(0,620,0,380),
            Position=UDim2.new(0.5,-310,0.5,-190),
        }):Play()
    else
        TweenService:Create(win,TweenInfo.new(0.2,Enum.EasingStyle.Quart),{
            Size=UDim2.new(0,0,0,0),
            Position=UDim2.new(0.5,0,0.5,0),
        }):Play()
        task.wait(0.2)
        win.Visible=false
    end
end

btn.MouseButton1Click:Connect(toggleMenu)
UserInputService.InputBegan:Connect(function(i,gp)
    if not gp and i.KeyCode==Enum.KeyCode.RightShift then toggleMenu() end
end)

game:BindToClose(saveCfg)