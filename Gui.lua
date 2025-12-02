local Lib = {}
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled
local scale = isMobile and 1.2 or 1

local function tween(obj, props, time)
    TS:Create(obj, TweenInfo.new(time or 0.2, Enum.EasingStyle.Quad), props):Play()
end

function Lib:CreateWindow(config)
    local title = type(config) == "string" and config or config.Title or "GUI"
    local logoId = type(config) == "table" and config.Logo or nil
    local toggleButtonImage = type(config) == "table" and config.ToggleButton or nil
    
    local sg = Instance.new("ScreenGui")
    sg.Name = "GUI_" .. tick()
    sg.ResetOnSpawn = false
    sg.Parent = game.CoreGui
    
    local toggleBtn
    if isMobile and toggleButtonImage then
        toggleBtn = Instance.new("ImageButton", sg)
        toggleBtn.Size = UDim2.new(0, 60*scale, 0, 60*scale)
        toggleBtn.Position = UDim2.new(0, 10, 0.5, -30*scale)
        toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        toggleBtn.BorderSizePixel = 0
        toggleBtn.Image = toggleButtonImage
        toggleBtn.ScaleType = Enum.ScaleType.Fit
        Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 12)
        
        local drag, dragStart, startPos
        toggleBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                drag = true
                dragStart = input.Position
                startPos = toggleBtn.Position
            end
        end)
        toggleBtn.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch then
                drag = false
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if drag and input.UserInputType == Enum.UserInputType.Touch then
                local delta = input.Position - dragStart
                toggleBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end
    
    local main = Instance.new("Frame", sg)
    main.Size = UDim2.new(0, 700*scale, 0, 500*scale)
    main.Position = UDim2.new(0.5, -350*scale, 0.5, -250*scale)
    main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    main.BorderSizePixel = 0
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)
    
    local sidebar = Instance.new("ScrollingFrame", main)
    sidebar.Size = UDim2.new(0, 180*scale, 1, 0)
    sidebar.Position = UDim2.new(0, 0, 0, 0)
    sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    sidebar.BorderSizePixel = 0
    sidebar.ScrollBarThickness = 4
    sidebar.ScrollBarImageColor3 = Color3.fromRGB(50, 50, 50)
    
    local sidebarCorner = Instance.new("UICorner", sidebar)
    sidebarCorner.CornerRadius = UDim.new(0, 10)
    
    if logoId then
        local logoFrame = Instance.new("Frame", sidebar)
        logoFrame.Size = UDim2.new(1, 0, 0, 60*scale)
        logoFrame.BackgroundTransparency = 1
        
        local logo = Instance.new("ImageLabel", logoFrame)
        logo.Size = UDim2.new(0, 40*scale, 0, 40*scale)
        logo.Position = UDim2.new(0, 15, 0.5, -20*scale)
        logo.BackgroundTransparency = 1
        logo.Image = logoId
        logo.ScaleType = Enum.ScaleType.Fit
        
        local logoText = Instance.new("TextLabel", logoFrame)
        logoText.Size = UDim2.new(1, -65*scale, 1, 0)
        logoText.Position = UDim2.new(0, 60*scale, 0, 0)
        logoText.BackgroundTransparency = 1
        logoText.Text = title
        logoText.TextColor3 = Color3.fromRGB(255, 255, 255)
        logoText.TextSize = 18*scale
        logoText.Font = Enum.Font.GothamBold
        logoText.TextXAlignment = Enum.TextXAlignment.Left
    end
    
    local sidebarLayout = Instance.new("UIListLayout", sidebar)
    sidebarLayout.Padding = UDim.new(0, 8)
    sidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    
    sidebarLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        sidebar.CanvasSize = UDim2.new(0, 0, 0, sidebarLayout.AbsoluteContentSize.Y + 10)
    end)
    
    local topBar = Instance.new("Frame", main)
    topBar.Size = UDim2.new(1, -190*scale, 0, 50*scale)
    topBar.Position = UDim2.new(0, 185*scale, 0, 5)
    topBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    topBar.BorderSizePixel = 0
    Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 8)
    
    local searchBox = Instance.new("TextBox", topBar)
    searchBox.Size = UDim2.new(1, -20, 0, 35*scale)
    searchBox.Position = UDim2.new(0, 10, 0.5, -17.5*scale)
    searchBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    searchBox.PlaceholderText = "Search"
    searchBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
    searchBox.Text = ""
    searchBox.TextColor3 = Color3.fromRGB(200, 200, 200)
    searchBox.TextSize = 14*scale
    searchBox.Font = Enum.Font.Gotham
    searchBox.ClearTextOnFocus = false
    searchBox.BorderSizePixel = 0
    searchBox.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 6)
    
    local searchPadding = Instance.new("UIPadding", searchBox)
    searchPadding.PaddingLeft = UDim.new(0, 35)
    searchPadding.PaddingRight = UDim.new(0, 10)
    
    local searchIcon = Instance.new("ImageLabel", searchBox)
    searchIcon.Size = UDim2.new(0, 18*scale, 0, 18*scale)
    searchIcon.Position = UDim2.new(0, -25, 0.5, -9*scale)
    searchIcon.BackgroundTransparency = 1
    searchIcon.Image = "rbxassetid://7072725342"
    searchIcon.ImageColor3 = Color3.fromRGB(100, 100, 100)
    
    local close = Instance.new("TextButton", main)
    close.Size = UDim2.new(0, 30*scale, 0, 30*scale)
    close.Position = UDim2.new(1, -35*scale, 0, 5)
    close.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    close.Text = "X"
    close.TextColor3 = Color3.fromRGB(255, 255, 255)
    close.TextSize = 16*scale
    close.Font = Enum.Font.GothamBold
    close.BorderSizePixel = 0
    Instance.new("UICorner", close).CornerRadius = UDim.new(0, 6)
    close.MouseButton1Click:Connect(function()
        tween(main, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        task.wait(0.3)
        sg:Destroy()
    end)
    
    local min = Instance.new("TextButton", main)
    min.Size = UDim2.new(0, 30*scale, 0, 30*scale)
    min.Position = UDim2.new(1, -70*scale, 0, 5)
    min.BackgroundColor3 = Color3.fromRGB(255, 180, 60)
    min.Text = "-"
    min.TextColor3 = Color3.fromRGB(255, 255, 255)
    min.TextSize = 20*scale
    min.Font = Enum.Font.GothamBold
    min.BorderSizePixel = 0
    Instance.new("UICorner", min).CornerRadius = UDim.new(0, 6)
    
    local minimized = false
    local origSize = main.Size
    min.MouseButton1Click:Connect(function()
        minimized = not minimized
        tween(main, {Size = minimized and UDim2.new(0, 700*scale, 0, 50*scale) or origSize})
    end)
    
    if toggleBtn then
        toggleBtn.MouseButton1Click:Connect(function()
            main.Visible = not main.Visible
            if main.Visible then
                main.Size = UDim2.new(0, 0, 0, 0)
                tween(main, {Size = origSize}, 0.3)
            end
        end)
    end
    
    local drag, dragStart, startPos
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            drag = true
            dragStart = input.Position
            startPos = main.Position
        end
    end)
    topBar.InputEnded:Connect(function(input)
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
    content.Size = UDim2.new(1, -195*scale, 1, -65*scale)
    content.Position = UDim2.new(0, 185*scale, 0, 60*scale)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 6
    content.ScrollBarImageColor3 = Color3.fromRGB(50, 50, 50)
    
    local layout = Instance.new("UIListLayout", content)
    layout.Padding = UDim.new(0, 8)
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        content.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end)
    
    local win = {searchableItems = {}, tabs = {}, main = main, sidebar = sidebar, content = content, searchBox = searchBox}
    
    local function updateSearch(query)
        query = query:lower()
        for _, item in pairs(win.searchableItems) do
            if query == "" then
                item.element.Visible = true
            else
                item.element.Visible = item.text:lower():find(query) ~= nil
            end
        end
    end
    
    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        updateSearch(searchBox.Text)
    end)
    
    function win:AddButton(text, callback, iconId)
        local btn = Instance.new("TextButton", content)
        btn.Size = UDim2.new(1, -10, 0, 40*scale)
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        btn.Text = iconId and "" or text
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        btn.TextSize = 14*scale
        btn.Font = Enum.Font.Gotham
        btn.BorderSizePixel = 0
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        
        if iconId then
            local icon = Instance.new("ImageLabel", btn)
            icon.Size = UDim2.new(0, 20*scale, 0, 20*scale)
            icon.Position = UDim2.new(0, 10, 0.5, -10*scale)
            icon.BackgroundTransparency = 1
            icon.Image = iconId
            icon.ScaleType = Enum.ScaleType.Fit
            
            local label = Instance.new("TextLabel", btn)
            label.Size = UDim2.new(1, -40*scale, 1, 0)
            label.Position = UDim2.new(0, 35*scale, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = Color3.fromRGB(200, 200, 200)
            label.TextSize = 14*scale
            label.Font = Enum.Font.Gotham
            label.TextXAlignment = Enum.TextXAlignment.Left
        end
        
        btn.MouseButton1Click:Connect(function()
            tween(btn, {BackgroundColor3 = Color3.fromRGB(50, 150, 100)}, 0.1)
            task.wait(0.1)
            tween(btn, {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}, 0.1)
            if callback then callback() end
        end)
        
        table.insert(win.searchableItems, {element = btn, text = text})
        return btn
    end
    
    function win:AddCheckbox(text, default, callback)
        local frame = Instance.new("Frame", content)
        frame.Size = UDim2.new(1, -10, 0, 40*scale)
        frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        frame.BorderSizePixel = 0
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
        
        local label = Instance.new("TextLabel", frame)
        label.Size = UDim2.new(1, -60, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(200, 200, 200)
        label.TextSize = 14*scale
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        
        local toggle = Instance.new("Frame", frame)
        toggle.Size = UDim2.new(0, 45*scale, 0, 24*scale)
        toggle.Position = UDim2.new(1, -55*scale, 0.5, -12*scale)
        toggle.BackgroundColor3 = default and Color3.fromRGB(50, 200, 150) or Color3.fromRGB(60, 60, 60)
        toggle.BorderSizePixel = 0
        Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)
        
        local knob = Instance.new("Frame", toggle)
        knob.Size = UDim2.new(0, 18*scale, 0, 18*scale)
        knob.Position = default and UDim2.new(1, -21*scale, 0.5, -9*scale) or UDim2.new(0, 3, 0.5, -9*scale)
        knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        knob.BorderSizePixel = 0
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
        
        local btn = Instance.new("TextButton", frame)
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.BackgroundTransparency = 1
        btn.Text = ""
        
        local checked = default or false
        btn.MouseButton1Click:Connect(function()
            checked = not checked
            tween(toggle, {BackgroundColor3 = checked and Color3.fromRGB(50, 200, 150) or Color3.fromRGB(60, 60, 60)})
            tween(knob, {Position = checked and UDim2.new(1, -21*scale, 0.5, -9*scale) or UDim2.new(0, 3, 0.5, -9*scale)})
            if callback then callback(checked) end
        end)
        
        table.insert(win.searchableItems, {element = frame, text = text})
        return frame
    end
    
    function win:AddDropdown(text, options, default, callback)
        local frame = Instance.new("Frame", content)
        frame.Size = UDim2.new(1, -10, 0, 40*scale)
        frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        frame.BorderSizePixel = 0
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
        
        local label = Instance.new("TextLabel", frame)
        label.Size = UDim2.new(0.4, 0, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(200, 200, 200)
        label.TextSize = 14*scale
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        
        local dropdown = Instance.new("TextButton", frame)
        dropdown.Size = UDim2.new(0.55, -10, 0, 28*scale)
        dropdown.Position = UDim2.new(0.45, 0, 0.5, -14*scale)
        dropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        dropdown.Text = "  " .. (default or options[1] or "Select")
        dropdown.TextColor3 = Color3.fromRGB(200, 200, 200)
        dropdown.TextSize = 13*scale
        dropdown.Font = Enum.Font.Gotham
        dropdown.TextXAlignment = Enum.TextXAlignment.Left
        dropdown.BorderSizePixel = 0
        Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0, 5)
        
        local arrow = Instance.new("TextLabel", dropdown)
        arrow.Size = UDim2.new(0, 20, 1, 0)
        arrow.Position = UDim2.new(1, -20, 0, 0)
        arrow.BackgroundTransparency = 1
        arrow.Text = "v"
        arrow.TextColor3 = Color3.fromRGB(150, 150, 150)
        arrow.TextSize = 12*scale
        arrow.Font = Enum.Font.GothamBold
        
        local listFrame = Instance.new("Frame", sg)
        listFrame.Size = UDim2.new(0, dropdown.AbsoluteSize.X, 0, math.min(#options * 32*scale, 200*scale))
        listFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        listFrame.BorderSizePixel = 0
        listFrame.Visible = false
        listFrame.ZIndex = 10
        Instance.new("UICorner", listFrame).CornerRadius = UDim.new(0, 6)
        
        local listScroll = Instance.new("ScrollingFrame", listFrame)
        listScroll.Size = UDim2.new(1, 0, 1, 0)
        listScroll.BackgroundTransparency = 1
        listScroll.BorderSizePixel = 0
        listScroll.ScrollBarThickness = 4
        
        local listLayout = Instance.new("UIListLayout", listScroll)
        listLayout.Padding = UDim.new(0, 2)
        listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            listScroll.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)
        end)
        
        for _, option in ipairs(options) do
            local optBtn = Instance.new("TextButton", listScroll)
            optBtn.Size = UDim2.new(1, -5, 0, 30*scale)
            optBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            optBtn.Text = "  " .. option
            optBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
            optBtn.TextSize = 13*scale
            optBtn.Font = Enum.Font.Gotham
            optBtn.TextXAlignment = Enum.TextXAlignment.Left
            optBtn.BorderSizePixel = 0
            Instance.new("UICorner", optBtn).CornerRadius = UDim.new(0, 4)
            
            optBtn.MouseButton1Click:Connect(function()
                dropdown.Text = "  " .. option
                listFrame.Visible = false
                if callback then callback(option) end
            end)
        end
        
        dropdown.MouseButton1Click:Connect(function()
            listFrame.Visible = not listFrame.Visible
            if listFrame.Visible then
                local absPos = dropdown.AbsolutePosition
                listFrame.Position = UDim2.new(0, absPos.X, 0, absPos.Y + dropdown.AbsoluteSize.Y + 5)
            end
        end)
        
        table.insert(win.searchableItems, {element = frame, text = text})
        return frame
    end
    
    function win:AddLabel(text)
        local label = Instance.new("TextLabel", content)
        label.Size = UDim2.new(1, -10, 0, 30*scale)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(150, 150, 150)
        label.TextSize = 13*scale
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        return label
    end
    
    function win:AddTab(name, iconId)
        local tabBtn = Instance.new("TextButton", sidebar)
        tabBtn.Size = UDim2.new(1, -10, 0, 40*scale)
        tabBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        tabBtn.Text = iconId and "" or "  " .. name
        tabBtn.TextColor3 = Color3.fromRGB(150, 150, 150)
        tabBtn.TextSize = 14*scale
        tabBtn.Font = Enum.Font.Gotham
        tabBtn.TextXAlignment = Enum.TextXAlignment.Left
        tabBtn.BorderSizePixel = 0
        Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 6)
        
        if iconId then
            local icon = Instance.new("ImageLabel", tabBtn)
            icon.Size = UDim2.new(0, 20*scale, 0, 20*scale)
            icon.Position = UDim2.new(0, 10, 0.5, -10*scale)
            icon.BackgroundTransparency = 1
            icon.Image = iconId
            icon.ImageColor3 = Color3.fromRGB(150, 150, 150)
            
            local label = Instance.new("TextLabel", tabBtn)
            label.Size = UDim2.new(1, -40*scale, 1, 0)
            label.Position = UDim2.new(0, 35*scale, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = name
            label.TextColor3 = Color3.fromRGB(150, 150, 150)
            label.TextSize = 14*scale
            label.Font = Enum.Font.Gotham
            label.TextXAlignment = Enum.TextXAlignment.Left
        end
        
        local tabContent = Instance.new("ScrollingFrame", main)
        tabContent.Size = UDim2.new(1, -195*scale, 1, -65*scale)
        tabContent.Position = UDim2.new(0, 185*scale, 0, 60*scale)
        tabContent.BackgroundTransparency = 1
        tabContent.BorderSizePixel = 0
        tabContent.ScrollBarThickness = 6
        tabContent.ScrollBarImageColor3 = Color3.fromRGB(50, 50, 50)
        tabContent.Visible = false
        
        local tabLayout = Instance.new("UIListLayout", tabContent)
        tabLayout.Padding = UDim.new(0, 8)
        tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabContent.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y + 10)
        end)
        
        local tabData = {Button = tabBtn, Content = tabContent}
        table.insert(win.tabs, tabData)
        
        tabBtn.MouseButton1Click:Connect(function()
            for _, t in pairs(win.tabs) do
                t.Content.Visible = false
                t.Button.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
                t.Button.TextColor3 = Color3.fromRGB(150, 150, 150)
            end
            tabBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 100)
            tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            tabContent.Visible = true
            content.Visible = false
        end)
        
        local tab = {Content = tabContent, Button = tabBtn}
        
        function tab:AddButton(text, callback, iconId)
            local btn = win:AddButton(text, callback, iconId)
            btn.Parent = tabContent
            return btn
        end
        
        function tab:AddCheckbox(text, default, callback)
            local chk = win:AddCheckbox(text, default, callback)
            chk.Parent = tabContent
            return chk
        end
        
        function tab:AddDropdown(text, options, default, callback)
            local dd = win:AddDropdown(text, options, default, callback)
            dd.Parent = tabContent
            return dd
        end
        
        function tab:AddLabel(text)
            local lbl = win:AddLabel(text)
            lbl.Parent = tabContent
            return lbl
        end
        
        return tab
    end
    
    return win
end
