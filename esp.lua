
--==================================================
-- DX TAME BETA | RAINBOW LASER ESP FULL
-- Roblox Studio | LocalScript
--==================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")

local enabled = false
local rainbowHue = 0
local rainbowSpeed = 0.45
local lasers = {}
local characterConnections = {}
local destroyed = false

-- Xóa laser của một người chơi
local function removeLaser(player)
    local data = lasers[player]
    if not data then return end

    for _, object in ipairs({
        data.beam,
        data.startAttachment,
        data.endAttachment
    }) do
        if object then
            object:Destroy()
        end
    end

    lasers[player] = nil
end

-- Tạo laser nối hai nhân vật
local function createLaser(player)
    if player == localPlayer or not enabled then
        return
    end

    removeLaser(player)

    local myCharacter = localPlayer.Character
    local targetCharacter = player.Character

    if not myCharacter or not targetCharacter then return end

    local myRoot = myCharacter:FindFirstChild("HumanoidRootPart")
    local targetRoot = targetCharacter:FindFirstChild("HumanoidRootPart")

    if not myRoot or not targetRoot then return end

    local startAttachment = Instance.new("Attachment")
    startAttachment.Name = "DX_TAME_LaserStart"
    startAttachment.Parent = myRoot

    local endAttachment = Instance.new("Attachment")
    endAttachment.Name = "DX_TAME_LaserEnd"
    endAttachment.Parent = targetRoot

    local beam = Instance.new("Beam")
    beam.Name = "DX_TAME_RainbowLaser"
    beam.Attachment0 = startAttachment
    beam.Attachment1 = endAttachment
    beam.FaceCamera = true
    beam.Width0 = 0.075
    beam.Width1 = 0.035
    beam.LightEmission = 1
    beam.LightInfluence = 0
    beam.Segments = 12
    beam.Enabled = true
    beam.Parent = myRoot

    lasers[player] = {
        beam = beam,
        startAttachment = startAttachment,
        endAttachment = endAttachment
    }
end

-- Theo dõi nhân vật hồi sinh
local function watchPlayer(player)
    if player == localPlayer then return end

    if characterConnections[player] then
        characterConnections[player]:Disconnect()
    end

    characterConnections[player] = player.CharacterAdded:Connect(function()
        task.wait(1)

        if enabled and not destroyed and player.Parent then
            createLaser(player)
        end
    end)

    if enabled then
        createLaser(player)
    end
end

-- Bật hoặc tắt TẤT CẢ laser
local function setLaserEnabled(state)
    enabled = state

    if enabled then
        for _, player in ipairs(Players:GetPlayers()) do
            watchPlayer(player)
        end
    else
        for player in pairs(lasers) do
            removeLaser(player)
        end
    end
end

-- Giao diện
local gui = Instance.new("ScreenGui")
gui.Name = "DX_TAME_BETA_LASER"
gui.ResetOnSpawn = false
gui.DisplayOrder = 999
gui.Parent = playerGui

local panel = Instance.new("Frame")
panel.Name = "MainPanel"
panel.Size = UDim2.fromOffset(245, 130)
panel.Position = UDim2.new(0.5, -122, 0.5, -65)
panel.BackgroundColor3 = Color3.fromRGB(13, 15, 25)
panel.BorderSizePixel = 0
panel.Active = true
panel.Parent = gui

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 12)
panelCorner.Parent = panel

local panelStroke = Instance.new("UIStroke")
panelStroke.Thickness = 2
panelStroke.Parent = panel

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -20, 0, 35)
title.Position = UDim2.fromOffset(10, 4)
title.BackgroundTransparency = 1
title.Text = "DX TAME BETA"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 19
title.Parent = panel

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -20, 0, 20)
subtitle.Position = UDim2.fromOffset(10, 37)
subtitle.BackgroundTransparency = 1
subtitle.Text = "RAINBOW LASER ESP"
subtitle.TextColor3 = Color3.fromRGB(175, 180, 205)
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 11
subtitle.Parent = panel

local toggle = Instance.new("TextButton")
toggle.Name = "ToggleAllLasers"
toggle.Size = UDim2.new(1, -24, 0, 42)
toggle.Position = UDim2.fromOffset(12, 70)
toggle.BackgroundColor3 = Color3.fromRGB(30, 33, 48)
toggle.BorderSizePixel = 0
toggle.Text = "LASER ESP : OFF"
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 14
toggle.Parent = panel

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggle

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Thickness = 1.5
toggleStroke.Parent = toggle

-- Kéo thả bảng bằng thanh tiêu đề
local dragging = false
local dragStart
local startPosition

title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then

        dragging = true
        dragStart = input.Position
        startPosition = panel.Position
    end
end)

local dragEndedConnection

dragEndedConnection = game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

RunService.RenderStepped:Connect(function(dt)
    if destroyed then return end

    -- RGB cầu vồng liên tục
    rainbowHue = (rainbowHue + dt * rainbowSpeed) % 1

    local rainbow = Color3.fromHSV(rainbowHue, 1, 1)
    panelStroke.Color = rainbow
    toggleStroke.Color = rainbow
    title.TextColor3 = rainbow

    -- Dải màu cầu vồng trên từng tia
    for player, data in pairs(lasers) do
        if data.beam and data.beam.Parent then
            local offset = (player.UserId % 100) / 100
            local h = (rainbowHue + offset) % 1

            data.beam.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(
                    0, Color3.fromHSV(h, 1, 1)
                ),
                ColorSequenceKeypoint.new(
                    0.25, Color3.fromHSV((h + 0.17) % 1, 1, 1)
                ),
                ColorSequenceKeypoint.new(
                    0.5, Color3.fromHSV((h + 0.34) % 1, 1, 1)
                ),
                ColorSequenceKeypoint.new(
                    0.75, Color3.fromHSV((h + 0.5) % 1, 1, 1)
                ),
                ColorSequenceKeypoint.new(
                    1, Color3.fromHSV((h + 0.67) % 1, 1, 1)
                )
            })
        end
    end

    -- Di chuyển bảng
    if dragging and dragStart and startPosition then
        local input = game:GetService("UserInputService"):GetMouseLocation()
        local delta = input - dragStart

        panel.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

-- Nút bật/tắt toàn bộ laser
toggle.Activated:Connect(function()
    setLaserEnabled(not enabled)

    if enabled then
        toggle.Text = "LASER ESP : ON"
        toggle.BackgroundColor3 = Color3.fromRGB(20, 70, 55)
    else
        toggle.Text = "LASER ESP : OFF"
        toggle.BackgroundColor3 = Color3.fromRGB(30, 33, 48)
    end
end)

-- Người chơi mới vào / rời game
Players.PlayerAdded:Connect(function(player)
    watchPlayer(player)
end)

Players.PlayerRemoving:Connect(function(player)
    removeLaser(player)

    if characterConnections[player] then
        characterConnections[player]:Disconnect()
        characterConnections[player] = nil
    end
end)

-- Khởi tạo theo dõi nhân vật
for _, player in ipairs(Players:GetPlayers()) do
    watchPlayer(player)
end

-- Dọn dữ liệu nếu giao diện bị xóa
gui.Destroying:Connect(function()
    destroyed = true
    enabled = false

    for player in pairs(lasers) do
        removeLaser(player)
    end

    for player, connection in pairs(characterConnections) do
        connection:Disconnect()
        characterConnections[player] = nil
    end

    if dragEndedConnection then
        dragEndedConnection:Disconnect()
    end
end)

print("[DX TAME BETA] RAINBOW LASER ESP loaded")
