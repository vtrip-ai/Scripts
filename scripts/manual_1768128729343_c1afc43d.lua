--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║              VTriP AI Generated Script                     ║
    ╠═══════════════════════════════════════════════════════════╣
    ║  Script ID: c1afc43d
    ║  Author: minhtri.csx
    ║  Created: 2026-01-11T10:52:09.917Z
    ║  Updated: 2026-01-11T11:35:06.708Z
    ║  Version: 3
    ╚═══════════════════════════════════════════════════════════╝
--]]

-- VTriP AI ESP Script with Rayfield UI
-- Creator: VTriP AI by MinhTri

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "VTriP ESP",
    LoadingTitle = "Loading VTriP ESP...",
    LoadingSubtitle = "by MinhTri",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "VTRIP_ESP",
        FileName = "ESP_Settings"
    },
    Discord = {
        Enabled = false,
        InviteCode = "noinvite",
        Hook = ""
    },
    KeySystem = false,
    KeySettings = {
        Title = "Secret Key",
        Subtitle = "Join the discord for the key",
        Note = "Your key here",
        FileName = "Key",
        SaveKey = true,
        GrabKeyFrom = nil,
        ExitOnFalseKey = true
    }
})

local ESP_Tab = Window:CreateTab("ESP Settings")
local Visuals_Tab = Window:CreateTab("Visuals")
local Players_Tab = Window:CreateTab("Players")

-- ESP Variables
local ESP_Enabled = false
local Esp_Objects = {}
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

-- Default settings
local Settings = {
    BoxESP = true,
    NameESP = true,
    HealthBar = true,
    DistanceESP = true,
    TracerESP = false,
    TeamCheck = true,
    TeamColor = true,
    BoxColor = Color3.fromRGB(255, 255, 255),
    BoxThickness = 1.5,
    BoxTransparency = 0.3,
    TextColor = Color3.fromRGB(255, 255, 255),
    TextSize = 14,
    TracerColor = Color3.fromRGB(255, 0, 0),
    ShowTeam = false,
    MaxDistance = 1000,
    RefreshRate = 0.1
}

-- Create UI Elements
ESP_Tab:CreateToggle({
    Name = "Enable ESP",
    CurrentValue = false,
    Flag = "ESP_Enabled",
    Callback = function(Value)
        ESP_Enabled = Value
        if not Value then
            ClearESP()
        end
    end
})

ESP_Tab:CreateSlider({
    Name = "Max Distance",
    Min = 100,
    Max = 2000,
    Default = 1000,
    Callback = function(Value)
        Settings.MaxDistance = Value
    end
})

ESP_Tab:CreateSlider({
    Name = "Refresh Rate (seconds)",
    Min = 0.05,
    Max = 1,
    Default = 0.1,
    Round = 2,
    Callback = function(Value)
        Settings.RefreshRate = Value
    end
})

ESP_Tab:CreateToggle({
    Name = "Team Check",
    CurrentValue = true,
    Flag = "TeamCheck",
    Callback = function(Value)
        Settings.TeamCheck = Value
    end
})

ESP_Tab:CreateToggle({
    Name = "Team Color",
    CurrentValue = true,
    Flag = "TeamColor",
    Callback = function(Value)
        Settings.TeamColor = Value
    end
})

Visuals_Tab:CreateToggle({
    Name = "Box ESP",
    CurrentValue = true,
    Flag = "BoxESP",
    Callback = function(Value)
        Settings.BoxESP = Value
    end
})

Visuals_Tab:CreateToggle({
    Name = "Name ESP",
    CurrentValue = true,
    Flag = "NameESP",
    Callback = function(Value)
        Settings.NameESP = Value
    end
})

Visuals_Tab:CreateToggle({
    Name = "Health Bar",
    CurrentValue = true,
    Flag = "HealthBar",
    Callback = function(Value)
        Settings.HealthBar = Value
    end
})

Visuals_Tab:CreateToggle({
    Name = "Distance ESP",
    CurrentValue = true,
    Flag = "DistanceESP",
    Callback = function(Value)
        Settings.DistanceESP = Value
    end
})

Visuals_Tab:CreateToggle({
    Name = "Tracer ESP",
    CurrentValue = false,
    Flag = "TracerESP",
    Callback = function(Value)
        Settings.TracerESP = Value
    end
})

Visuals_Tab:CreateColorPicker({
    Name = "Box Color",
    Color = Settings.BoxColor,
    Callback = function(Color)
        Settings.BoxColor = Color
    end
})

Visuals_Tab:CreateColorPicker({
    Name = "Text Color",
    Color = Settings.TextColor,
    Callback = function(Color)
        Settings.TextColor = Color
    end
})

Visuals_Tab:CreateColorPicker({
    Name = "Tracer Color",
    Color = Settings.TracerColor,
    Callback = function(Color)
        Settings.TracerColor = Color
    end
})

Visuals_Tab:CreateSlider({
    Name = "Box Thickness",
    Min = 1,
    Max = 5,
    Default = 1.5,
    Round = 1,
    Callback = function(Value)
        Settings.BoxThickness = Value
    end
})

Visuals_Tab:CreateSlider({
    Name = "Box Transparency",
    Min = 0,
    Max = 1,
    Default = 0.3,
    Round = 2,
    Callback = function(Value)
        Settings.BoxTransparency = Value
    end
})

Visuals_Tab:CreateSlider({
    Name = "Text Size",
    Min = 8,
    Max = 24,
    Default = 14,
    Round = 0,
    Callback = function(Value)
        Settings.TextSize = Value
    end
})

-- ESP Functions
local function ClearESP()
    for _, v in pairs(Esp_Objects) do
        if v then
            if v.Box then
                v.Box:Destroy()
            end
            if v.Name then
                v.Name:Destroy()
            end
            if v.Health then
                v.Health:Destroy()
            end
            if v.Distance then
                v.Distance:Destroy()
            end
            if v.Tracer then
                v.Tracer:Destroy()
            end
        end
    end
    Esp_Objects = {}
end

local function GetTeamColor(player)
    if not Settings.TeamColor then
        return Settings.BoxColor
    end
    local team = player.Team
    if team and team.TeamColor then
        return team.TeamColor.Color
    end
    return Settings.BoxColor
end

local function CreateESP(player)
    if player == LocalPlayer or not player.Character then return end
    
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local esp_table = {}
    
    -- Box ESP
    if Settings.BoxESP then
        local box = Drawing.new("Square")
        box.Thickness = Settings.BoxThickness
        box.Transparency = Settings.BoxTransparency
        box.Color = GetTeamColor(player)
        box.Filled = false
        esp_table.Box = box
    end
    
    -- Name ESP
    if Settings.NameESP then
        local name = Drawing.new("Text")
        name.Text = player.Name
        name.Color = Settings.TextColor
        name.Size = Settings.TextSize
        name.Center = true
        name.Outline = true
        esp_table.Name = name
    end
    
    -- Health Bar
    if Settings.HealthBar then
        local health = Drawing.new("Square")
        health.Thickness = 1
        health.Color = Color3.new(0, 1, 0)
        health.Filled = true
        esp_table.Health = health
    end
    
    -- Distance ESP
    if Settings.DistanceESP then
        local distance = Drawing.new("Text")
        distance.Text = "0m"
        distance.Color = Settings.TextColor
        distance.Size = Settings.TextSize
        distance.Center = true
        distance.Outline = true
        esp_table.Distance = distance
    end
    
    -- Tracer ESP
    if Settings.TracerESP then
        local tracer = Drawing.new("Line")
        tracer.Thickness = 1
        tracer.Color = Settings.TracerColor
        tracer.Transparency = 1
        esp_table.Tracer = tracer
    end
    
    Esp_Objects[player] = esp_table
end

local function UpdateESP()
    ClearESP()
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if Settings.TeamCheck and player.Team == LocalPlayer.Team then
                continue
            end
            
            local distance = (player.Character and player.Character:FindFirstChild("HumanoidRootPart") and 
                             (player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude) or 0
            
            if distance <= Settings.MaxDistance then
                CreateESP(player)
            end
        end
    end
end

local function UpdateDrawings()
    for player, esp_table in pairs(Esp_Objects) do
        if not player or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            Esp_Objects[player] = nil
            continue
        end
        
        local rootPart = player.Character.HumanoidRootPart
        local vector, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
        
        if not onScreen then
            if esp_table.Box then esp_table.Box.Visible = false end
            if esp_table.Name then esp_table.Name.Visible = false end
            if esp_table.Health then esp_table.Health.Visible = false end
            if esp_table.Distance then esp_table.Distance.Visible = false end
            if esp_table.Tracer then esp_table.Tracer.Visible = false end
            continue
        end
        
        local scale = 100 / (vector.Z * 100)
        local size = Vector2.new(5 * scale, 7 * scale)
        local top = Vector2.new(vector.X - size.X / 2, vector.Y - size.Y / 2)
        local bottom = Vector2.new(vector.X + size.X / 2, vector.Y + size.Y / 2)
        
        -- Update Box
        if esp_table.Box then
            esp_table.Box.Size = Vector2.new(bottom.X - top.X, bottom.Y - top.Y)
            esp_table.Box.Position = top
            esp_table.Box.Visible = true
        end
        
        -- Update Name
        if esp_table.Name then
            esp_table.Name.Position = Vector2.new(vector.X, top.Y - 15)
            esp_table.Name.Visible = true
        end
        
        -- Update Health Bar
        if esp_table.Health then
            local health = player.Character:FindFirstChild("Humanoid")
            if health then
                local healthPercentage = health.Health / health.MaxHealth
                local healthWidth = size.X * healthPercentage
                local healthPos = Vector2.new(top.X + (size.X - healthWidth) / 2, top.Y - 5)
                local healthSize = Vector2.new(healthWidth, 3)
                
                esp_table.Health.Position = healthPos
                esp_table.Health.Size = healthSize
                esp_table.Health.Color = Color3.new(1 - healthPercentage, healthPercentage, 0)
                esp_table.Health.Visible = true
            end
        end
        
        -- Update Distance
        if esp_table.Distance then
            local distance = (rootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            esp_table.Distance.Text = math.floor(distance / 3.281) .. "m"
            esp_table.Distance.Position = Vector2.new(vector.X, bottom.Y + 15)
            esp_table.Distance.Visible = true
        end
        
        -- Update Tracer
        if esp_table.Tracer then
            local screenCenter = Camera.ViewportSize / 2
            esp_table.Tracer.From = screenCenter
            esp_table.Tracer.To = Vector2.new(vector.X, vector.Y)
            esp_table.Tracer.Visible = true
        end
    end
end

-- Main ESP Loop
spawn(function()
    while wait(Settings.RefreshRate) do
        if ESP_Enabled then
            UpdateESP()
            UpdateDrawings()
        end
    end
end)

-- Player added/removed events
Players.PlayerAdded:Connect(function(player)
    if ESP_Enabled then
        CreateESP(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if Esp_Objects[player] then
        ClearESP()
    end
end)

-- Initialize ESP for existing players
for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        CreateESP(player)
    end
end