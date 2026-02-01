--[[
    FIXED SCRIPT: AUTO PICKUP LUCKY BLOCK
    Sửa lỗi: "Expected identifier when parsing expression"
--]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local Remote = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Network"):WaitForChild("RemoteEventStorage"):WaitForChild("PickupLuckyBlock")

-- Biến toàn cục để tránh chạy chồng chéo
_G.AutoPickupLoop = _G.AutoPickupLoop or false

-----------------------------------------------------------
-- GIAO DIỆN GUI (Mobile Friendly & Draggable)
-----------------------------------------------------------

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FixLuckyBlockGui"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 180, 0, 80)
MainFrame.Position = UDim2.new(0.5, -90, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.Parent = MainFrame

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0.9, 0, 0.6, 0)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.2, 0)
ToggleBtn.Text = "AUTO: OFF"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 14
ToggleBtn.Parent = MainFrame

Instance.new("UICorner").Parent = ToggleBtn

-- Logic kéo thả (Draggable Fix cho Mobile)
local dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragStart then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragStart = nil
    end
end)

-----------------------------------------------------------
-- LOGIC QUÉT VÀ FIRE REMOTE
-----------------------------------------------------------

local function startPickup()
    while _G.AutoPickupLoop do
        -- Sử dụng FindFirstChild để tránh lỗi nếu Folder chưa load
        local folder = workspace:FindFirstChild("LuckyBlocks")
        if folder then
            -- Quét qua tất cả các khu vực (Ví dụ: Beach, Desert...)
            for _, zone in pairs(folder:GetChildren()) do
                -- Quét các block bên trong khu vực đó
                for _, block in pairs(zone:GetChildren()) do
                    -- Kiểm tra nếu tên có chứa cụm "Exclusive Lucky Block"
                    if string.match(block.Name, "Exclusive Lucky Block") then
                        -- Gửi lệnh lên Server với tên block tìm được
                        Remote:FireServer(block.Name)
                    end
                end
            end
        end
        task.wait(0.3) -- Tốc độ quét (giây)
    end
end

ToggleBtn.MouseButton1Click:Connect(function()
    _G.AutoPickupLoop = not _G.AutoPickupLoop
    if _G.AutoPickupLoop then
        ToggleBtn.Text = "AUTO: ON"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        task.spawn(startPickup)
    else
        ToggleBtn.Text = "AUTO: OFF"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    end
end)
