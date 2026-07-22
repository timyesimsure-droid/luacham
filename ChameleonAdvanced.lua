-- =============================================
-- Chameleon - Final Fixed Version
-- =============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

local autoPaint = false
local bestMatch = true
local espEnabled = false
local highlights = {}

print("🦎 Chameleon Script Loading...")

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ChameleonGUI"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 1000
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 340, 0, 420)
frame.Position = UDim2.new(0, 40, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
title.Text = "🦎 Chameleon Advanced"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = frame

local function createButton(text, yOffset, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 48)
    btn.Position = UDim2.new(0.05, 0, 0, yOffset)
    btn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    btn.AutoButtonColor = true
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = frame
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Paint
local function paintCharacter()
    local char = player.Character
    if not char then return end

    local color = bestMatch and Color3.fromRGB(120, 120, 120) or Color3.fromRGB(255, 100, 100)

    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Transparency < 0.9 and part.Name ~= "HumanoidRootPart" then
            part.Color = color
            part.Material = Enum.Material.SmoothPlastic
        end
    end
end

-- ESP
local function toggleESP()
    espEnabled = not espEnabled
    print("ESP Toggled:", espEnabled)
    
    if espEnabled then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character then
                local hl = Instance.new("Highlight")
                hl.Adornee = plr.Character
                hl.FillColor = Color3.fromRGB(255, 80, 80)
                hl.Parent = plr.Character
                highlights[plr] = hl
            end
        end
    else
        for _, hl in pairs(highlights) do hl:Destroy() end
        highlights = {}
    end
end

-- Buttons
createButton("Auto Paint: OFF", 60, function()
    autoPaint = not autoPaint
    print("Auto Paint:", autoPaint)
end)

createButton("Best Match: ON", 120, function()
    bestMatch = not bestMatch
    print("Best Match:", bestMatch)
end)

createButton("ESP Seekers: OFF", 180, function()
    toggleESP()
end)

-- Main Loop
RunService.Heartbeat:Connect(function()
    if autoPaint then
        paintCharacter()
    end
end)

print("✅ Script Loaded! Check console (F9) when clicking buttons.")
