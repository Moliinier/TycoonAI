--[[
═══════════════════════════════════════════════════════════════════════════════
    TYCOON AI v17.1 - UI MÓVIL COMPACTA
    📱 Optimizada para Android
    ✨ Más pequeña, draggable, perfecta para celular
═══════════════════════════════════════════════════════════════════════════════
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer

-- Limpiar UI anterior
if Player.PlayerGui:FindFirstChild("TycoonAI_MobileCompact") then
    Player.PlayerGui:FindFirstChild("TycoonAI_MobileCompact"):Destroy()
end

-- Theme
local Theme = {
    Primary = Color3.fromRGB(138, 43, 226),
    Secondary = Color3.fromRGB(255, 20, 147),
    Background = Color3.fromRGB(15, 15, 25),
    Text = Color3.fromRGB(255, 255, 255)
}

-- Screen GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TycoonAI_MobileCompact"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = Player.PlayerGui

-- Main Frame (MÁS PEQUEÑO)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.AnchorPoint = Vector2.new(0.5, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0, 10)
mainFrame.Size = UDim2.new(0, 320, 0, 400)  -- ← MÁS PEQUEÑO
mainFrame.BackgroundColor3 = Theme.Background
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 15)
corner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Theme.Primary
stroke.Thickness = 2
stroke.Parent = mainFrame

-- Header (MÁS COMPACTO)
local header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 40)  -- ← Más pequeño
header.BackgroundColor3 = Theme.Primary
header.BorderSizePixel = 0
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 15)
headerCorner.Parent = header

-- Título más pequeño
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🧠 TycoonAI"  -- ← Más corto
title.TextColor3 = Theme.Text
title.TextSize = 16  -- ← Más pequeño
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

-- Botón minimizar
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 35, 0, 35)
minimizeBtn.Position = UDim2.new(1, -75, 0, 2.5)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 204, 0)
minimizeBtn.Text = "━"
minimizeBtn.TextSize = 16
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.Parent = header

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 8)
minCorner.Parent = minimizeBtn

-- Botón cerrar
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 35, 0, 35)
closeBtn.Position = UDim2.new(1, -38, 0, 2.5)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 69, 58)
closeBtn.Text = "✕"
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = header

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

minimizeBtn.MouseButton1Click:Connect(function()
    local isMinimized = mainFrame.Size.Y.Offset == 40
    if isMinimized then
        TweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 320, 0, 400)}):Play()
    else
        TweenService:Create(mainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 320, 0, 40)}):Play()
    end
end)

-- Tabs más pequeños
local tabsContainer = Instance.new("Frame")
tabsContainer.Position = UDim2.new(0, 5, 0, 45)
tabsContainer.Size = UDim2.new(1, -10, 0, 30)  -- ← Más pequeño
tabsContainer.BackgroundTransparency = 1
tabsContainer.Parent = mainFrame

local tabsLayout = Instance.new("UIListLayout")
tabsLayout.FillDirection = Enum.FillDirection.Horizontal
tabsLayout.Padding = UDim.new(0, 4)
tabsLayout.Parent = tabsContainer

-- Content Area
local contentArea = Instance.new("Frame")
contentArea.Position = UDim2.new(0, 5, 0, 80)
contentArea.Size = UDim2.new(1, -10, 1, -85)
contentArea.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
contentArea.BorderSizePixel = 0
contentArea.ClipsDescendants = true
contentArea.Parent = mainFrame

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 10)
contentCorner.Parent = contentArea

-- Chat Tab
local chatTab = Instance.new("Frame")
chatTab.Size = UDim2.new(1, 0, 1, 0)
chatTab.BackgroundTransparency = 1
chatTab.Visible = true
chatTab.Parent = contentArea

-- Chat scroll
local chatScroll = Instance.new("ScrollingFrame")
chatScroll.Size = UDim2.new(1, -5, 1, -55)
chatScroll.Position = UDim2.new(0, 2, 0, 2)
chatScroll.BackgroundTransparency = 1
chatScroll.BorderSizePixel = 0
chatScroll.ScrollBarThickness = 4
chatScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
chatScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
chatScroll.Parent = chatTab

local chatLayout = Instance.new("UIListLayout")
chatLayout.Padding = UDim.new(0, 5)
chatLayout.Parent = chatScroll

-- Input container más pequeño
local inputContainer = Instance.new("Frame")
inputContainer.Size = UDim2.new(1, -5, 0, 45)
inputContainer.Position = UDim2.new(0, 2, 1, -48)
inputContainer.BackgroundColor3 = Theme.Background
inputContainer.BorderSizePixel = 0
inputContainer.Parent = chatTab

local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 8)
inputCorner.Parent = inputContainer

local inputStroke = Instance.new("UIStroke")
inputStroke.Color = Theme.Primary
inputStroke.Thickness = 1
inputStroke.Parent = inputContainer

-- Input box más pequeño
local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(1, -50, 1, -8)
inputBox.Position = UDim2.new(0, 8, 0, 4)
inputBox.BackgroundTransparency = 1
inputBox.Text = ""
inputBox.PlaceholderText = "💬 Escribe aquí..."
inputBox.TextColor3 = Theme.Text
inputBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 120)
inputBox.TextSize = 12  -- ← Más pequeño
inputBox.Font = Enum.Font.Gotham
inputBox.TextXAlignment = Enum.TextXAlignment.Left
inputBox.TextWrapped = true
inputBox.ClearTextOnFocus = false
inputBox.Parent = inputContainer

-- Send button
local sendBtn = Instance.new("TextButton")
sendBtn.Size = UDim2.new(0, 40, 0, 37)
sendBtn.Position = UDim2.new(1, -44, 0, 4)
sendBtn.BackgroundColor3 = Theme.Primary
sendBtn.Text = "➤"
sendBtn.TextSize = 16
sendBtn.Font = Enum.Font.GothamBold
sendBtn.Parent = inputContainer

local sendCorner = Instance.new("UICorner")
sendCorner.CornerRadius = UDim.new(0, 6)
sendCorner.Parent = sendBtn

-- Función para agregar mensaje
local function AddMessage(text, isUser, aiName)
    local msg = Instance.new("Frame")
    msg.Size = UDim2.new(1, -10, 0, 0)
    msg.BackgroundColor3 = isUser and Theme.Primary or Theme.Background
    msg.BackgroundTransparency = isUser and 0.3 or 0.1
    msg.BorderSizePixel = 0
    msg.AutomaticSize = Enum.AutomaticSize.Y
    msg.Parent = chatScroll
    
    local msgCorner = Instance.new("UICorner")
    msgCorner.CornerRadius = UDim.new(0, 8)
    msgCorner.Parent = msg
    
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 25, 0, 25)
    icon.Position = UDim2.new(0, 5, 0, 5)
    icon.BackgroundColor3 = isUser and Color3.fromRGB(100, 200, 255) or Color3.fromRGB(0, 255, 127)
    icon.Text = isUser and "👤" or "🧠"
    icon.TextSize = 14
    icon.Parent = msg
    
    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(0, 6)
    iconCorner.Parent = icon
    
    local msgText = Instance.new("TextLabel")
    msgText.Size = UDim2.new(1, -40, 0, 0)
    msgText.Position = UDim2.new(0, 35, 0, 5)
    msgText.BackgroundTransparency = 1
    msgText.Text = text
    msgText.TextColor3 = Theme.Text
    msgText.TextSize = 11  -- ← Más pequeño
    msgText.Font = Enum.Font.Gotham
    msgText.TextXAlignment = Enum.TextXAlignment.Left
    msgText.TextYAlignment = Enum.TextYAlignment.Top
    msgText.TextWrapped = true
    msgText.AutomaticSize = Enum.AutomaticSize.Y
    msgText.Parent = msg
    
    if not isUser and aiName then
        local aiLabel = Instance.new("TextLabel")
        aiLabel.Size = UDim2.new(1, -40, 0, 12)
        aiLabel.Position = UDim2.new(0, 35, 1, -15)
        aiLabel.BackgroundTransparency = 1
        aiLabel.Text = "🤖 " .. aiName
        aiLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
        aiLabel.TextSize = 9
        aiLabel.Font = Enum.Font.GothamBold
        aiLabel.TextXAlignment = Enum.TextXAlignment.Right
        aiLabel.Parent = msg
    end
    
    msg.Size = UDim2.new(1, -10, 0, msgText.AbsoluteSize.Y + 15)
    chatScroll.CanvasPosition = Vector2.new(0, chatScroll.AbsoluteCanvasSize.Y)
end

-- Procesar comando
local function ProcessCommand(input)
    AddMessage(input, true)
    
    local response = "✅ Procesando: " .. input
    
    if _G.TycoonAI and _G.TycoonAI.Brain then
        local result = _G.TycoonAI.Brain:ProcessIntelligently(input)
        response = result.message or response
        
        local aiName = "TycoonAI"
        if result.ai_insights then
            if result.ai_insights["DeepSeek"] then aiName = "DeepSeek"
            elseif result.ai_insights["Claude"] then aiName = "Claude"
            elseif result.ai_insights["ChatGPT"] then aiName = "ChatGPT"
            elseif result.ai_insights["Gemini"] then aiName = "Gemini"
            end
        end
        
        AddMessage(response, false, aiName)
        
        if result.suggestions and #result.suggestions > 0 then
            wait(0.3)
            local suggestions = "💡 Sugerencias:\n"
            for i = 1, math.min(2, #result.suggestions) do
                suggestions = suggestions .. "• " .. result.suggestions[i].command .. "\n"
            end
            AddMessage(suggestions, false, "Gemini")
        end
    else
        AddMessage(response, false, "Sistema")
    end
end

sendBtn.MouseButton1Click:Connect(function()
    if inputBox.Text ~= "" then
        ProcessCommand(inputBox.Text)
        inputBox.Text = ""
    end
end)

inputBox.FocusLost:Connect(function(enterPressed)
    if enterPressed and inputBox.Text ~= "" then
        ProcessCommand(inputBox.Text)
        inputBox.Text = ""
    end
end)

-- Mensaje inicial
AddMessage("👋 ¡Hola! Soy TycoonAI v17.1\n\n5 IAs trabajando para ti:\n🔵 DeepSeek 🟣 Claude 🟢 ChatGPT 🔴 Gemini\n\n¿En qué te ayudo?", false, "TycoonAI")

-- Crear tabs
local tabs = {
    {name = "💬", fullName = "Chat", tab = chatTab},
}

for _, tabData in ipairs(tabs) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(0, 70, 1, 0)
    tabBtn.BackgroundColor3 = Theme.Primary
    tabBtn.Text = tabData.name
    tabBtn.TextSize = 14
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.Parent = tabsContainer
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 6)
    tabCorner.Parent = tabBtn
end

-- Hacer draggable
local dragging = false
local dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        update(input)
    end
end)

-- Stats Bar (más pequeña)
local statsFrame = Instance.new("Frame")
statsFrame.Size = UDim2.new(0, 150, 0, 90)
statsFrame.Position = UDim2.new(0, 5, 1, -95)
statsFrame.BackgroundColor3 = Theme.Background
statsFrame.BackgroundTransparency = 0.3
statsFrame.BorderSizePixel = 0
statsFrame.Parent = screenGui

local statsCorner = Instance.new("UICorner")
statsCorner.CornerRadius = UDim.new(0, 10)
statsCorner.Parent = statsFrame

local statsStroke = Instance.new("UIStroke")
statsStroke.Color = Theme.Primary
statsStroke.Thickness = 1
statsStroke.Parent = statsFrame

local statsLayout = Instance.new("UIListLayout")
statsLayout.Padding = UDim.new(0, 3)
statsLayout.Parent = statsFrame

local function createStat(name)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -8, 0, 18)
    label.BackgroundTransparency = 1
    label.Text = name .. ": --"
    label.TextColor3 = Theme.Text
    label.TextSize = 11
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = statsFrame
    return label
end

local speedLabel = createStat("⚡ Speed")
local jumpLabel = createStat("🦘 Jump")
local fpsLabel = createStat("📊 FPS")
local pingLabel = createStat("🌐 Ping")

local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

RunService.Heartbeat:Connect(function(dt)
    speedLabel.Text = "⚡ Speed: " .. math.floor(Humanoid.WalkSpeed)
    jumpLabel.Text = "🦘 Jump: " .. math.floor(Humanoid.JumpPower)
    fpsLabel.Text = "📊 FPS: " .. math.floor(1/dt)
    
    local Stats = game:GetService("Stats")
    local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
    pingLabel.Text = "🌐 Ping: " .. ping .. "ms"
end)

print("✅ TycoonAI UI Móvil Compacta cargada!")
game.StarterGui:SetCore("SendNotification", {
    Title = "✅ TycoonAI v17.1",
    Text = "UI compacta cargada!\n320x400 - Perfecta para móvil 📱",
    Duration = 3
})

return screenGui
