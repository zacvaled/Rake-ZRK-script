-- Rake ZRK Hub - Modified Version
local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Window = Library:CreateWindow({
    Title = "Rake ZRK script by nurisla2rus",
    Footer = "version: 1.0",
    Icon = 4483345998,
    ShowCustomCursor = true,
})

-- Tabs
local Tabs = {
    Main = Window:AddTab("Features", "user"),
    Weapons = Window:AddTab("Weapons", "gun"),
    ESP = Window:AddTab("ESP", "eye"),
    LocalPlayer = Window:AddTab("Local Player", "user"),
    Misc = Window:AddTab("Misc", "settings"),
    ["UI Settings"] = Window:AddTab("UI Settings", "settings"),
}

-- Main Tab Groupboxes
local MainLeftGroup = Tabs.Main:AddLeftGroupbox("Movement")
local MainRightGroup = Tabs.Main:AddRightGroupbox("Stamina")

-- Run Speed Slider
MainLeftGroup:AddSlider("RunSpeed", {
    Text = "Run Speed",
    Default = 25,
    Min = 16,
    Max = 150,
    Rounding = 0,
    Suffix = " speed",
    Callback = function(Value)
        pcall(function()
            LocalPlayer.PlayerGui.ImportantGUI.Stamina.Runspeed.Value = Value
        end)
    end,
})

-- Infinite Stamina Toggle
MainRightGroup:AddToggle("InfStamina", {
    Text = "Infinite Stamina",
    Default = false,
    Callback = function(Value)
        getgenv().InfStamina = Value
        if Value then
            while getgenv().InfStamina and task.wait(0.1) do
                pcall(function()
                    LocalPlayer.PlayerGui.ImportantGUI.Stamina.Current.Value = 125
                end)
            end
        end
    end,
})

-- Weapons Tab
local WeaponConfigGroup = Tabs.Weapons:AddLeftGroupbox("Weapon Configuration")
local HitboxGroup = Tabs.Weapons:AddRightGroupbox("Hitbox Settings")

-- Store original values
local originalCooldowns = {}
local originalHitboxSizes = {}
local currentWeapon = nil

-- Function to get currently equipped weapon
local function getCurrentWeapon()
    if LocalPlayer.Character then
        for _, tool in pairs(LocalPlayer.Character:GetChildren()) do
            if tool:IsA("Tool") then
                return tool
            end
        end
    end
    return nil
end

-- Monitor weapon changes and apply modifications
local function updateWeaponModifications()
    local weapon = getCurrentWeapon()
    if weapon then
        -- Apply cooldown modification
        if getgenv().NoCooldown then
            if weapon:FindFirstChild("Configuration") then
                local config = weapon.Configuration
                if config:FindFirstChild("Cooldown") then
                    if not originalCooldowns[weapon.Name] then
                        originalCooldowns[weapon.Name] = config.Cooldown.Value
                    end
                    config.Cooldown.Value = 0
                end
            end
        else
            -- Restore cooldown if stored
            if originalCooldowns[weapon.Name] then
                if weapon:FindFirstChild("Configuration") then
                    local config = weapon.Configuration
                    if config:FindFirstChild("Cooldown") then
                        config.Cooldown.Value = originalCooldowns[weapon.Name]
                    end
                end
            end
        end
        
        -- Apply hitbox modification
        if getgenv().BigHitbox then
            if weapon:FindFirstChild("Hitbox") then
                if not originalHitboxSizes[weapon.Name] then
                    originalHitboxSizes[weapon.Name] = weapon.Hitbox.Size
                end
                weapon.Hitbox.Size = Vector3.new(40, 40, 40)
            end
        else
            -- Restore hitbox if stored
            if originalHitboxSizes[weapon.Name] then
                if weapon:FindFirstChild("Hitbox") then
                    weapon.Hitbox.Size = originalHitboxSizes[weapon.Name]
                end
            end
        end
    end
end

-- No Cooldown Toggle
WeaponConfigGroup:AddToggle("NoCooldown", {
    Text = "No Cooldown Current Weapon",
    Default = false,
    Callback = function(Value)
        getgenv().NoCooldown = Value
        updateWeaponModifications()
    end,
})

-- Big Hitbox Toggle
HitboxGroup:AddToggle("BigHitbox", {
    Text = "Big Hitbox Current Weapon",
    Default = false,
    Callback = function(Value)
        getgenv().BigHitbox = Value
        updateWeaponModifications()
    end,
})

-- Monitor weapon changes continuously
RunService.Heartbeat:Connect(function()
    updateWeaponModifications()
end)

-- Local Player Tab
local MovementGroup = Tabs.LocalPlayer:AddLeftGroupbox("Movement")
local PlayerGroup = Tabs.LocalPlayer:AddRightGroupbox("Player Controls")

-- Infinite Jump
MovementGroup:AddToggle("InfJump", {
    Text = "Infinite Jump",
    Default = false,
    Callback = function(Value)
        getgenv().InfJump = Value
        if Value then
            getgenv().jumpConnection = UserInputService.JumpRequest:Connect(function()
                if getgenv().InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                    LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
                end
            end)
        else
            if getgenv().jumpConnection then
                getgenv().jumpConnection:Disconnect()
            end
        end
    end,
})

-- Noclip
MovementGroup:AddToggle("Noclip", {
    Text = "Noclip",
    Default = false,
    Callback = function(Value)
        getgenv().Noclip = Value
        if Value then
            getgenv().noclipConnection = RunService.Stepped:Connect(function()
                if getgenv().Noclip and LocalPlayer.Character then
                    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            if getgenv().noclipConnection then
                getgenv().noclipConnection:Disconnect()
            end
        end
    end,
})

-- No Fall Damage Toggle
MovementGroup:AddToggle("NoFallDamage", {
    Text = "No Fall Damage",
    Default = false,
    Callback = function(Value)
        getgenv().NoFallDamage = Value
        
        local function handleFallDamage()
            if LocalPlayer.Character then
                local fallDamage = LocalPlayer.Character:FindFirstChild("FallDamage")
                
                if getgenv().NoFallDamage then
                    -- Store and remove FallDamage
                    if fallDamage and not getgenv().StoredFallDamage then
                        getgenv().StoredFallDamage = fallDamage:Clone()
                        fallDamage:Destroy()
                    end
                else
                    -- Restore FallDamage if stored
                    if getgenv().StoredFallDamage and not fallDamage then
                        getgenv().StoredFallDamage.Parent = LocalPlayer.Character
                        getgenv().StoredFallDamage = nil
                    end
                end
            end
        end
        
        -- Apply immediately
        handleFallDamage()
        
        -- Monitor character changes
        if Value then
            getgenv().fallDamageConnection = LocalPlayer.CharacterAdded:Connect(function()
                task.wait(1) -- Wait for character to load
                handleFallDamage()
            end)
        else
            if getgenv().fallDamageConnection then
                getgenv().fallDamageConnection:Disconnect()
            end
        end
    end,
})

-- Misc Tab
local VisualGroup = Tabs.Misc:AddLeftGroupbox("Visual Effects")
local WorldGroup = Tabs.Misc:AddRightGroupbox("World Modifications")

-- Full Bright
VisualGroup:AddToggle("FullBright", {
    Text = "Full Bright",
    Default = false,
    Callback = function(Value)
        getgenv().FullBright = Value
        if Value then
            getgenv().brightnessConnection = RunService.Heartbeat:Connect(function()
                if getgenv().FullBright then
                    game:GetService("Lighting").Brightness = 2
                    game:GetService("Lighting").ClockTime = 14
                    game:GetService("Lighting").FogEnd = 100000
                    game:GetService("Lighting").GlobalShadows = false
                    game:GetService("Lighting").OutdoorAmbient = Color3.new(1, 1, 1)
                end
            end)
        else
            if getgenv().brightnessConnection then
                getgenv().brightnessConnection:Disconnect()
                game:GetService("Lighting").Brightness = 1
                game:GetService("Lighting").GlobalShadows = true
            end
        end
    end,
})

-- No Fog
VisualGroup:AddToggle("NoFog", {
    Text = "No Fog",
    Default = false,
    Callback = function(Value)
        getgenv().NoFog = Value
        if Value then
            getgenv().fogConnection = RunService.Heartbeat:Connect(function()
                if getgenv().NoFog then
                    game:GetService("Lighting").FogEnd = 100000
                end
            end)
        else
            if getgenv().fogConnection then
                getgenv().fogConnection:Disconnect()
            end
        end
    end,
})

-- ESP Tab
local ESPGroup = Tabs.ESP:AddLeftGroupbox("Player ESP")

-- MrRake ESP Toggle
ESPGroup:AddToggle("RakeESP", {
    Text = "MrRake ESP",
    Default = false,
    Callback = function(Value)
        getgenv().RakeESP = Value
        if Value then
            local function highlightRake(model)
                if model.Name == "MrRake" and model:IsA("Model") then
                    local highlight = Instance.new("Highlight")
                    highlight.Adornee = model
                    highlight.FillColor = Color3.new(1, 0, 0)
                    highlight.Parent = model
                end
            end
            
            for _, obj in pairs(workspace:GetChildren()) do
                highlightRake(obj)
            end
            
            getgenv().rakeConn = workspace.ChildAdded:Connect(highlightRake)
        else
            if getgenv().rakeConn then
                getgenv().rakeConn:Disconnect()
            end
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Highlight") then
                    obj:Destroy()
                end
            end
        end
    end,
})

-- UI Settings
local MenuGroup = Tabs["UI Settings"]:AddLeftGroupbox("Menu")
local ThemeGroup = Tabs["UI Settings"]:AddRightGroupbox("Themes")

MenuGroup:AddButton("Unload", function()
    Library:Unload()
end)

MenuGroup:AddLabel("Menu Keybind"):AddKeyPicker("MenuKeybind", {
    Default = "RightShift", 
    NoUI = true, 
    Text = "Menu keybind" 
})

MenuGroup:AddToggle("ShowCustomCursor", {
    Text = "Custom Cursor",
    Default = true,
    Callback = function(Value)
        Library.ShowCustomCursor = Value
    end,
})

MenuGroup:AddDropdown("NotificationSide", {
    Values = { "Left", "Right" },
    Default = "Right",
    Text = "Notification Side",
    Callback = function(Value)
        Library:SetNotifySide(Value)
    end,
})

MenuGroup:AddDropdown("DPIDropdown", {
    Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
    Default = "100%",
    Text = "DPI Scale",
    Callback = function(Value)
        Value = Value:gsub("%%", "")
        local DPI = tonumber(Value)
        Library:SetDPIScale(DPI)
    end,
})

MenuGroup:AddColorpicker("AccentColor", {
    Title = "Accent Color",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(Value)
        Library:ChangeThemeColor(Value)
    end
})

Library.ToggleKeybind = Options.MenuKeybind

-- Notify on load
Library:Notify({
    Title = "Rake ZRK Loaded!",
    Content = "Press RightShift to show/hide menu",
    Time = 5
})

-- Theme and Save Managers
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })

SaveManager:SetFolder("RakeZRKConfig")
ThemeManager:SetFolder("RakeZRKConfig")

SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])

SaveManager:LoadAutoloadConfig()

print("Rake ZRK Modified Version Loaded - Press RightShift")