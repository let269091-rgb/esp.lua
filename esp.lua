
-- DX TAME BETA | FRUIT ESP
-- Roblox Studio - LocalScript
-- Menu kéo thả, nút tròn, ESP trái và khoảng cách

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("DX_TAME_BETA")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "DX_TAME_BETA"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local function corner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = obj
end

local function outline(obj, color)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = 1.5
    s.Parent = obj
end

-- Menu
local menu = Instance.new("Frame")
menu.Name = "Menu"
menu.Size = UDim2.fromOffset(285, 245)
menu.Position = UDim2.new(0.5, -142, 0.35, 0)
menu.BackgroundColor3 = Color3.fromRGB(16, 19, 36)
menu.BorderSizePixel = 0
menu.Active = true
menu.Parent = gui
corner(menu, 12)
outline(menu, Color3.fromRGB(105, 100, 255))

-- Header
local header = Instance.new("TextLabel")
header.Size = UDim2.new(1, -48, 0, 42)
header.Position = UDim2.fromOffset(10, 0)
header.BackgroundTransparency = 1
header.Text = "DX TAME BETA"
header.TextColor3 = Color3.fromRGB(130, 175, 255)
header.Font = Enum.Font.GothamBold
header.TextSize = 18
header.TextXAlignment = Enum.TextXAlignment.Left
header.Parent = menu

local minimize = Instance.new("TextButton")
minimize.Size = UDim2.fromOffset(34, 30)
minimize.Position = UDim2.new(1, -40, 0, 6)
minimize.Text = "—"
minimize.Font = Enum.Font.GothamBold
minimize.TextSize = 18
minimize.TextColor3 = Color3.new(1, 1, 1)
minimize.BackgroundColor3 = Color3.fromRGB(49, 52, 82)
minimize.Parent = menu
corner(minimize, 8)

-- Nút tròn
local circle = Instance.new("TextButton")
circle.Name = "DX_FloatingButton"
circle.Size = UDim2.fromOffset(58, 58)
circle.Position = menu.Position
circle.Text = "DX"
circle.Font = Enum.Font.GothamBold
circle.TextSize = 18
circle.TextColor3 = Color3.new(1, 1, 1)
circle.BackgroundColor3 = Color3.fromRGB(43, 48, 135)
circle.Visible = false
circle.Active = true
circle.Parent = gui
corner(circle, 29)
outline(circle, Color3.fromRGB(105, 180, 255))

-- Tạo nút cài đặt
local function makeButton(text, y)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -20, 0, 38)
    b.Position = UDim2.fromOffset(10, y)
    b.BackgroundColor3 = Color3.fromRGB(35, 40, 67)
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamSemibold
    b.TextSize = 13
    b.Text = text
    b.Parent = menu
    corner(b, 8)
    return b
end

local espButton = makeButton("FRUIT ESP : ON", 55)
local nameButton = makeButton("HIỆN TÊN : ON", 101)
local distanceButton = makeButton("KHOẢNG CÁCH : ON", 147)

local info = Instance.new("TextLabel")
info.Size = UDim2.new(1, -20, 0, 32)
info.Position = UDim2.fromOffset(10, 198)
info.BackgroundTransparency = 1
info.Text = "Fruit ESP | Studio"
info.TextColor3 = Color3.fromRGB(165, 175, 205)
info.Font = Enum.Font.Gotham
info.TextSize = 11
info.Parent = menu

-- Kéo thả bằng chuột hoặc cảm ứng
local function draggable(obj, handle)
    local dragging = false
    local startPos, startInput
    local moved = false

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            moved = false
            startInput = input.Position
            startPos = obj.Position

            local ended
            ended = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    ended:Disconnect()
                end
            end)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if not dragging then return end

        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - startInput
            if math.abs(delta.X) + math.abs(delta.Y) > 5 then
                moved = true
            end

            obj.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    return function()
        return moved
    end
end

local menuMoved = draggable(menu, header)
local circleMoved = draggable(circle, circle)

minimize.Activated:Connect(function()
    circle.Position = menu.Position
    menu.Visible = false
    circle.Visible = true
end)

circle.Activated:Connect(function()
    -- Khi vừa kéo nút, không mở menu ngoài ý muốn
    if circleMoved() then return end
    menu.Position = circle.Position
    circle.Visible = false
    menu.Visible = true
end)

-- Cài đặt ESP
local espEnabled = true
local showName = true
local showDistance = true

espButton.Activated:Connect(function()
    espEnabled = not espEnabled
    espButton.Text = espEnabled and "FRUIT ESP : ON"
        or "FRUIT ESP : OFF"
end)

nameButton.Activated:Connect(function()
    showName = not showName
    nameButton.Text = showName and "HIỆN TÊN : ON"
        or "HIỆN TÊN : OFF"
end)

distanceButton.Activated:Connect(function()
    showDistance = not showDistance
    distanceButton.Text = showDistance and "KHOẢNG CÁCH : ON"
        or "KHOẢNG CÁCH : OFF"
end)

-- Tìm các đối tượng trái trong Workspace.
-- Trong game thử nghiệm, đặt tên Model/Part chứa "Fruit"
-- hoặc "Trái" để script nhận diện.
local tracked = {}

local function isFruit(obj)
    local n = string.lower(obj.Name)
    return string.find(n, "fruit", 1, true) ~= nil
        or string.find(n, "trái", 1, true) ~= nil
end

local function getPart(obj)
    if obj:IsA("BasePart") then
        return obj
    end
    if obj:IsA("Model") then
        return obj.PrimaryPart
            or obj:FindFirstChildWhichIsA("BasePart", true)
    end
end

local function addFruit(obj)
    if tracked[obj] or not isFruit(obj) then return end
    if not (obj:IsA("Model") or obj:IsA("BasePart")) then
        return
    end

    local part = getPart(obj)
    if not part then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "DX_FruitESP"
    billboard.Size = UDim2.fromOffset(220, 48)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Adornee = part
    billboard.Enabled = true
    billboard.Parent = gui

    local label = Instance.new("TextLabel")
    label.Size = UDim2.fromScale(1, 1)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(115, 255, 170)
    label.TextStrokeTransparency = 0.2
    label.Font = Enum.Font.GothamBold
    label.TextSize = 13
    label.Parent = billboard

    tracked[obj] = {
        gui = billboard,
        label = label,
        part = part
    }
end

for _, obj in ipairs(workspace:GetDescendants()) do
    addFruit(obj)
end

workspace.DescendantAdded:Connect(addFruit)

workspace.DescendantRemoving:Connect(function(obj)
    local data = tracked[obj]
    if data then
        data.gui:Destroy()
        tracked[obj] = nil
    end
end)

RunService.RenderStepped:Connect(function()
    local character = player.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")

    for obj, data in pairs(tracked) do
        if not obj.Parent or not data.part.Parent then
            data.gui:Destroy()
            tracked[obj] = nil
        else
            data.gui.Enabled = espEnabled

            local text = {}
            if showName then
                table.insert(text, obj.Name)
            end

            if showDistance and root then
                local studs = (root.Position - data.part.Position).Magnitude
                table.insert(text, string.format("%.0f studs", studs))
            end

            data.label.Text = table.concat(text, " | ")
        end
    end
end)
