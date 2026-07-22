-- =============================================
-- Chameleon Advanced Script - ESP Fixed
-- =============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

local autoPaint = false
local bestMatch = true
local espEnabled = false
local tauntSpamEnabled = false
local tauntConnection = nil
local highlights = {}

-- GUI (same clean look)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ChameleonGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 400)
frame.Position = UDim2.new(0, 20, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
title.Text = "🦎 Chameleon Advanced"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = frame

local function createButton(text, yOffset, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = UDim2.new(0.05, 0, 0, yOffset)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = frame
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Paint Functions
local function getBestColor()
    local ray = workspace.CurrentCamera:ScreenPointToRay(mouse.X, mouse.Y)
    local result = workspace:Raycast(ray.Origin, ray.Direction * 400)
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
            part.Material = Enum.Material.SmoothPlastic
        end
    end
end

-- Working ESP
local function updateESP()
    for _, hl in pairs(highlights) do
        if hl.Parent then hl:Destroy() end
    end
    highlights = {}

    if not espEnabled then return end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local highlight = Instance.new("Highlight")
            highlight.Name = "ChameleonESP"
            highlight.FillColor = Color3.fromRGB(255, 50, 50)
            highlight.OutlineColor = Color3.fromRGB(255, 100, 100)
            highlight.FillTransparency = 0.5
            highlight.OutlineTransparency = 0
            highlight.Adornee = plr.Character
            highlight.Parent = plr.Character
            highlights[plr] = highlight
        end
    end
end

-- Taunt Spam (unchanged)
local function startTauntSpam()
    if tauntConnection then tauntConnection:Disconnect() end
    tauntConnection = RunService.Heartbeat:Connect(function()
        if not tauntSpamEnabled then return end
        pcall(function()
            local remotes = ReplicatedStorage:GetDescendants()
            for _, v in ipairs(remotes) do
                if v:IsA("RemoteEvent") and (v.Name:lower():find("taunt") or v.Name:lower():find("emote")) then
                    v:FireServer(math.random(1,6))
                    break
                end
            end
        end)
        wait(1.6)
    end)
end

local function stopTauntSpam()
    if tauntConnection then tauntConnection:Disconnect() tauntConnection = nil end
end

-- Buttons
createButton("Auto Paint: OFF", 60, function(btn)
    autoPaint = not autoPaint
    btn.Text = "Auto Paint: " .. (autoPaint and "ON" or "OFF")
end)

createButton("Best Color Match: ON", 110, function(btn)
    bestMatch = not bestMatch
    btn.Text = "Best Color Match: " .. (bestMatch and "ON" or "OFF")
end)

createButton("ESP Seekers: OFF", 160, function(btn)
    espEnabled = not espEnabled
    btn.Text = "ESP Seekers: " .. (espEnabled and "ON" or "OFF")
    updateESP()
end)

createButton("Taunt Spam: OFF", 210, function(btn)
    tauntSpamEnabled = not tauntSpamEnabled
    btn.Text = "Taunt Spam: " .. (tauntSpamEnabled and "ON" or "OFF")
    if tauntSpamEnabled then startTauntSpam() else stopTauntSpam() end
end)

-- Update ESP when players join/leave
Players.PlayerAdded:Connect(updateESP)
Players.PlayerRemoving:Connect(updateESP)

-- Main Loop
RunService.RenderStepped:Connect(function()
    if autoPaint then
        paintCharacter()
    end
end)

print("✅ Chameleon Advanced Script Loaded! (ESP Fixed)")
