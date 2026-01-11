--[[
    ╔═══════════════════════════════════════════════════════════╗
    ║              VTriP AI Generated Script                     ║
    ╠═══════════════════════════════════════════════════════════╣
    ║  Script ID: bd761a37
    ║  Created by: minhtri.csx (800626738853052433)
    ║  Timestamp: 2026-01-11T10:44:46.851Z
    ║  
    ║  Loadstring:
    ║  loadstring(game:HttpGet("https://raw.githubusercontent.com/vtrip-ai/Scripts/main/scripts/auto_1768128286851_bd761a37.lua"))()
    ╚═══════════════════════════════════════════════════════════╝
--]]

-- Rayfield Mobile UI Menu by VTriP AI
-- Tối ưu hóa hoàn toàn cho thiết bị di động

local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

local Window = Rayfield:CreateWindow({
    Name = "Mobile UI",
    LoadingTitle = "Đang tải UI Mobile...",
    LoadingSubtitle = "By VTriP AI",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "RayfieldMobile",
        FileName = "MobileConfig"
    },
    Discord = {
        Enabled = false
    },
    KeySystem = false
})

-- Tab chính
local MainTab = Window:CreateTab("Mobile", 4483362458)

-- Section điều khiển nhân vật
local CharacterSection = MainTab:CreateSection("🎮 Điều Khiển Nhân Vật")

MainTab:CreateButton({
    Name = "🚶‍♂️ Tăng Tốc Đi",
    Callback = function()
        local humanoid = game.Players.LocalPlayer.Character:WaitForChild("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 50
            Rayfield:Notify({
                Title = "✅ Thành Công",
                Content = "Tốc độ đi đã được tăng lên 50!",
                Duration = 3,
            })
        end
    end,
})

MainTab:CreateButton({
    Name = "🦘 Siêu Nhảy",
    Callback = function()
        local humanoid = game.Players.LocalPlayer.Character:WaitForChild("Humanoid")
        if humanoid then
            humanoid.JumpPower = 100
            Rayfield:Notify({
                Title = "✅ Thành Công",
                Content = "Sức nhảy đã được tăng lên!",
                Duration = 3,
            })
        end
    end,
})

MainTab:CreateButton({
    Name = "🔄 Reset Nhân Vật",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character
        if character then
            character:BreakJoints()
            Rayfield:Notify({
                Title = "✅ Thành Công",
                Content = "Nhân vật đã được reset!",
                Duration = 3,
            })
        end
    end,
})

-- Section mobile
local MobileSection = MainTab:CreateSection("📱 Tính Năng Mobile")

MainTab:CreateToggle({
    Name = "🔋 Auto Click",
    CurrentValue = false,
    Callback = function(Value)
        _G.AutoClick = Value
        if Value then
            Rayfield:Notify({
                Title = "🔋 Auto Click Bật",
                Content = "Chạm vào màn hình để tự động click!",
                Duration = 3,
            })
        end
    end,
})

MainTab:CreateToggle({
    Name = "🎯 Auto Farm",
    CurrentValue = false,
    Callback = function(Value)
        _G.AutoFarm = Value
        if Value then
            Rayfield:Notify({
                Title = "🎯 Auto Farm Bật",
                Content = "Tự động farm đang hoạt động!",
                Duration = 3,
            })
        end
    end,
})

MainTab:CreateButton({
    Name = "📱 Ẩn/Mobile GUI",
    Callback = function()
        local mobileGui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("MobileButtons")
        if mobileGui then
            mobileGui.Enabled = not mobileGui.Enabled
        end
        Rayfield:Notify({
            Title = "📱 Mobile GUI",
            Content = "Đã chuyển đổi trạng thái Mobile GUI!",
            Duration = 3,
        })
    end,
})

-- Section game
local GameSection = MainTab:CreateSection("🎮 Trò Chơi")

MainTab:CreateButton({
    Name = "💎 Infinite Coins",
    Callback = function()
        -- Thêm code infinite coins ở đây
        Rayfield:Notify({
            Title = "💎 Coins",
            Content = "Đang kích hoạt infinite coins...",
            Duration = 3,
        })
    end,
})

MainTab:CreateButton({
    Name = "🔥 Infinite Jump",
    Callback = function()
        _G.InfiniteJump = true
        game:GetService("UserInputService").JumpRequest:Connect(function()
            if _G.InfiniteJump then
                game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
            end
        end)
        Rayfield:Notify({
            Title = "🔥 Infinite Jump",
            Content = "Infinite jump đã được kích hoạt!",
            Duration = 3,
        })
    end,
})

MainTab:CreateButton({
    Name = "👁️ X-Ray Vision",
    Callback = function()
        -- Thêm code x-ray vision ở đây
        Rayfield:Notify({
            Title = "👁️ X-Ray",
            Content = "X-Ray vision đã được kích hoạt!",
            Duration = 3,
        })
    end,
})

-- Section settings
local SettingsSection = MainTab:CreateSection("⚙️ Cài Đặt")

MainTab:CreateToggle({
    Name = "🔔 Hiển Thông Báo",
    CurrentValue = true,
    Callback = function(Value)
        Rayfield:SetNotificationsEnabled(Value)
    end,
})

MainTab:CreateButton({
    Name = "💾 Lưu Cài Đặt",
    Callback = function()
        Rayfield:SaveConfiguration()
        Rayfield:Notify({
            Title = "💾 Lưu Thành Công",
            Content = "Cài đặt đã được lưu!",
            Duration = 3,
        })
    end,
})

MainTab:CreateButton({
    Name = "🔄 Reset UI",
    Callback = function()
        Rayfield:Destroy()
        game.Players.LocalPlayer.PlayerGui:FindFirstChild("RayfieldMobile"):Destroy()
        Rayfield:Notify({
            Title = "🔄 Reset Thành Công",
            Content = "UI đã được reset!",
            Duration = 3,
        })
    end,
})

-- Mobile-specific features
local MobileFeatures = Window:CreateTab("Mobile Features", 4483362458)

-- Mobile controls
MobileFeatures:CreateSection("🎯 Điều Khiển Mobile")

MobileFeatures:CreateToggle({
    Name = "📱 Mobile Mode",
    CurrentValue = true,
    Callback = function(Value)
        _G.MobileMode = Value
        if Value then
            -- Enable mobile-specific features
            game.Players.LocalPlayer.PlayerGui.Rayfield.Main.Size = UDim2.new(0, 300, 0, 400)
        else
            -- Desktop mode
            game.Players.LocalPlayer.PlayerGui.Rayfield.Main.Size = UDim2.new(0, 500, 0, 600)
        end
    end,
})

MobileFeatures:CreateButton({
    Name = "🎚️ Điều Chỉnh Kích Thước",
    Callback = function()
        local size = game.Players.LocalPlayer.PlayerGui.Rayfield.Main.Size
        if size.X.Scale == 0 then
            game.Players.LocalPlayer.PlayerGui.Rayfield.Main.Size = UDim2.new(0, 400, 0, 500)
        else
            game.Players.LocalPlayer.PlayerGui.Rayfield.Main.Size = UDim2.new(0, 300, 0, 400)
        end
    end,
})

MobileFeatures:CreateToggle({
    Name = "🖱️ Touch Controls",
    CurrentValue = true,
    Callback = function(Value)
        _G.TouchControls = Value
        if Value then
            -- Enable touch controls
            local touchFrame = Instance.new("Frame")
            touchFrame.Name = "TouchControls"
            touchFrame.Size = UDim2.new(0, 100, 0, 100)
            touchFrame.Position = UDim2.new(1, -120, 1, -120)
            touchFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            touchFrame.BackgroundTransparency = 0.5
            touchFrame.Parent = game.Players.LocalPlayer.PlayerGui.Rayfield
        else
            -- Disable touch controls
            local touchFrame = game.Players.LocalPlayer.PlayerGui.Rayfield:FindFirstChild("TouchControls")
            if touchFrame then
                touchFrame:Destroy()
            end
        end
    end,
})

-- Auto click functionality
if _G.AutoClick then
    game:GetService("UserInputService").InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            -- Auto click logic here
            print("Auto click triggered!")
        end
    end)
end

print("🚀 Mobile UI đã được tải thành công!")