
--[[
    DX TAME CHEST ESP v1.0
    Creator: HA HUU XUYEN
    Platform: Roblox Studio
    Features:
      - Draggable menu and floating orb
      - Rainbow RGB animation
      - Transparent glass-style interface
      - Chest ESP and distance labels
      - Sorted chest list
      - ESP / Distance / List toggles
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local CollectionService = game:GetService("CollectionService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("DXTAME_CHEST_ESP")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "DXTAME_CHEST_ESP"
gui.ResetOnSpawn = false
gui.DisplayOrder = 100
gui.Parent = playerGui

local function make(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props) do
        obj[k] = v
    end
    obj.Parent = parent
    return obj
end

local function round(obj, radius)
    make("UICorner", {
        CornerRadius = UDim.new(0, radius)
    }, obj)
end

local function outline(obj)
    return make("UIStroke", {
        Thickness = 2,
        Color = Color3.fromRGB(0, 255, 255),
        Transparency = 0.05
    }, obj)
end

local function label(parent, text, size, pos, textSize)
    return make("TextLabel", {
        Size = size,
        Position = pos,
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = textSize,
        Font = Enum.Font.GothamBold,
        TextWrapped = true
    }, parent)
end

local function button(parent, text, y)
    local b = make("TextButton", {
        Position = UDim2.fromOffset(14, y),
        Size = UDim2.new(1, -28, 0, 38),
        BackgroundColor3 = Color3.fromRGB(24, 39, 65),
        BackgroundTransparency = 0.12,
        Text = text,
        TextColor3 = Color3.new(1, 1, 1),
        TextSize = 13,
        Font = Enum.Font.GothamBold
    }, parent)
    round(b, 9)
    outline(b)
    return b
end

-- Main menu
local main = make("Frame", {
    Name = "Main",
    Size = UDim2.fromOffset(310, 365),
    Position = UDim2.new(0.5, -155, 0.5, -182),
    BackgroundColor3 = Color3.fromRGB(10, 18, 35),
    BackgroundTransparency = 0.15,
    BorderSizePixel = 0
}, gui)
round(main, 16)
local mainStroke = outline(main)

local header = make("Frame", {
    Size = UDim2.new(1, 0, 0, 62),
    BackgroundTransparency = 1
}, main)

label(header, "DX TAME  ✦", UDim2.new(1, -55, 0, 30),
    UDim2.fromOffset(14, 5), 22).TextXAlignment =
    Enum.TextXAlignment.Left

label(header, "CHEST ESP • ALL MAP", UDim2.new(1, -20, 0, 20),
    UDim2.fromOffset(14, 35), 11).TextColor3 =
    Color3.fromRGB(100, 220, 255)

local minimize = make("TextButton", {
    Size = UDim2.fromOffset(34, 34),
    Position = UDim2.new(1, -44, 0, 12),
    BackgroundColor3 = Color3.fromRGB(30, 45, 70),
    Text = "—",
    TextColor3 = Color3.new(1, 1, 1),
    TextSize = 20,
    Font = Enum.Font.GothamBold
}, header)
round(minimize, 17)

local status = label(main, "CHEST FOUND: 0",
    UDim2.new(1, -28, 0, 22), UDim2.fromOffset(14, 65), 12)
status.TextXAlignment = Enum.TextXAlignment.Left
status.TextColor3 = Color3.fromRGB(120, 255, 190)

local espButton = button(main, "CHEST ESP: ON", 94)
local distanceButton = button(main, "SHOW DISTANCE: ON", 140)
local listButton = button(main, "CHEST LIST: ON", 186)
local refreshButton = button(main, "REFRESH CHESTS", 232)

label(main, "RELEASED BY HÀ HỮU XUYÊN",
    UDim2.new(1, -20, 0, 30), UDim2.fromOffset(10, 300), 15)

-- Chest list
local listFrame = make("Frame", {
    Name = "ChestList",
    Size = UDim2.fromOffset(245, 230),
    Position = UDim2.new(1, -260, 0.5, -115),
    BackgroundColor3 = Color3.fromRGB(10, 18, 35),
    BackgroundTransparency = 0.13,
    BorderSizePixel = 0
}, gui)
round(listFrame, 13)
local listStroke = outline(listFrame)

local listHeader = label(listFrame, "✦ CHEST LIST",
    UDim2.new(1, -12, 0, 35), UDim2.fromOffset(6, 2), 15)

local scroll = make("ScrollingFrame", {
    Position = UDim2.fromOffset(8, 39),
    Size = UDim2.new(1, -16, 1, -47),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    CanvasSize = UDim2.new()
}, listFrame)

make("UIListLayout", {
    Padding = UDim.new(0, 5),
    SortOrder = Enum.SortOrder.LayoutOrder
}, scroll)

-- Minimized orb
local orb = make("TextButton", {
    Name = "DXOrb",
    Size = UDim2.fromOffset(58, 58),
    Position = UDim2.new(0, 25, 0.5, -29),
    BackgroundColor3 = Color3.fromRGB(12, 20, 42),
    BackgroundTransparency = 0.08,
    Text = "DX",
    TextColor3 = Color3.new(1, 1, 1),
    TextSize = 21,
    Font = Enum.Font.GothamBlack,
    Visible = false
}, gui)
round(orb, 30)
local orbStroke = outline(orb)

-- Drag functionality
local function draggable(handle, target)
    local active = false
    local startInput, startPosition

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            active = true
            startInput = input.Position
            startPosition = target.Position
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if not active then return end

        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - startInput
            target.Position = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            active = false
        end
    end)
end

draggable(header, main)
draggable(orb, orb)
draggable(listHeader, listFrame)

minimize.Activated:Connect(function()
    main.Visible = false
    listFrame.Visible = false
    orb.Visible = true
end)

orb.Activated:Connect(function()
    main.Visible = true
    listFrame.Visible = true
    orb.Visible = false
end)

-- Chest detection
local espEnabled = true
local distanceEnabled = true
local listEnabled = true
local tracked = {}
local refreshRequested = false

local function getPart(obj)
    if obj:IsA("BasePart") then
        return obj
    end
    if obj:IsA("Model") and obj.PrimaryPart then
        return obj.PrimaryPart
    end
    return obj:FindFirstChildWhichIsA("BasePart", true)
end

local function isChest(obj)
    if not (obj:IsA("Model") or obj:IsA("BasePart")) then
        return false
    end

    if CollectionService:HasTag(obj, "Chest") then
        return true
    end

    return string.find(string.lower(obj.Name), "chest", 1, true)
        ~= nil
end

local function clearEntry(obj)
    local e = tracked[obj]
    if not e then return end
    if e.billboard then e.billboard:Destroy() end
    if e.highlight then e.highlight:Destroy() end
    tracked[obj] = nil
end

local function createEntry(obj)
    local part = getPart(obj)
    if not part then return end

    local billboard = make("BillboardGui", {
        Name = "DXTAME_ChestLabel",
        Adornee = part,
        Size = UDim2.fromOffset(160, 42),
        StudsOffset = Vector3.new(0, 2.5, 0),
        AlwaysOnTop = true,
        Enabled = espEnabled
    }, playerGui)

    local text = make("TextLabel", {
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.fromRGB(10, 15, 30),
        BackgroundTransparency = 0.2,
        Text = obj.Name,
        TextColor3 = Color3.new(1, 1, 1),
        TextStrokeTransparency = 0.25,
        TextSize = 13,
        Font = Enum.Font.GothamBold
    }, billboard)
    round(text, 8)

    local textStroke = outline(text)

    local highlight = make("Highlight", {
        Name = "DXTAME_ChestHighlight",
        Adornee = obj,
        FillTransparency = 0.8,
        OutlineTransparency = 0,
        Enabled = espEnabled,
        DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    }, obj)

    tracked[obj] = {
        obj = obj,
        part = part,
        billboard = billboard,
        label = text,
        stroke = textStroke,
        highlight = highlight
    }
end

local function refresh()
    for obj in pairs(tracked) do
        if not obj:IsDescendantOf(workspace) then
            clearEntry(obj)
        end
    end

    for _, obj in ipairs(workspace:GetDescendants()) do
        if isChest(obj) and not tracked[obj] then
            createEntry(obj)
        end
    end

    for _, obj in ipairs(CollectionService:GetTagged("Chest")) do
        if obj:IsDescendantOf(workspace) and not tracked[obj] then
            createEntry(obj)
        end
    end

    refreshRequested = false
end

local function updateList()
    for _, child in ipairs(scroll:GetChildren()) do
        if child:IsA("TextLabel") then
            child:Destroy()
        end
    end

    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local items = {}

    if root then
        for obj, entry in pairs(tracked) do
            if obj:IsDescendantOf(workspace)
                and entry.part:IsDescendantOf(workspace) then
                table.insert(items, {
                    entry = entry,
                    distance = (root.Position -
                        entry.part.Position).Magnitude
                })
            end
        end
    end

    table.sort(items, function(a, b)
        return a.distance < b.distance
    end)

    status.Text = "CHEST FOUND: " .. #items

    for i, item in ipairs(items) do
        local row = make("TextLabel", {
            Size = UDim2.new(1, -4, 0, 30),
            BackgroundColor3 = Color3.fromRGB(25, 40, 65),
            BackgroundTransparency = 0.2,
            Text = string.format("%02d  %s  •  %dm",
                i,
                item.entry.obj.Name,
                math.floor(item.distance + 0.5)),
            TextColor3 = Color3.new(1, 1, 1),
            TextSize = 11,
            Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
            LayoutOrder = i
        }, scroll)
        round(row, 6)
    end
end

espButton.Activated:Connect(function()
    espEnabled = not espEnabled
    espButton.Text = "CHEST ESP: " .. (espEnabled and "ON" or "OFF")

    for _, e in pairs(tracked) do
        e.billboard.Enabled = espEnabled
        e.highlight.Enabled = espEnabled
    end
end)

distanceButton.Activated:Connect(function()
    distanceEnabled = not distanceEnabled
    distanceButton.Text =
        "SHOW DISTANCE: " .. (distanceEnabled and "ON" or "OFF")
end)

listButton.Activated:Connect(function()
    listEnabled = not listEnabled
    listButton.Text =
        "CHEST LIST: " .. (listEnabled and "ON" or "OFF")
    listFrame.Visible = listEnabled and main.Visible
end)

refreshButton.Activated:Connect(function()
    refreshRequested = true
    refresh()
    updateList()
end)

-- Rainbow animation and live updates
local hue = 0
local listTimer = 0

RunService.RenderStepped:Connect(function(dt)
    hue = (hue + dt * 0.22) % 1
    local rainbow = Color3.fromHSV(hue, 1, 1)

    mainStroke.Color = rainbow
    orbStroke.Color = Color3.fromHSV((hue + 0.2) % 1, 1, 1)
    listStroke.Color = Color3.fromHSV((hue + 0.4) % 1, 1, 1)

    for _, e in pairs(tracked) do
        e.stroke.Color = rainbow
        e.highlight.OutlineColor = rainbow
        e.highlight.FillColor = rainbow

        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")

        if root and e.part:IsDescendantOf(workspace) then
            local d = (root.Position - e.part.Position).Magnitude
            if distanceEnabled then
                e.label.Text = string.format("%s\n%dm",
                    e.obj.Name, math.floor(d + 0.5))
            else
                e.label.Text = e.obj.Name
            end
        end
    end

    if refreshRequested then
        refresh()
    end

    listTimer += dt
    if listTimer >= 1 then
        listTimer = 0
        if listEnabled then
            updateList()
        end
    end
end)

workspace.DescendantAdded:Connect(function(obj)
    if isChest(obj) then
        refreshRequested = true
    end
end)

workspace.DescendantRemoving:Connect(function(obj)
    if tracked[obj] then
        clearEntry(obj)
        refreshRequested = true
    end
end)

refresh()
updateList()

print("DX TAME CHEST ESP | HÀ HỮU XUYÊN | Loaded")
