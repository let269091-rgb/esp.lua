
-- DX TAME BETA | DRAG + CIRCLE MINIMIZE
-- Dùng trong LocalScript của Roblox Studio

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "DXTameBeta"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local menu = Instance.new("Frame")
menu.Size = UDim2.fromOffset(280, 190)
menu.Position = UDim2.new(0.5, -140, 0.5, -95)
menu.BackgroundColor3 = Color3.fromRGB(18, 20, 32)
menu.BorderSizePixel = 0
menu.Active = true
menu.Parent = gui

Instance.new("UICorner", menu).CornerRadius =
    UDim.new(0, 12)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(90, 90, 255)
stroke.Thickness = 2
stroke.Parent = menu

local header = Instance.new("TextLabel")
header.Size = UDim2.new(1, -45, 0, 42)
header.BackgroundTransparency = 1
header.Text = "DX TAME BETA"
header.TextColor3 = Color3.fromRGB(120, 180, 255)
header.Font = Enum.Font.GothamBold
header.TextSize = 17
header.Parent = menu

local minimize = Instance.new("TextButton")
minimize.Size = UDim2.fromOffset(36, 32)
minimize.Position = UDim2.new(1, -40, 0, 5)
minimize.BackgroundColor3 = Color3.fromRGB(45, 48, 75)
minimize.Text = "—"
minimize.TextColor3 = Color3.new(1, 1, 1)
minimize.TextSize = 20
minimize.Parent = menu
Instance.new("UICorner", minimize).CornerRadius =
    UDim.new(0, 8)

local content = Instance.new("Frame")
content.Name = "Content"
content.Position = UDim2.fromOffset(10, 48)
content.Size = UDim2.new(1, -20, 1, -58)
content.BackgroundTransparency = 1
content.Parent = menu

local circle = Instance.new("TextButton")
circle.Name = "OpenMenu"
circle.Size = UDim2.fromOffset(58, 58)
circle.Position = menu.Position
circle.BackgroundColor3 = Color3.fromRGB(45, 55, 150)
circle.Text = "DX"
circle.TextColor3 = Color3.new(1, 1, 1)
circle.Font = Enum.Font.GothamBold
circle.TextSize = 18
circle.Visible = false
circle.Active = true
circle.Parent = gui

Instance.new("UICorner", circle).CornerRadius =
    UDim.new(1, 0)

local circleStroke = Instance.new("UIStroke")
circleStroke.Color = Color3.fromRGB(100, 180, 255)
circleStroke.Thickness = 2
circleStroke.Parent = circle

-- Kéo thả bằng chuột hoặc cảm ứng
local function makeDraggable(object, dragArea)
    local dragging = false
    local dragInput
    local startInput
    local startPosition

    dragArea = dragArea or object

    dragArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            startInput = input.Position
            startPosition = object.Position

            input.Changed:Connect(function()
                if input.UserInputState ==
                    Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dragArea.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input == dragInput
        or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - startInput
            object.Position = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )
        end
    end)
end

makeDraggable(menu, header)
makeDraggable(circle)

minimize.Activated:Connect(function()
    circle.Position = menu.Position
    menu.Visible = false
    circle.Visible = true
end)

circle.Activated:Connect(function()
    menu.Position = circle.Position
    circle.Visible = false
    menu.Visible = true
end)

-- Ví dụ nút ESP; thay bằng chức năng ESP hiện tại của ông
local espButton = Instance.new("TextButton")
espButton.Size = UDim2.new(1, 0, 0, 42)
espButton.Position = UDim2.fromOffset(0, 8)
espButton.BackgroundColor3 = Color3.fromRGB(35, 40, 65)
espButton.TextColor3 = Color3.new(1, 1, 1)
espButton.Font = Enum.Font.GothamBold
espButton.TextSize = 14
espButton.Text = "LASER ESP : OFF"
espButton.Parent = content

Instance.new("UICorner", espButton).CornerRadius =
    UDim.new(0, 8)

local espEnabled = false

espButton.Activated:Connect(function()
    espEnabled = not espEnabled
    espButton.Text = espEnabled
        and "LASER ESP : ON"
        or "LASER ESP : OFF"

    -- Kết nối espEnabled với vòng lặp laser ESP
    -- hiện có của ông để bật/tắt hiệu ứng.
end)
