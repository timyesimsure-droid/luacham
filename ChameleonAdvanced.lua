-- =============================================
-- Advanced Chameleon Script + GUI (Updated)
-- Fixed Taunt Spam
-- =============================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

local autoPaint = false
local bestMatch = true
local brushSize = 1
local espEnabled = false
local tauntSpamEnabled = false
local tauntConnection = nil

-- Create GUI (same as before)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ChameleonGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 280, 0, 420)
frame.Position = UDim2.new(0, 10, 0.5, -210)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
title.Text = "🦎 Chameleon Advanced"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = frame

local function createButton(text, pos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 35)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextScaled = true
    btn.Font = Enum.Font.Gotham
    btn.Parent = frame
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Auto Paint + Best Match
local function getBestColor()
    local ray = workspace.CurrentCamera:ScreenPointToRay(mouse.X, mouse.Y)
    local result = workspace:Raycast(ray.Origin, ray.Direction * 300)
    return result and result.Instance and result.Instance.Color or Color3.new(1,1,1)
end

local function paintCharacter()
    local character = player.Character
    if not character then return end
    local targetColor = bestMatch and getBestColor() or (mouse.Target and mouse.Target.Color)
    if not targetColor then return end

    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.Color = targetColor
            part.Material = Enum.Material.SmoothPlastic
        end
    end
end

-- Fixed Taunt Spam
local function startTauntSpam()
    if tauntConnection then tauntConnection:Disconnect() end
    
    tauntConnection = RunService.Heartbeat:Connect(function()
        if not tauntSpamEnabled or not player.Character then return end
        
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid then
            -- Method 1: Play random animation (most common in these games)
            local animator = humanoid:FindFirstChild("Animator")
            if animator then
                local animations = player.Character:GetChildren()
                for _, v in ipairs(animations) do
                    if v:IsA("Animation") or v:IsA("AnimationTrack") then
                        pcall(function()
                            local track = animator:LoadAnimation(v)
                            track:Play()
                            wait(0.8)
                            track:Stop()
                        end)
                        break
                    end
                end
            end
            
            -- Method 2: Alternative - Fire common taunt events if they exist
            pcall(function()
                local tauntRemote = workspace:FindFirstChild("TauntEvent", true) or 
                                  game.ReplicatedStorage:FindFirstChild("Taunt", true)
                if tauntRemote then
                    tauntRemote:FireServer(math.random(1,5))
                end
            end)
        end
    end)
end

local function stopTauntSpam()
    if tauntConnection then
        tauntConnection:Disconnect()
        tauntConnection = nil
    end
end

-- ESP (unchanged)
local function toggleESP() 
    espEnabled = not espEnabled
    -- Simplified ESP for now
    print("ESP Toggled: " .. tostring(espEnabled))
end

-- Buttons
createButton("Auto Paint: OFF", UDim2.new(0.05, 0, 0, 50), function(btn)
    autoPaint = not autoPaint
    btn.Text = "Auto Paint: " .. (autoPaint and "ON" or "OFF")
end)

createButton("Best Color Match: ON", UDim2.new(0.05, 0, 0, 95), function(btn)
    bestMatch = not bestMatch
    btn.Text = "Best Color Match: " .. (bestMatch and "ON" or "OFF")
end)

createButton("ESP Seekers: OFF", UDim2.new(0.05, 0, 0, 140), function(btn)
    toggleESP()
    btn.Text = "ESP Seekers: " .. (espEnabled and "ON" or "OFF")
end)

createButton("Taunt Spam: OFF", UDim2.new(0.05, 0, 0, 185), function(btn)
    tauntSpamEnabled = not tauntSpamEnabled
    btn.Text = "Taunt Spam: " .. (tauntSpamEnabled and "ON" or "OFF")
    
    if tauntSpamEnabled then
        startTauntSpam()
    else
        stopTauntSpam()
    end
end)

-- Brush Size
local sizeLabel = Instance.new("TextLabel")
sizeLabel.Size = UDim2.new(0.9, 0, 0, 30)
sizeLabel.Position = UDim2.new(0.05, 0, 0, 230)
sizeLabel.BackgroundTransparency = 1
sizeLabel.Text = "Brush Size: " .. brushSize
sizeLabel.TextColor3 = Color3.new(1,1,1)
sizeLabel.Parent = frame

createButton("+ Brush", UDim2.new(0.05, 0, 0, 270), function()
    brushSize = math.min(brushSize + 1, 5)
    sizeLabel.Text = "Brush Size: " .. brushSize
end)

createButton("- Brush", UDim2.new(0.05, 0, 0, 315), function()
    brushSize = math.max(brushSize - 1, 1)
    sizeLabel.Text = "Brush Size: " .. brushSize
end)

-- Main Loop
RunService.RenderStepped:Connect(function()
    if autoPaint then
        paintCharacter()
    end
end)

print("🦎 Chameleon Script Updated - Taunt Spam Fixed!")