-- Minimal Chameleon Script - Only ESP + Hide GUI

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local espEnabled = false
local highlights = {}

-- Sleek GUI
local screenGui = Instance.new("ScreenGui")
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 999
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 340, 0, 220)
frame.Position = UDim2.new(0.5, -170, 0.5, -110)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 16)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 60)
title.BackgroundTransparency = 1
title.Text = "🦎 CHAMELEON"
title.TextColor3 = Color3.fromRGB(0, 230, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBlack
title.Parent = frame

local function createButton(text, yOffset, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.85, 0, 0, 55)
    btn.Position = UDim2.new(0.075, 0, 0, yOffset)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = frame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 12)
    btnCorner.Parent = btn

    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- ESP Function
local function toggleESP()
    espEnabled = not espEnabled
    if espEnabled then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character then
                local hl = Instance.new("Highlight")
                hl.Adornee = plr.Character
                hl.FillColor = Color3.fromRGB(255, 50, 50)
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.FillTransparency = 0.4
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
createButton("ESP Seekers : OFF", 80, function(btn)
    toggleESP()
    btn.Text = "ESP Seekers : " .. (espEnabled and "ON" or "OFF")
end)

createButton("Hide GUI", 150, function()
    frame.Visible = false
    print("GUI Hidden - Rejoin to show again")
end)

print("✅ Minimal Chameleon Script Loaded (ESP + Hide GUI)")
