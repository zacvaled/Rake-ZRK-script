-- Load Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Create Window
local Window = Rayfield:CreateWindow({
   Name = "Rake ZRK Hub",
   LoadingTitle = "Rake ZRK",
   LoadingSubtitle = "Loaded Successfully",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "RakeZRKHub",
      FileName = "UserConfig"
   },
   Discord = { Enabled = false },
   KeySystem = false
})

-- Tabs with icons
local MainTab = Window:CreateTab("Main", 12443244377)
local ESPTab = Window:CreateTab("ESP", 13549782540)
local FunTab = Window:CreateTab("Fun", 3057073095)
local WeaponTab = Window:CreateTab("Weapon", 124599541946939)

-- ================= MAIN TAB =================
MainTab:CreateToggle({
    Name = "Infinite Stamina",
    CurrentValue = false,
    Flag = "InfStamina",
    Callback = function(value)
        getgenv().InfiniteStamina = value
        if value then
            spawn(function()
                while getgenv().InfiniteStamina do
                    pcall(function()
                        local stamina = game.Players.LocalPlayer.PlayerGui.ImportantGUI.Stamina.Current
                        if stamina then stamina.Value = 125 end
                    end)
                    task.wait(0.1)
                end
            end)
        end
    end
})

MainTab:CreateToggle({
    Name = "No Fall Damage",
    CurrentValue = false,
    Flag = "NoFallDamage",
    Callback = function(value)
        if value then
            pcall(function()
                local fd = game.Players.LocalPlayer.Character:FindFirstChild("FallDamage")
                if fd then fd:Destroy() end
            end)
        end
    end
})

MainTab:CreateSlider({
    Name = "Run Speed",
    Range = {16, 100},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 25,
    Flag = "RunSpeed",
    Callback = function(value)
        pcall(function()
            local rs = game.Players.LocalPlayer.PlayerGui.ImportantGUI.Stamina.Runspeed
            if rs then rs.Value = value end
        end)
    end
})

MainTab:CreateSlider({
    Name = "Proximity Prompt Hold Duration",
    Range = {0, 5},
    Increment = 0.1,
    Suffix = "s",
    CurrentValue = 0,
    Flag = "PromptDuration",
    Callback = function(value)
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then
                obj.HoldDuration = value
            end
        end
    end
})

-- ================= ESP TAB =================
ESPTab:CreateToggle({
    Name = "MrRake ESP",
    CurrentValue = false,
    Flag = "MrRakeESP",
    Callback = function(value)
        getgenv().MrRakeESP = value
        spawn(function()
            while getgenv().MrRakeESP do
                for _, npc in pairs(workspace:GetDescendants()) do
                    if npc.Name == "MrRake" and npc:IsA("Model") then
                        if not npc:FindFirstChild("ESP") then
                            local billboard = Instance.new("BillboardGui")
                            billboard.Name = "ESP"
                            billboard.Size = UDim2.new(0,100,0,50)
                            billboard.Adornee = npc:FindFirstChild("HumanoidRootPart")
                            billboard.AlwaysOnTop = true

                            local label = Instance.new("TextLabel")
                            label.Size = UDim2.new(1,0,1,0)
                            label.BackgroundTransparency = 1
                            label.TextColor3 = Color3.new(1,0,0)
                            label.Font = Enum.Font.GothamBold
                            label.TextSize = 14
                            label.Text = npc.Name .. " | HP: " .. (npc:FindFirstChild("Humanoid") and npc.Humanoid.Health or 0)
                            label.Parent = billboard

                            billboard.Parent = npc
                        else
                            local hb = npc:FindFirstChild("ESP")
                            local label = hb:FindFirstChildWhichIsA("TextLabel")
                            if label and npc:FindFirstChild("Humanoid") then
                                label.Text = npc.Name .. " | HP: " .. npc.Humanoid.Health
                            end
                        end
                    end
                end
                task.wait(0.5)
            end
        end)
    end
})

-- ================= FUN TAB =================
FunTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Flag = "InfJump",
    Callback = function(value)
        getgenv().InfiniteJump = value
    end
})

FunTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "NoClip",
    Callback = function(value)
        getgenv().NoClip = value
        if value then
            local player = game.Players.LocalPlayer
            game:GetService('RunService').Stepped:Connect(function()
                if getgenv().NoClip and player.Character then
                    for _, part in pairs(player.Character:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end
            end)
        end
    end
})

FunTab:CreateButton({
    Name = "Sky Fall",
    Callback = function()
        local player = game.Players.LocalPlayer
        local hum = player.Character:FindFirstChild("Humanoid")
        if hum then
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            if root then
                root.CFrame = root.CFrame + Vector3.new(0,500,0) -- teleport up
            end
            hum:ChangeState(Enum.HumanoidStateType.Freefall)
        end
    end
})

FunTab:CreateButton({
    Name = "Rainbow Current Weapon",
    Callback = function()
        local player = game.Players.LocalPlayer
        local weapon = player.Character:FindFirstChildOfClass("Tool")
        if weapon then
            spawn(function()
                while weapon and weapon.Parent == player.Character do
                    for _, part in pairs(weapon:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.Color = Color3.fromHSV(tick()%1,1,1)
                        end
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})

-- ================= WEAPON TAB =================
WeaponTab:CreateButton({
    Name = "Big Hitbox (40,40,40)",
    Callback = function()
        local player = game.Players.LocalPlayer
        local weapon = player.Character:FindFirstChildOfClass("Tool")
        if weapon then
            local hitbox = weapon:FindFirstChild("Hitbox")
            if hitbox and hitbox:IsA("BasePart") then
                hitbox.Size = Vector3.new(40,40,40)
            end
        end
    end
})

WeaponTab:CreateButton({
    Name = "No Weapon Cooldown",
    Callback = function()
        local player = game.Players.LocalPlayer
        local weapon = player.Character:FindFirstChildOfClass("Tool")
        if weapon then
            local config = weapon:FindFirstChild("Configuration")
            if config then
                local cooldown = config:FindFirstChild("Cooldown")
                if cooldown and cooldown:IsA("NumberValue") then
                    cooldown.Value = 0
                end
            end
        end
    end
})

-- ================= Infinite Jump Logic =================
game:GetService("UserInputService").JumpRequest:Connect(function()
    if getgenv().InfiniteJump then
        local hum = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

print("Rake ZRK Rayfield Full Bundle Loaded!")