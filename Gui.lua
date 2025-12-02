-- Gui.lua
local Lib = {}
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled
local scale = isMobile and 1.2 or 1

local function tween(obj, props, time)
    TS:Create(obj, TweenInfo.new(time or 0.2, Enum.EasingStyle.Quad), props):Play()
end

function Lib:CreateWindow(title)
    local sg = Instance.new("ScreenGui")
    sg.Name = "GUI_" .. tick()
    sg.ResetOnSpawn = false
    sg.Parent = game.CoreGui
    
    local main = Instance.new("Frame", sg)
    main.Size = UDim2.new(0, 500*scale, 0, 400*scale)
    main.Position = UDim2.new(0.5, -250*scale, 0.5, -200*scale)
    main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    main.BorderSizePixel = 0
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)
    
    local bar = Instance.new("Frame", main)
    bar.Size = UDim2.new(1, 0, 0, 40*scale)
    bar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    bar.BorderSizePixel = 0
    Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 8)
    
    local lbl = Instance.new("TextLabel", bar)
    lbl.Size = UDim2.new(1, -100, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = title or "GUI"
    lbl.TextColor3 = Color3.new(1, 1, 1)
    lbl.TextSize = 16*scale
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    
    local close = Instance.new("TextButton", bar)
    close.Size = UDim2.new(0, 30*scale, 0, 30*scale)
    close.Position = UDim2.new(1, -35*scale, 0.5, -15*scale)
    close.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    close.Text = "×"
    close.TextColor3 = Color3.new(1, 1, 1)
    close.TextSize = 20*scale
    close.Font = Enum.Font.GothamBold
    close.BorderSizePixel = 0
    Instance.new("UICorner", close).CornerRadius = UDim.new(0, 6)
    close.MouseButton1Click:Connect(function()
        tween(main, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        task.wait(0.3)
        sg:Destroy()
    end)
    
    local min = Instance.new("TextButton", bar)
    min.Size = UDim2.new(0, 30*scale, 0, 30*scale)
    min.Position = UDim2.new(1, -70*scale, 0.5, -15*scale)
    min.BackgroundColor3 = Color3.fromRGB(255, 180, 60)
    min.Text = "−"
    min.TextColor3 = Color3.new(1, 1, 1)
    min.TextSize = 20*scale
    min.Font = Enum.Font.GothamBold
    min.BorderSizePixel = 0
    Instance.new("UICorner", min).CornerRadius = UDim.new(0, 6)
    
    local minimized = false
    local origSize = main.Size
    min.MouseButton1Click:Connect(function()
        minimized = not minimized
        tween(main, {Size = minimized and UDim2.new(0, 500*scale, 0, 40*scale) or origSize})
    end)
    
    local drag, dragStart, startPos
    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            drag = true
            dragStart = input.Position
            startPos = main.Position
        end
    end)
    bar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            drag = false
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if drag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    local content = Instance.new("ScrollingFrame", main)
    content.Size = UDim2.new(1, -20, 1, -60*scale)
    content.Position = UDim2.new(0, 10, 0, 50*scale)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 4
    
    local layout = Instance.new("UIListLayout", content)
    layout.Padding = UDim.new(0, 8)
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        content.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end)
    
    local win = {}
    
    function win:AddButton(text, callback)
        local btn = Instance.new("TextButton", content)
        btn.Size = UDim2.new(1, -10, 0, 35*scale)
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        btn.Text = text
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.TextSize = 14*scale
        btn.Font = Enum.Font.Gotham
        btn.BorderSizePixel = 0
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        btn.MouseButton1Click:Connect(function()
            tween(btn, {BackgroundColor3 = Color3.fromRGB(70, 130, 255)}, 0.1)
            task.wait(0.1)
            tween(btn, {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}, 0.1)
            if callback then callback() end
        end)
        return btn
    end
    
    function win:AddCheckbox(text, default, callback)
        local frame = Instance.new("Frame", content)
        frame.Size = UDim2.new(1, -10, 0, 35*scale)
        frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        frame.BorderSizePixel = 0
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
        
        local label = Instance.new("TextLabel", frame)
        label.Size = UDim2.new(1, -40, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.new(1, 1, 1)
        label.TextSize = 14*scale
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        
        local check = Instance.new("TextButton", frame)
        check.Size = UDim2.new(0, 25*scale, 0, 25*scale)
        check.Position = UDim2.new(1, -30*scale, 0.5, -12.5*scale)
        check.BackgroundColor3 = default and Color3.fromRGB(70, 130, 255) or Color3.fromRGB(60, 60, 60)
        check.Text = default and "✓" or ""
        check.TextColor3 = Color3.new(1, 1, 1)
        check.TextSize = 16*scale
        check.Font = Enum.Font.GothamBold
        check.BorderSizePixel = 0
        Instance.new("UICorner", check).CornerRadius = UDim.new(0, 4)
        
        local checked = default or false
        check.MouseButton1Click:Connect(function()
            checked = not checked
            check.Text = checked and "✓" or ""
            tween(check, {BackgroundColor3 = checked and Color3.fromRGB(70, 130, 255) or Color3.fromRGB(60, 60, 60)})
            if callback then callback(checked) end
        end)
        return frame
    end
    
    function win:AddLabel(text)
        local label = Instance.new("TextLabel", content)
        label.Size = UDim2.new(1, -10, 0, 30*scale)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(200, 200, 200)
        label.TextSize = 14*scale
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        return label
    end
    
    function win:AddTabs()
        local tabs = {Tabs = {}}
        local tabBar = Instance.new("Frame", content)
        tabBar.Size = UDim2.new(1, -20, 0, 35*scale)
        tabBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        tabBar.BorderSizePixel = 0
        Instance.new("UICorner", tabBar).CornerRadius = UDim.new(0, 6)
        local tabLayout = Instance.new("UIListLayout", tabBar)
        tabLayout.FillDirection = Enum.FillDirection.Horizontal
        tabLayout.Padding = UDim.new(0, 5)
        
        function tabs:AddTab(name)
            local btn = Instance.new("TextButton", tabBar)
            btn.Size = UDim2.new(0, 100*scale, 1, -10)
            btn.Position = UDim2.new(0, 0, 0, 5)
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            btn.Text = name
            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            btn.TextSize = 13*scale
            btn.Font = Enum.Font.Gotham
            btn.BorderSizePixel = 0
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
            
            local tabContent = Instance.new("ScrollingFrame", content)
            tabContent.Size = UDim2.new(1, -10, 1, -95*scale)
            tabContent.Position = UDim2.new(0, 5, 0, 90*scale)
            tabContent.BackgroundTransparency = 1
            tabContent.BorderSizePixel = 0
            tabContent.ScrollBarThickness = 4
            tabContent.Visible = false
            
            local tabLayout = Instance.new("UIListLayout", tabContent)
            tabLayout.Padding = UDim.new(0, 8)
            tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                tabContent.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y + 10)
            end)
            
            btn.MouseButton1Click:Connect(function()
                for _, t in pairs(tabs.Tabs) do
                    t.Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                    t.Button.TextColor3 = Color3.fromRGB(200, 200, 200)
                    t.Content.Visible = false
                end
                btn.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
                btn.TextColor3 = Color3.new(1, 1, 1)
                tabContent.Visible = true
            end)
            
            local tab = {Button = btn, Content = tabContent}
            
            function tab:AddButton(text, callback)
                local b = Instance.new("TextButton", tabContent)
                b.Size = UDim2.new(1, -10, 0, 35*scale)
                b.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                b.Text = text
                b.TextColor3 = Color3.new(1, 1, 1)
                b.TextSize = 14*scale
                b.Font = Enum.Font.Gotham
                b.BorderSizePixel = 0
                Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
                b.MouseButton1Click:Connect(function()
                    tween(b, {BackgroundColor3 = Color3.fromRGB(70, 130, 255)}, 0.1)
                    task.wait(0.1)
                    tween(b, {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}, 0.1)
                    if callback then callback() end
                end)
                return b
            end
            
            function tab:AddCheckbox(text, default, callback)
                local f = Instance.new("Frame", tabContent)
                f.Size = UDim2.new(1, -10, 0, 35*scale)
                f.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                f.BorderSizePixel = 0
                Instance.new("UICorner", f).CornerRadius = UDim.new(0, 6)
                
                local l = Instance.new("TextLabel", f)
                l.Size = UDim2.new(1, -40, 1, 0)
                l.Position = UDim2.new(0, 10, 0, 0)
                l.BackgroundTransparency = 1
                l.Text = text
                l.TextColor3 = Color3.new(1, 1, 1)
                l.TextSize = 14*scale
                l.Font = Enum.Font.Gotham
                l.TextXAlignment = Enum.TextXAlignment.Left
                
                local c = Instance.new("TextButton", f)
                c.Size = UDim2.new(0, 25*scale, 0, 25*scale)
                c.Position = UDim2.new(1, -30*scale, 0.5, -12.5*scale)
                c.BackgroundColor3 = default and Color3.fromRGB(70, 130, 255) or Color3.fromRGB(60, 60, 60)
                c.Text = default and "✓" or ""
                c.TextColor3 = Color3.new(1, 1, 1)
                c.TextSize = 16*scale
                c.Font = Enum.Font.GothamBold
                c.BorderSizePixel = 0
                Instance.new("UICorner", c).CornerRadius = UDim.new(0, 4)
                
                local checked = default or false
                c.MouseButton1Click:Connect(function()
                    checked = not checked
                    c.Text = checked and "✓" or ""
                    tween(c, {BackgroundColor3 = checked and Color3.fromRGB(70, 130, 255) or Color3.fromRGB(60, 60, 60)})
                    if callback then callback(checked) end
                end)
                return f
            end
            
            function tab:AddLabel(text)
                local l = Instance.new("TextLabel", tabContent)
                l.Size = UDim2.new(1, -10, 0, 30*scale)
                l.BackgroundTransparency = 1
                l.Text = text
                l.TextColor3 = Color3.fromRGB(200, 200, 200)
                l.TextSize = 14*scale
                l.Font = Enum.Font.Gotham
                l.TextXAlignment = Enum.TextXAlignment.Left
                return l
            end
            
            table.insert(tabs.Tabs, tab)
            if #tabs.Tabs == 1 then
                btn.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
                btn.TextColor3 = Color3.new(1, 1, 1)
                tabContent.Visible = true
            end
            return tab
        end
        return tabs
    end
    return win
end

return Lib
