--[[
    SAMWARE UI LIBRARY (Final Modern Edition)
    Features: Procedural Backgrounds, Smooth Dragging, and Functional Elements.
]]

local MyLibrary = {}
MyLibrary.__index = MyLibrary

-- Services
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Styling
local THEME = {
    Main = Color3.fromRGB(15, 15, 15),
    Accent = Color3.fromRGB(255, 69, 58),
    Text = Color3.fromRGB(255, 255, 255),
    Element = Color3.fromRGB(25, 25, 25)
}

function MyLibrary:CreateWindow(title)
    local Window = setmetatable({}, MyLibrary)
    
    -- Core GUI
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Samware_v1"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
    ScreenGui.Parent = game:GetService("CoreGui")
    
    -- Main Card
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 500, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
    MainFrame.BackgroundColor3 = THEME.Main
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
    
    -- Header / Drag Handle
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 50)
    Header.BackgroundTransparency = 1
    Header.Parent = MainFrame

    -- Title Text
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text = title:upper() .. "."
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 24
    TitleLabel.TextColor3 = THEME.Text
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 20, 0.5, -12)
    TitleLabel.Size = UDim2.new(0, 100, 0, 24)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Header

    -- Element Container (The "Stuff" goes here)
    local Container = Instance.new("ScrollingFrame")
    Container.Name = "Container"
    Container.Size = UDim2.new(1, -40, 1, -80)
    Container.Position = UDim2.new(0, 20, 0, 70)
    Container.BackgroundTransparency = 1
    Container.BorderSizePixel = 0
    Container.ScrollBarThickness = 0
    Container.CanvasSize = UDim2.new(0, 0, 0, 0)
    Container.Parent = MainFrame

    local Layout = Instance.new("UIListLayout", Container)
    Layout.Padding = UDim.new(0, 10)
    Layout.SortOrder = Enum.SortOrder.LayoutOrder

    -- Automatic Canvas Scaling
    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Container.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y)
    end)

    -- Background Canvas
    local Canvas = Instance.new("Frame")
    Canvas.Size = UDim2.new(1, 0, 1, 0)
    Canvas.BackgroundTransparency = 1
    Canvas.ZIndex = 0
    Canvas.Parent = MainFrame

    -- --- DRAGGING LOGIC ---
    local dragging, dragInput, dragStart, startPos
    
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X, 
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    Window.Main = MainFrame
    Window.Canvas = Canvas
    Window.Container = Container
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
    Indicator.Size = UDim2.new(0, 10, 0, 10)
    Indicator.Position = UDim2.new(0, 15, 0.5, -5)
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

-- (Include your ModifyBackground function here as well)
return MyLibrary
