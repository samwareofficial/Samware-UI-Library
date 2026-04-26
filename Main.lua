--[[
    SAMWARE UI LIBRARY
    A high-performance, procedurally animated UI library.
    Features: Smooth Dragging, Scrolling Container, 5 Lua Backgrounds.
]]

local MyLibrary = {}
MyLibrary.__index = MyLibrary

-- Services
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Constants & Styling
local THEME = {
    Main = Color3.fromRGB(12, 12, 12),
    Accent = Color3.fromRGB(255, 69, 58),
    Text = Color3.fromRGB(255, 255, 255),
    Element = Color3.fromRGB(22, 22, 22),
}

function MyLibrary:CreateWindow(title)
    local Window = setmetatable({}, MyLibrary)
    
    -- 1. Main ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Samware_" .. math.random(100,999)
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = game:GetService("CoreGui")
    
    -- 2. Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 500, 0, 380)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -190)
    MainFrame.BackgroundColor3 = THEME.Main
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

    -- 3. Drag Handle / Header Area
    local DragHandle = Instance.new("Frame")
    DragHandle.Name = "DragHandle"
    DragHandle.Size = UDim2.new(1, 0, 0, 60)
    DragHandle.BackgroundTransparency = 1
    DragHandle.ZIndex = 10
    DragHandle.Parent = MainFrame
    
    -- 4. Title Text ("SAM.")
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text = title:upper() .. "."
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 26
    TitleLabel.TextColor3 = THEME.Text
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 25, 0, 20)
    TitleLabel.Size = UDim2.new(0, 200, 0, 40)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.ZIndex = 11
    TitleLabel.Parent = MainFrame
    
    local Dot = Instance.new("Frame")
    Dot.BackgroundColor3 = THEME.Accent
    Dot.Size = UDim2.new(0, 7, 0, 7)
    Dot.Position = UDim2.new(1, 2, 0.65, -3.5)
    Dot.BorderSizePixel = 0
    Dot.Parent = TitleLabel
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

    -- 5. Elements Container
    local Container = Instance.new("ScrollingFrame")
    Container.Name = "Container"
    Container.Size = UDim2.new(1, -50, 1, -110)
    Container.Position = UDim2.new(0, 25, 0, 80)
    Container.BackgroundTransparency = 1
    Container.BorderSizePixel = 0
    Container.ScrollBarThickness = 0
    Container.CanvasSize = UDim2.new(0, 0, 0, 0)
    Container.ZIndex = 5
    Container.Parent = MainFrame

    local Layout = Instance.new("UIListLayout", Container)
    Layout.Padding = UDim.new(0, 10)
    Layout.SortOrder = Enum.SortOrder.LayoutOrder

    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Container.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y)
    end)

    -- 6. Background Canvas
    local Canvas = Instance.new("Frame")
    Canvas.Size = UDim2.new(1, 0, 1, 0)
    Canvas.BackgroundTransparency = 1
    Canvas.ZIndex = 0
    Canvas.Parent = MainFrame

    -- DRAGGING ENGINE
    local dragging, dragInput, dragStart, startPos
    DragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    Window.Canvas = Canvas
    Window.Container = Container
    Window.CurrentConnection = nil
    
    return Window
end

-- METHOD: Create a Toggle
function MyLibrary:CreateToggle(text, callback)
    local ToggleFrame = Instance.new("TextButton")
    ToggleFrame.Size = UDim2.new(1, 0, 0, 45)
    ToggleFrame.BackgroundColor3 = THEME.Element
    ToggleFrame.Text = "      " .. text
    ToggleFrame.Font = Enum.Font.GothamMedium
    ToggleFrame.TextColor3 = THEME.Text
    ToggleFrame.TextSize = 14
    ToggleFrame.TextXAlignment = Enum.TextXAlignment.Left
    ToggleFrame.AutoButtonColor = false
    ToggleFrame.Parent = self.Container
    Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 8)

    local Indicator = Instance.new("Frame")
    Indicator.Size = UDim2.new(0, 8, 0, 8)
    Indicator.Position = UDim2.new(0, 15, 0.5, -4)
    Indicator.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Indicator.Parent = ToggleFrame
    Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)

    local toggled = false
    ToggleFrame.MouseButton1Click:Connect(function()
        toggled = not toggled
        local color = toggled and THEME.Accent or Color3.fromRGB(50, 50, 50)
        TweenService:Create(Indicator, TweenInfo.new(0.2), {BackgroundColor3 = color}):Play()
        callback(toggled)
    end)
end

-- METHOD: Modify Background
function MyLibrary:ModifyBackground(style)
    if self.CurrentConnection then self.CurrentConnection:Disconnect() end
    self.Canvas:ClearAllChildren()
    
    if style == "Flames" then
        self.CurrentConnection = RunService.RenderStepped:Connect(function()
            if math.random(1, 5) == 1 then
                local p = Instance.new("Frame", self.Canvas)
                p.Size = UDim2.new(0, math.random(2, 4), 0, math.random(5, 15))
                p.Position = UDim2.new(math.random(), 0, 1.1, 0)
                p.BackgroundColor3 = Color3.fromRGB(255, math.random(50, 100), 0)
                p.BorderSizePixel = 0
                TweenService:Create(p, TweenInfo.new(1.2), {Position = UDim2.new(p.Position.X.Scale, 0, -0.2, 0), BackgroundTransparency = 1}):Play()
                task.delay(1.3, function() p:Destroy() end)
            end
        end)
    elseif style == "Bubbles" then
        local bubbles = {}
        for i = 1, 10 do
            local b = Instance.new("Frame", self.Canvas)
            b.Size = UDim2.new(0, 8, 0, 8)
            b.BackgroundTransparency = 0.8
            Instance.new("UICorner", b).CornerRadius = UDim.new(1, 0)
            table.insert(bubbles, {obj = b, x = math.random(), y = math.random(), s = math.random(1, 2)/1000})
        end
        self.CurrentConnection = RunService.RenderStepped:Connect(function()
            for _, v in pairs(bubbles) do
                v.y = v.y - v.s
                if v.y < -0.1 then v.y = 1.1 end
                v.obj.Position = UDim2.new(v.x, 0, v.y, 0)
            end
        end)
    elseif style == "Fluids" then
        local f = Instance.new("Frame", self.Canvas)
        f.Size = UDim2.new(1.5, 0, 1.5, 0)
        f.Position = UDim2.new(-0.25, 0, -0.25, 0)
        local g = Instance.new("UIGradient", f)
        g.Color = ColorSequence.new(Color3.fromRGB(20, 20, 30), Color3.fromRGB(40, 40, 60))
        self.CurrentConnection = RunService.RenderStepped:Connect(function() g.Rotation = g.Rotation + 0.2 end)
    elseif style == "Impacts" then
        self.CurrentConnection = RunService.RenderStepped:Connect(function()
            if math.random(1, 50) == 1 then
                local ring = Instance.new("Frame", self.Canvas)
                ring.BackgroundColor3 = THEME.Accent
                ring.AnchorPoint = Vector2.new(0.5, 0.5)
                ring.Position = UDim2.new(math.random(), 0, math.random(), 0)
                Instance.new("UICorner", ring).CornerRadius = UDim.new(1, 0)
                TweenService:Create(ring, TweenInfo.new(0.8), {Size = UDim2.new(0, 100, 0, 100), BackgroundTransparency = 1}):Play()
                task.delay(0.9, function() ring:Destroy() end)
            end
        end)
    elseif style == "BlackHoles" then
        local hole = Instance.new("Frame", self.Canvas)
        hole.Size = UDim2.new(0, 120, 0, 120)
        hole.Position = UDim2.new(0.5, -60, 0.5, -60)
        hole.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        Instance.new("UICorner", hole).CornerRadius = UDim.new(1, 0)
        self.CurrentConnection = RunService.RenderStepped:Connect(function() hole.Rotation = hole.Rotation + 1 end)
    end
end

return MyLibrary
