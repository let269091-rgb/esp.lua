
-- DX TAME BETA V2 | INDEPENDENT ESP CONTROLS
-- Roblox Studio - game thử nghiệm do bạn quản lý

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local me = Players.LocalPlayer
local pg = me:WaitForChild("PlayerGui")

local old = pg:FindFirstChild("DX_TAME_BETA_V2")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "DX_TAME_BETA_V2"
gui.ResetOnSpawn = false
gui.Parent = pg

local settings = {
    Fruit = true,
    Laser = false,
    Player = false,
    Mob = false,
    Bot = false,
}

local function round(obj, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r)
    c.Parent = obj
end

local function outline(obj)
    local s = Instance.new("UIStroke")
    s.Color = Color3.fromRGB(90, 150, 255)
    s.Thickness = 1.5
    s.Parent = obj
end

-- Menu kính trong suốt
local menu = Instance.new("Frame")
menu.Name = "MainMenu"
menu.Size = UDim2.fromOffset(285, 335)
menu.Position = UDim2.new(0.5, -142, 0.3, 0)
menu.BackgroundColor3 = Color3.fromRGB(15, 20, 40)
menu.BackgroundTransparency = 0.2
menu.BorderSizePixel = 0
menu.Parent = gui
round(menu, 14)
outline(menu)

local header = Instance.new("TextLabel")
header.Size = UDim2.new(1, -50, 0, 44)
header.Position = UDim2.fromOffset(12, 0)
header.BackgroundTransparency = 1
header.Text = "DX TAME BETA"
header.TextColor3 = Color3.fromRGB(120, 220, 255)
header.Font = Enum.Font.GothamBold
header.TextSize = 18
header.TextXAlignment = Enum.TextXAlignment.Left
header.Parent = menu

local collapse = Instance.new("TextButton")
collapse.Size = UDim2.fromOffset(34, 30)
collapse.Position = UDim2.new(1, -40, 0, 7)
collapse.Text = "—"
collapse.TextColor3 = Color3.new(1, 1, 1)
collapse.BackgroundColor3 = Color3.fromRGB(45, 55, 90)
collapse.Parent = menu
round(collapse, 8)

local floating = Instance.new("TextButton")
floating.Name = "FloatingDX"
floating.Size = UDim2.fromOffset(58, 58)
floating.Position = menu.Position
floating.Text = "DX"
floating.Font = Enum.Font.GothamBold
floating.TextSize = 18
floating.TextColor3 = Color3.new(1, 1, 1)
floating.BackgroundColor3 = Color3.fromRGB(35, 60, 145)
floating.Visible = false
floating.Parent = gui
round(floating, 29)
outline(floating)

-- Kéo thả bằng chuột hoặc cảm ứng
local function makeDraggable(obj, handle)
    local dragging = false
    local startInput, startPosition
    local moved = false

    handle.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
        and input.UserInputType ~= Enum.UserInputType.Touch then
            return
        end

        dragging = true
        moved = false
        startInput = input.Position
        startPosition = obj.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end)

    UIS.InputChanged:Connect(function(input)
        if not dragging then return end

        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            local d = input.Position - startInput
            if d.Magnitude > 5 then moved = true end

            obj.Position = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + d.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + d.Y
            )
        end
    end)

    return function() return moved end
end

makeDraggable(menu, header)
local floatingMoved = makeDraggable(floating, floating)

collapse.Activated:Connect(function()
    floating.Position = menu.Position
    menu.Visible = false
    floating.Visible = true
end)

floating.Activated:Connect(function()
    if floatingMoved() then return end
    menu.Position = floating.Position
    floating.Visible = false
    menu.Visible = true
end)

-- Công tắc riêng cho từng chức năng
local rows = {}
local order = {
    {"Fruit", "FRUIT ESP"},
    {"Laser", "RAINBOW LASER"},
    {"Player", "PLAYER ESP"},
    {"Mob", "MOB ESP"},
    {"Bot", "NPC / BOT ESP"},
}

local function refresh(key)
    local b = rows[key]
    b.Text = order[({Fruit=1,Laser=2,Player=3,Mob=4,Bot=5})[key]][2]
        .. " : " .. (settings[key] and "ON" or "OFF")

    b.BackgroundColor3 = settings[key]
        and Color3.fromRGB(32, 80, 88)
        or Color3.fromRGB(35, 40, 65)
end

for i, item in ipairs(order) do
    local key, title = item[1], item[2]

    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -24, 0, 40)
    b.Position = UDim2.fromOffset(12, 49 + (i - 1) * 45)
    b.BackgroundColor3 = Color3.fromRGB(32, 80, 88)
    b.BackgroundTransparency = 0.12
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    b.Parent = menu
    round(b, 8)

    rows[key] = b
    refresh(key)

    b.Activated:Connect(function()
        settings[key] = not settings[key]
        refresh(key)
    end)
end

local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, -20, 0, 30)
footer.Position = UDim2.fromOffset(10, 282)
footer.BackgroundTransparency = 1
footer.Text = "Independent switches | Studio"
footer.TextColor3 = Color3.fromRGB(145, 175, 220)
footer.Font = Enum.Font.Gotham
footer.TextSize = 11
footer.Parent = menu

-- ESP demo: đánh dấu mục tiêu bằng Attribute DXType
-- Giá trị hỗ trợ: Fruit, Player, Mob, Bot.
local tracked = {}

local function getPart(obj)
    if obj:IsA("BasePart") then return obj end
    if obj:IsA("Model") then
        return obj.PrimaryPart
            or obj:FindFirstChildWhichIsA("BasePart", true)
    end
end

local function register(obj)
    if tracked[obj] then return end
    if not (obj:IsA("Model") or obj:IsA("BasePart")) then
        return
    end

    local kind = obj:GetAttribute("DXType")
    if not settings[kind] then return end

    local part = getPart(obj)
    if not part then return end

    local bb = Instance.new("BillboardGui")
    bb.Name = "DX_ESP"
    bb.Adornee = part
    bb.Size = UDim2.fromOffset(220, 34)
    bb.StudsOffset = Vector3.new(0, 3, 0)
    bb.AlwaysOnTop = true
    bb.Parent = gui

    local label = Instance.new("TextLabel")
    label.Size = UDim2.fromScale(1, 1)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(120, 255, 190)
    label.TextStrokeTransparency = 0.15
    label.Font = Enum.Font.GothamBold
    label.TextSize = 13
    label.Parent = bb

    tracked[obj] = {
        kind = kind,
        part = part,
        bb = bb,
        label = label,
    }
end

local function removeTarget(obj)
    local d = tracked[obj]
    if not d then return end
    d.bb:Destroy()
    tracked[obj] = nil
end

for _, obj in ipairs(workspace:GetDescendants()) do
    register(obj)
end

workspace.DescendantAdded:Connect(register)
workspace.DescendantRemoving:Connect(removeTarget)

-- Cập nhật trạng thái và khoảng cách
RunService.RenderStepped:Connect(function()
    local char = me.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")

    for obj, d in pairs(tracked) do
        if not obj.Parent or not d.part.Parent then
            removeTarget(obj)
        else
            d.bb.Enabled = settings[d.kind]

            local dist = root
                and (root.Position - d.part.Position).Magnitude
                or 0

            d.label.Text = string.format(
                "%s | %.0f studs", obj.Name, dist
            )
        end
    end
end)

print("[DX TAME BETA V2] Loaded")
