--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║              VTriP AI Generated Script                     ║
    ╠═══════════════════════════════════════════════════════════╣
    ║  Script ID: c1afc43d
    ║  Author: minhtri.csx
    ║  Created: 2026-01-11T10:52:09.344Z
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

Visuals_Tab:ColorPicker({
    Name = "Text Color",
    Color = Settings.TextColor,
    Flag = "TextColor",
    Callback = function(Color)
        Settings.TextColor = Color
    end
})

Visuals_Tab:ColorPicker({
    Name = "Tracer Color",
    Color = Settings.TracerColor,
    Flag = "TracerColor",
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
    Flag = "BoxThickness",
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
    Flag = "BoxTransparency",
    Callback = function(Value)
        Settings.BoxTransparency = Value
    end
})

Visuals_Tab:CreateSlider({
    Name = "Text Size",
    Min = 8,
    Max = 24,
    Default = 14,
    Flag = "TextSize",
    Callback = function(Value)
        Settings.TextSize = Value
    end
})

Players_Tab:CreateToggle({
    Name = "Show Team Members",
    CurrentValue = false,
    Flag = "ShowTeam",
    Callback = function(Value)
        Settings.ShowTeam = Value
    end
})

-- ESP Functions
local function CreateESP(Player)
    if not ESP_Enabled then return end
    
    local Character = Player.Character
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then return end
    
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    if not Humanoid then return end
    
    -- Check team settings
    if Settings.TeamCheck and LocalPlayer.Team and Player.Team and LocalPlayer.Team == Player.Team and not Settings.ShowTeam then
        return
    end
    
    -- Check distance
    local Distance = (Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    if Distance > Settings.MaxDistance then return end
    
    -- Create ESP objects
    local ESP_Table = {}
    
    -- Box ESP
    if Settings.BoxESP then
        local Box = Drawing.new("Square")
        Box.Thickness = Settings.BoxThickness
        Box.Transparency = Settings.BoxTransparency
        Box.Color = Settings.BoxColor
        Box.Filled = false
        ESP_Table.Box = Box
    end
    
    -- Name ESP
    if Settings.NameESP then
        local Name = Drawing.new("Text")
        Name.Text = Player.Name
        Name.Color = Settings.TextColor
        Name.Size = Settings.TextSize
        Name.Center = true
        Name.Outline = true
        Name.Font = Drawing.Fonts.Monospace
        ESP_Table.Name = Name
    end
    
    -- Health Bar
    if Settings.HealthBar then
        local HealthBar = Drawing.new("Square")
        HealthBar.Thickness = 2
        HealthBar.Filled = true
        HealthBar.Color = Color3.fromRGB(0, 255, 0)
        ESP_Table.HealthBar = HealthBar
    end
    
    -- Distance ESP
    if Settings.DistanceESP then
        local Distance = Drawing.new("Text")
        Distance.Text = tostring(math.floor(Distance)) .. " studs"
        Distance.Color = Settings.TextColor
        Distance.Size = Settings.TextSize
        Distance.Center = false
        Distance.Outline = true
        Distance.Font = Drawing.Fonts.Monospace
        ESP_Table.Distance = Distance
    end
    
    -- Tracer ESP
    if Settings.TracerESP then
        local Tracer = Drawing.new("Line")
        Tracer.Thickness = 1
        Tracer.Color = Settings.TracerColor
        Tracer.Transparency = 0.5
        ESP_Table.Tracer = Tracer
    end
    
    Esp_Objects[Player] = ESP_Table
end

local function UpdateESP()
    if not ESP_Enabled then return end
    
    for Player, ESP_Table in pairs(Esp_Objects) do
        local Character = Player.Character
        if not Character or not Character:FindFirstChild("HumanoidRootPart") then
            ClearESP(Player)
            return
        end
        
        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        if not Humanoid then
            ClearESP(Player)
            return
        end
        
        -- Check team settings
        if Settings.TeamCheck and LocalPlayer.Team and Player.Team and LocalPlayer.Team == Player.Team and not Settings.ShowTeam then
            ClearESP(Player)
            return
        end
        
        -- Check distance
        local Distance = (Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
        if Distance > Settings.MaxDistance then
            ClearESP(Player)
            return
        end
        
        -- Get screen position
        local HeadPos, HeadVisible = Camera:WorldToViewportPoint(Character.HumanoidRootPart.Position)
        local RootPos, RootVisible = Camera:WorldToViewportPoint(Character.HumanoidRootPart.Position)
        
        -- Update Box
        if ESP_Table.Box then
            ESP_Table.Box.Visible = HeadVisible
            ESP_Table.Box.Size = Vector2.new(2000 / HeadPos.Z, Humanoid.Health / Humanoid.MaxHealth * 50)
            ESP_Table.Box.Position = Vector2.new(HeadPos.X - ESP_Table.Box.Size.X / 2, HeadPos.Y - ESP_Table.Box.Size.Y / 2)
            
            if Settings.TeamColor and Player.Team then
                ESP_Table.Box.Color = Player.Team.TeamColor.Color
            end
        end
        
        -- Update Name
        if ESP_Table.Name then
            ESP_Table.Name.Visible = HeadVisible
            ESP_Table.Name.Position = Vector2.new(HeadPos.X, HeadPos.Y - 20)
        end
        
        -- Update Health Bar
        if ESP_Table.HealthBar then
            ESP_Table.HealthBar.Visible = HeadVisible
            ESP_Table.HealthBar.Size = Vector2.new(4, Humanoid.Health / Humanoid.MaxHealth * 50)
            ESP_Table.HealthBar.Position = Vector2.new(HeadPos.X + 100, HeadPos.Y - ESP_Table.HealthBar.Size.Y / 2)
            ESP_Table.HealthBar.Color = Humanoid.Health > 50 and Color3.fromRGB(0, 255, 0) or Humanoid.Health > 20 and Color3.fromRGB(255, 255, 0) or Color3.fromRGB(255, 0, 0)
        end
        
        -- Update Distance
        if ESP_Table.Distance then
            ESP_Table.Distance.Visible = HeadVisible
            ESP_Table.Distance.Position = Vector2.new(HeadPos.X + 110, HeadPos.Y + 20)
        end
        
        -- Update Tracer
        if ESP_Table.Tracer then
            ESP_Table.Tracer.Visible = HeadVisible
            ESP_Table.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
            ESP_Table.Tracer.To = Vector2.new(HeadPos.X, HeadPos.Y)
        end
    end
end

local function ClearESP(Player)
    if Player then
        if Esp_Objects[Player] then
            for _, DrawingObject in pairs(Esp_Objects[Player]) do
                DrawingObject:Remove()
            end
            Esp_Objects[Player] = nil
        end
    else
        for Player, ESP_Table in pairs(Esp_Objects) do
            for _, DrawingObject in pairs(ESP_Table) do
                DrawingObject:Remove()
            end
        end
        Esp_Objects = {}
    end
end

-- Player Events
Players.PlayerAdded:Connect(function(Player)
    Player.CharacterAdded:Connect(function()
        wait(0.1)
        CreateESP(Player)
    end)
end)

Players.PlayerRemoving:Connect(function(Player)
    ClearESP(Player)
end)

-- Initialize ESP for existing players
for _, Player in ipairs(Players:GetPlayers()) do
    if Player ~= LocalPlayer then
        Player.CharacterAdded:Connect(function()
            wait(0.1)
            CreateESP(Player)
        end)
        
        if Player.Character then
            CreateESP(Player)
        end
    end
end

-- Main update loop
spawn(function()
    while wait(Settings.RefreshRate) do
        UpdateESP()
    end
end)

print("✅ VTriP ESP đã tải thành công!")
print("🎯 Sử dụng UI Rayfield để tùy chỉnh cài đặt ESP")