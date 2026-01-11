--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║              VTriP AI Generated Script                     ║
    ╠═══════════════════════════════════════════════════════════╣
    ║  Script ID: 87e75dde
    ║  Created by: minhtri.csx (800626738853052433)
    ║  Timestamp: 2026-01-11T09:58:55.541Z
    ║  
    ║  Loadstring:
    ║  loadstring(game:HttpGet("https://raw.githubusercontent.com/vtrip-ai/Scripts/main/scripts/auto_1768125535541_87e75dde.lua"))()
    ╚═══════════════════════════════════════════════════════════╝
--]]

-- Mobile Custom UI Menu by VTriP AI
-- Tối ưu hóa cho thiết bị di động với điều khiển cảm ứng

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

-- Cài đặt menu
local settings = {
    themeColor = Color3.fromRGB(0, 150, 255),
    backgroundColor = Color3.fromRGB(20, 20, 20),
    textColor = Color3.fromRGB(255, 255, 255),
    buttonSize = UDim2.new(0, 120, 0, 40),
    menuPosition = UDim2.new(0, 20, 0, 20),
    closed = false,
    autoClose = true
}

local mobileMenu = Instance.new("ScreenGui")
mobileMenu.Name = "MobileMenu"
mobileMenu.ResetOnSpawn = false
mobileMenu.IgnoreGuiInset = true
mobileMenu.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
mobileMenu.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Frame chính
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 200, 0, 300)
mainFrame.Position = settings.menuPosition
mainFrame.BackgroundColor3 = settings.backgroundColor
mainFrame.BorderSizePixel = 0
mainFrame.Parent = mobileMenu

-- Gradient hiệu ứng
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 40)),
    ColorSequenceKeypoint.new(1, settings.backgroundColor)
}
gradient.Transparency = NumberSequence.new{
    NumberSequenceKeypoint.new(0, 0.2),
    NumberSequenceKeypoint.new(1, 0)
}
gradient.Rotation = 90
gradient.Parent = mainFrame

-- Title
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Mobile Menu"
title.TextColor3 = settings.themeColor
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

-- Drag handle
local dragHandle = Instance.new("TextButton")
dragHandle.Name = "DragHandle"
dragHandle.Size = UDim2.new(1, 0, 0, 30)
dragHandle.Position = UDim2.new(0, 0, 0, 0)
dragHandle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
dragHandle.Text = "⋮⋮"
dragHandle.TextColor3 = settings.themeColor
dragHandle.TextScaled = true
dragHandle.Font = Enum.Font.GothamBold
dragHandle.Parent = mainFrame

-- Nội dung menu
local contentFrame = Instance.new("Frame")
contentFrame.Name = "Content"
contentFrame.Size = UDim2.new(1, 0, 1, -30)
contentFrame.Position = UDim2.new(0, 0, 0, 30)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Function tạo button
local function createButton(text, callback, yPosition, icon)
    local button = Instance.new("TextButton")
    button.Name = "Button"
    button.Size = settings.buttonSize
    button.Position = UDim2.new(0, 10, 0, yPosition)
    button.BackgroundColor3 = settings.backgroundColor
    button.BorderSizePixel = 0
    button.Text = icon and (icon .. " " .. text) or text
    button.TextColor3 = settings.textColor
    button.TextScaled = true
    button.Font = Enum.Font.Gotham
    button.Parent = contentFrame

    -- Shadow effect
    local shadow = Instance.new("Frame")
    shadow.Name = "Shadow"
    shadow.Size = UDim2.new(1, 4, 1, 4)
    shadow.Position = UDim2.new(0, 2, 0, 2)
    shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    shadow.BackgroundTransparency = 0.5
    shadow.BorderSizePixel = 0
    shadow.ZIndex = -1
    shadow.Parent = button

    -- Hover effect
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = settings.themeColor,
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
    end)

    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {
            BackgroundColor3 = settings.backgroundColor,
            TextColor3 = settings.textColor
        }):Play()
    end)

    button.MouseButton1Click:Connect(function()
        callback()
        if settings.autoClose then
            toggleMenu()
        end
    end)

    return button
end

-- Toggle menu
local function toggleMenu()
    settings.closed = not settings.closed
    if settings.closed then
        mainFrame:TweenSize(UDim2.new(0, 60, 0, 30), "Out", "Quad", 0.3)
        contentFrame.Visible = false
    else
        mainFrame:TweenSize(UDim2.new(0, 200, 0, 300), "Out", "Quad", 0.3)
        contentFrame.Visible = true
    end
end

-- Drag functionality
local dragging
local dragInput
local dragStart
local dragStartPos

dragHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        dragStartPos = mainFrame.Position
    end
end)

dragHandle.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragInput = input
    end
end)

dragHandle.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and dragInput then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            dragStartPos.X.Scale + (delta.X / game.Workspace.CurrentCamera.ViewportSize.X),
            dragStartPos.X.Offset,
            dragStartPos.Y.Scale + (delta.Y / game.Workspace.CurrentCamera.ViewportSize.Y),
            dragStartPos.Y.Offset
        )
    end
end)

-- Tạo các nút chức năng
createButton("TP Tools", function()
    local tpFrame = Instance.new("Frame")
    tpFrame.Size = UDim2.new(0, 300, 0, 200)
    tpFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
    tpFrame.BackgroundColor3 = settings.backgroundColor
    tpFrame.BorderSizePixel = 0
    tpFrame.Parent = mobileMenu
    tpFrame:TweenSize(UDim2.new(0, 300, 0, 200), "Out", "Quad", 0.3)
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "TP Tools"
    title.TextColor3 = settings.themeColor
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = tpFrame

    -- Các nút TP
    createButton("TP Player", function()
        local players = {}
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                table.insert(players, player.Name)
            end
        end
        
        local playerList = Instance.new("ScrollingFrame")
        playerList.Size = UDim2.new(1, -20, 1, -40)
        playerList.Position = UDim2.new(0, 10, 0, 30)
        playerList.BackgroundTransparency = 1
        playerList.Parent = tpFrame
        
        for i, playerName in ipairs(players) do
            local btn = createButton(playerName, function()
                local target = Players:FindFirstChild(playerName)
                if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = target.Character.HumanoidRootPart.CFrame
                end
                tpFrame:Destroy()
            end, (i-1) * 45, "👤")
            btn.Parent = playerList
        end
    end, 40, "📍")

    createButton("TP Location", function()
        LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(0, 100, 0)
        tpFrame:Destroy()
    end, 85, "🎯")

    createButton("Close", function()
        tpFrame:Destroy()
    end, 130, "❌")
end, 40, "📱")

createButton("ESP", function()
    local espEnabled = false
    
    local function toggleESP()
        espEnabled = not espEnabled
        
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character and player ~= LocalPlayer then
                local character = player.Character
                local head = character:FindFirstChild("Head")
                local torso = character:FindFirstChild("HumanoidRootPart")
                
                if espEnabled and head and torso then
                    -- Box ESP
                    local box = Instance.new("BoxHandleAdaptive")
                    box.AdaptiveTransparency = true
                    box.Color = BrickColor.new("Bright red")
                    box.Transparency = 0.5
                    box.Size = Vector3.new(2, 2, 1)
                    box.Parent = torso
                    box.Name = "ESPBox"
                    
                    -- Name ESP
                    local nameLabel = Instance.new("BillboardGui")
                    nameLabel.Name = "ESPName"
                    nameLabel.Size = UDim2.new(0, 100, 0, 20)
                    nameLabel.AlwaysOnTop = true
                    nameLabel.Parent = head
                    
                    local nameLabel2 = Instance.new("TextLabel")
                    nameLabel2.Size = UDim2.new(1, 0, 1, 0)
                    nameLabel2.BackgroundTransparency = 1
                    nameLabel2.Text = player.Name
                    nameLabel2.TextColor3 = Color3.new(1, 0, 0)
                    nameLabel2.TextScaled = true
                    nameLabel2.Font = Enum.Font.GothamBold
                    nameLabel2.Parent = nameLabel
                elseif not espEnabled then
                    local espBox = torso:FindFirstChild("ESPBox")
                    local espName = head:FindFirstChild("ESPName")
                    if espBox then espBox:Destroy() end
                    if espName then espName:Destroy() end
                end
            end
        end
    end
    
    toggleESP()
end, 85, "👁️")

createButton("Speed", function()
    local speed = 50
    LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = speed
end, 130, "⚡")

createButton("Fly", function()
    local flyEnabled = false
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.P = 5000
    bodyVelocity.Name = "FlyVelocity"
    
    local function toggleFly()
        flyEnabled = not flyEnabled
        
        if flyEnabled then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.PlatformStand = true
                local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    bodyVelocity.Parent = rootPart
                end
            end
        else
            local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                bodyVelocity:Destroy()
            end
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.PlatformStand = false
            end
        end
    end
    
    toggleFly()
end, 175, "🕊️")

-- Auto close khi không dùng
if settings.autoClose then
    local idleTimer
    UserInputService.TouchStarted:Connect(function()
        if idleTimer then
            idleTimer:Disconnect()
            idleTimer = nil
        end
        
        idleTimer = spawn(function()
            wait(10)
            if not settings.closed then
                toggleMenu()
            end
        end)
    end)
end

-- Toggle bằng cách nhấn đúp vào màn hình
UserInputService.TouchTapInCountChanged:Connect(function(count, input)
    if count == 2 then
        toggleMenu()
    end
end)

-- Anti-detection
mobileMenu.IgnoreGuiInset = true
mobileMenu.ResetOnSpawn = false
spawn(function()
    while wait(1) do
        if mobileMenu.Parent ~= LocalPlayer.PlayerGui then
            mobileMenu.Parent = LocalPlayer.PlayerGui
        end
    end
end)

-- Thông báo khởi động
local notification = Instance.new("TextLabel")
notification.Size = UDim2.new(0, 250, 0, 50)
notification.Position = UDim2.new(0.5, -125, 0, 20)
notification.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
notification.Text = "Mobile Menu Loaded!"
notification.TextColor3 = Color3.new(1, 1, 1)
notification.TextScaled = true
notification.Font = Enum.Font.GothamBold
notification.BorderSizePixel = 0
notification.Parent = mobileMenu

notification:TweenPosition(UDim2.new(0.5, -125, 0, -60), "Out", "Quad", 1, true)
wait(1)
notification:Destroy()