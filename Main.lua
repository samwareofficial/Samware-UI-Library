--[[
    SAMWARE UI LIBRARY (Element Edition)
    Added: Scrolling Containers & Toggles
]]

local MyLibrary = {}
MyLibrary.__index = MyLibrary

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local THEME = {
    Main = Color3.fromRGB(15, 15, 15),
    Accent = Color3.fromRGB(255, 69, 58),
    Text = Color3.fromRGB(255, 255, 255),
    Element = Color3.fromRGB(30, 30, 30)
}

function MyLibrary:CreateWindow(title)
    local Window = setmetatable({}, MyLibrary)
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Samware_UI"
    ScreenGui.Parent = game:GetService("CoreGui")
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 550, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
    MainFrame.BackgroundColor3 = THEME.Main
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
    
    -- Title Logic
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text = title:upper() .. "."
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 28
    TitleLabel.TextColor3 = THEME.Text
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0.05, 0, 0.05, 0)
    TitleLabel.Size = UDim2.new(0, 200, 0, 40)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.ZIndex = 10
    TitleLabel.Parent = MainFrame

    -- Scrolling Container (Where your Toggles will go)
    local Container = Instance.new("ScrollingFrame")
    Container.Name = "Container"
    Container.Size = UDim2.new(0.9, 0, 0.7, 0)
    Container.Position = UDim2.new(0.05, 0, 0.2, 0)
    Container.BackgroundTransparency = 1
    Container.BorderSizePixel = 0
    Container.ScrollBarThickness = 2
    Container.ZIndex = 5
    Container.Parent = MainFrame

    local Layout = Instance.new("UIListLayout", Container)
    Layout.Padding = UDim.new(0, 8)
    Layout.SortOrder = Enum.SortOrder.LayoutOrder

    -- Background Canvas
    local Canvas = Instance.new("Frame")
    Canvas.Size = UDim2.new(1, 0, 1, 0)
    Canvas.BackgroundTransparency = 1
    Canvas.ZIndex = 1
    Canvas.Parent = MainFrame
    
    Window.Canvas = Canvas
    Window.Container = Container
    Window.CurrentConnection = nil
    
    return Window
end

-- METHOD: Create a Toggle
function MyLibrary:CreateToggle(text, callback)
    local Toggle = Instance.new("TextButton")
    Toggle.Name = text .. "_Toggle"
    Toggle.Size = UDim2.new(1, 0, 0, 40)
    Toggle.BackgroundColor3 = THEME.Element
    Toggle.BorderSizePixel = 0
    Toggle.Text = "  " .. text
    Toggle.TextColor3 = THEME.Text
    Toggle.Font = Enum.Font.Gotham
    TitleLabel.TextSize = 16
    Toggle.TextXAlignment = Enum.TextXAlignment.Left
    Toggle.AutoButtonColor = false
    Toggle.Parent = self.Container

    Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0, 8)

    -- Status Indicator (The Switch)
    local Indicator = Instance.new("Frame")
    Indicator.Size = UDim2.new(0, 30, 0, 15)
    Indicator.Position = UDim2.new(0.9, 0, 0.5, -7)
    Indicator.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Indicator.Parent = Toggle
    Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)

    local Toggled = false
    Toggle.MouseButton1Click:Connect(function()
        Toggled = not Toggled
        local color = Toggled and THEME.Accent or Color3.fromRGB(50, 50, 50)
        TweenService:Create(Indicator, TweenInfo.new(0.2), {BackgroundColor3 = color}):Play()
        callback(Toggled)
    end)
end

-- (Keep your ModifyBackground function below this)
