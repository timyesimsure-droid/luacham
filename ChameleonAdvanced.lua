-- =============================================
-- Chameleon - Auto Paint FIXED + ESP
-- =============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

local autoPaint = false
local bestMatch = true
local espEnabled = false
local highlights = {}

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ChameleonGUI"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 400)
frame.Position = UDim2.new(0, 30, 0.3, 0)
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

local function createButton(text, y, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 45)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.AutoButtonColor = true
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = frame
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Improved Auto Paint
local function getBestColor()
    local ray = workspace.CurrentCamera:ScreenPointToRay(mouse.X, mouse.Y)
    local result = workspace:Raycast(ray.Origin, ray.Direction * 600)
    return result and result.Instance and result.Instance.Color or Color3.new(1,1,1)
end

local function paintCharacter()
    local char = player.Character
    if not char then return end

    local targetColor = bestMatch and getBestColor() or (mouse.Target and mouse.Target.Color)
    if not targetColor then return end

    -- Paint ALL visual parts more aggressively
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and not part:FindFirstChild("Mesh") then
            if part.Name ~= "HumanoidRootPart" and part.Transparency < 1 then
                part.Color = targetColor
                part.Material = Enum.Material.SmoothPlastic
            end
        end
    end
end

-- ESP
local function clearESP()
    for _, hl in pairs(highlights) do hl:Destroy() end
    highlights = {}
end

local function toggleESP(btn)
    espEnabled = not espEnabled
    btn.Text = "ESP Seekers: " .. (espEnabled and "ON" or "OFF")
    
    if espEnabled then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character then
                local hl = Instance.new("Highlight")
                hl.Adornee = plr.Character
                hl.FillColor = Color3.fromRGB(255, 60, 60)
                hl.OutlineColor = Color3.fromRGB(255, 150, 150)
                hl.FillTransparency = 0.5
                hl.Parent = plr.Character
                highlights[plr] = hl
            end
        end
    else
        clearESP()
    end
end

-- Buttons
local autoBtn = createButton("Auto Paint: OFF", 60, function(btn)
    autoPaint = not autoPaint
    btn.Text = "Auto Paint: " .. (autoPaint and "ON" or "OFF")
end)

local matchBtn = createButton("Best Match: ON", 115, function(btn)
    bestMatch = not bestMatch
    btn.Text = "Best Match: " .. (bestMatch and "ON" or "OFF")
end)

local espBtn = createButton("ESP Seekers: OFF", 170, function(btn)
    toggleESP(btn)
end)

-- Main Loop - This is the key fix for Auto Paint
RunService.Heartbeat:Connect(function()
    if autoPaint and player.Character then
        paintCharacter()
    end
end)

print("✅ Auto Paint should now work better!")
