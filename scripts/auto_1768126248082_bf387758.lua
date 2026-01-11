--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║              VTriP AI Generated Script                     ║
    ╠═══════════════════════════════════════════════════════════╣
    ║  Script ID: bf387758
    ║  Created by: justkanto (808580002684862464)
    ║  Timestamp: 2026-01-11T10:10:48.082Z
    ║  
    ║  Loadstring:
    ║  loadstring(game:HttpGet("https://raw.githubusercontent.com/vtrip-ai/Scripts/main/scripts/auto_1768126248082_bf387758.lua"))()
    ╚═══════════════════════════════════════════════════════════╝
--]]

-- Aimbot Script for Prison Life
-- VTriP AI - Created by MinhTri

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local enabled = false
local nearestTarget = nil

-- Cấu hình
local config = {
    teamCheck = true,         -- Bật/tắt kiểm tra team
    wallCheck = true,         -- Bật/tắt kiểm tra tường
    aimTeam = "Guards",       -- Team cần aim (chỉ aim vào guard)
    aimPart = "HumanoidRootPart", -- Phần body để aim
    fov = 100,               -- Tầm nhìn (field of view)
    smoothness = 0.2,        -- Độ mượt của aim (0-1)
    keybind = Enum.UserInputType.MouseButton2, -- Chuột phải để aim
    enableKeybind = Enum.KeyCode.RightControl -- Phím để bật aimbot (Ctrl phải)
}

-- Hàm kiểm tra xem có tường chắn không (wall check)
local function isVisible(targetPart)
    if not config.wallCheck then return true end
    
    local origin = Camera.CFrame.Position
    local direction = (targetPart.Position - origin).Unit
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {player.Character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.IgnoreWater = true
    raycastParams.RespectCanCollide = true
    
    local raycastResult = Workspace:Raycast(origin, direction * 1000, raycastParams)
    if raycastResult then
        return raycastResult.Instance == targetPart
    end
    return false
end

-- Hàm kiểm tra team
local function isInTeam(character, teamName)
    if not config.teamCheck then return true end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end
    
    local teamValue = humanoid:FindFirstChild("Team")
    if not teamValue then return false end
    
    return teamValue.Value == teamName
end

-- Hàm tìm guard gần nhất
local function getNearestGuard()
    local nearestTarget = nil
    local nearestDistance = math.huge
    
    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer == player then continue end
        
        local otherCharacter = otherPlayer.Character
        if not otherCharacter then continue end
        
        local humanoid = otherCharacter:FindFirstChildOfClass("Humanoid")
        if not humanoid or humanoid.Health <= 0 then continue end
        
        -- Kiểm tra nếu là guard
        if isInTeam(otherCharacter, config.aimTeam) then
            local targetPart = otherCharacter:FindFirstChild(config.aimPart)
            if not targetPart then continue end
            
            -- Kiểm tra xem có trong tầm nhìn không
            local screenPoint, onScreen = Camera:WorldToScreenPoint(targetPart.Position)
            if not onScreen then continue end
            
            local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude
            if distance < config.fov then
                -- Wall check
                if isVisible(targetPart) then
                    local distanceToTarget = (Camera.CFrame.Position - targetPart.Position).Magnitude
                    if distanceToTarget < nearestDistance then
                        nearestDistance = distanceToTarget
                        nearestTarget = targetPart
                    end
                end
            end
        end
    end
    
    return nearestTarget
end

-- Hàm aim vào mục tiêu
local function aimAt(targetPart)
    if not targetPart then return end
    
    local targetPosition = targetPart.Position
    local currentCFrame = Camera.CFrame
    
    -- Tính toán góc camera mới
    local newCFrame = CFrame.new(currentCFrame.Position, targetPosition)
    
    -- Áp dụng độ mượt
    Camera.CFrame = currentCFrame:Lerp(newCFrame, config.smoothness)
end

-- Event loop
RunService.RenderStepped:Connect(function()
    if enabled then
        nearestTarget = getNearestGuard()
        if nearestTarget then
            aimAt(nearestTarget)
        end
    end
end)

-- Xử lý input
UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end
    
    -- Bật/tắt aimbot
    if input.KeyCode == config.enableKeybind then
        enabled = not enabled
        print("Aimbot " .. (enabled and "Bật" or "Tắt"))
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end
    
    -- Aim khi nhấn chuột phải
    if input.UserInputType == config.keybind then
        enabled = true
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end
    
    -- Tắt aim khi thả chuột phải
    if input.UserInputType == config.keybind then
        enabled = false
    end
end)

print("Aimbot đã tải xong!")
print("Nhấn " .. config.enableKeybind.Name .. " để bật/tắt aimbot")
print("Giữ chuột phải để aim")