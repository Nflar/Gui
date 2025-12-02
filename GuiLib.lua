-- GuiLib.lua (Mobile-Friendly & Responsive)
local GuiLib = {}
GuiLib.__index = GuiLib

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Utility for responsive sizing
local function scaleSize(baseSize)
    local viewportSize = workspace.CurrentCamera.ViewportSize
    local scaleFactor = math.clamp(viewportSize.X / 1920, 0.5, 1)
    return baseSize * scaleFactor
end

-- Create Window
function GuiLib:CreateWindow(title)
    local self = setmetatable({}, GuiLib)
    local player = Players.LocalPlayer

    local screen = Instance.new("ScreenGui")
    screen.Name = title or "GuiWindow"
    screen.ResetOnSpawn = false
    screen.Parent = player:WaitForChild("PlayerGui")

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, scaleSize(500), 0, scaleSize(330))
    main.Position = UDim2.new(0.5, 0, 0.5, 0)
    main.AnchorPoint = Vector2.new(0.5, 0.5)
    main.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    main.BorderSizePixel = 0
    main.Parent = screen

    -- Draggable
    local dragging, dragStart, startPos = false, Vector2.new(), UDim2.new()
    main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
        end
    end)
    main.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    main.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    -- Title bar
    local titleBar = Instance.new("TextLabel")
    titleBar.Size = UDim2.new(1, 0, 0, scaleSize(35))
    titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    titleBar.Text = title
    titleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleBar.Font = Enum.Font.GothamBold
    titleBar.TextSize = scaleSize(18)
    titleBar.Parent = main

    -- Tabs container
    local tabs = Instance.new("Frame")
    tabs.Size = UDim2.new(0, scaleSize(120), 1, -scaleSize(35))
    tabs.Position = UDim2.new(0, 0, 0, scaleSize(35))
    tabs.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    tabs.Parent = main

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, scaleSize(5))
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Parent = tabs

    -- Pages container
    local pages = Instance.new("Folder")
    pages.Parent = main

    self.screen = screen
    self.main = main
    self.tabs = tabs
    self.pages = pages
    return self
end

-- Create Tab
function GuiLib:CreateTab(name)
    local tab = {}
    local scaleFactor = 1

    -- Tab button
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -scaleSize(10), 0, scaleSize(30))
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = scaleSize(14)
    btn.Parent = self.tabs

    -- Page
    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.Visible = false
    page.BackgroundTransparency = 1
    page.Parent = self.pages

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, scaleSize(8))
    layout.Parent = page

    btn.MouseButton1Click:Connect(function()
        for _, p in ipairs(self.pages:GetChildren()) do
            p.Visible = false
        end
        page.Visible = true
    end)

    -- Label
    function tab:Label(text)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -scaleSize(10), 0, scaleSize(30))
        lbl.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
        lbl.Text = text
        lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = scaleSize(14)
        lbl.Parent = page
        return lbl
    end

    -- Button
    function tab:Button(text, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -scaleSize(10), 0, scaleSize(30))
        btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = scaleSize(14)
        btn.Parent = page
        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    -- Toggle
    function tab:Toggle(text, callback)
        local t = Instance.new("TextButton")
        t.Size = UDim2.new(1, -scaleSize(10), 0, scaleSize(30))
        t.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        t.Text = text .. ": OFF"
        t.TextColor3 = Color3.fromRGB(255, 255, 255)
        t.Font = Enum.Font.Gotham
        t.TextSize = scaleSize(14)
        t.Parent = page

        local state = false
        t.MouseButton1Click:Connect(function()
            state = not state
            t.Text = text .. ": " .. (state and "ON" or "OFF")
            callback(state)
        end)
        return t
    end

    -- Slider
    function tab:Slider(text, min, max, default, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -scaleSize(10), 0, scaleSize(40))
        frame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        frame.Parent = page

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, scaleSize(20))
        label.BackgroundTransparency = 1
        label.Text = text .. ": " .. default
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Font = Enum.Font.Gotham
        label.TextSize = scaleSize(14)
        label.Parent = frame

        local back = Instance.new("Frame")
        back.Size = UDim2.new(1, -scaleSize(10), 0, scaleSize(10))
        back.Position = UDim2.new(0, scaleSize(5), 0, scaleSize(25))
        back.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        back.Parent = frame

        local knob = Instance.new("Frame")
        knob.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
        knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        knob.Parent = back

        back.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                local moveConn, releaseConn
                moveConn = UserInputService.InputChanged:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
                        local rel = math.clamp((i.Position.X - back.AbsolutePosition.X)/back.AbsoluteSize.X,0,1)
                        knob.Size = UDim2.new(rel,0,1,0)
                        local value = math.floor(min + (max-min)*rel)
                        label.Text = text .. ": " .. value
                        callback(value)
                    end
                end)
                releaseConn = UserInputService.InputEnded:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                        moveConn:Disconnect()
                        releaseConn:Disconnect()
                    end
                end)
            end
        end)
        return frame
    end

    -- TextBox
    function tab:TextBox(placeholder, callback)
        local box = Instance.new("TextBox")
        box.Size = UDim2.new(1, -scaleSize(10), 0, scaleSize(30))
        box.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        box.PlaceholderText = placeholder
        box.Text = ""
        box.TextColor3 = Color3.fromRGB(255, 255, 255)
        box.Font = Enum.Font.Gotham
        box.TextSize = scaleSize(14)
        box.Parent = page

        box.FocusLost:Connect(function(enter)
            if enter then callback(box.Text) end
        end)
        return box
    end

    return tab
end

return GuiLib
