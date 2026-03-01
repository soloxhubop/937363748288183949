if game.PlaceId ~= 109983668079237 then return end
 
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
 
local Window = Rayfield:CreateWindow({
   Name = "😈SAB HACK",
   Icon = 0,
   LoadingTitle = "Lekker gaan raggen",
   LoadingSubtitle = "by Zurk",
   ShowText = "Rayfield",
   Theme = "Default",
   ToggleUIKeybind = "K",
   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,
   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil,
      FileName = "SAB Duels"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = true,
   KeySettings = {
      Title = "Steal a Brainrot",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"SAB123"}
   }
})
 
Rayfield:Notify({
   Title = "😈 SAB Duels Hack",
   Content = "Loaded successfully! Enjoy duels king 🔥",
   Duration = 5,
   Image = 4483362458
})
 
-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local lp = Players.LocalPlayer
local getgenv = getgenv or function() return _G end
getgenv().SAB = getgenv().SAB or {}
 
-- ==================== DUELS TAB ====================
local DuelsTab = Window:CreateTab("🗡️ Duels", 4483362458)
 
DuelsTab:CreateToggle({
   Name = "🔥 Instant Steal (Duels)",
   CurrentValue = false,
   Flag = "InstantSteal",
   Callback = function(Value)
      getgenv().SAB.InstantSteal = Value
      task.spawn(function()
         while getgenv().SAB.InstantSteal and task.wait(0.05) do
            pcall(function()
               for _, v in ipairs(workspace:GetDescendants()) do
                  if v.Name:lower():find("brainrot") or v.Name:find("Steal") or (v:IsA("BasePart") and v:FindFirstChild("Prompt")) then
                     local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
                     if hrp and (hrp.Position - v.Position).Magnitude < 30 then
                        hrp.CFrame = v.CFrame + Vector3.new(0, 5, 0)
                        -- Most scripts fire a proximity prompt or remote here
                        if v:FindFirstChild("ProximityPrompt") then
                           fireproximityprompt(v.ProximityPrompt)
                        end
                        break
                     end
                  end
               end
            end)
         end
      end)
   end
})
 
DuelsTab:CreateToggle({
   Name = "⚡ Auto Grab / Fast Steal",
   CurrentValue = false,
   Flag = "AutoGrab",
   Callback = function(Value)
      getgenv().SAB.AutoGrab = Value
      task.spawn(function()
         while getgenv().SAB.AutoGrab and task.wait(0.1) do
            pcall(function()
               local tool = lp.Character:FindFirstChildOfClass("Tool")
               if tool and tool:FindFirstChild("Handle") then
                  tool:Activate() -- spam grab/steal
               end
            end)
         end
      end)
   end
})
 
DuelsTab:CreateButton({
   Name = "💀 Auto-Win Current Duel (Risky)",
   Callback = function()
      Rayfield:Notify({Title="Auto-Win", Content="Trying to force win...", Duration=4})
      pcall(function()
         -- Common ways in current meta: spam steal + desync + kill opponent
         for i = 1, 20 do
            task.wait(0.1)
            if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
               lp.Character.HumanoidRootPart.CFrame = CFrame.new(0, 1000, 0) -- fake teleport to break duel
            end
         end
      end)
   end
})
 
DuelsTab:CreateToggle({
   Name = "🌌 Desync (Anti-Hit)",
   CurrentValue = false,
   Flag = "Desync",
   Callback = function(Value)
      getgenv().SAB.Desync = Value
      local conn
      conn = RunService.Heartbeat:Connect(function()
         if not getgenv().SAB.Desync then conn:Disconnect() return end
         local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
         if hrp then
            local old = hrp.CFrame
            hrp.CFrame = old * CFrame.new(0, 0, -15) -- classic desync offset
            RunService.RenderStepped:Wait()
            hrp.CFrame = old
         end
      end)
   end
})
 
-- ==================== MOVEMENT TAB ====================
local MovementTab = Window:CreateTab("🏃 Movement", 4483362458)
 
MovementTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 350},
   Increment = 1,
   CurrentValue = 16,
   Flag = "WalkSpeed",
   Callback = function(Value)
      if lp.Character and lp.Character:FindFirstChild("Humanoid") then
         lp.Character.Humanoid.WalkSpeed = Value
      end
   end
})
 
MovementTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Flag = "InfJump",
   Callback = function(Value)
      if Value then
         getgenv().InfJumpConn = UIS.JumpRequest:Connect(function()
            local hum = lp.Character and lp.Character:FindFirstChild("Humanoid")
            if hum then hum:ChangeState("Jumping") end
         end)
      else
         if getgenv().InfJumpConn then getgenv().InfJumpConn:Disconnect() end
      end
   end
})
 
-- Simple Fly
local flySpeed = 150
local bv, bg
MovementTab:CreateToggle({
   Name = "✈️ Fly (Hold Space/Ctrl)",
   CurrentValue = false,
   Flag = "Fly",
   Callback = function(Value)
      getgenv().SAB.Fly = Value
      if Value then
         local hrp = lp.Character:WaitForChild("HumanoidRootPart")
         bv = Instance.new("BodyVelocity")
         bg = Instance.new("BodyGyro")
         bv.MaxForce = Vector3.new(9e9,9e9,9e9)
         bg.MaxTorque = Vector3.new(9e9,9e9,9e9)
         bv.Parent = hrp
         bg.Parent = hrp
         RunService.Heartbeat:Connect(function()
            if not getgenv().SAB.Fly then bv:Destroy() bg:Destroy() return end
            local cam = workspace.CurrentCamera
            local move = Vector3.new()
            if UIS:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.new(0,1,0) end
            bv.Velocity = move.Unit * flySpeed
            bg.CFrame = cam.CFrame
         end)
      end
   end
})
 
-- ==================== VISUALS TAB ====================
local VisualsTab = Window:CreateTab("👁️ Visuals", 4483362458)
 
VisualsTab:CreateToggle({
   Name = "Player ESP (Highlight)",
   CurrentValue = false,
   Flag = "ESP",
   Callback = function(Value)
      getgenv().ESPEnabled = Value
      if Value then
         for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= lp and plr.Character then
               local hl = Instance.new("Highlight")
               hl.Adornee = plr.Character
               hl.FillColor = Color3.fromRGB(255, 0, 255)
               hl.OutlineColor = Color3.fromRGB(255, 255, 255)
               hl.Parent = plr.Character
            end
         end
         Players.PlayerAdded:Connect(function(plr)
            plr.CharacterAdded:Connect(function(char)
               if getgenv().ESPEnabled then
                  local hl = Instance.new("Highlight")
                  hl.Adornee = char
                  hl.FillColor = Color3.fromRGB(255, 0, 255)
                  hl.Parent = char
               end
            end)
         end)
      end
   end
})
 
-- ==================== MISC TAB ====================
local MiscTab = Window:CreateTab("🔧 Misc", 4483362458)
 
MiscTab:CreateButton({
   Name = "Anti-AFK",
   Callback = function()
      game:GetService("Players").LocalPlayer.Idled:Connect(function()
         game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
         wait(1)
         game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
      end)
      Rayfield:Notify({Title="Anti-AFK", Content="Enabled!", Duration=3})
   end
})
 
MiscTab:CreateButton({
   Name = "Rejoin Server",
   Callback = function()
      game:GetService("TeleportService"):Teleport(game.PlaceId, lp)
   end
})
 
Rayfield:LoadConfiguration()
Add Comment
Please, Sign In to add comment
create new paste  /  syntax languages  /  archive  /  faq  /  tools  /  night mode  /  api  /  scraping api  /  news  /  pro
privacy statement  /  cookies policy  /  terms of service /  security disclosure  /  dmca  /  report abuse  /  contact

