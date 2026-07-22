-- =============================================
-- Chameleon Script with Improved ESP (from gumanba)
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

-- Paint
local function getBestColor()
    local ray = workspace.CurrentCamera:ScreenPointToRay(mouse.X, mouse.Y)
    local result = workspace:Raycast(ray.Origin, ray.Direction * 500)
    return result and result.Instance and result.Instance.Color or Color3.new(1,1,1)
end

local function paintCharacter()
    local char = player.Character
    if not char then return end
    local color = bestMatch and getBestColor() or (mouse.Target and mouse.Target.Color)
    if not color then return end

    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.Color = color
        end
    end
end

-- ESP (Improved from the other script style)
local function clearESP()
    for _, v in pairs(highlights) do v:Destroy() end
    highlights = {}
end

local function toggleESP()
    espEnabled = not espEnabled
    if not espEnabled then
        clearESP()
        return
    end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local highlight = Instance.new("Highlight")
            highlight.Adornee = plr.Character
            highlight.FillColor = Color3.fromRGB(255, 0, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 100, 100)
            highlight.FillTransparency = 0.5
            highlight.OutlineTransparency = 0
            highlight.Parent = plr.Character
            highlights[plr] = highlight
        end
    end
end

-- Buttons
createButton("Auto Paint: OFF", 60, function(btn)
    autoPaint = not autoPaint
    btn.Text = "Auto Paint: " .. (autoPaint and "ON" or "OFF")
end)

createButton("Best Match: ON", 115, function(btn)
    bestMatch = not bestMatch
    btn.Text = "Best Match: " .. (bestMatch and "ON" or "OFF")
end)

createButton("ESP Seekers: OFF", 170, function(btn)
    toggleESP()
    btn.Text = "ESP Seekers: " .. (espEnabled and "ON" or "OFF")
end)

createButton("Taunt Spam: OFF", 225, function(btn)
    print("Taunt Spam - Not fully implemented in this version")
    -- Add your taunt logic here if needed
end)

-- Main Loop
RunService.RenderStepped:Connect(function()
    if autoPaint then
        paintCharacter()
    end
end)

print("✅ Loaded with ESP from gumanba script style!")
