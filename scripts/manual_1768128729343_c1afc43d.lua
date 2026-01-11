--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║              VTriP AI Generated Script                     ║
    ╠═══════════════════════════════════════════════════════════╣
    ║  Script ID: c1afc43d
    ║  Author: minhtri.csx
    ║  Created: 2026-01-11T10:52:09.917Z
    ║  Updated: 2026-01-11T10:57:08.744Z
    ║  Version: 2
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
    Flag = "MaxDistance",
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
    Flag = "RefreshRate",
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
    Flag = "BoxColor",
    Callback = function(Color)
        Settings.BoxColor = Color
    end
})

Visuals_Tab:CreateColorPicker({
    Name = "Text Color",
    Color = Settings.TextColor,
    Flag = "TextColor",
    Callback = function(Color)
        Settings.TextColor = Color
    end
})

Visuals_Tab:CreateColorPicker({
    Name = "Tracer Color",
    Color = Settings.TracerColor,
    Flag = "TracerColor",
    Callback = function(Color)
        Settings.TracerColor = Color
    end
})

-- ESP Drawing Functions
local function DrawESP(player)
    if not player or player == LocalPlayer or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    if not ESP_Enabled then
        return
    end
    
    local character = player.Character
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    local head = character:FindFirstChild("Head")
    
    if not rootPart or not head then return end
    
    local rootPosition, rootVisible = Camera:WorldToViewportPoint(rootPart.Position)
    local headPosition, headVisible = Camera:WorldToViewportPoint(head.Position)
    
    if not rootVisible or not headVisible then return end
    
    local distance = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and 
        (rootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude) or 0
    
    if distance > Settings.MaxDistance then return end
    
    -- Team check
    if Settings.TeamCheck and LocalPlayer.Team and player.Team and LocalPlayer.Team == player.Team then
        return
    end
    
    -- Create ESP elements
    local espData = {
        Box = nil,
        Name = nil,
        HealthBar = nil,
        Distance = nil,
        Tracer = nil,
        Player = player
    }
    
    -- Box ESP
    if Settings.BoxESP then
        espData.Box = Drawing.new("Square")
        espData.Box.Thickness = Settings.BoxThickness
        espData.Box.Transparency = Settings.BoxTransparency
        espData.Box.Color = Settings.TeamColor and player.Team and player.Team.TeamColor.Color or Settings.BoxColor
        espData.Box.Visible = true
        espData.Box.Filled = false
    end
    
    -- Name ESP
    if Settings.NameESP then
        espData.Name = Drawing.new("Text")
        espData.Name.Text = player.Name
        espData.Name.Size = Settings.TextSize
        espData.Name.Color = Settings.TextColor
        espData.Name.Center = true
        espData.Name.Visible = true
        espData.Name.Font = Drawing.Fonts.Plex
    end
    
    -- Health Bar
    if Settings.HealthBar and humanoid then
        espData.HealthBar = Drawing.new("Square")
        espData.HealthBar.Thickness = 0
        espData.HealthBar.Filled = true
        espData.HealthBar.Visible = true
        espData.HealthBar.Color = Color3.fromRGB(0, 255, 0)
    end
    
    -- Distance ESP
    if Settings.DistanceESP then
        espData.Distance = Drawing.new("Text")
        espData.Distance.Text = tostring(math.floor(distance)) .. "m"
        espData.Distance.Size = Settings.TextSize
        espData.Distance.Color = Settings.TextColor
        espData.Distance.Center = true
        espData.Distance.Visible = true
        espData.Distance.Font = Drawing.Fonts.Plex
    end
    
    -- Tracer ESP
    if Settings.TracerESP then
        espData.Tracer = Drawing.new("Line")
        espData.Tracer.Thickness = 1
        espData.Tracer.Transparency = 0.5
        espData.Tracer.Color = Settings.TracerColor
        espData.Tracer.Visible = true
    end
    
    table.insert(Esp_Objects, espData)
end

local function UpdateESP()
    if not ESP_Enabled then return end
    
    -- Clear old ESP
    ClearESP()
    
    -- Draw ESP for all players
    for _, player in ipairs(Players:GetPlayers()) do
        if player and player.Character then
            spawn(function()
                DrawESP(player)
            end)
        end
    end
end

local function ClearESP()
    for _, espData in ipairs(Esp_Objects) do
        if espData.Box then espData.Box:Remove() end
        if espData.Name then espData.Name:Remove() end
        if espData.HealthBar then espData.HealthBar:Remove() end
        if espData.Distance then espData.Distance:Remove() end
        if espData.Tracer then espData.Tracer:Remove() end
    end
    Esp_Objects = {}
end

local function UpdateESPElements()
    if not ESP_Enabled then return end
    
    local cameraPos = Camera.CFrame.Position
    
    for i, espData in ipairs(Esp_Objects) do
        if not espData or not espData.Player or not espData.Player.Character then
            table.remove(Esp_Objects, i)
            continue
        end
        
        local character = espData.Player.Character
        if not character then continue end
        
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        local head = character:FindFirstChild("Head")
        local humanoid = character:FindFirstChild("Humanoid")
        
        if not rootPart or not head or not humanoid then continue end
        
        local rootPosition, rootVisible = Camera:WorldToViewportPoint(rootPart.Position)
        local headPosition, headVisible = Camera:WorldToViewportPoint(head.Position)
        
        if not rootVisible or not headVisible then
            if espData.Box then espData.Box.Visible = false end
            if espData.Name then espData.Name.Visible = false end
            if espData.HealthBar then espData.HealthBar.Visible = false end
            if espData.Distance then espData.Distance.Visible = false end
            if espData.Tracer then espData.Tracer.Visible = false end
            continue
        end
        
        local distance = (rootPart.Position - cameraPos).Magnitude
        
        -- Update Box
        if Settings.BoxESP and espData.Box then
            local boxSize = Vector2.new(math.abs(headPosition.X - rootPosition.X) * 1.5, 
                                     headPosition.Y - rootPosition.Y + 15)
            espData.Box.Size = boxSize
            espData.Box.Position = Vector2.new(rootPosition.X - boxSize.X / 2, rootPosition.Y - boxSize.Y / 2)
            espData.Box.Visible = true
            espData.Box.Color = Settings.TeamColor and espData.Player.Team and espData.Player.Team.TeamColor.Color or Settings.BoxColor
        end
        
        -- Update Name
        if Settings.NameESP and espData.Name then
            espData.Name.Position = Vector2.new(rootPosition.X, headPosition.Y - 20)
            espData.Name.Text = espData.Player.Name
            espData.Name.Visible = true
        end
        
        -- Update Health Bar
        if Settings.HealthBar and espData.HealthBar and humanoid then
            local healthPercent = humanoid.Health / humanoid.MaxHealth
            local barSize = Vector2.new(3, headPosition.Y - rootPosition.Y - 5)
            espData.HealthBar.Size = Vector2.new(barSize.X, barSize.Y * healthPercent)
            espData.HealthBar.Position = Vector2.New(rootPosition.X + 10, rootPosition.Y)
            espData.HealthBar.Color = healthPercent > 0.5 and Color3.fromRGB(0, 255, 0) or 
                                     healthPercent > 0.25 and Color3.fromRGB(255, 255, 0) or 
                                     Color3.fromRGB(255, 0, 0)
            espData.HealthBar.Visible = true
        end
        
        -- Update Distance
        if Settings.DistanceESP and espData.Distance then
            espData.Distance.Position = Vector2.New(rootPosition.X, rootPosition.Y + 20)
            espData.Distance.Text = tostring(math.floor(distance)) .. "m"
            espData.Distance.Visible = true
        end
        
        -- Update Tracer
        if Settings.TracerESP and espData.Tracer then
            local bottomCenter = Vector2.New(rootPosition.X, rootPosition.Y + 50)
            espData.Tracer.From = bottomCenter
            espData.Tracer.To = Vector2.New(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
            espData.Tracer.Visible = true
        end
    end
end

-- Start ESP loop
spawn(function()
    while wait(Settings.RefreshRate) do
        if ESP_Enabled then
            UpdateESPElements()
        end
    end
end)

-- Player added/removed events
Players.PlayerAdded:Connect(function(player)
    if ESP_Enabled then
        spawn(function()
            wait(0.5) -- Wait for character to load
            DrawESP(player)
        end)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    for i, espData in ipairs(Esp_Objects) do
        if espData.Player == player then
            if espData.Box then espData.Box:Remove() end
            if espData.Name then espData.Name:Remove() end
            if espData.HealthBar then espData.HealthBar:Remove() end
            if espData.Distance then espData.Distance:Remove() end
            if espData.Tracer then espData.Tracer:Remove() end
            table.remove(Esp_Objects, i)
            break
        end
    end
end)

-- Character added event for existing players
for _, player in ipairs(Players:GetPlayers()) do
    player.CharacterAdded:Connect(function()
        if ESP_Enabled then
            spawn(function()
                wait(0.5) -- Wait for character to load
                DrawESP(player)
            end)
        end
    end)
end

print("VTriP ESP đã được tải xong!")