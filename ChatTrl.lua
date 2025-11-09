-- Инжектор скрипт для Roblox - Переводчик раскладки чата

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
    ["<"] = "Б", [">"] = "Ю", ["?"] = ",", ["~"] = "Ё",
    
    ["й"] = "q", ["ц"] = "w", ["у"] = "e", ["к"] = "r", ["е"] = "t", ["н"] = "y",
    ["г"] = "u", ["ш"] = "i", ["щ"] = "o", ["з"] = "p", ["х"] = "[", ["ъ"] = "]",
    ["ф"] = "a", ["ы"] = "s", ["в"] = "d", ["а"] = "f", ["п"] = "g", ["р"] = "h",
    ["о"] = "j", ["л"] = "k", ["д"] = "l", ["ж"] = ";", ["э"] = "'", ["я"] = "z",
    ["ч"] = "x", ["с"] = "c", ["м"] = "v", ["и"] = "b", ["т"] = "n", ["ь"] = "m",
    ["б"] = ",", ["ю"] = ".", ["ё"] = "`",
    
    ["Й"] = "Q", ["Ц"] = "W", ["У"] = "E", ["К"] = "R", ["Е"] = "T", ["Н"] = "Y",
    ["Г"] = "U", ["Ш"] = "I", ["Щ"] = "O", ["З"] = "P", ["Х"] = "{", ["Ъ"] = "}",
    ["Ф"] = "A", ["Ы"] = "S", ["В"] = "D", ["А"] = "F", ["П"] = "G", ["Р"] = "H",
    ["О"] = "J", ["Л"] = "K", ["Д"] = "L", ["Ж"] = ":", ["Э"] = '"', ["Я"] = "Z",
    ["Ч"] = "X", ["С"] = "C", ["М"] = "V", ["И"] = "B", ["Т"] = "N", ["Ь"] = "M",
    ["Б"] = "<", ["Ю"] = ">", ["Ё"] = "~"
}

function translateText(text)
    local result = ""
    for i = 1, #text do
        local char = text:sub(i, i)
        if char == "<" then
            result = result .. "Б"
        elseif char == ">" then
            result = result .. "Ю"
        elseif char == "&lt;" then
            result = result .. "Б"
        elseif char == "&gt;" then
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
neonBorder.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
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
header.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = header

local icon = Instance.new("ImageLabel")
icon.Name = "Icon"
icon.Size = UDim2.new(0, 25, 0, 25)
icon.Position = UDim2.new(0, 15, 0, 10)
icon.BackgroundTransparency = 1
icon.Image = "rbxassetid://10734948220"
icon.ImageColor3 = Color3.fromRGB(0, 200, 255)
icon.Parent = header

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim2.new(0, 50, 0, 0)
title.BackgroundTransparency = 1
title.Text = "CHAT TRANSLATOR"
title.TextColor3 = Color3.fromRGB(0, 200, 255)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 28, 0, 28)
closeButton.Position = UDim2.new(1, -33, 0, 8)
closeButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
closeButton.BorderSizePixel = 0
closeButton.Text = "×"
closeButton.TextColor3 = Color3.fromRGB(255, 80, 80)
closeButton.TextSize = 20
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton

closeButton.MouseEnter:Connect(function()
    closeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
end)

closeButton.MouseLeave:Connect(function()
    closeButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
end)

local separator = Instance.new("Frame")
separator.Name = "Separator"
separator.Size = UDim2.new(1, -20, 0, 1)
separator.Position = UDim2.new(0, 10, 0, 45)
separator.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
separator.BorderSizePixel = 0
separator.Parent = mainFrame

local messagesContainer = Instance.new("ScrollingFrame")
messagesContainer.Name = "MessagesContainer"
messagesContainer.Size = UDim2.new(1, -20, 1, -75)
messagesContainer.Position = UDim2.new(0, 10, 0, 55)
messagesContainer.BackgroundTransparency = 1
messagesContainer.BorderSizePixel = 0
messagesContainer.ScrollBarThickness = 4
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
footer.Size = UDim2.new(1, 0, 0, 25)
footer.Position = UDim2.new(0, 0, 1, -25)
footer.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
footer.BorderSizePixel = 0
footer.Parent = mainFrame

local footerText = Instance.new("TextLabel")
footerText.Name = "FooterText"
footerText.Size = UDim2.new(1, -10, 1, 0)
footerText.Position = UDim2.new(0, 10, 0, 0)
footerText.BackgroundTransparency = 1
footerText.Text = "F5 - скрыть/показать • Сообщения: 0"
footerText.TextColor3 = Color3.fromRGB(100, 100, 100)
footerText.TextSize = 11
footerText.Font = Enum.Font.Gotham
footerText.TextXAlignment = Enum.TextXAlignment.Left
footerText.Parent = footer

local messageCount = 0
local function updateMessageCount()
    messageCount = messageCount + 1
    footerText.Text = "F5 - скрыть/показать • Сообщения: " .. messageCount
end

local isVisible = true
local isDestroyed = false

function toggleVisibility()
    if isDestroyed then return end
    
    isVisible = not isVisible
    if isVisible then
        mainFrame.Visible = true
        local tweenInfo = TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        local tween = TweenService:Create(mainFrame, tweenInfo, {Size = UDim2.new(0, 450, 0, 550)})
        tween:Play()
        startGlowAnimation()
    else
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        local tween = TweenService:Create(mainFrame, tweenInfo, {Size = UDim2.new(0, 0, 0, 0)})
        tween:Play()
        tween.Completed:Connect(function()
            mainFrame.Visible = false
        end)
    end
end

function closeCompletely()
    if isDestroyed then return end
    
    isDestroyed = true
    if glowConnection then
        glowConnection:Disconnect()
    end
    
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In)
    local tween = TweenService:Create(mainFrame, tweenInfo, {
        Size = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1
    })
    tween:Play()
    
    tween.Completed:Connect(function()
        screenGui:Destroy()
        warn("Chat Translator полностью закрыт")
    end)
end

closeButton.MouseButton1Click:Connect(closeCompletely)

function addMessage(playerName, originalText, translatedText)
    if isDestroyed then return end
    
    local messageFrame = Instance.new("Frame")
    messageFrame.Name = "MessageFrame"
    messageFrame.Size = UDim2.new(1, 0, 0, 90)
    messageFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
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

    local accentCorner = Instance.new("UICorner")
    accentCorner.CornerRadius = UDim.new(0, 2)
    accentCorner.Parent = accentBar

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "PlayerName"
    nameLabel.Size = UDim2.new(1, -15, 0, 20)
    nameLabel.Position = UDim2.new(0, 10, 0, 8)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = "👤 " .. playerName
    nameLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
    nameLabel.TextSize = 14
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = messageFrame

    local originalLabel = Instance.new("TextLabel")
    originalLabel.Name = "OriginalText"
    originalLabel.Size = UDim2.new(1, -15, 0, 25)
    originalLabel.Position = UDim2.new(0, 10, 0, 30)
    originalLabel.BackgroundTransparency = 1
    originalLabel.Text = "📝 " .. originalText
    originalLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    originalLabel.TextSize = 12
    originalLabel.Font = Enum.Font.Gotham
    originalLabel.TextXAlignment = Enum.TextXAlignment.Left
    originalLabel.TextWrapped = true
    originalLabel.Parent = messageFrame

    local translatedLabel = Instance.new("TextLabel")
    translatedLabel.Name = "TranslatedText"
    translatedLabel.Size = UDim2.new(1, -15, 0, 25)
    translatedLabel.Position = UDim2.new(0, 10, 0, 55)
    translatedLabel.BackgroundTransparency = 1
    translatedLabel.Text = "🔤 " .. translatedText
    translatedLabel.TextColor3 = Color3.fromRGB(0, 255, 200)
    translatedLabel.TextSize = 13
    translatedLabel.Font = Enum.Font.GothamBold
    translatedLabel.TextXAlignment = Enum.TextXAlignment.Left
    translatedLabel.TextWrapped = true
    translatedLabel.Parent = messageFrame

    messagesContainer.CanvasPosition = Vector2.new(0, messagesContainer.AbsoluteCanvasSize.Y)
    
    updateMessageCount()
end

if TextChatService then
    local function onMessageReceived(message)
        if isDestroyed then return end
        
        if message.TextSource then
            local player = message.TextSource.UserId and Players:GetPlayerByUserId(message.TextSource.UserId)
            if player and player ~= localPlayer then
                local originalText = message.Text
                local cleanedText = originalText:gsub("&lt;", "<"):gsub("&gt;", ">")
                local translatedText = translateText(cleanedText)
                
                addMessage(player.Name, originalText, translatedText)
            end
        end
    end

    if TextChatService.MessageReceived then
        TextChatService.MessageReceived:Connect(onMessageReceived)
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed or isDestroyed then return end
    
    if input.KeyCode == Enum.KeyCode.F5 then
        toggleVisibility()
    end
end)

local dragging = false
local dragInput
local dragStart
local startPos

local function update(input)
    if isDestroyed then return end
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

header.InputBegan:Connect(function(input)
    if isDestroyed then return end
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
    if isDestroyed then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging and not isDestroyed then
        update(input)
    end
end)

startGlowAnimation()

warn("Chat Translator успешно запущен!\nF5 - скрыть/показать меню\nКрестик - полностью закрыть")
