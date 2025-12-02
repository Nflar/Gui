-- Gui.lua
local Lib = {}
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled
local scale = isMobile and 1.2 or 1

local function tween(obj, props, time)
    TS:Create(obj, TweenInfo.new(time or 0.2, Enum.EasingStyle.Quad), props):Play()
end

local colorPresets = {
    Default = {
        Primary = Color3.fromRGB(70, 130, 255),
        Background = Color3.fromRGB(30, 30, 30),
        Secondary = Color3.fromRGB(40, 40, 40),
        TitleBar = Color3.fromRGB(20, 20, 20),
        Text = Color3.fromRGB(255, 255, 255),
        CloseButton = Color3.fromRGB(255, 60, 60),
        MinimizeButton = Color3.fromRGB(255, 180, 60)
    },
    Dark = {
        Primary = Color3.fromRGB(100, 100, 255),
        Background = Color3.fromRGB(15, 15, 15),
        Secondary = Color3.fromRGB(25, 25, 25),
        TitleBar = Color3.fromRGB(10, 10, 10),
        Text = Color3.fromRGB(255, 255, 255),
        CloseButton = Color3.fromRGB(200, 50, 50),
        MinimizeButton = Color3.fromRGB(200, 150, 50)
    },
    Purple = {
        Primary = Color3.fromRGB(150, 80, 255),
        Background = Color3.fromRGB(25, 15, 35),
        Secondary = Color3.fromRGB(35, 25, 45),
        TitleBar = Color3.fromRGB(20, 10, 30),
        Text = Color3.fromRGB(255, 255, 255),
        CloseButton = Color3.fromRGB(255, 60, 60),
        MinimizeButton = Color3.fromRGB(255, 180, 60)
    },
    Green = {
        Primary = Color3.fromRGB(80, 200, 120),
        Background = Color3.fromRGB(15, 30, 20),
        Secondary = Color3.fromRGB(25, 40, 30),
        TitleBar = Color3.fromRGB(10, 25, 15),
        Text = Color3.fromRGB(255, 255, 255),
        CloseButton = Color3.fromRGB(255, 60, 60),
        MinimizeButton = Color3.fromRGB(255, 180, 60)
    },
    Red = {
        Primary = Color3.fromRGB(255, 80, 80),
        Background = Color3.fromRGB(30, 15, 15),
        Secondary = Color3.fromRGB(40, 25, 25),
        TitleBar = Color3.fromRGB(25, 10, 10),
        Text = Color3.fromRGB(255, 255, 255),
        CloseButton = Color3.fromRGB(255, 60, 60),
        MinimizeButton = Color3.fromRGB(255, 180, 60)
    },
    Ocean = {
        Primary = Color3.fromRGB(0, 150, 200),
        Background = Color3.fromRGB(15, 25, 35),
        Secondary = Color3.fromRGB(25, 35, 45),
        TitleBar = Color3.fromRGB(10, 20, 30),
        Text = Color3.fromRGB(255, 255, 255),
        CloseButton = Color3.fromRGB(255, 60, 60),
        MinimizeButton = Color3.fromRGB(255, 180, 60)
    }
}

function Lib:CreateWindow(config)
    local title = type(config) == "string" and config or config.Title or "GUI"
    local logoId = type(config) == "table" and config.Logo or nil
    local toggleButtonImage = type(config) == "table" and config.ToggleButton or nil
    
    local currentTheme = colorPresets.Default
    
    local sg = Instance.new("ScreenGui")
    sg.Name = "GUI_" .. tick()
    sg.ResetOnSpawn = false
    sg.Parent = game.CoreGui
    
    local toggleBtn
    if isMobile or toggleButtonImage then
        toggleBtn = Instance.new("ImageButton", sg)
        toggleBtn.Size = UDim2.new(0, 60*scale, 0, 60*scale)
        toggleBtn.Position = UDim2.new(0, 10, 0.5, -30*scale)
        toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        toggleBtn.BorderSizePixel = 0
        toggleBtn.Image = toggleButtonImage or ""
        toggleBtn.ScaleType = Enum.ScaleType.Fit
        Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 12)
        
        local drag, dragStart, startPos
        toggleBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                drag = true
                dragStart = input.Position
                startPos = toggleBtn.Position
            end
        end)
        toggleBtn.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                drag = false
            end
        end)
        UIS.InputChanged:Connect(function(input)
            if drag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                toggleBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end
    
    local main = Instance.new("Frame", sg)
    main.Size = UDim2.new(0, 600*scale, 0, 400*scale)
    main.Position = UDim2.new(0.5, -300*scale, 0.5, -200*scale)
    main.BackgroundColor3 = currentTheme.Background
    main.BorderSizePixel = 0
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)
    
    local sidebar = Instance.new("ScrollingFrame", main)
    sidebar.Size = UDim2.new(0, 120*scale, 1, -40*scale)
    sidebar.Position = UDim2.new(0, 0, 0, 40*scale)
    sidebar.BackgroundColor3 = currentTheme.TitleBar
    sidebar.BorderSizePixel = 0
    sidebar.ScrollBarThickness = 4
    
    local sidebarCorner = Instance.new("UICorner", sidebar)
    sidebarCorner.CornerRadius = UDim.new(0, 8)
    
    local sidebarLayout = Instance.new("UIListLayout", sidebar)
    sidebarLayout.Padding = UDim.new(0, 5)
    sidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    sidebarLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        sidebar.CanvasSize = UDim2.new(0, 0, 0, sidebarLayout.AbsoluteContentSize.Y + 10)
    end)
    
    local bar = Instance.new("Frame", main)
    bar.Size = UDim2.new(1, 0, 0, 40*scale)
    bar.BackgroundColor3 = currentTheme.TitleBar
    bar.BorderSizePixel = 0
    Instance.new("UICorner", bar).CornerRadius = UDim.new(0, 8)
    
    local logoSize = 30*scale
    local logoOffset = 5
    if logoId then
        local logo = Instance.new("ImageLabel", bar)
        logo.Size = UDim2.new(0, logoSize, 0, logoSize)
        logo.Position = UDim2.new(0, 5, 0.5, -logoSize/2)
        logo.BackgroundTransparency = 1
        logo.Image = logoId
        logo.ScaleType = Enum.ScaleType.Fit
        logoOffset = logoSize + 10
    end
    
    local lbl = Instance.new("TextLabel", bar)
    lbl.Size = UDim2.new(0, 150*scale, 1, 0)
    lbl.Position = UDim2.new(0, logoOffset, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = title
    lbl.TextColor3 = currentTheme.Text
    lbl.TextSize = 16*scale
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    
    local searchBox = Instance.new("TextBox", bar)
    searchBox.Size = UDim2.new(0, 150*scale, 0, 25*scale)
    searchBox.Position = UDim2.new(0.5, -75*scale, 0.5, -12.5*scale)
    searchBox.BackgroundColor3 = currentTheme.Secondary
    searchBox.PlaceholderText = "Search..."
    searchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    searchBox.Text = ""
    searchBox.TextColor3 = currentTheme.Text
    searchBox.TextSize = 12*scale
    searchBox.Font = Enum.Font.Gotham
    searchBox.ClearTextOnFocus = false
    searchBox.BorderSizePixel = 0
    Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 4)
    
    local searchIcon = Instance.new("TextLabel", searchBox)
    searchIcon.Size = UDim2.new(0, 20, 1, 0)
    searchIcon.Position = UDim2.new(1, -20, 0, 0)
    searchIcon.BackgroundTransparency = 1
    searchIcon.Text = "🔍"
    searchIcon.TextColor3 = Color3.fromRGB(150, 150, 150)
    searchIcon.TextSize = 12*scale
    
    local close = Instance.new("TextButton", bar)
    close.Size = UDim2.new(0, 30*scale, 0, 30*scale)
    close.Position = UDim2.new(1, -35*scale, 0.5, -15*scale)
    close.BackgroundColor3 = currentTheme.CloseButton
    close.Text = "×"
    close.TextColor3 = currentTheme.Text
    close.TextSize = 20*scale
    close.Font = Enum.Font.GothamBold
    close.BorderSizePixel = 0
    Instance.new("UICorner", close).CornerRadius = UDim.new(0, 6)
    close.MouseButton1Click:Connect(function()
        tween(main, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        task.wait(0.3)
        main.Visible = false
    end)
    
    local min = Instance.new("TextButton", bar)
    min.Size = UDim2.new(0, 30*scale, 0, 30*scale)
    min.Position = UDim2.new(1, -70*scale, 0.5, -15*scale)
    min.BackgroundColor3 = currentTheme.MinimizeButton
    min.Text = "−"
    min.TextColor3 = currentTheme.Text
    min.TextSize = 20*scale
    min.Font = Enum.Font.GothamBold
    min.BorderSizePixel = 0
    Instance.new("UICorner", min).CornerRadius = UDim.new(0, 6)
    
    local minimized = false
    local origSize = main.Size
    min.MouseButton1Click:Connect(function()
        minimized = not minimized
        tween(main, {Size = minimized and UDim2.new(0, 600*scale, 0, 40*scale) or origSize})
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
    content.Size = UDim2.new(1, -140*scale, 1, -60*scale)
    content.Position = UDim2.new(0, 130*scale, 0, 50*scale)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 4
    
    local layout = Instance.new("UIListLayout", content)
    layout.Padding = UDim.new(0, 8)
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        content.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end)
    
    local win = {
        searchableItems = {},
        theme = currentTheme,
        themeElements = {},
        tabs = {},
        main = main,
        bar = bar,
        sidebar = sidebar,
        content = content,
        close = close,
        min = min,
        searchBox = searchBox,
        lbl = lbl
    }
    
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
    
    function win:UpdateTheme(theme)
        currentTheme = theme
        win.theme = theme
        main.BackgroundColor3 = theme.Background
        bar.BackgroundColor3 = theme.TitleBar
        sidebar.BackgroundColor3 = theme.TitleBar
        lbl.TextColor3 = theme.Text
        searchBox.BackgroundColor3 = theme.Secondary
        searchBox.TextColor3 = theme.Text
        close.BackgroundColor3 = theme.CloseButton
        min.BackgroundColor3 = theme.MinimizeButton
        
        for _, elem in pairs(win.themeElements) do
            if elem.Type == "Button" then
                elem.Object.BackgroundColor3 = theme.Secondary
                if elem.Label then
                    elem.Label.TextColor3 = theme.Text
                else
                    elem.Object.TextColor3 = theme.Text
                end
            elseif elem.Type == "Checkbox" then
                elem.Frame.BackgroundColor3 = theme.Secondary
                elem.Label.TextColor3 = theme.Text
            elseif elem.Type == "Dropdown" then
                elem.Frame.BackgroundColor3 = theme.Secondary
                elem.Label.TextColor3 = theme.Text
                elem.Dropdown.TextColor3 = theme.Text
            elseif elem.Type == "Tab" then
                if elem.Active then
                    elem.Button.BackgroundColor3 = theme.Primary
                    elem.Button.TextColor3 = theme.Text
                else
                    elem.Button.BackgroundColor3 = theme.Secondary
                    elem.Button.TextColor3 = Color3.fromRGB(200, 200, 200)
                end
            end
        end
    end
    
    function win:SaveConfig(name)
        local config = {Theme = nil}
        for presetName, preset in pairs(colorPresets) do
            if preset == currentTheme then
                config.Theme = presetName
                break
            end
        end
        writefile(name .. ".json", game:GetService("HttpService"):JSONEncode(config))
        return true
    end
    
    function win:LoadConfig(name)
        if isfile(name .. ".json") then
            local config = game:GetService("HttpService"):JSONDecode(readfile(name .. ".json"))
            if config.Theme and colorPresets[config.Theme] then
                win:UpdateTheme(colorPresets[config.Theme])
            end
            return true
        end
        return false
    end
    
    function win:AddButton(text, callback, iconId)
        local btn = Instance.new("TextButton", content)
        btn.Size = UDim2.new(1, -10, 0, 35*scale)
        btn.BackgroundColor3 = currentTheme.Secondary
        btn.Text = iconId and "" or text
        btn.TextColor3 = currentTheme.Text
        btn.TextSize = 14*scale
        btn.Font = Enum.Font.Gotham
        btn.BorderSizePixel = 0
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        
        local label
        if iconId then
            local icon = Instance.new("ImageLabel", btn)
            icon.Size = UDim2.new(0, 25*scale, 0, 25*scale)
            icon.Position = UDim2.new(0, 5, 0.5, -12.5*scale)
            icon.BackgroundTransparency = 1
            icon.Image = iconId
            icon.ScaleType = Enum.ScaleType.Fit
            
            label = Instance.new("TextLabel", btn)
            label.Size = UDim2.new(1, -35*scale, 1, 0)
            label.Position = UDim2.new(0, 35*scale, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = currentTheme.Text
            label.TextSize = 14*scale
            label.Font = Enum.Font.Gotham
            label.TextXAlignment = Enum.TextXAlignment.Left
        end
        
        btn.MouseButton1Click:Connect(function()
            tween(btn, {BackgroundColor3 = currentTheme.Primary}, 0.1)
            task.wait(0.1)
            tween(btn, {BackgroundColor3 = currentTheme.Secondary}, 0.1)
            if callback then callback() end
        end)
        
        table.insert(win.searchableItems, {element = btn, text = text})
        table.insert(win.themeElements, {Type = "Button", Object = btn, Label = label})
        return btn
    end
    
    function win:AddCheckbox(text, default, callback)
        local frame = Instance.new("Frame", content)
        frame.Size = UDim2.new(1, -10, 0, 35*scale)
        frame.BackgroundColor3 = currentTheme.Secondary
        frame.BorderSizePixel = 0
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
        
        local label = Instance.new("TextLabel", frame)
        label.Size = UDim2.new(1, -40, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = currentTheme.Text
        label.TextSize = 14*scale
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        
        local check = Instance.new("TextButton", frame)
        check.Size = UDim2.new(0, 25*scale, 0, 25*scale)
        check.Position = UDim2.new(1, -30*scale, 0.5, -12.5*scale)
        check.BackgroundColor3 = default and currentTheme.Primary or Color3.fromRGB(60, 60, 60)
        check.Text = default and "✓" or ""
        check.TextColor3 = currentTheme.Text
        check.TextSize = 16*scale
        check.Font = Enum.Font.GothamBold
        check.BorderSizePixel = 0
        Instance.new("UICorner", check).CornerRadius = UDim.new(0, 4)
        
        local checked = default or false
        check.MouseButton1Click:Connect(function()
            checked = not checked
            check.Text = checked and "✓" or ""
            tween(check, {BackgroundColor3 = checked and currentTheme.Primary or Color3.fromRGB(60, 60, 60)})
            if callback then callback(checked) end
        end)
        
        table.insert(win.searchableItems, {element = frame, text = text})
        table.insert(win.themeElements, {Type = "Checkbox", Frame = frame, Label = label, Check = check})
        return frame
    end
    
    function win:AddDropdown(text, options, default, callback)
        local frame = Instance.new("Frame", content)
        frame.Size = UDim2.new(1, -10, 0, 35*scale)
        frame.BackgroundColor3 = currentTheme.Secondary
        frame.BorderSizePixel = 0
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
        
        local label = Instance.new("TextLabel", frame)
        label.Size = UDim2.new(0.5, -10, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = currentTheme.Text
        label.TextSize = 14*scale
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        
        local dropdown = Instance.new("TextButton", frame)
        dropdown.Size = UDim2.new(0.5, -20, 0, 25*scale)
        dropdown.Position = UDim2.new(0.5, 5, 0.5, -12.5*scale)
        dropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        dropdown.Text = default or options[1] or "Select"
        dropdown.TextColor3 = currentTheme.Text
        dropdown.TextSize = 12*scale
        dropdown.Font = Enum.Font.Gotham
        dropdown.BorderSizePixel = 0
        Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0, 4)
        
        local arrow = Instance.new("TextLabel", dropdown)
        arrow.Size = UDim2.new(0, 20, 1, 0)
        arrow.Position = UDim2.new(1, -20, 0, 0)
        arrow.BackgroundTransparency = 1
        arrow.Text = "▼"
        arrow.TextColor3 = currentTheme.Text
        arrow.TextSize = 10*scale
        
        local listFrame = Instance.new("Frame", sg)
        listFrame.Size = UDim2.new(0, 200*scale, 0, math.min(#options * 30*scale, 150*scale))
        listFrame.BackgroundColor3 = currentTheme.Secondary
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
            optBtn.Size = UDim2.new(1, -5, 0, 28*scale)
            optBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            optBtn.Text = option
            optBtn.TextColor3 = currentTheme.Text
            optBtn.TextSize = 12*scale
            optBtn.Font = Enum.Font.Gotham
            optBtn.BorderSizePixel = 0
            Instance.new("UICorner", optBtn).CornerRadius = UDim.new(0, 4)
            
            optBtn.MouseButton1Click:Connect(function()
                dropdown.Text = option
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
        table.insert(win.themeElements, {Type = "Dropdown", Frame = frame, Label = label, Dropdown = dropdown})
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
    
    function win:AddTab(name)
        local tabBtn = Instance.new("TextButton", sidebar)
        tabBtn.Size = UDim2.new(1, -10, 0, 35*scale)
        tabBtn.BackgroundColor3 = currentTheme.Secondary
        tabBtn.Text = name
        tabBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        tabBtn.TextSize = 13*scale
        tabBtn.Font = Enum.Font.Gotham
        tabBtn.BorderSizePixel = 0
        Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 6)
        
        local tabContent = Instance.new("ScrollingFrame", main)
        tabContent.Size = UDim2.new(1, -140*scale, 1, -60*scale)
        tabContent.Position = UDim2.new(0, 130*scale, 0, 50*scale)
        tabContent.BackgroundTransparency = 1
        tabContent.BorderSizePixel = 0
        tabContent.ScrollBarThickness = 4
        tabContent.Visible = false
        
        local tabLayout = Instance.new("UIListLayout", tabContent)
        tabLayout.Padding = UDim.new(0, 8)
        tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tabContent.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y + 10)
        end)
        
        local tabData = {Button = tabBtn, Content = tabContent, Active = false}
        table.insert(win.tabs, tabData)
        table.insert(win.themeElements, {Type = "Tab", Button = tabBtn, Active = false})
        
        tabBtn.MouseButton1Click:Connect(function()
            for _, t in pairs(win.tabs) do
                t.Content.Visible = false
                t.Button.BackgroundColor3 = currentTheme.Secondary
                t.Button.TextColor3 = Color3.fromRGB(200, 200, 200)
                t.Active = false
            end
            for _, elem in pairs(win.themeElements) do
                if elem.Type == "Tab" then
                    elem.Active = false
                end
            end
            
            tabBtn.BackgroundColor3 = currentTheme.Primary
            tabBtn.TextColor3 = currentTheme.Text
            tabContent.Visible = true
            content.Visible = false
            tabData.Active = true
            
            for _, elem in pairs(win.themeElements) do
                if elem.Type == "Tab" and elem.Button == tabBtn then
                    elem.Active = true
                
                end
            end
        end)
        
        local tab = {Content = tabContent, Button = tabBtn}
        
        function tab:AddButton(text, callback, iconId)
            local btn = Instance.new("TextButton", tabContent)
            btn.Size = UDim2.new(1, -10, 0, 35*scale)
            btn.BackgroundColor3 = currentTheme.Secondary
            btn.Text = iconId and "" or text
            btn.TextColor3 = currentTheme.Text
            btn.TextSize = 14*scale
            btn.Font = Enum.Font.Gotham
            btn.BorderSizePixel = 0
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
            
            local label
            if iconId then
                local icon = Instance.new("ImageLabel", btn)
                icon.Size = UDim2.new(0, 25*scale, 0, 25*scale)
                icon.Position = UDim2.new(0, 5, 0.5, -12.5*scale)
                icon.BackgroundTransparency = 1
                icon.Image = iconId
                icon.ScaleType = Enum.ScaleType.Fit
                
                label = Instance.new("TextLabel", btn)
                label.Size = UDim2.new(1, -35*scale, 1, 0)
                label.Position = UDim2.new(0, 35*scale, 0, 0)
                label.BackgroundTransparency = 1
                label.Text = text
                label.TextColor3 = currentTheme.Text
                label.TextSize = 14*scale
                label.Font = Enum.Font.Gotham
                label.TextXAlignment = Enum.TextXAlignment.Left
            end
            
            btn.MouseButton1Click:Connect(function()
                tween(btn, {BackgroundColor3 = currentTheme.Primary}, 0.1)
                task.wait(0.1)
                tween(btn, {BackgroundColor3 = currentTheme.Secondary}, 0.1)
                if callback then callback() end
            end)
            
            table.insert(win.searchableItems, {element = btn, text = text})
            table.insert(win.themeElements, {Type = "Button", Object = btn, Label = label})
            return btn
        end
        
        function tab:AddCheckbox(text, default, callback)
            local frame = Instance.new("Frame", tabContent)
            frame.Size = UDim2.new(1, -10, 0, 35*scale)
            frame.BackgroundColor3 = currentTheme.Secondary
            frame.BorderSizePixel = 0
            Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
            
            local label = Instance.new("TextLabel", frame)
            label.Size = UDim2.new(1, -40, 1, 0)
            label.Position = UDim2.new(0, 10, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = currentTheme.Text
            label.TextSize = 14*scale
            label.Font = Enum.Font.Gotham
            label.TextXAlignment = Enum.TextXAlignment.Left
            
            local check = Instance.new("TextButton", frame)
            check.Size = UDim2.new(0, 25*scale, 0, 25*scale)
            check.Position = UDim2.new(1, -30*scale, 0.5, -12.5*scale)
            check.BackgroundColor3 = default and currentTheme.Primary or Color3.fromRGB(60, 60, 60)
            check.Text = default and "✓" or ""
            check.TextColor3 = currentTheme.Text
            check.TextSize = 16*scale
            check.Font = Enum.Font.GothamBold
            check.BorderSizePixel = 0
            Instance.new("UICorner", check).CornerRadius = UDim.new(0, 4)
            
            local checked = default or false
            check.MouseButton1Click:Connect(function()
                checked = not checked
                check.Text = checked and "✓" or ""
                tween(check, {BackgroundColor3 = checked and currentTheme.Primary or Color3.fromRGB(60, 60, 60)})
                if callback then callback(checked) end
            end)
            
            table.insert(win.searchableItems, {element = frame, text = text})
            table.insert(win.themeElements, {Type = "Checkbox", Frame = frame, Label = label, Check = check})
            return frame
        end
        
        function tab:AddDropdown(text, options, default, callback)
            local frame = Instance.new("Frame", tabContent)
            frame.Size = UDim2.new(1, -10, 0, 35*scale)
            frame.BackgroundColor3 = currentTheme.Secondary
            frame.BorderSizePixel = 0
            Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
            
            local label = Instance.new("TextLabel", frame)
            label.Size = UDim2.new(0.5, -10, 1, 0)
            label.Position = UDim2.new(0, 10, 0, 0)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = currentTheme.Text
            label.TextSize = 14*scale
            label.Font = Enum.Font.Gotham
            label.TextXAlignment = Enum.TextXAlignment.Left
            
            local dropdown = Instance.new("TextButton", frame)
            dropdown.Size = UDim2.new(0.5, -20, 0, 25*scale)
            dropdown.Position = UDim2.new(0.5, 5, 0.5, -12.5*scale)
            dropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            dropdown.Text = default or options[1] or "Select"
            dropdown.TextColor3 = currentTheme.Text
            dropdown.TextSize = 12*scale
            dropdown.Font = Enum.Font.Gotham
            dropdown.BorderSizePixel = 0
            Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0, 4)
            
            local arrow = Instance.new("TextLabel", dropdown)
            arrow.Size = UDim2.new(0, 20, 1, 0)
            arrow.Position = UDim2.new(1, -20, 0, 0)
            arrow.BackgroundTransparency = 1
            arrow.Text = "▼"
            arrow.TextColor3 = currentTheme.Text
            arrow.TextSize = 10*scale
            
            local listFrame = Instance.new("Frame", sg)
            listFrame.Size = UDim2.new(0, 200*scale, 0, math.min(#options * 30*scale, 150*scale))
            listFrame.BackgroundColor3 = currentTheme.Secondary
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
                optBtn.Size = UDim2.new(1, -5, 0, 28*scale)
                optBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                optBtn.Text = option
                optBtn.TextColor3 = currentTheme.Text
                optBtn.TextSize = 12*scale
                optBtn.Font = Enum.Font.Gotham
                optBtn.BorderSizePixel = 0
                Instance.new("UICorner", optBtn).CornerRadius = UDim.new(0, 4)
                
                optBtn.MouseButton1Click:Connect(function()
                    dropdown.Text = option
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
            table.insert(win.themeElements, {Type = "Dropdown", Frame = frame, Label = label, Dropdown = dropdown})
            return frame
        end
        
        function tab:AddLabel(text)
            local label = Instance.new("TextLabel", tabContent)
            label.Size = UDim2.new(1, -10, 0, 30*scale)
            label.BackgroundTransparency = 1
            label.Text = text
            label.TextColor3 = Color3.fromRGB(200, 200, 200)
            label.TextSize = 14*scale
            label.Font = Enum.Font.Gotham
            label.TextXAlignment = Enum.TextXAlignment.Left
            return label
        end
        
        return tab
    end
    
    return win
end

return Lib
