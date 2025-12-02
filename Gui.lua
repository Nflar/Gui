-- Gui.lua - Optimized Roblox GUI Library for Mobile & PC
-- Usage: loadstring(game:HttpGet("https://raw.githubusercontent.com/Nflar/Gui/refs/heads/main/Gui.lua"))()

local GuiLibrary = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Detect device type
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local scaleFactor = isMobile and 1.2 or 1

-- Create ScreenGui
local function createScreenGui()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CustomGui_" .. math.random(1000, 9999)
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    return screenGui
end

-- Tween helper
local function tween(object, properties, duration)
    duration = duration or 0.2
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(object, tweenInfo, properties):Play()
end

-- Create Window
function GuiLibrary:CreateWindow(title)
    local screenGui = createScreenGui()
    screenGui.Parent = game.CoreGui
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 500 * scaleFactor, 0, 400 * scaleFactor)
    mainFrame.Position = UDim2.new(0.5, -250 * scaleFactor, 0.5, -200 * scaleFactor)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = mainFrame
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 40 * scaleFactor)
    titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = titleBar
    
    -- Title Text
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -100, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "GUI Library"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 16 * scaleFactor
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar
    
    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseButton"
    closeBtn.Size = UDim2.new(0, 30 * scaleFactor, 0, 30 * scaleFactor)
    closeBtn.Position = UDim2.new(1, -35 * scaleFactor, 0.5, -15 * scaleFactor)
    closeBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    closeBtn.Text = "×"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 20 * scaleFactor
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = titleBar
    
    local closeBtnCorner = Instance.new("UICorner")
    closeBtnCorner.CornerRadius = UDim.new(0, 6)
    closeBtnCorner.Parent = closeBtn
    
    closeBtn.MouseButton1Click:Connect(function()
        tween(mainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        wait(0.3)
        screenGui:Destroy()
    end)
    
    -- Minimize Button
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Name = "MinimizeButton"
    minimizeBtn.Size = UDim2.new(0, 30 * scaleFactor, 0, 30 * scaleFactor)
    minimizeBtn.Position = UDim2.new(1, -70 * scaleFactor, 0.5, -15 * scaleFactor)
    minimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 180, 60)
    minimizeBtn.Text = "−"
    minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minimizeBtn.TextSize = 20 * scaleFactor
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Parent = titleBar
    
    local minimizeBtnCorner = Instance.new("UICorner")
    minimizeBtnCorner.CornerRadius = UDim.new(0, 6)
    minimizeBtnCorner.Parent = minimizeBtn
    
    local isMinimized = false
    local originalSize = mainFrame.Size
    minimizeBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            tween(mainFrame, {Size = UDim2.new(0, 500 * scaleFactor, 0, 40 * scaleFactor)})
        else
            tween(mainFrame, {Size = originalSize})
        end
    end)
    
    -- Dragging
    local dragging, dragInput, dragStart, startPos
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)
    
    titleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    -- Content Container
    local contentFrame = Instance.new("ScrollingFrame")
    contentFrame.Name = "Content"
    contentFrame.Size = UDim2.new(1, -20, 1, -60 * scaleFactor)
    contentFrame.Position = UDim2.new(0, 10, 0, 50 * scaleFactor)
    contentFrame.BackgroundTransparency = 1
    contentFrame.BorderSizePixel = 0
    contentFrame.ScrollBarThickness = 4
    contentFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
    contentFrame.Parent = mainFrame
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 8)
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Parent = contentFrame
    
    contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        contentFrame.CanvasSize = UDim2.new(0, 0, 0, contentLayout.AbsoluteContentSize.Y + 10)
    end)
    
    local window = {
        Frame = mainFrame,
        Content = contentFrame,
        ScreenGui = screenGui
    }
    
    -- Button
    function window:AddButton(text, callback)
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(1, -10, 0, 35 * scaleFactor)
        button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        button.Text = text
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        button.TextSize = 14 * scaleFactor
        button.Font = Enum.Font.Gotham
        button.BorderSizePixel = 0
        button.Parent = contentFrame
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = button
        
        button.MouseButton1Click:Connect(function()
            tween(button, {BackgroundColor3 = Color3.fromRGB(70, 130, 255)}, 0.1)
            wait(0.1)
            tween(button, {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}, 0.1)
            if callback then callback() end
        end)
        
        return button
    end
    
    -- Checkbox
    function window:AddCheckbox(text, default, callback)
        local checkboxFrame = Instance.new("Frame")
        checkboxFrame.Size = UDim2.new(1, -10, 0, 35 * scaleFactor)
        checkboxFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        checkboxFrame.BorderSizePixel = 0
        checkboxFrame.Parent = contentFrame
        
        local frameCorner = Instance.new("UICorner")
        frameCorner.CornerRadius = UDim.new(0, 6)
        frameCorner.Parent = checkboxFrame
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -40, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 14 * scaleFactor
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = checkboxFrame
        
        local checkbox = Instance.new("TextButton")
        checkbox.Size = UDim2.new(0, 25 * scaleFactor, 0, 25 * scaleFactor)
        checkbox.Position = UDim2.new(1, -30 * scaleFactor, 0.5, -12.5 * scaleFactor)
        checkbox.BackgroundColor3 = default and Color3.fromRGB(70, 130, 255) or Color3.fromRGB(60, 60, 60)
        checkbox.Text = default and "✓" or ""
        checkbox.TextColor3 = Color3.fromRGB(255, 255, 255)
        checkbox.TextSize = 16 * scaleFactor
        checkbox.Font = Enum.Font.GothamBold
        checkbox.BorderSizePixel = 0
        checkbox.Parent = checkboxFrame
        
        local checkCorner = Instance.new("UICorner")
        checkCorner.CornerRadius = UDim.new(0, 4)
        checkCorner.Parent = checkbox
        
        local checked = default or false
        checkbox.MouseButton1Click:Connect(function()
            checked = not checked
            checkbox.Text = checked and "✓" or ""
            tween(checkbox, {BackgroundColor3 = checked and Color3.fromRGB(70, 130, 255) or Color3.fromRGB(60, 60, 60)})
            if callback then callback(checked) end
        end)
        
        return checkboxFrame
    end
    
    -- TextLabel
    function window:AddLabel(text)
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -10, 0, 30 * scaleFactor)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(200, 200, 200)
        label.TextSize = 14 * scaleFactor
        label.Font = Enum.Font.Gotham
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = contentFrame
        
        return label
    end
    
    -- Tabs
    function window:AddTabs()
        local tabSystem = {
            Tabs = {},
            CurrentTab = nil
        }
        
        local tabBar = Instance.new("Frame")
        tabBar.Size = UDim2.new(1, -20, 0, 35 * scaleFactor)
        tabBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        tabBar.BorderSizePixel = 0
        tabBar.Parent = contentFrame
        
        local tabBarCorner = Instance.new("UICorner")
        tabBarCorner.CornerRadius = UDim.new(0, 6)
        tabBarCorner.Parent = tabBar
        
        local tabLayout = Instance.new("UIListLayout")
        tabLayout.FillDirection = Enum.FillDirection.Horizontal
        tabLayout.Padding = UDim.new(0, 5)
        tabLayout.Parent = tabBar
        
        function tabSystem:AddTab(name)
            local tabButton = Instance.new("TextButton")
            tabButton.Size = UDim2.new(0, 100 * scaleFactor, 1, -10)
            tabButton.Position = UDim2.new(0, 0, 0, 5)
            tabButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            tabButton.Text = name
            tabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
            tabButton.TextSize = 13 * scaleFactor
            tabButton.Font = Enum.Font.Gotham
            tabButton.BorderSizePixel = 0
            tabButton.Parent = tabBar
            
            local tabBtnCorner = Instance.new("UICorner")
            tabBtnCorner.CornerRadius = UDim.new(0, 4)
            tabBtnCorner.Parent = tabButton
            
            local tabContent = Instance.new("ScrollingFrame")
            tabContent.Size = UDim2.new(1, -10, 1, -95 * scaleFactor)
            tabContent.Position = UDim2.new(0, 5, 0, 90 * scaleFactor)
            tabContent.BackgroundTransparency = 1
            tabContent.BorderSizePixel = 0
            tabContent.ScrollBarThickness = 4
            tabContent.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)
            tabContent.Visible = false
            tabContent.Parent = contentFrame
            
            local tabContentLayout = Instance.new("UIListLayout")
            tabContentLayout.Padding = UDim.new(0, 8)
            tabContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
            tabContentLayout.Parent = tabContent
            
            tabContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                tabContent.CanvasSize = UDim2.new(0, 0, 0, tabContentLayout.AbsoluteContentSize.Y + 10)
            end)
            
            tabButton.MouseButton1Click:Connect(function()
                for _, tab in pairs(tabSystem.Tabs) do
                    tab.Button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                    tab.Button.TextColor3 = Color3.fromRGB(200, 200, 200)
                    tab.Content.Visible = false
                end
                tabButton.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
                tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                tabContent.Visible = true
                tabSystem.CurrentTab = name
            end)
            
            local tab = {
                Button = tabButton,
                Content = tabContent,
                Name = name
            }
            
            table.insert(tabSystem.Tabs, tab)
            
            if #tabSystem.Tabs == 1 then
                tabButton.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
                tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                tabContent.Visible = true
                tabSystem.CurrentTab = name
            end
            
            return {
                AddButton = function(_, text, callback)
                    return window:AddButton(text, callback).Parent = tabContent
                end,
                AddCheckbox = function(_, text, default, callback)
                    return window:AddCheckbox(text, default, callback).Parent = tabContent
                end,
                AddLabel = function(_, text)
                    return window:AddLabel(text).Parent = tabContent
                end
            }
        end
        
        return tabSystem
    end
    
    return window
end

return GuiLibrary
