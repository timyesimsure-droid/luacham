-- =============================================
-- DEBUG VERSION - Click + Auto Paint Test
-- =============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

local autoPaint = false
local bestMatch = true
local espEnabled = false

print("🦎 Script Starting...")

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ChameleonDebug"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 1000
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 340, 0, 420)
frame.Position = UDim2.new(0, 50, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
title.Text = "DEBUG - Chameleon"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = frame

local function createButton(text, yOffset)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 50)
    btn.Position = UDim2.new(0.05, 0, 0, yOffset)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.AutoButtonColor = true
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextScaled = true
    btn.Font = Enum.Font.Gotham
    btn.Parent = frame
    return btn
end

-- Paint Function
local function paintCharacter()
    local char = player.Character
    if not char then return end
    local color = bestMatch and Color3.fromRGB(100,100,100) or Color3.new(1,0,0) -- test color

    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.Color = color
        end
    end
end

-- Buttons with Debug
local autoBtn = createButton("Auto Paint: OFF", 60)
autoBtn.MouseButton1Click:Connect(function()
    autoPaint = not autoPaint
    autoBtn.Text = "Auto Paint: " .. (autoPaint and "ON" or "OFF")
    print("Auto Paint toggled to:", autoPaint)
end)

local matchBtn = createButton("Best Match: ON", 120)
matchBtn.MouseButton1Click:Connect(function()
    bestMatch = not bestMatch
    matchBtn.Text = "Best Match: " .. (bestMatch and "ON" or "OFF")
    print("Best Match toggled to:", bestMatch)
end)

local espBtn = createButton("ESP: OFF", 180)
espBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espBtn.Text = "ESP: " .. (espEnabled and "ON" or "OFF")
    print("ESP toggled to:", espEnabled)
end)

-- Main Loop
RunService.Heartbeat:Connect(function()
    if autoPaint then
        paintCharacter()
    end
end)

print("✅ Debug Script Loaded - Click buttons and check console (F9)")
