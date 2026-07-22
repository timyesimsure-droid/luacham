-- Sleek GUI for Chameleon (Inspired by popular scripts)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

local autoPaint = false
local bestMatch = true
local espEnabled = false
local highlights = {}

-- Sleek GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ChameleonSleek"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 360, 0, 420)
mainFrame.Position = UDim2.new(0, 60, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Corner Radius
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 60)
title.BackgroundTransparency = 1
title.Text = "🦎 CHAMELEON"
title.TextColor3 = Color3.fromRGB(0, 200, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

local function createSleekButton(text, yOffset, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.88, 0, 0, 52)
    btn.Position = UDim2.new(0.06, 0, 0, yOffset)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = mainFrame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = btn

    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Functions
local function getBestColor()
    local ray = workspace.CurrentCamera:ScreenPointToRay(mouse.X, mouse.Y)
    local result = workspace:Raycast(ray.Origin, ray.Direction * 600)
    return result and result.Instance and result.Instance.Color or Color3.new(1,1,1)
end

local function paintCharacter()
    local char = player.Character
    if not char then return end
    local color = bestMatch and getBestColor() or Color3.fromRGB(200, 100, 255)

    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Transparency < 0.9 then
            part.Color = color
            part.Material = Enum.Material.SmoothPlastic
        end
    end
end

local function toggleESP()
    espEnabled = not espEnabled
    if espEnabled then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character then
                local hl = Instance.new("Highlight")
                hl.Adornee = plr.Character
                hl.FillColor = Color3.fromRGB(255, 40, 40)
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.FillTransparency = 0.45
                hl.Parent = plr.Character
                highlights[plr] = hl
            end
        end
    else
        for _, hl in pairs(highlights) do hl:Destroy() end
        highlights = {}
    end
end

-- Sleek Buttons
createSleekButton("Auto Paint : OFF", 80, function(btn)
    autoPaint = not autoPaint
    btn.Text = "Auto Paint : " .. (autoPaint and "ON" or "OFF")
end)

createSleekButton("Best Color Match : ON", 145, function(btn)
    bestMatch = not bestMatch
    btn.Text = "Best Color Match : " .. (bestMatch and "ON" or "OFF")
end)

createSleekButton("ESP Seekers : OFF", 210, function(btn)
    toggleESP()
    btn.Text = "ESP Seekers : " .. (espEnabled and "ON" or "OFF")
end)

-- Main Loop
RunService.Heartbeat:Connect(function()
    if autoPaint then
        paintCharacter()
    end
end)

print("✅ Sleek Chameleon GUI Loaded!")
