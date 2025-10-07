-- Rake ZRK ULTIMATE BUNDLE by 0Zer0
local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local Window = Library:CreateWindow({
    Title = "Rake ZRK ULTIMATE by ferZ",
    Footer = "FULL BUNDLE v2.0",
    Icon = 4483345998,
    ShowCustomCursor = true,
})

local Tabs = {
    Main = Window:AddTab("Features", "user"),
    Weapons = Window:AddTab("Weapons", "gun"),
    ESP = Window:AddTab("ESP", "eye"),
    LocalPlayer = Window:AddTab("Local Player", "user"),
    Misc = Window:AddTab("Misc", "settings"),
    ["UI Settings"] = Window:AddTab("UI Settings", "settings"),
}

-- MAIN TAB
local MainLeftGroup = Tabs.Main:AddLeftGroupbox("Movement")
local MainRightGroup = Tabs.Main:AddRightGroupbox("Stamina & Safety")

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

MainRightGroup:AddToggle("NoFallDamage", {
    Text = "No Fall Damage",
    Default = false,
    Callback = function(Value)
        getgenv().NoFallDamage = Value
        local function handleFallDamage()
            if LocalPlayer.Character then
                local fallDamage = LocalPlayer.Character:FindFirstChild("FallDamage")
                if getgenv().NoFallDamage then
                    if fallDamage and not getgenv().StoredFallDamage then
                        getgenv().StoredFallDamage = fallDamage:Clone()
                        fallDamage:Destroy()
                    end
                else
                    if getgenv().StoredFallDamage and not fallDamage then
                        getgenv().StoredFallDamage.Parent = LocalPlayer.Character
                        getgenv().StoredFallDamage = nil
                    end
                end
            end
        end
        handleFallDamage()
        if Value then
            getgenv().fallDamageConnection = LocalPlayer.CharacterAdded:Connect(function()
                task.wait(1)
                handleFallDamage()
            end)
        else
            if getgenv().fallDamageConnection then
                getgenv().fallDamageConnection:Disconnect()
            end
        end
    end,
})

-- WEAPONS TAB
local WeaponConfigGroup = Tabs.Weapons:AddLeftGroupbox("Weapon Configuration")
local HitboxGroup = Tabs.Weapons:AddRightGroupbox("Hitbox Settings")

local originalCooldowns = {}
local originalHitboxSizes = {}

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

local function updateWeaponModifications()
    local weapon = getCurrentWeapon()
    if weapon then
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
            if originalCooldowns[weapon.Name] then
                if weapon:FindFirstChild("Configuration") then
                    local config = weapon.Configuration
                    if config:FindFirstChild("Cooldown") then
                        config.Cooldown.Value = originalCooldowns[weapon.Name]
                    end
                end
            end
        end
        
        if getgenv().BigHitbox then
            if weapon:FindFirstChild("Hitbox") then
                if not originalHitboxSizes[weapon.Name] then
                    originalHitboxSizes[weapon.Name] = weapon.Hitbox.Size
                end
                weapon.Hitbox.Size = Vector3.new(40, 40, 40)
            end
        else
            if originalHitboxSizes[weapon.Name] then
                if weapon:FindFirstChild("Hitbox") then
                    weapon.Hitbox.Size = originalHitboxSizes[weapon.Name]
                end
            end
        end
    end
end

WeaponConfigGroup:AddToggle("NoCooldown", {
    Text = "No Cooldown Current Weapon",
    Default = false,
    Callback = function(Value)
        getgenv().NoCooldown = Value
        updateWeaponModifications()
    end,
})

HitboxGroup:AddToggle("BigHitbox", {
    Text = "Big Hitbox Current Weapon",
    Default = false,
    Callback = function(Value)
        getgenv().BigHitbox = Value
        updateWeaponModifications()
    end,
})

RunService.Heartbeat:Connect(function()
    updateWeaponModifications()
end)

-- LOCAL PLAYER TAB
local MovementGroup = Tabs.LocalPlayer:AddLeftGroupbox("Movement")
local PlayerGroup = Tabs.LocalPlayer:AddRightGroupbox("Player Controls")

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

-- MISC TAB
local VisualGroup = Tabs.Misc:AddLeftGroupbox("Visual Effects")
local WorldGroup = Tabs.Misc:AddRightGroupbox("World Modifications")

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

WorldGroup:AddButton("Remove Fog", function()
    game:GetService("Lighting").FogEnd = 1000000
    game:GetService("Lighting").FogStart = 1000000
    Library:Notify({
        Title = "Fog Removed",
        Content = "All fog has been cleared from the game",
        Time = 5
    })
end)

-- INSTANT PROXIMITY PROMPTS (HIGH PERFORMANCE)
local InstantPromptsToggle = WorldGroup:AddToggle("InstantPrompts", {
    Text = "Instant Proximity Prompts",
    Default = false,
    Callback = function(Value)
        getgenv().InstantPrompts = Value
        if Value then
            -- Function to set all prompts to instant
            local function setInstantPrompts()
                for _, prompt in pairs(workspace:GetDescendants()) do
                    if prompt:IsA("ProximityPrompt") then
                        prompt.HoldDuration = 0
                    end
                end
            end
            
            -- Set initially
            setInstantPrompts()
            
            -- Monitor for new prompts
            getgenv().promptConnection = workspace.DescendantAdded:Connect(function(descendant)
                if descendant:IsA("ProximityPrompt") then
                    descendant.HoldDuration = 0
                end
            end)
            
            -- Continuous refresh every 2 seconds (optimized)
            getgenv().promptLoop = RunService.Heartbeat:Connect(function()
                if getgenv().InstantPrompts then
                    for _, prompt in pairs(workspace:GetDescendants()) do
                        if prompt:IsA("ProximityPrompt") then
                            prompt.HoldDuration = 0
                        end
                    end
                else
                    getgenv().promptLoop:Disconnect()
                end
            end)
        else
            -- Clean up connections
            if getgenv().promptConnection then
                getgenv().promptConnection:Disconnect()
            end
            if getgenv().promptLoop then
                getgenv().promptLoop:Disconnect()
            end
        end
    end,
})

-- ESP TAB
local ESPGroup = Tabs.ESP:AddLeftGroupbox("Player ESP")
local ScrapGroup = Tabs.ESP:AddRightGroupbox("Scrap ESP")

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
                    highlight.OutlineColor = Color3.new(1, 1, 1)
                    highlight.FillTransparency = 0.3
                    highlight.Parent = model
                    
                    local billboard = Instance.new("BillboardGui")
                    billboard.Adornee = model:FindFirstChild("Head") or model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
                    billboard.Size = UDim2.new(0, 200, 0, 50)
                    billboard.StudsOffset = Vector3.new(0, 3, 0)
                    billboard.AlwaysOnTop = true
                    billboard.Parent = model
                    
                    local label = Instance.new("TextLabel")
                    label.Size = UDim2.new(1, 0, 1, 0)
                    label.BackgroundTransparency = 1
                    label.Text = "MrRake"
                    label.TextColor3 = Color3.new(1, 0, 0)
                    label.TextSize = 14
                    label.Font = Enum.Font.GothamBold
                    label.Parent = billboard
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
                if obj:IsA("Highlight") and obj.Adornee and obj.Adornee.Name == "MrRake" then
                    obj:Destroy()
                end
                if obj:IsA("BillboardGui") and obj.Parent and obj.Parent.Name == "MrRake" then
                    obj:Destroy()
                end
            end
        end
    end,
})

ScrapGroup:AddToggle("ScrapESP", {
    Text = "Scrap ESP",
    Default = false,
    Callback = function(Value)
        getgenv().ScrapESP = Value
        if Value then
            local function highlightScrap(obj)
                if (obj:IsA("MeshPart") or obj:IsA("Part")) and obj.Name:lower():find("scrap") then
                    if not obj:FindFirstChildOfClass("Highlight") then
                        local highlight = Instance.new("Highlight")
                        highlight.Adornee = obj
                        highlight.FillColor = Color3.new(0, 1, 0)
                        highlight.OutlineColor = Color3.new(1, 1, 1)
                        highlight.FillTransparency = 0.2
                        highlight.Parent = obj
                        
                        local billboard = Instance.new("BillboardGui")
                        billboard.Adornee = obj
                        billboard.Size = UDim2.new(0, 150, 0, 40)
                        billboard.StudsOffset = Vector3.new(0, 2, 0)
                        billboard.AlwaysOnTop = true
                        billboard.Parent = obj
                        
                        local label = Instance.new("TextLabel")
                        label.Size = UDim2.new(1, 0, 1, 0)
                        label.BackgroundTransparency = 1
                        label.Text = "Scrap"
                        label.TextColor3 = Color3.new(0, 1, 0)
                        label.TextSize = 12
                        label.Font = Enum.Font.GothamBold
                        label.Parent = billboard
                    end
                end
            end
            
            for _, obj in pairs(workspace:GetDescendants()) do
                highlightScrap(obj)
            end
            
            getgenv().scrapConn = workspace.DescendantAdded:Connect(highlightScrap)
        else
            if getgenv().scrapConn then
                getgenv().scrapConn:Disconnect()
            end
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Highlight") then
                    obj:Destroy()
                end
                if obj:IsA("BillboardGui") and obj.Parent then
                    obj:Destroy()
                end
            end
        end
    end,
})

-- UI SETTINGS
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

Library.ToggleKeybind = Options.MenuKeybind

Library:Notify({
    Title = "Rake ZRK ULTIMATE Loaded!",
    Content = "Full Bundle Activated - Press RightShift",
    Time = 5
})

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })

SaveManager:SetFolder("RakeZRKConfig")
ThemeManager:SetFolder("RakeZRKConfig")

SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])

SaveManager:LoadAutoloadConfig()

print("Rake ZRK ULTIMATE BUNDLE Loaded - All Features Active")                    weapon.Hitbox.Size = originalHitboxSizes[weapon.Name]
                end
            end
        end
    end
end

WeaponConfigGroup:AddToggle("NoCooldown", {
    Text = "No Cooldown Current Weapon",
    Default = false,
    Callback = function(Value)
        getgenv().NoCooldown = Value
        updateWeaponModifications()
    end,
})

HitboxGroup:AddToggle("BigHitbox", {
    Text = "Big Hitbox Current Weapon",
    Default = false,
    Callback = function(Value)
        getgenv().BigHitbox = Value
        updateWeaponModifications()
    end,
})

RunService.Heartbeat:Connect(function()
    updateWeaponModifications()
end)

local MovementGroup = Tabs.LocalPlayer:AddLeftGroupbox("Movement")
local PlayerGroup = Tabs.LocalPlayer:AddRightGroupbox("Player Controls")

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

MovementGroup:AddToggle("NoFallDamage", {
    Text = "No Fall Damage",
    Default = false,
    Callback = function(Value)
        getgenv().NoFallDamage = Value
        
        local function handleFallDamage()
            if LocalPlayer.Character then
                local fallDamage = LocalPlayer.Character:FindFirstChild("FallDamage")
                
                if getgenv().NoFallDamage then
                    if fallDamage and not getgenv().StoredFallDamage then
                        getgenv().StoredFallDamage = fallDamage:Clone()
                        fallDamage:Destroy()
                    end
                else
                    if getgenv().StoredFallDamage and not fallDamage then
                        getgenv().StoredFallDamage.Parent = LocalPlayer.Character
                        getgenv().StoredFallDamage = nil
                    end
                end
            end
        end
        
        handleFallDamage()
        
        if Value then
            getgenv().fallDamageConnection = LocalPlayer.CharacterAdded:Connect(function()
                task.wait(1)
                handleFallDamage()
            end)
        else
            if getgenv().fallDamageConnection then
                getgenv().fallDamageConnection:Disconnect()
            end
        end
    end,
})

local VisualGroup = Tabs.Misc:AddLeftGroupbox("Visual Effects")
local WorldGroup = Tabs.Misc:AddRightGroupbox("World Modifications")

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

WorldGroup:AddButton("Remove Fog", function()
    game:GetService("Lighting").FogEnd = 1000000
    game:GetService("Lighting").FogStart = 1000000
    Library:Notify({
        Title = "Fog Removed",
        Content = "All fog has been cleared from the game",
        Time = 5
    })
end)

local ESPGroup = Tabs.ESP:AddLeftGroupbox("Player ESP")

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

Library:Notify({
    Title = "Rake ZRK script Loaded!",
    Content = "Press RightShift to show/hide menu",
    Time = 5
})

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })

SaveManager:SetFolder("RakeZRKConfig")
ThemeManager:SetFolder("RakeZRKConfig")

SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])

SaveManager:LoadAutoloadConfig()
