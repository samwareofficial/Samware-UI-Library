--[[
    SAM UI LIBRARY (Procedural Lua Edition)
    Description: Backgrounds are now generated and animated via Luau scripts.
]]

local MyLibrary = {}
MyLibrary.__index = MyLibrary

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local THEME = {
    CardColor = Color3.fromRGB(15, 15, 15),
    AccentColor = Color3.fromRGB(255, 69, 58),
    TextMain = Color3.fromRGB(255, 255, 255)
}

function MyLibrary:CreateWindow(title)
    local Window = setmetatable({}, MyLibrary)
    
    -- UI Setup
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SAM_Procedural_UI"
    ScreenGui.Parent = game:GetService("CoreGui")
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 550, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
    MainFrame.BackgroundColor3 = THEME.CardColor
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 14)
    Corner.Parent = MainFrame
    
    -- Header
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text = title:upper() .. "."
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 28
    TitleLabel.TextColor3 = THEME.TextMain
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0.05, 0, 0.05, 0)
    TitleLabel.Size = UDim2.new(0, 200, 0, 40)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.ZIndex = 10
    TitleLabel.Parent = MainFrame
    
    -- Background Canvas
    local Canvas = Instance.new("Frame")
    Canvas.Name = "Canvas"
    Canvas.Size = UDim2.new(1, 0, 1, 0)
    Canvas.BackgroundTransparency = 1
    Canvas.ZIndex = 1
    Canvas.Parent = MainFrame
    
    Window.Canvas = Canvas
    Window.CurrentRender = nil -- Holds the connection for the animation loop
    
    return Window
end

-- --- Procedural Background Logic ---

function MyLibrary:ModifyBackground(style)
    -- Clear previous animations and objects
    if self.CurrentRender then self.CurrentRender:Disconnect() end
    self.Canvas:ClearAllChildren()
    
    if style == "Bubbles" then
        -- Logic: Create circles that float upwards and reset
        local bubbles = {}
        for i = 1, 15 do
            local b = Instance.new("Frame")
            b.Size = UDim2.new(0, math.random(5, 15), 0, math.random(5, 15))
            b.Position = UDim2.new(math.random(), 0, 1, 0)
            b.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            b.BackgroundTransparency = 0.8
            b.BorderSizePixel = 0
            b.Parent = self.Canvas
            Instance.new("UICorner", b).CornerRadius = UDim.new(1, 0)
            
            table.insert(bubbles, {obj = b, speed = math.random(10, 30) / 1000})
        end
        
        self.CurrentRender = RunService.RenderStepped:Connect(function()
            for _, bData in pairs(bubbles) do
                local newY = bData.obj.Position.Y.Scale - bData.speed
                if newY < -0.1 then newY = 1.1 end -- Reset to bottom
                bData.obj.Position = UDim2.new(bData.obj.Position.X.Scale, 0, newY, 0)
            end
        end)

    elseif style == "Fluids" then
        -- Logic: A slow moving gradient or "blob" effect using UI Gradient
        local FluidFrame = Instance.new("Frame")
        FluidFrame.Size = UDim2.new(1.5, 0, 1.5, 0)
        FluidFrame.Position = UDim2.new(-0.25, 0, -0.25, 0)
        FluidFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        FluidFrame.Parent = self.Canvas
        
        local Gradient = Instance.new("UIGradient")
        Gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 20, 40)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(40, 20, 60)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 40))
        })
        Gradient.Parent = FluidFrame
        
        self.CurrentRender = RunService.RenderStepped:Connect(function()
            Gradient.Rotation = Gradient.Rotation + 0.5 -- Rotate the "fluid"
        end)
        
    elseif style == "Flames" then
        -- Logic: Glowing orange/red frames that flicker
        local light = Instance.new("ImageLabel")
        light.Size = UDim2.new(1, 0, 1, 0)
        light.BackgroundTransparency = 1
        light.Image = "rbxassetid://12415174488" -- Soft Glow Asset
        light.ImageColor3 = Color3.fromRGB(255, 80, 0)
        light.Parent = self.Canvas
        
        self.CurrentRender = RunService.RenderStepped:Connect(function()
            light.ImageTransparency = 0.7 + (math.random(-10, 10) / 100) -- Flicker effect
        end)
    end
end

return MyLibrary
