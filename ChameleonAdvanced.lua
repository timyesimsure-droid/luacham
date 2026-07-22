-- =============================================
-- Chameleon Advanced - ESP Fully Fixed
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

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ChameleonGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 420)
frame.Position = UDim2.new(0, 20, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
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
    btn.Size = UDim2.new(0.9, 0, 0, 45)
    btn.Position = UDim2.new(0.05, 0, 0, yOffset)
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

-- ESP
local function clearHighlights()
    for _, hl in pairs(highlights) do
        if hl and hl.Parent then hl:Destroy() end
    end
    highlights = {}
end

local function updateESP()
    clearHighlights()
    if not espEnabled then return end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local highlight = Instance.new("Highlight")
            highlight.FillColor = Color3.fromRGB(255, 60, 60)
            highlight.OutlineColor = Color3.fromRGB(255, 150, 150)
            highlight.FillTransparency = 0.4
            highlight.OutlineTransparency = 0
            highlight.Adornee = plr.Character
            highlight.Parent = plr.Character
            highlights[plr] = highlight
        end
    end
end

-- Taunt Spam
local function startTauntSpam()
    if tauntConnection then tauntConnection:Disconnect() end
    tauntConnection = RunService.Heartbeat:Connect(function()
        if not tauntSpamEnabled then return end
        pcall(function()
            for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
                if v:IsA("RemoteEvent") and (v.Name:lower():find("taunt") or v.Name:lower():find("emote")) then
                    v:FireServer(math.random(1,8))
                    break
                end
            end
        end)
        wait(1.5)
    end)
end

local function stopTauntSpam()
    if tauntConnection then tauntConnection:Disconnect() tauntConnection = nil end
end

-- Buttons with proper state update
local espBtn = createButton("ESP Seekers: OFF", 70, function()
    espEnabled = not espEnabled
    espBtn.Text = "ESP Seekers: " .. (espEnabled and "ON" or "OFF")
    updateESP()
end)

local autoBtn = createButton("Auto Paint: OFF", 125, function()
    autoPaint = not autoPaint
    autoBtn.Text = "Auto Paint: " .. (autoPaint and "ON" or "OFF")
end)

local matchBtn = createButton("Best Color Match: ON", 180, function()
    bestMatch = not bestMatch
    matchBtn.Text = "Best Color Match: " .. (bestMatch and "ON" or "OFF")
end)

local tauntBtn = createButton("Taunt Spam: OFF", 235, function()
    tauntSpamEnabled = not tauntSpamEnabled
    tauntBtn.Text = "Taunt Spam: " .. (tauntSpamEnabled and "ON" or "OFF")
    if tauntSpamEnabled then startTauntSpam() else stopTauntSpam() end
end)

-- Connections
Players.PlayerAdded:Connect(updateESP)
Players.PlayerRemoving:Connect(function() wait(1) updateESP() end)

RunService.RenderStepped:Connect(function()
    if autoPaint then
        paintCharacter()
    end
end)

print("✅ Chameleon Script Loaded - ESP Should Now Work!")
