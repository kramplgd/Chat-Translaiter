local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer

local layoutMap = {
    ["q"] = "й", ["w"] = "ц", ["e"] = "у", ["r"] = "к", ["t"] = "е", ["y"] = "н", 
    ["u"] = "г", ["i"] = "ш", ["o"] = "щ", ["p"] = "з", ["["] = "х", ["]"] = "ъ",
    ["a"] = "ф", ["s"] = "ы", ["d"] = "в", ["f"] = "а", ["g"] = "п", ["h"] = "р",
    ["j"] = "о", ["k"] = "л", ["l"] = "д", [";"] = "ж", ["'"] = "э", ["z"] = "я",
    ["x"] = "ч", ["c"] = "с", ["v"] = "м", ["b"] = "и", ["n"] = "т", ["m"] = "ь",
    [","] = "б", ["."] = "ю", ["/"] = ".", ["`"] = "ё",
    
    ["Q"] = "Й", ["W"] = "Ц", ["E"] = "У", ["R"] = "К", ["T"] = "Е", ["Y"] = "Н",
    ["U"] = "Г", ["I"] = "Ш", ["O"] = "Щ", ["P"] = "З", ["{"] = "Х", ["}"] = "Ъ",
    ["A"] = "Ф", ["S"] = "Ы", ["D"] = "В", ["F"] = "А", ["G"] = "П", ["H"] = "Р",
    ["J"] = "О", ["K"] = "Л", ["L"] = "Д", [":"] = "Ж", ['"'] = "Э", ["Z"] = "Я",
    ["X"] = "Ч", ["C"] = "С", ["V"] = "М", ["B"] = "И", ["N"] = "Т", ["M"] = "Ь",
    ["<"] = "Б", [">"] = "Ю", ["?"] = ",", ["~"] = "Ё"
}

local function translateText(text)
    local result = ""
    for i = 1, #text do
        local char = text:sub(i, i)
        if char == "<" then
            result = result .. "Б"
        elseif char == ">" then
            result = result .. "Ю"
        else
            result = result .. (layoutMap[char] or char)
        end
    end
    return result
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ChatTranslatorGUI"
screenGui.Parent = CoreGui

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 450, 0, 550)
mainFrame.Position = UDim2.new(0.5, -225, 0.5, -275)
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

local neonBorder = Instance.new("Frame")
neonBorder.Name = "NeonBorder"
neonBorder.Size = UDim2.new(1, 4, 1, 4)
neonBorder.Position = UDim2.new(0, -2, 0, -2)
neonBorder.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
neonBorder.BorderSizePixel = 0
neonBorder.ZIndex = 0
neonBorder.Parent = mainFrame

local neonCorner = Instance.new("UICorner")
neonCorner.CornerRadius = UDim.new(0, 14)
neonCorner.Parent = neonBorder

local glowConnection
local function startGlowAnimation()
    if glowConnection then
        glowConnection:Disconnect()
    end
    local time = 0
    glowConnection = RunService.Heartbeat:Connect(function(delta)
        time = time + delta
        local glow = math.abs(math.sin(time * 2)) * 0.5 + 0.5
        neonBorder.BackgroundColor3 = Color3.fromRGB(
            math.floor(50 * glow),
            math.floor(200 * glow),
            math.floor(255 * glow)
        )
    end)
end

local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 45)
header.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = header

local icon = Instance.new("TextLabel")
icon.Name = "Icon"
icon.Size = UDim2.new(0, 30, 0, 30)
icon.Position = UDim2.new(0, 10, 0, 7)
icon.BackgroundTransparency = 1
icon.Text = "🔤"
icon.TextColor3 = Color3.fromRGB(255, 255, 255)
icon.TextSize = 20
icon.Font = Enum.Font.GothamBold
icon.Parent = header

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -150, 1, 0)
title.Position = UDim2.new(0, 50, 0, 0)
title.BackgroundTransparency = 1
title.Text = "CHAT TRANSLATOR"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 7)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
closeButton.BorderSizePixel = 0
closeButton.Text = "×"
closeButton.TextColor3 = Color3.fromRGB(0, 0, 0)
closeButton.TextSize = 20
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton

closeButton.MouseEnter:Connect(function()
    closeButton.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
end)

closeButton.MouseLeave:Connect(function()
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
end)

local controlButtons = Instance.new("Frame")
controlButtons.Name = "ControlButtons"
controlButtons.Size = UDim2.new(0, 70, 0, 30)
controlButtons.Position = UDim2.new(1, -110, 0, 7)
controlButtons.BackgroundTransparency = 1
controlButtons.Parent = header

local clearButton = Instance.new("TextButton")
clearButton.Name = "ClearButton"
clearButton.Size = UDim2.new(0, 30, 0, 30)
clearButton.Position = UDim2.new(0, 0, 0, 0)
clearButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
clearButton.BorderSizePixel = 0
clearButton.Text = "🗑️"
clearButton.TextColor3 = Color3.fromRGB(0, 0, 0)
clearButton.TextSize = 14
clearButton.Font = Enum.Font.Gotham
clearButton.Parent = controlButtons

local clearCorner = Instance.new("UICorner")
clearCorner.CornerRadius = UDim.new(0, 6)
clearCorner.Parent = clearButton

clearButton.MouseEnter:Connect(function()
    clearButton.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
end)

clearButton.MouseLeave:Connect(function()
    clearButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
end)

local pauseButton = Instance.new("TextButton")
pauseButton.Name = "PauseButton"
pauseButton.Size = UDim2.new(0, 30, 0, 30)
pauseButton.Position = UDim2.new(0, 40, 0, 0)
pauseButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
pauseButton.BorderSizePixel = 0
pauseButton.Text = "⏸️"
pauseButton.TextColor3 = Color3.fromRGB(0, 0, 0)
pauseButton.TextSize = 14
pauseButton.Font = Enum.Font.Gotham
pauseButton.Parent = controlButtons

local pauseCorner = Instance.new("UICorner")
pauseCorner.CornerRadius = UDim.new(0, 6)
pauseCorner.Parent = pauseButton

pauseButton.MouseEnter:Connect(function()
    pauseButton.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
end)

pauseButton.MouseLeave:Connect(function()
    pauseButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
end)

local searchFrame = Instance.new("Frame")
searchFrame.Name = "SearchFrame"
searchFrame.Size = UDim2.new(1, -20, 0, 35)
searchFrame.Position = UDim2.new(0, 10, 0, 55)
searchFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
searchFrame.BorderSizePixel = 0
searchFrame.Parent = mainFrame

local searchCorner = Instance.new("UICorner")
searchCorner.CornerRadius = UDim.new(0, 8)
searchCorner.Parent = searchFrame

local searchBox = Instance.new("TextBox")
searchBox.Name = "SearchBox"
searchBox.Size = UDim2.new(1, -50, 0.7, 0)
searchBox.Position = UDim2.new(0, 10, 0.15, 0)
searchBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
searchBox.BorderSizePixel = 0
searchBox.Text = ""
searchBox.PlaceholderText = "Поиск по игроку..."
searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
searchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
searchBox.TextSize = 12
searchBox.Font = Enum.Font.Gotham
searchBox.TextXAlignment = Enum.TextXAlignment.Left
searchBox.ClearTextOnFocus = false
searchBox.Parent = searchFrame

local searchBoxCorner = Instance.new("UICorner")
searchBoxCorner.CornerRadius = UDim.new(0, 6)
searchBoxCorner.Parent = searchBox

local searchIcon = Instance.new("TextLabel")
searchIcon.Name = "SearchIcon"
searchIcon.Size = UDim2.new(0, 25, 0, 25)
searchIcon.Position = UDim2.new(1, -35, 0.15, 0)
searchIcon.BackgroundTransparency = 1
searchIcon.Text = "🔍"
searchIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
searchIcon.TextSize = 14
searchIcon.Font = Enum.Font.Gotham
searchIcon.Parent = searchFrame

local messagesContainer = Instance.new("ScrollingFrame")
messagesContainer.Name = "MessagesContainer"
messagesContainer.Size = UDim2.new(1, -20, 1, -140)
messagesContainer.Position = UDim2.new(0, 10, 0, 100)
messagesContainer.BackgroundTransparency = 1
messagesContainer.BorderSizePixel = 0
messagesContainer.ScrollBarThickness = 6
messagesContainer.ScrollBarImageColor3 = Color3.fromRGB(0, 150, 200)
messagesContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
messagesContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
messagesContainer.Parent = mainFrame

local messagesLayout = Instance.new("UIListLayout")
messagesLayout.Name = "MessagesLayout"
messagesLayout.Padding = UDim.new(0, 8)
messagesLayout.Parent = messagesContainer

local footer = Instance.new("Frame")
footer.Name = "Footer"
footer.Size = UDim2.new(1, 0, 0, 30)
footer.Position = UDim2.new(0, 0, 1, -30)
footer.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
footer.BorderSizePixel = 0
footer.Parent = mainFrame

local footerText = Instance.new("TextLabel")
footerText.Name = "FooterText"
footerText.Size = UDim2.new(1, -10, 1, 0)
footerText.Position = UDim2.new(0, 10, 0, 0)
footerText.BackgroundTransparency = 1
footerText.Text = "F5 - скрыть/показать • Сообщения: 0 • Пауза: ВЫКЛ"
footerText.TextColor3 = Color3.fromRGB(255, 255, 255)
footerText.TextSize = 11
footerText.Font = Enum.Font.Gotham
footerText.TextXAlignment = Enum.TextXAlignment.Left
footerText.Parent = footer

local messageCount = 0
local isPaused = false
local isVisible = true

local function updateMessageCount()
    footerText.Text = "F5 - скрыть/показать • Сообщения: " .. messageCount .. " • Пауза: " .. (isPaused and "ВКЛ" or "ВЫКЛ")
end

local function applyFilter()
    for _, child in ipairs(messagesContainer:GetChildren()) do
        if child:IsA("Frame") and child.Name == "MessageFrame" then
            child.Visible = true
        end
    end
    
    if searchBox.Text ~= "" then
        local searchLower = searchBox.Text:lower()
        for _, child in ipairs(messagesContainer:GetChildren()) do
            if child:IsA("Frame") and child.Name == "MessageFrame" then
                local nameLabel = child:FindFirstChild("PlayerName")
                if nameLabel then
                    local text = nameLabel.Text:lower()
                    if not text:find(searchLower, 1, true) then
                        child.Visible = false
                    end
                end
            end
        end
    end
end

local function addMessage(player, originalText, translatedText)
    if isPaused then return end
    
    local messageFrame = Instance.new("Frame")
    messageFrame.Name = "MessageFrame"
    messageFrame.Size = UDim2.new(1, 0, 0, 80)
    messageFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    messageFrame.BorderSizePixel = 0
    messageFrame.Parent = messagesContainer

    local messageCorner = Instance.new("UICorner")
    messageCorner.CornerRadius = UDim.new(0, 8)
    messageCorner.Parent = messageFrame

    local accentBar = Instance.new("Frame")
    accentBar.Name = "AccentBar"
    accentBar.Size = UDim2.new(0, 3, 1, -10)
    accentBar.Position = UDim2.new(0, 0, 0, 5)
    accentBar.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
    accentBar.BorderSizePixel = 0
    accentBar.Parent = messageFrame

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "PlayerName"
    nameLabel.Size = UDim2.new(1, -10, 0, 18)
    nameLabel.Position = UDim2.new(0, 8, 0, 5)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.DisplayName .. " (@" .. player.Name .. ")"
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextSize = 12
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = messageFrame

    local originalLabel = Instance.new("TextLabel")
    originalLabel.Name = "OriginalText"
    originalLabel.Size = UDim2.new(1, -10, 0, 25)
    originalLabel.Position = UDim2.new(0, 8, 0, 25)
    originalLabel.BackgroundTransparency = 1
    originalLabel.Text = originalText
    originalLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    originalLabel.TextSize = 11
    originalLabel.Font = Enum.Font.Gotham
    originalLabel.TextXAlignment = Enum.TextXAlignment.Left
    originalLabel.TextWrapped = true
    originalLabel.Parent = messageFrame

    local translatedLabel = Instance.new("TextLabel")
    translatedLabel.Name = "TranslatedText"
    translatedLabel.Size = UDim2.new(1, -10, 0, 25)
    translatedLabel.Position = UDim2.new(0, 8, 0, 50)
    translatedLabel.BackgroundTransparency = 1
    translatedLabel.Text = translatedText
    translatedLabel.TextColor3 = Color3.fromRGB(0, 255, 200)
    translatedLabel.TextSize = 12
    translatedLabel.Font = Enum.Font.GothamBold
    translatedLabel.TextXAlignment = Enum.TextXAlignment.Left
    translatedLabel.TextWrapped = true
    translatedLabel.Parent = messageFrame

    messageCount = messageCount + 1
    updateMessageCount()
    
    applyFilter()
    
    -- УБРАЛ АВТОСКРОЛЛ ПОЛНОСТЬЮ
    -- Сообщения просто добавляются, но скролл не меняется
end

local function toggleVisibility()
    isVisible = not isVisible
    if isVisible then
        mainFrame.Visible = true
        local tween = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 450, 0, 550)})
        tween:Play()
    else
        local tween = TweenService:Create(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
        tween:Play()
        tween.Completed:Connect(function()
            mainFrame.Visible = false
        end)
    end
end

closeButton.MouseButton1Click:Connect(function()
    if glowConnection then
        glowConnection:Disconnect()
    end
    screenGui:Destroy()
end)

clearButton.MouseButton1Click:Connect(function()
    for _, child in ipairs(messagesContainer:GetChildren()) do
        if child:IsA("Frame") and child.Name == "MessageFrame" then
            child:Destroy()
        end
    end
    messageCount = 0
    updateMessageCount()
end)

pauseButton.MouseButton1Click:Connect(function()
    isPaused = not isPaused
    pauseButton.Text = isPaused and "▶️" or "⏸️"
    updateMessageCount()
end)

searchBox:GetPropertyChangedSignal("Text"):Connect(applyFilter)

if TextChatService and TextChatService.MessageReceived then
    TextChatService.MessageReceived:Connect(function(message)
        if message.TextSource then
            local player = message.TextSource.UserId and Players:GetPlayerByUserId(message.TextSource.UserId)
            if player and player ~= localPlayer then
                local originalText = message.Text
                local cleanedText = originalText:gsub("&lt;", "<"):gsub("&gt;", ">")
                local translatedText = translateText(cleanedText)
                
                addMessage(player, originalText, translatedText)
            end
        end
    end)
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F5 then
        toggleVisibility()
    end
end)

local dragging = false
local dragInput
local dragStart
local startPos

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

startGlowAnimation()
warn("Chat Translator успешно запущен! F5 - скрыть/показать")
