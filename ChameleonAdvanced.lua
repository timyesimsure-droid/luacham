-- =============================================
-- Chameleon Final Stable Version
-- =============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

local autoPaint = false
local bestMatch = true
local espEnabled = false
local highlights = {}

print("🦎 Chameleon Script vFinal Loading...")

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 340, 0, 380)
frame.Position = UDim2.new(0, 50, 0.25, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
title.Text = "🦎 Chameleon"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = frame

local function createButton(text, y)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 50)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextScaled = true
    btn.Font = Enum.Font.Gotham
    btn.Parent = frame
    return btn
end

-- Paint
local function paintCharacter()
    local char = player.Character
    if not char then return end
    local color = bestMatch and Color3.fromRGB(100, 100, 100) or Color3.fromRGB(255, 100, 100)

    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Transparency < 0.9 then
            part.Color = color
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
                hl.FillColor = Color3.fromRGB(255, 50, 50)
                hl.OutlineColor = Color3.fromRGB(255, 200, 200)
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
createButton("Toggle Auto Paint", 60).MouseButton1Click:Connect(function()
    autoPaint = not autoPaint
    print("Auto Paint:", autoPaint)
end)

createButton("Toggle Best Match", 120).MouseButton1Click:Connect(function()
    bestMatch = not bestMatch
    print("Best Match:", bestMatch)
end)

createButton("Toggle ESP", 180).MouseButton1Click:Connect(toggleESP)

-- Loop
RunService.Heartbeat:Connect(function()
    if autoPaint then
        paintCharacter()
    end
end)

print("✅ Loaded! Use F9 console to see status.")
