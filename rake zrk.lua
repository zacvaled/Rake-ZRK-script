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
   Discord = {
      Enabled = false
   },
   KeySystem = false
})

-- MAIN TAB
local MainTab = Window:CreateTab("Main")

-- Infinite Stamina Toggle
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

-- No Fall Damage Button
MainTab:CreateButton({
    Name = "Remove Fall Damage",
    Callback = function()
        pcall(function()
            local fd = game.Players.LocalPlayer.Character:FindFirstChild("FallDamage")
            if fd then fd:Destroy() end
        end)
    end
})

-- Run Speed Slider
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

-- ESP TAB
local ESPTab = Window:CreateTab("ESP")
ESPTab:CreateToggle({
    Name = "MrRake ESP",
    CurrentValue = false,
    Flag = "MrRakeESP",
    Callback = function(value)
        getgenv().MrRakeESP = value
        if value then
            spawn(function()
                while getgenv().MrRakeESP do
                    pcall(function()
                        local rake = workspace:FindFirstChild("MrRake")
                        if rake and rake:FindFirstChild("HumanoidRootPart") then
                            local billboard = rake:FindFirstChild("ESPBillboard")
                            if not billboard then
                                billboard = Instance.new("BillboardGui")
                                billboard.Name = "ESPBillboard"
                                billboard.Adornee = rake:WaitForChild("HumanoidRootPart")
                                billboard.Size = UDim2.new(0,100,0,50)
                                billboard.StudsOffset = Vector3.new(0,3,0)
                                billboard.AlwaysOnTop = true
                                local label = Instance.new("TextLabel")
                                label.Size = UDim2.new(1,0,1,0)
                                label.BackgroundTransparency = 1
                                label.TextColor3 = Color3.fromRGB(255,0,0)
                                label.Font = Enum.Font.GothamBold
                                label.TextSize = 14
                                label.Text = rake.Name .. " | " .. math.floor(rake:FindFirstChild("Humanoid").Health)
                                label.Parent = billboard
                                billboard.Parent = rake
                            else
                                local label = billboard:FindFirstChildOfClass("TextLabel")
                                if label and rake:FindFirstChild("Humanoid") then
                                    label.Text = rake.Name .. " | " .. math.floor(rake.Humanoid.Health)
                                end
                            end
                        end
                    end)
                    task.wait(0.2)
                end
            end)
        else
            local rake = workspace:FindFirstChild("MrRake")
            if rake then
                local esp = rake:FindFirstChild("ESPBillboard")
                if esp then esp:Destroy() end
            end
        end
    end
})

-- FUN TAB
local FunTab = Window:CreateTab("Fun")

-- Infinite Jump
FunTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Flag = "InfJump",
    Callback = function(value)
        getgenv().InfiniteJump = value
    end
})

-- Noclip
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
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end
    end
})

-- Sky Fall Button
FunTab:CreateButton({
    Name = "Sky Fall",
    Callback = function()
        local hum = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then
            local root = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                root.CFrame = root.CFrame + Vector3.new(0,1000,0)
            end
        end
    end
})

-- Rainbow Weapon Button
FunTab:CreateButton({
    Name = "Rainbow Weapon",
    Callback = function()
        local player = game.Players.LocalPlayer
        local tool = player.Character:FindFirstChildOfClass("Tool")
        if tool then
            spawn(function()
                while tool.Parent do
                    for _, part in pairs(tool:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.Color = Color3.fromHSV(tick() % 5 / 5,1,1)
                        end
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})

-- Weapons TAB
local WeaponTab = Window:CreateTab("Weapons")

-- Big Hitbox Button
WeaponTab:CreateButton({
    Name = "Big Hitbox",
    Callback = function()
        local player = game.Players.LocalPlayer
        local tool = player.Character:FindFirstChildOfClass("Tool")
        if tool then
            for _, part in pairs(tool:GetDescendants()) do
                if part:IsA("BasePart") and part.Name == "Hitbox" then
                    part.Size = Vector3.new(40,40,40)
                end
            end
        end
    end
})

-- No Weapon Cooldown Button
WeaponTab:CreateButton({
    Name = "No Weapon Cooldown",
    Callback = function()
        local player = game.Players.LocalPlayer
        local tool = player.Character:FindFirstChildOfClass("Tool")
        if tool and tool:FindFirstChild("Configuration") and tool.Configuration:FindFirstChild("Cooldown") then
            tool.Configuration.Cooldown.Value = 0
        end
    end
})

-- Infinite Jump Logic
game:GetService("UserInputService").JumpRequest:Connect(function()
    if getgenv().InfiniteJump then
        local hum = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

print("Rake ZRK Rayfield GUI Full Bundle Loaded!")