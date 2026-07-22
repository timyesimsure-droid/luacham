-- Chameleon Script with Strong ESP (gumanba style)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

local autoPaint = false
local bestMatch = true
local espEnabled = false
local highlights = {}

print("🦎 Loading Chameleon with gumanba-style ESP...")

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 340, 0, 400)
frame.Position = UDim2.new(0, 40, 0.25, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
title.Text = "🦎 Chameleon (gumanba ESP)"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = frame

local function createButton(text, y, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 50)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextScaled = true
    btn.Font = Enum.Font.Gotham
    btn.Parent = frame
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Paint
local function paintCharacter()
    local char = player.Character
    if not char then return end
    local color = bestMatch and getBestColor() or Color3.fromRGB(255, 100, 100)

    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Transparency < 0.9 then
            part.Color = color
        end
    end
end

local function getBestColor()
    local ray = workspace.CurrentCamera:ScreenPointToRay(mouse.X, mouse.Y)
    local result = workspace:Raycast(ray.Origin, ray.Direction * 500)
    return result and result.Instance and result.Instance.Color or Color3.new(1,1,1)
end

-- Strong ESP
local function toggleESP()
    espEnabled = not espEnabled
    print("ESP:", espEnabled)

    if espEnabled then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character then
                local highlight = Instance.new("Highlight")
                highlight.Adornee = plr.Character
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.FillTransparency = 0.4
                highlight.OutlineTransparency = 0
                highlight.Parent = plr.Character
                highlights[plr] = highlight
            end
        end
    else
        for _, hl in pairs(highlights) do hl:Destroy() end
        highlights = {}
    end
end

-- Buttons
createButton("Toggle Auto Paint", 60, function()
    autoPaint = not autoPaint
    print("Auto Paint:", autoPaint)
end)

createButton("Toggle Best Match", 120, function()
    bestMatch = not bestMatch
    print("Best Match:", bestMatch)
end)

createButton("Toggle ESP", 180, toggleESP)

-- Loop
RunService.Heartbeat:Connect(function()
    if autoPaint then
        paintCharacter()
    end
end)

print("✅ Loaded!")
