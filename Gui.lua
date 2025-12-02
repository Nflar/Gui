-- GuiLib.lua
local GuiLib = {}
GuiLib.__index = GuiLib

-----------------------------------------------------
-- Create Window
-----------------------------------------------------
function GuiLib:CreateWindow(title)
    local self = setmetatable({}, GuiLib)

    local player = game.Players.LocalPlayer
    local screen = Instance.new("ScreenGui")
    screen.Name = title or "GuiWindow"
    screen.Parent = player:WaitForChild("PlayerGui")

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 500, 0, 330)
    main.Position = UDim2.new(0.5, -250, 0.5, -165)
    main.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    main.Parent = screen

    local top = Instance.new("TextLabel")
    top.Size = UDim2.new(1, 0, 0, 35)
    top.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    top.Text = title
    top.TextColor3 = Color3.fromRGB(255, 255, 255)
    top.Font = Enum.Font.GothamBold
    top.TextSize = 18
    top.Parent = main

    local tabs = Instance.new("Frame")
    tabs.Size = UDim2.new(0, 120, 1, -35)
    tabs.Position = UDim2.new(0, 0, 0, 35)
    tabs.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    tabs.Parent = main

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.Padding = UDim.new(0, 5)
    tabLayout.Parent = tabs

    local pageHolder = Instance.new("Folder")
    pageHolder.Parent = main

    self.screen = screen
    self.main = main
    self.tabs = tabs
    self.pageHolder = pageHolder

    return self
end

-----------------------------------------------------
-- Create Tab
-----------------------------------------------------
function GuiLib:CreateTab(name)
    local tab = {}

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Parent = self.tabs

    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, -120, 1, -35)
    page.Position = UDim2.new(0, 120, 0, 35)
    page.Visible = false
    page.BackgroundTransparency = 1
    page.Parent = self.main

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.Parent = page

    btn.MouseButton1Click:Connect(function()
        for _, p in ipairs(self.main:GetChildren()) do
            if p:IsA("Frame") and p ~= page then
                p.Visible = false
            end
        end
        page.Visible = true
    end)

    -------------------------------------------------
    -- Label
    -------------------------------------------------
    function tab:Label(text)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -10, 0, 30)
        lbl.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
        lbl.Text = text
        lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 14
        lbl.Parent = page
        return lbl
    end

    -------------------------------------------------
    -- Button
    -------------------------------------------------
    function tab:Button(text, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 30)
        btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        btn.Text = text
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 14
        btn.Parent = page
        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    -------------------------------------------------
    -- Toggle
    -------------------------------------------------
    function tab:Toggle(text, callback)
        local t = Instance.new("TextButton")
        t.Size = UDim2.new(1, -10, 0, 30)
        t.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        t.Text = text .. ": OFF"
        t.TextColor3 = Color3.fromRGB(255, 255, 255)
        t.Font = Enum.Font.Gotham
        t.TextSize = 14
        t.Parent = page

        local state = false
        t.MouseButton1Click:Connect(function()
            state = not state
            t.Text = text .. ": " .. (state and "ON" or "OFF")
            callback(state)
        end)

        return t
    end

    -------------------------------------------------
    -- TextBox
    -------------------------------------------------
    function tab:TextBox(placeholder, callback)
        local box = Instance.new("TextBox")
        box.Size = UDim2.new(1, -10, 0, 30)
        box.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        box.Text = ""
        box.PlaceholderText = placeholder
        box.TextColor3 = Color3.fromRGB(255, 255, 255)
        box.Font = Enum.Font.Gotham
        box.TextSize = 14
        box.Parent = page

        box.FocusLost:Connect(function(enter)
            if enter then
                callback(box.Text)
            end
        end)

        return box
    end

    -------------------------------------------------
    -- Slider
    -------------------------------------------------
    function tab:Slider(text, min, max, default, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -10, 0, 40)
        frame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        frame.Parent = page

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 0, 20)
        label.BackgroundTransparency = 1
        label.Text = text .. ": " .. default
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Font = Enum.Font.Gotham
        label.TextSize = 14
        label.Parent = frame

        local back = Instance.new("Frame")
        back.Size = UDim2.new(1, -10, 0, 10)
        back.Position = UDim2.new(0, 5, 0, 25)
        back.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        back.Parent = frame

        local knob = Instance.new("Frame")
        knob.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        knob.Parent = back

        back.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local moveConn, releaseConn

                moveConn = game:GetService("UserInputService").InputChanged:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseMovement then
                        local rel = math.clamp(
                            (i.Position.X - back.AbsolutePosition.X) / back.AbsoluteSize.X,
                            0, 1
                        )
                        knob.Size = UDim2.new(rel, 0, 1, 0)
                        local value = math.floor(min + (max - min) * rel)
                        label.Text = text .. ": " .. value
                        callback(value)
                    end
                end)

                releaseConn = game:GetService("UserInputService").InputEnded:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 then
                        moveConn:Disconnect()
                        releaseConn:Disconnect()
                    end
                end)
            end
        end)

        return frame
    end

    return tab
end

return GuiLib
