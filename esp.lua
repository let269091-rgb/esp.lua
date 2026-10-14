
-- DX TAME BETA | TRANSPARENT NEON ESP
-- Roblox Studio / game thử nghiệm do bạn quản lý

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local me = Players.LocalPlayer
local guiParent = me:WaitForChild("PlayerGui")

local old = guiParent:FindFirstChild("DX_TAME_BETA")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "DX_TAME_BETA"
gui.ResetOnSpawn = false
gui.Parent = guiParent

local function round(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = obj
end

local function stroke(obj, color)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = 1.5
    s.Parent = obj
end

-- Menu kính trong suốt
local menu = Instance.new("Frame")
menu.Size = UDim2.fromOffset(290, 335)
menu.Position = UDim2.new(0.5, -145, 0.3, 0)
menu.BackgroundColor3 = Color3.fromRGB(15, 20, 40)
menu.BackgroundTransparency = 0.22
menu.BorderSizePixel = 0
menu.Active = true
menu.Parent = gui
round(menu, 14)
stroke(menu, Color3.fromRGB(90, 150, 255))

local header = Instance.new("TextLabel")
header.Size = UDim2.new(1, -48, 0, 44)
header.Position = UDim2.fromOffset(12, 0)
header.BackgroundTransparency = 1
header.Text = "DX TAME BETA"
header.TextColor3 = Color3.fromRGB(120, 220, 255)
header.TextSize = 18
header.Font = Enum.Font.GothamBold
header.TextXAlignment = Enum.TextXAlignment.Left
header.Parent = menu

local minimize = Instance.new("TextButton")
minimize.Size = UDim2.fromOffset(34, 30)
minimize.Position = UDim2.new(1, -40, 0, 7)
minimize.Text = "—"
minimize.TextColor3 = Color3.new(1, 1, 1)
minimize.BackgroundColor3 = Color3.fromRGB(50, 60, 100)
minimize.BackgroundTransparency = 0.15
minimize.Parent = menu
round(minimize, 8)

local circle = Instance.new("TextButton")
circle.Size = UDim2.fromOffset(58, 58)
circle.Position = menu.Position
circle.Text = "DX"
circle.TextColor3 = Color3.new(1, 1, 1)
circle.Font = Enum.Font.GothamBold
circle.TextSize = 18
circle.BackgroundColor3 = Color3.fromRGB(30, 65, 145)
circle.BackgroundTransparency = 0.1
circle.Visible = false
circle.Active = true
circle.Parent = gui
round(circle, 29)
stroke(circle, Color3.fromRGB(90, 200, 255))

-- Kéo thả hỗ trợ chuột và cảm ứng
local function drag(obj, handle)
    local down, startInput, startPosition
    local moved = false

    handle.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
        and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        down = true
        moved = false
        startInput = input.Position
        startPosition = obj.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                down = false
            end
        end)
    end)

    UIS.InputChanged:Connect(function(input)
        if not down then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - startInput
            if delta.Magnitude > 5 then moved = true end
            obj.Position = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )
        end
    end)

    return function()
        return moved
    end
end

drag(menu, header)
local circleMoved = drag(circle, circle)

minimize.Activated:Connect(function()
    circle.Position = menu.Position
    menu.Visible = false
    circle.Visible = true
end)

circle.Activated:Connect(function()
    if circleMoved() then return end
    menu.Position = circle.Position
    circle.Visible = false
    menu.Visible = true
end)

-- Các công tắc
local settings = {
    Players = true,
    Fruits = true,
    Mobs = true,
    Bots = true,
    Laser = true,
}

local buttons = {}

local function addToggle(key, label, y)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -24, 0, 38)
    b.Position = UDim2.fromOffset(12, y)
    b.BackgroundColor3 = Color3.fromRGB(30, 42, 75)
    b.BackgroundTransparency = 0.15
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamSemibold
    b.TextSize = 13
    b.Parent = menu
    round(b, 8)

    local function refresh()
        b.Text = label .. " : " .. (settings[key] and "ON" or "OFF")
        b.TextColor3 = settings[key]
            and Color3.fromRGB(120, 255, 200)
            or Color3.fromRGB(185, 190, 210)
    end

    b.Activated:Connect(function()
        settings[key] = not settings[key]
        refresh()
    end)

    refresh()
    buttons[key] = b
end

addToggle("Players", "PLAYER ESP", 52)
addToggle("Fruits", "FRUIT ESP", 96)
addToggle("Mobs", "MOB ESP", 140)
addToggle("Bots", "BOT ESP", 184)
addToggle("Laser", "RAINBOW LASER", 228)

local note = Instance.new("TextLabel")
note.Size = UDim2.new(1, -24, 0, 30)
note.Position = UDim2.fromOffset(12, 282)
note.BackgroundTransparency = 1
note.Text = "DX TAME | TEST MODE"
note.TextColor3 = Color3.fromRGB(145, 175, 220)
note.Font = Enum.Font.Gotham
note.TextSize = 11
note.Parent = menu

-- ESP demo cho mục tiêu được game thử nghiệm đánh dấu.
-- Đặt Attribute DXType = Player, Fruit, Mob hoặc Bot.
-- Các mục tiêu phải có BasePart/Model trong Workspace.

local targets = {}
local function getPart(obj)
    if obj:IsA("BasePart") then return obj end
    if obj:IsA("Model") then
        return obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart", true)
    end
end

local function register(obj)
    if targets[obj] then return end
    if not (obj:IsA("Model") or obj:IsA("BasePart")) then return end

    local kind = obj:GetAttribute("DXType")
    if not settings[kind == "Player" and "Players"
        or kind == "Fruit" and "Fruits"
        or kind == "Mob" and "Mobs"
        or kind == "Bot" and "Bots"
        or "Invalid"] then
        return
    end

    local part = getPart(obj)
    if not part then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "DX_TargetLabel"
    billboard.Adornee = part
    billboard.Size = UDim2.fromOffset(220, 36)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = gui

    local label = Instance.new("TextLabel")
    label.Size = UDim2.fromScale(1, 1)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(130, 255, 190)
    label.TextStrokeTransparency = 0.15
    label.Font = Enum.Font.GothamBold
    label.TextSize = 13
    label.Parent = billboard

    targets[obj] = {
        part = part,
        kind = kind,
        label = label,
        billboard = billboard,
        beam = nil,
        attachment = nil,
        targetAttachment = nil,
    }
end

for _, obj in ipairs(workspace:GetDescendants()) do
    register(obj)
end

workspace.DescendantAdded:Connect(register)

workspace.DescendantRemoving:Connect(function(obj)
    local data = targets[obj]
    if data then
        data.billboard:Destroy()
        if data.beam then data.beam:Destroy() end
        if data.attachment then data.attachment:Destroy() end
        if data.targetAttachment then data.targetAttachment:Destroy() end
        targets[obj] = nil
    end
end)

-- Nguồn tia laser gắn với nhân vật của người chơi
local sourceAttachment
local sourcePart

local function updateSource()
    local char = me.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root ~= sourcePart then
        if sourceAttachment then sourceAttachment:Destroy() end
        sourceAttachment = nil
        sourcePart = root

        if root then
            sourceAttachment = Instance.new("Attachment")
            sourceAttachment.Name = "DX_LaserSource"
            sourceAttachment.Parent = root
        end
    end
end

local hue = 0

RunService.RenderStepped:Connect(function(dt)
    hue = (hue + dt * 0.3) % 1
    local color = Color3.fromHSV(hue, 1, 1)

    updateSource()

    local root = sourcePart
    for obj, data in pairs(targets) do
        if not obj.Parent or not data.part.Parent then
            data.billboard:Destroy()
            if data.beam then data.beam:Destroy() end
            if data.attachment then data.attachment:Destroy() end
            if data.targetAttachment then data.targetAttachment:Destroy() end
            targets[obj] = nil
        else
            local key = data.kind == "Player" and "Players"
                or data.kind == "Fruit" and "Fruits"
                or data.kind == "Mob" and "Mobs"
                or "Bots"

            local enabled = settings[key]
            data.billboard.Enabled = enabled

            local distance = root
                and (root.Position - data.part.Position).Magnitude
                or 0

            data.label.Text = string.format(
                "%s | %.0f studs", obj.Name, distance
            )

            if settings.Laser and enabled and sourceAttachment then
                if not data.beam then
                    data.attachment = Instance.new("Attachment")
                    data.attachment.Name = "DX_LaserTarget"
                    data.attachment.Parent = data.part

                    data.beam = Instance.new("Beam")
                    data.beam.Name = "DX_RainbowLaser"
                    data.beam.Attachment0 = sourceAttachment
                    data.beam.Attachment1 = data.attachment
                    data.beam.Width0 = 0.045
                    data.beam.Width1 = 0.025
                    data.beam.FaceCamera = true
                    data.beam.LightEmission = 1
                    data.beam.Parent = data.part
                end

                data.beam.Attachment0 = sourceAttachment
                data.beam.Color = ColorSequence.new(color)
                data.beam.Enabled = true
            elseif data.beam then
                data.beam.Enabled = false
            end
        end
    end
end)

print("DX TAME BETA loaded")
