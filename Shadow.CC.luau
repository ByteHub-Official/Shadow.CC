local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local TextChatService = game:GetService("TextChatService")
local StarterGui = game:GetService("StarterGui")
local Camera = workspace.CurrentCamera
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local IsMobile = UserInputService.TouchEnabled

local Toggles = {
   Fly = false, Noclip = false, Speed = false, ESP = false, Fullbright = false,
   InfJump = false, ClickTP = false, Godmode = false, KillAura = false,
   AntiAFK = false, AutoClick = false, FPSBoost = false, ChatSpam = false,
   Invisible = false, BigHead = false, Tiny = false, Rainbow = false,
   NoFog = false, BrightSky = false, AutoRejoin = false,
   ItemESP = false, CollectAuto = false, JumpPower = false, HipHeight = false,
   Aimbot = false, SilentAim = false, Triggerbot = false, Bunnyhop = false,
   AutoFarm = false, Wallhack = false, NoRecoil = false,
   HitboxExpand = false, Reach = false, AutoHeal = false, AutoWin = false
}

local Values = {
   Speed = 50, FlySpeed = 50, JumpPower = 50, HipHeight = 0,
   KillRange = 20, ClickSpeed = 10, SpamSpeed = 0.5,
   AimbotSmoothness = 0.5, AimbotFOV = 150, SilentAimHitChance = 100,
   TriggerbotDelay = 0.1, BunnyhopSpeed = 50,
   HitboxSize = 5, ReachDistance = 20
}

local AimParts = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"}
local SelectedAimPart = "Head"

local MobileControls = {Forward=false, Backward=false, Left=false, Right=false, Up=false, Down=false, Aim=false}
local Connections = {}
local ESPDrawings = {}
local ItemESPGuis = {}

local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Thickness = 2
FOVCircle.NumSides = 100
FOVCircle.Radius = Values.AimbotFOV
FOVCircle.Color = Color3.new(1, 0, 0)
FOVCircle.Filled = false
FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid, RootPart
local OriginalWalkSpeed = 16
local OriginalJumpPower = 50
local OriginalHipHeight = 0
local OriginalMaxHealth = 100

local OriginalLighting = {
   Brightness = Lighting.Brightness,
   ClockTime = Lighting.ClockTime,
   FogEnd = Lighting.FogEnd,
   GlobalShadows = Lighting.GlobalShadows,
   Ambient = Lighting.Ambient
}

local function UpdateCharacter()
   Character = LocalPlayer.Character
   if Character then
      Humanoid = Character:FindFirstChildOfClass("Humanoid")
      RootPart = Character:FindFirstChild("HumanoidRootPart")
      if Humanoid then
         OriginalWalkSpeed = Humanoid.WalkSpeed
         OriginalJumpPower = Humanoid.JumpPower
         OriginalHipHeight = Humanoid.HipHeight
         OriginalMaxHealth = Humanoid.MaxHealth
      end
   end
end

LocalPlayer.CharacterAdded:Connect(UpdateCharacter)
UpdateCharacter()

local Window = Rayfield:CreateWindow({
   Name = "🖤 Shadow.CC v1.0.0 PREMIUM",
   LoadingTitle = "Verifying Premium Access...",
   LoadingSubtitle = "Enter your key",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "ShadowCC",
      FileName = "Config"
   },
   KeySystem = true,
   KeySettings = {
      Title = "🖤 Shadow.CC Premium",
      Subtitle = "Key Required",
      Note = "Join discord.gg/Kezxm2TyGY for keys",
      FileName = "ShadowKey",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"SHADOWPREMIUM2026", "FBIINCHATKEY", "SHADOWV8ELITE"}
   }
})

local MainTab = Window:CreateTab("🏠 Home", 4483362458)
MainTab:CreateSection("Welcome to Shadow.CC v1.0.0 Premium")
MainTab: CreateSection("Offically Released: Monday Feb. 2, 2026")
MainTab:CreateLabel("Fixes: None")
MainTab:CreateLabel("Platform Detected: " .. (IsMobile and "Mobile" or "PC"))
MainTab:CreateButton({
   Name = "Copy Discord Invite",
   Callback = function()
      setclipboard("discord.gg/Kezxm2TyGY")
      StarterGui:SetCore("SendNotification", {Title = "Copied!", Text = "Discord link copied to clipboard"})
   end
})

local MovementTab = Window:CreateTab("🚀 Movement", 4483362458)
MovementTab:CreateToggle({Name="✈️ Fly " .. (IsMobile and "(Mobile Controls)" or "(WASD + Space/Shift)"), CurrentValue=false, Callback=function(v)
   Toggles.Fly = v
   if not v and RootPart and RootPart:FindFirstChild("ShadowFlyBV") then RootPart.ShadowFlyBV:Destroy() end
end})
MovementTab:CreateSlider({Name="Fly Speed", Range={16,300}, Increment=5, CurrentValue=50, Callback=function(v) Values.FlySpeed = v end})
MovementTab:CreateToggle({Name="👻 Noclip", CurrentValue=false, Callback=function(v) Toggles.Noclip = v end})
MovementTab:CreateToggle({Name="⚡ Speed Hack", CurrentValue=false, Callback=function(v)
   Toggles.Speed = v
   if not v and Humanoid then Humanoid.WalkSpeed = OriginalWalkSpeed end
end})
MovementTab:CreateSlider({Name="Walk Speed", Range={16,200}, Increment=1, CurrentValue=50, Callback=function(v) Values.Speed = v end})
MovementTab:CreateToggle({Name="🐰 Bunnyhop", CurrentValue=false, Callback=function(v) Toggles.Bunnyhop = v end})
MovementTab:CreateSlider({Name="Bunnyhop Boost", Range={20,100}, Increment=5, CurrentValue=50, Callback=function(v) Values.BunnyhopSpeed = v end})
MovementTab:CreateToggle({Name="📈 Infinite Jump", CurrentValue=false, Callback=function(v) Toggles.InfJump = v end})
MovementTab:CreateToggle({Name="Jump Power", CurrentValue=false, Callback=function(v)
   Toggles.JumpPower = v
   if not v and Humanoid then Humanoid.JumpPower = OriginalJumpPower end
end})
MovementTab:CreateSlider({Name="Jump Power", Range={50,300}, Increment=5, CurrentValue=50, Callback=function(v) Values.JumpPower = v end})
MovementTab:CreateToggle({Name="Hip Height", CurrentValue=false, Callback=function(v)
   Toggles.HipHeight = v
   if not v and Humanoid then Humanoid.HipHeight = OriginalHipHeight end
end})
MovementTab:CreateSlider({Name="Hip Height", Range={0,20}, Increment=0.5, CurrentValue=0, Callback=function(v) Values.HipHeight = v end})
MovementTab:CreateToggle({Name="🎯 Click Teleport", CurrentValue=false, Callback=function(v) Toggles.ClickTP = v end})

local VisualsTab = Window:CreateTab("👁️ Visuals", 4483362458)
VisualsTab:CreateToggle({Name="☀️ Fullbright", CurrentValue=false, Callback=function(v)
   Toggles.Fullbright = v
   if not v then
      Lighting.Brightness = OriginalLighting.Brightness
      Lighting.ClockTime = OriginalLighting.ClockTime
      Lighting.FogEnd = OriginalLighting.FogEnd
      Lighting.GlobalShadows = OriginalLighting.GlobalShadows
   end
end})
VisualsTab:CreateToggle({Name="🌤️ No Fog", CurrentValue=false, Callback=function(v)
   Toggles.NoFog = v
   if not v then Lighting.FogEnd = OriginalLighting.FogEnd end
end})
VisualsTab:CreateToggle({Name="⭐ Bright Sky", CurrentValue=false, Callback=function(v)
   Toggles.BrightSky = v
   if not v then Lighting.Ambient = OriginalLighting.Ambient end
end})
VisualsTab:CreateToggle({Name="👁️ Player ESP", CurrentValue=false, Callback=function(v)
   Toggles.ESP = v
   if not v then for _, d in pairs(ESPDrawings) do d.Visible = false end end
end})
VisualsTab:CreateToggle({Name="💰 Item ESP", CurrentValue=false, Callback=function(v) Toggles.ItemESP = v end})
VisualsTab:CreateToggle({Name="🧱 Wallhack (Chams)", CurrentValue=false, Callback=function(v) Toggles.Wallhack = v end})
VisualsTab:CreateToggle({Name="🌈 Rainbow Character", CurrentValue=false, Callback=function(v) Toggles.Rainbow = v end})
VisualsTab:CreateToggle({Name="🦵 Big Head", CurrentValue=false, Callback=function(v)
   Toggles.BigHead = v
   if not v and Character.Head then Character.Head.Size = Vector3.new(2,1,1) end
end})
VisualsTab:CreateToggle({Name="📏 Tiny Player", CurrentValue=false, Callback=function(v)
   Toggles.Tiny = v
   if not v then Character:ScaleTo(1) end
end})
VisualsTab:CreateToggle({Name="👻 Invisible", CurrentValue=false, Callback=function(v)
   Toggles.Invisible = v
   if not v then
      for _, p in pairs(Character:GetDescendants()) do
         if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then p.Transparency = 0 end
      end
   end
end})

local CombatTab = Window:CreateTab("⚔️ Combat", 4483362458)
CombatTab:CreateToggle({Name="🛡️ Godmode", CurrentValue=false, Callback=function(v)
   Toggles.Godmode = v
   if v and Humanoid then
      Humanoid.MaxHealth = math.huge
      Humanoid.Health = math.huge
   elseif Humanoid then
      Humanoid.MaxHealth = OriginalMaxHealth
      Humanoid.Health = OriginalMaxHealth
   end
end})
CombatTab:CreateToggle({Name="💥 Kill Aura (Soon)", CurrentValue=false, Callback=function(v) Toggles.KillAura = v end})
CombatTab:CreateSlider({Name="Kill Aura Range", Range={5,50}, Increment=1, CurrentValue=20, Callback=function(v) Values.KillRange = v end})
CombatTab:CreateToggle({Name="🔫 Auto Clicker", CurrentValue=false, Callback=function(v) Toggles.AutoClick = v end})
CombatTab:CreateSlider({Name="Auto Click CPS", Range={1,50}, Increment=1, CurrentValue=10, Callback=function(v) Values.ClickSpeed = v end})
CombatTab:CreateToggle({Name="🚫 No Recoil", CurrentValue=false, Callback=function(v) Toggles.NoRecoil = v end})
CombatTab:CreateToggle({Name="🤖 AutoFarm (Soon)", CurrentValue=false, Callback=function(v) Toggles.AutoFarm = v end})
CombatTab:CreateToggle({Name="🩹 Auto Heal", CurrentValue=false, Callback=function(v) Toggles.AutoHeal = v end})
CombatTab:CreateToggle({Name="🏆 Auto Win", CurrentValue=false, Callback=function(v) Toggles.AutoWin = v end})
CombatTab:CreateToggle({Name="🤺 Reach", CurrentValue=false, Callback=function(v) Toggles.Reach = v end})
CombatTab:CreateSlider({Name="Reach Distance", Range={10,50}, Increment=1, CurrentValue=20, Callback=function(v) Values.ReachDistance = v end})

local AimbotTab = Window:CreateTab("🔒 Aimbot", 4483362458)
AimbotTab:CreateToggle({Name="🔒 Aimbot " .. (IsMobile and "(Toggle Aim Button)" or "(Hold Right Mouse)"), CurrentValue=false, Callback=function(v) Toggles.Aimbot = v end})
AimbotTab:CreateSlider({Name="Smoothness (Lower = Smoother)", Range={0,1}, Increment=0.05, CurrentValue=0.5, Callback=function(v) Values.AimbotSmoothness = v end})
AimbotTab:CreateSlider({Name="Aimbot FOV", Range={50,500}, Increment=10, CurrentValue=150, Callback=function(v)
   Values.AimbotFOV = v
   FOVCircle.Radius = v
end})
AimbotTab:CreateToggle({Name="Show FOV Circle", CurrentValue=false, Callback=function(v) FOVCircle.Visible = v end})
AimbotTab:CreateDropdown({Name="Aim Part", Options=AimParts, CurrentOption="Head", Callback=function(v) SelectedAimPart = v end})
AimbotTab:CreateToggle({Name="🤫 Silent Aim", CurrentValue=false, Callback=function(v) Toggles.SilentAim = v end})
AimbotTab:CreateSlider({Name="Silent Aim Hit Chance %", Range={0,100}, Increment=5, CurrentValue=100, Callback=function(v) Values.SilentAimHitChance = v end})
AimbotTab:CreateToggle({Name="🔥 Triggerbot", CurrentValue=false, Callback=function(v) Toggles.Triggerbot = v end})
AimbotTab:CreateSlider({Name="Triggerbot Delay (s)", Range={0,1}, Increment=0.05, CurrentValue=0.1, Callback=function(v) Values.TriggerbotDelay = v end})
AimbotTab:CreateToggle({Name="📏 Hitbox Expand", CurrentValue=false, Callback=function(v) Toggles.HitboxExpand = v end})
AimbotTab:CreateSlider({Name="Hitbox Size", Range={2,10}, Increment=0.5, CurrentValue=5, Callback=function(v) Values.HitboxSize = v end})

local MiscTab = Window:CreateTab("⚙️ Misc", 4483362458)
MiscTab:CreateToggle({Name="😴 Anti AFK", CurrentValue=false, Callback=function(v) Toggles.AntiAFK = v end})
MiscTab:CreateToggle({Name="🚀 FPS Boost", CurrentValue=false, Callback=function(v) Toggles.FPSBoost = v end})
MiscTab:CreateToggle({Name="💬 Chat Spam(Soon)", CurrentValue=false, Callback=function(v) Toggles.ChatSpam = v end})
MiscTab:CreateSlider({Name="Chat Spam Delay (s)", Range={0.1,5}, Increment=0.1, CurrentValue=0.5, Callback=function(v) Values.SpamSpeed = v end})
MiscTab:CreateToggle({Name="🔄 Auto Rejoin", CurrentValue=false, Callback=function(v) Toggles.AutoRejoin = v end})
MiscTab:CreateToggle({Name="🔍 Auto Collect", CurrentValue=false, Callback=function(v) Toggles.CollectAuto = v end})
MiscTab:CreateButton({Name="🔀 Server Hop", Callback=function()
   local PlaceID = game.PlaceId
   local AllIDs = {}
   local foundAnything = ""
   local actualHour = os.date("!*t").hour
   local Deleted = false
   local File = pcall(function()
      AllIDs = game:GetService('HttpService'):JSONDecode(readfile("NotSameServers.json"))
   end)
   if not File then
      table.insert(AllIDs, actualHour)
      writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
   end
   local function TPReturner()
      local Site;
      if foundAnything == "" then
         Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
      else
         Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
      end
      local ID = ""
      if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
         foundAnything = Site.nextPageCursor
      end
      local num = 0;
      for i,v in pairs(Site.data) do
         local Possible = true
         ID = tostring(v.id)
         if tonumber(v.maxPlayers) > tonumber(v.playing) then
            for _,Existing in pairs(AllIDs) do
               if num ~= 0 then
                  if ID == tostring(Existing) then
                     Possible = false
                  end
               else
                  if tonumber(actualHour) ~= tonumber(Existing) then
                     local delFile = pcall(function()
                        delfile("NotSameServers.json")
                        AllIDs = {}
                        table.insert(AllIDs, actualHour)
                     end)
                  end
               end
               num = num + 1
            end
            if Possible == true then
               table.insert(AllIDs, ID)
               wait()
               pcall(function()
                  writefile("NotSameServers.json", game:GetService('HttpService'):JSONEncode(AllIDs))
                  wait()
                  game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
               end)
               wait(4)
            end
         end
      end
   end
   local function Teleport()
      while wait() do
         pcall(function()
            TPReturner()
            if foundAnything ~= "" then
               TPReturner()
            end
         end)
      end
   end
   Teleport()
end})
MiscTab:CreateButton({Name="👥 Teleport All To Me", Callback=function()
   if RootPart then
      for _, plr in Players:GetPlayers() do
         if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            plr.Character.HumanoidRootPart.CFrame = RootPart.CFrame * CFrame.new(math.random(-6,6), 3, math.random(-6,6))
         end
      end
   end
end})

if IsMobile then
   local MobileTab = Window:CreateTab("📱 Mobile", 4483362458)
   MobileTab:CreateLabel("Fly Controls (Toggle)")
   MobileTab:CreateButton({Name="⬆️ Forward", Callback=function() MobileControls.Forward = not MobileControls.Forward end})
   MobileTab:CreateButton({Name="⬇️ Backward", Callback=function() MobileControls.Backward = not MobileControls.Backward end})
   MobileTab:CreateButton({Name="⬅️ Left", Callback=function() MobileControls.Left = not MobileControls.Left end})
   MobileTab:CreateButton({Name="➡️ Right", Callback=function() MobileControls.Right = not MobileControls.Right end})
   MobileTab:CreateButton({Name="⬆ Up", Callback=function() MobileControls.Up = not MobileControls.Up end})
   MobileTab:CreateButton({Name="⬇ Down", Callback=function() MobileControls.Down = not MobileControls.Down end})
   MobileTab:CreateButton({Name="🔒 Aim (For Aimbot)", Callback=function() MobileControls.Aim = not MobileControls.Aim end})
   MobileTab:CreateButton({Name="Reset All", Callback=function()
      for k,_ in pairs(MobileControls) do MobileControls[k] = false end
   end})
end

local function GetClosestTarget()
   local closest, minDist = nil, Values.AimbotFOV
   local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
   for _, plr in Players:GetPlayers() do
      if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild(SelectedAimPart) then
         local hum = plr.Character:FindFirstChildOfClass("Humanoid")
         if hum and hum.Health > 0 then
            local part = plr.Character[SelectedAimPart]
            local screen, vis = Camera:WorldToViewportPoint(part.Position)
            if vis then
               local dist = (Vector2.new(screen.X, screen.Y) - center).Magnitude
               if dist < minDist then
                  minDist = dist
                  closest = part
               end
            end
         end
      end
   end
   return closest
end

Connections.Aimbot = RunService.RenderStepped:Connect(function()
   if Toggles.Aimbot then
      local target = GetClosestTarget()
      if target then
         if not IsMobile then
            if UserInputService:IsMouseButtonPressed(Enum.MouseButton.Right) then
               local targetPos = Camera:WorldToViewportPoint(target.Position)
               local mousePos = UserInputService:GetMouseLocation()
               local delta = Vector2.new(targetPos.X - mousePos.X, (targetPos.Y - mousePos.Y) - 36) * Values.AimbotSmoothness
               mousemoverel(delta.X, delta.Y)
            end
         else
            if MobileControls.Aim then
               local currentCam = Camera.CFrame
               local targetDir = (target.Position - currentCam.Position).Unit
               local newCam = CFrame.lookAt(currentCam.Position, currentCam.Position + targetDir)
               local tweenInfo = TweenInfo.new(Values.AimbotSmoothness / 2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
               TweenService:Create(Camera, tweenInfo, {CFrame = newCam}):Play()
            end
         end
      end
   end
end)

Connections.SilentAim = RunService.RenderStepped:Connect(function()
   if Toggles.SilentAim and math.random(1,100) <= Values.SilentAimHitChance then
      local target = GetClosestTarget()
      if target then
         Mouse.TargetFilter = target.Parent
         Mouse.Hit = CFrame.new(target.Position)
      end
   end
end)

spawn(function()
   while true do
      wait(Values.TriggerbotDelay)
      if Toggles.Triggerbot then
         local target = Mouse.Target
         if target and target.Parent then
            local player = Players:GetPlayerFromCharacter(target.Parent)
            if player and player ~= LocalPlayer then
               mouse1click()
            end
         end
      end
   end
end)

Connections.Bunnyhop = RunService.Heartbeat:Connect(function()
   if Toggles.Bunnyhop and Humanoid and Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
      Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
      if RootPart then
         local vel = RootPart.Velocity
         RootPart.Velocity = Vector3.new(vel.X, Values.BunnyhopSpeed, vel.Z)
      end
   end
end)

spawn(function()
   while wait(0.4) do
      if Toggles.Wallhack then
         for _, plr in Players:GetPlayers() do
            if plr ~= LocalPlayer and plr.Character then
               for _, part in plr.Character:GetDescendants() do
                  if part:IsA("BasePart") and not part:FindFirstChild("ShadowChams") then
                     local hl = Instance.new("Highlight")
                     hl.Name = "ShadowChams"
                     hl.FillColor = Color3.new(1,0,0)
                     hl.OutlineColor = Color3.new(1,1,0)
                     hl.FillTransparency = 0.4
                     hl.OutlineTransparency = 0
                     hl.Parent = part
                  end
               end
            end
         end
      else
         for _, plr in Players:GetPlayers() do
            if plr.Character then
               for _, part in plr.Character:GetDescendants() do
                  if part:FindFirstChild("ShadowChams") then part.ShadowChams:Destroy() end
               end
            end
         end
      end
   end
end)

Connections.NoRecoil = RunService.RenderStepped:Connect(function()
   if Toggles.NoRecoil then
      Camera.CFrame = Camera.CFrame
   end
end)

spawn(function()
   while wait(0.25) do
      if Toggles.AutoFarm and RootPart then
         for _, obj in workspace:GetChildren() do
            local n = obj.Name:lower()
            if obj:IsA("BasePart") and (n:find("coin") or n:find("gem") or n:find("money") or n:find("drop")) then
               RootPart.CFrame = obj.CFrame + Vector3.new(0, 3, 0)
               wait(0.08)
               firetouchinterest(RootPart, obj, 0)
               firetouchinterest(RootPart, obj, 1)
            end
         end
      end
   end
end)

Connections.Fly = RunService.Heartbeat:Connect(function()
   if not Toggles.Fly or not RootPart then return end
   local bv = RootPart:FindFirstChild("ShadowFlyBV") or Instance.new("BodyVelocity")
   bv.Name = "ShadowFlyBV"
   bv.MaxForce = Vector3.new(1e9,1e9,1e9)
   bv.Velocity = Vector3.zero
   bv.Parent = RootPart

   local cam = Camera.CFrame
   local move = Vector3.zero

   if UserInputService:IsKeyDown(Enum.KeyCode.W) or MobileControls.Forward then move += cam.LookVector end
   if UserInputService:IsKeyDown(Enum.KeyCode.S) or MobileControls.Backward then move -= cam.LookVector end
   if UserInputService:IsKeyDown(Enum.KeyCode.A) or MobileControls.Left then move -= cam.RightVector end
   if UserInputService:IsKeyDown(Enum.KeyCode.D) or MobileControls.Right then move += cam.RightVector end
   if UserInputService:IsKeyDown(Enum.KeyCode.Space) or MobileControls.Up then move += Vector3.yAxis end
   if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or MobileControls.Down then move -= Vector3.yAxis end

   if move.Magnitude > 0 then bv.Velocity = move.Unit * Values.FlySpeed end
end)

Connections.Noclip = RunService.Stepped:Connect(function()
   if Toggles.Noclip and Character then
      for _, p in Character:GetDescendants() do
         if p:IsA("BasePart") then p.CanCollide = false end
      end
   end
end)

Connections.Movement = RunService.Heartbeat:Connect(function()
   if Humanoid then
      if Toggles.Speed then Humanoid.WalkSpeed = Values.Speed end
      if Toggles.JumpPower then Humanoid.JumpPower = Values.JumpPower end
      if Toggles.HipHeight then Humanoid.HipHeight = Values.HipHeight end
   end
end)

Connections.InfJump = UserInputService.JumpRequest:Connect(function()
   if Toggles.InfJump and Humanoid then Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

Connections.Visuals = RunService.RenderStepped:Connect(function()
   if Toggles.Fullbright then
      Lighting.Brightness = 3
      Lighting.ClockTime = 14
      Lighting.FogEnd = 1e9
      Lighting.GlobalShadows = false
   end
   if Toggles.NoFog then Lighting.FogEnd = 1e9 end
   if Toggles.BrightSky then Lighting.Ambient = Color3.new(1,1,1) end
end)

Connections.God = Humanoid and Humanoid.HealthChanged:Connect(function(h)
   if Toggles.Godmode and h < Humanoid.MaxHealth then Humanoid.Health = Humanoid.MaxHealth end
end)

spawn(function()
   while wait(0.1) do
      if Toggles.KillAura and RootPart then
         local originalCFrame = RootPart.CFrame
         for _, plr in Players:GetPlayers() do
            if plr ~= LocalPlayer and plr.Character then
               local targetRoot = plr.Character:FindFirstChild("HumanoidRootPart")
               local targetHum = plr.Character:FindFirstChildOfClass("Humanoid")
               if targetRoot and targetHum and (RootPart.Position - targetRoot.Position).Magnitude <= Values.KillRange then
                  RootPart.CFrame = targetRoot.CFrame * CFrame.new(0,0,-3)
                  wait(0.05)
                  for _, tool in Character:GetChildren() do
                     if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
                        firetouchinterest(tool.Handle, plr.Character.Head, 0)
                        firetouchinterest(tool.Handle, plr.Character.Head, 1)
                     end
                  end
                  firetouchinterest(RootPart, plr.Character.Head, 0)
                  firetouchinterest(RootPart, plr.Character.Head, 1)
                  targetHum.Health = 0
               end
            end
         end
         RootPart.CFrame = originalCFrame
      end
   end
end)

spawn(function()
   while true do
      if Toggles.AutoClick then
         VirtualInputManager:SendMouseButtonEvent(Mouse.X, Mouse.Y, 0, true, game, 0)
         wait(0.01)
         VirtualInputManager:SendMouseButtonEvent(Mouse.X, Mouse.Y, 0, false, game, 0)
      end
      wait(1 / Values.ClickSpeed)
   end
end)

spawn(function()
   while wait(45) do
      if Toggles.AntiAFK then
         VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Unknown, false, game)
         wait(0.1)
         VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Unknown, false, game)
      end
   end
end)

MiscTab:CreateToggle({Name="🚀 FPS Boost", CurrentValue=false, Callback=function(v)
   Toggles.FPSBoost = v
   if v then
      settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
      for _, o in workspace:GetDescendants() do
         if o:IsA("Decal") or o:IsA("Texture") then o:Destroy() end
         if o:IsA("BasePart") then o.Material = Enum.Material.Plastic o.Reflectance = 0 end
      end
   end
end})

spawn(function()
   while wait(0.08) do
      if Character then
         if Toggles.Rainbow then
            local h = tick() % 5 / 5
            for _, p in Character:GetDescendants() do
               if p:IsA("BasePart") then p.Color = Color3.fromHSV(h,1,1) end
            end
         end
         if Toggles.BigHead and Character.Head then Character.Head.Size = Vector3.new(2.8,2.8,2.8) end
         if Toggles.Tiny then Character:ScaleTo(0.55) end
         if Toggles.Invisible then
            for _, p in Character:GetDescendants() do
               if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then p.Transparency = 0.97 end
            end
         end
      end
   end
end)

Connections.ClickTP = UserInputService.InputBegan:Connect(function(input)
   if Toggles.ClickTP and input.UserInputType == Enum.UserInputType.MouseButton1 and RootPart then
      local ray = Camera:ScreenPointToRay(Mouse.X, Mouse.Y)
      local params = RaycastParams.new()
      params.FilterDescendantsInstances = {Character}
      params.FilterType = Enum.RaycastFilterType.Exclude
      local res = workspace:Raycast(ray.Origin, ray.Direction * 2000, params)
      if res then RootPart.CFrame = CFrame.new(res.Position + Vector3.new(0,4,0)) end
   end
end)

local function CreateESP(plr)
   if plr == LocalPlayer then return end
   local txt = Drawing.new("Text")
   txt.Size = 17
   txt.Center = true
   txt.Outline = true
   txt.Font = 2
   txt.Color = Color3.new(1,0.2,0.2)
   table.insert(ESPDrawings, txt)

   spawn(function()
      while plr.Parent do
         if Toggles.ESP and plr.Character and plr.Character:FindFirstChild("Head") and RootPart then
            local head = plr.Character.Head
            local pos, vis = Camera:WorldToViewportPoint(head.Position + Vector3.new(0,2,0))
            if vis then
               local dist = (RootPart.Position - head.Position).Magnitude
               txt.Text = string.format("%s\n[%dm]", plr.Name, math.floor(dist))
               txt.Position = Vector2.new(pos.X, pos.Y)
               txt.Visible = true
            else
               txt.Visible = false
            end
         else
            txt.Visible = false
         end
         RunService.RenderStepped:Wait()
      end
      txt:Remove()
   end)
end

for _, p in Players:GetPlayers() do CreateESP(p) end
Players.PlayerAdded:Connect(CreateESP)

spawn(function()
   while wait(1.2) do
      if Toggles.ItemESP then
         for _, obj in workspace:GetDescendants() do
            local nl = obj.Name:lower()
            if obj:IsA("BasePart") and (nl:find("coin") or nl:find("gem") or nl:find("money") or nl:find("drop")) and not obj:FindFirstChild("ItemESP") then
               local bb = Instance.new("BillboardGui")
               bb.Name = "ItemESP"
               bb.Adornee = obj
               bb.Size = UDim2.new(0,140,0,35)
               bb.AlwaysOnTop = true
               bb.StudsOffset = Vector3.new(0,3,0)
               bb.Parent = obj

               local lbl = Instance.new("TextLabel", bb)
               lbl.Size = UDim2.new(1,0,1,0)
               lbl.BackgroundTransparency = 1
               lbl.Text = obj.Name
               lbl.TextColor3 = Color3.new(1,0.9,0)
               lbl.TextScaled = true
               lbl.Font = Enum.Font.GothamBold

               table.insert(ItemESPGuis, bb)
            end
         end
      else
         for _, g in ItemESPGuis do g:Destroy() end
         ItemESPGuis = {}
      end
   end
end)

spawn(function()
   while wait(0.4) do
      if Toggles.CollectAuto and RootPart then
         for _, obj in workspace:GetChildren() do
            local nl = obj.Name:lower()
            if obj:IsA("BasePart") and (nl:find("coin") or nl:find("gem") or nl:find("money")) and (RootPart.Position - obj.Position).Magnitude < 40 then
               firetouchinterest(RootPart, obj, 0)
               wait(0.02)
               firetouchinterest(RootPart, obj, 1)
            end
         end
      end
   end
end)

local SpamMsgs = {
   "🖤 Shadow.CC v1.0.0",
   "Mobile/PC Detection OP",
   "Aimbot Works on Mobile Now",
   "Get Shadow.CC or L",
   "discord.gg/Kezxm2TyGY",
   "EZ with Shadow Premium"
}

local function GetAllChatRemotes()
   local remotes = {}
   for _, service in {ReplicatedStorage, workspace, LocalPlayer, game:GetService("Lighting"), game:GetService("SoundService")} do
      pcall(function()
         for _, v in service:GetDescendants() do
            if v:IsA("RemoteEvent") and (v.Name:lower():find("chat") or v.Name:lower():find("message") or v.Name:lower():find("say") or v.Name:lower():find("talk") or v.Name:lower():find("broadcast")) then
               table.insert(remotes, v)
            end
         end
      end)
   end
   return remotes
end

local ChatRemotes = GetAllChatRemotes()

spawn(function()
   while true do
      if Toggles.ChatSpam then
         local msg = SpamMsgs[math.random(1,#SpamMsgs)]
         pcall(function()
            if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
               local channel = TextChatService.TextChannels:FindFirstChild("RBXGeneral") or TextChatService.TextChannels:FindFirstChildWhichIsA("TextChannel")
               if channel then channel:SendAsync(msg) end
            else
               local defaultChat = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
               if defaultChat then
                  local say = defaultChat:FindFirstChild("SayMessageRequest")
                  if say then say:FireServer(msg, "All") end
               end
            end
         end)
         for _, remote in ChatRemotes do
            pcall(function() remote:FireServer(msg, "All") end)
            pcall(function() remote:FireServer(msg) end)
            pcall(function() remote:FireServer(msg, "System") end)
            pcall(function() remote:FireServer({Text = msg}, "All") end)
            pcall(function() remote:FireServer("All", msg) end)
         end
      end
      wait(Values.SpamSpeed + math.random()*0.3)
   end
end)

LocalPlayer.OnTeleport:Connect(function(state)
   if Toggles.AutoRejoin and state == Enum.TeleportState.Failed then
      TeleportService:Teleport(game.PlaceId, LocalPlayer)
   end
end)

StarterGui:SetCore("SendNotification", {
   Title = "🖤 Shadow.CC v1.0.0 PREMIUM",
   Text = "Platform: " .. (IsMobile and "Mobile" or "PC") .. "\ndicord.gg/Kezxm2TyGY",
   Duration = 10
})

print("🖤 Shadow.CC v1.0.0 - Full Load Successful!")

spawn(function()
   while wait(0.2) do
      if Toggles.HitboxExpand then
         for _, plr in Players:GetPlayers() do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
               plr.Character.Head.Size = Vector3.new(Values.HitboxSize, Values.HitboxSize, Values.HitboxSize)
               plr.Character.Head.Transparency = 0.8
            end
         end
      else
         for _, plr in Players:GetPlayers() do
            if plr.Character and plr.Character:FindFirstChild("Head") then
               plr.Character.Head.Size = Vector3.new(2,1,1)
               plr.Character.Head.Transparency = 0
            end
         end
      end
   end
end)

spawn(function()
   while wait(0.1) do
      if Toggles.Reach and Character then
         for _, tool in Character:GetChildren() do
            if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
               tool.Handle.Size = Vector3.new(Values.ReachDistance, Values.ReachDistance, Values.ReachDistance)
               tool.Handle.Transparency = 0.9
            end
         end
      else
         for _, tool in Character:GetChildren() do
            if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
               tool.Handle.Size = Vector3.new(1,1,1)
               tool.Handle.Transparency = 0
            end
         end
      end
   end
end)

spawn(function()
   while wait(0.5) do
      if Toggles.AutoHeal and Humanoid then
         Humanoid.Health = Humanoid.MaxHealth
      end
   end
end)

spawn(function()
   while wait(1) do
      if Toggles.AutoWin then
         for _, obj in workspace:GetDescendants() do
            if obj.Name:lower():find("win") or obj.Name:lower():find("flag") or obj.Name:lower():find("end") then
               if obj:IsA("BasePart") then
                  RootPart.CFrame = obj.CFrame
                  firetouchinterest(RootPart, obj, 0)
                  firetouchinterest(RootPart, obj, 1)
               end
            end
         end
      end
   end
end)
