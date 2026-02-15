--[[
╔═══════════════════════════════════════════════════════════════════════════════╗
║              TYCOON AI ASSISTANT v17.1 - COMPLETE UI SYSTEM                  ║
║                    INTERFAZ PROFESIONAL CON CHAT IA                           ║
╚═══════════════════════════════════════════════════════════════════════════════╝

    🎨 CARACTERÍSTICAS:
    - Chat con IA en tiempo real
    - 4 Tabs organizados (Player, Teleport, Visual, Misc)
    - 67 comandos accesibles
    - Sistema de notificaciones
    - Barra de stats en vivo
    - 100% Draggable
    - Optimizado para Android
    - Animaciones fluidas
    - Theme moderno (Glassmorphism)
    
═══════════════════════════════════════════════════════════════════════════════]]

--!strict

-- ═══════════════════════════════════════════════════════════════════════════
-- 📦 SERVICIOS Y SETUP
-- ═══════════════════════════════════════════════════════════════════════════

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TextService = game:GetService("TextService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

-- Inicializar sistema si no existe
_G.TycoonAI = _G.TycoonAI or {}
_G.TycoonAI.UI = {}
_G.TycoonAI.ChatHistory = {}

-- ═══════════════════════════════════════════════════════════════════════════
-- 🎨 TEMA VISUAL
-- ═══════════════════════════════════════════════════════════════════════════

local Theme = {
    -- Colores principales
    Primary = Color3.fromRGB(138, 43, 226),      -- Morado vibrante
    Secondary = Color3.fromRGB(255, 20, 147),    -- Rosa neón
    Success = Color3.fromRGB(0, 255, 127),       -- Verde neón
    Warning = Color3.fromRGB(255, 204, 0),       -- Amarillo
    Danger = Color3.fromRGB(255, 69, 58),        -- Rojo neón
    Info = Color3.fromRGB(100, 200, 255),        -- Azul claro
    
    -- Fondos
    Background = Color3.fromRGB(15, 15, 25),     -- Azul oscuro profundo
    BackgroundLight = Color3.fromRGB(25, 25, 35),
    BackgroundDark = Color3.fromRGB(10, 10, 20),
    
    -- Texto
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(180, 180, 200),
    TextDark = Color3.fromRGB(100, 100, 120),
    
    -- Glass effect
    Glass = Color3.fromRGB(255, 255, 255),
}

-- ═══════════════════════════════════════════════════════════════════════════
-- 🛠️ FUNCIONES DE UTILIDAD
-- ═══════════════════════════════════════════════════════════════════════════

local function CreateTween(instance, properties, duration, easingStyle, easingDirection)
    local tweenInfo = TweenInfo.new(
        duration or 0.3,
        easingStyle or Enum.EasingStyle.Quart,
        easingDirection or Enum.EasingDirection.Out
    )
    return TweenService:Create(instance, tweenInfo, properties)
end

local function CreateCorner(radius, parent)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

local function CreateStroke(color, thickness, parent)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Theme.Primary
    stroke.Thickness = thickness or 2
    stroke.Transparency = 0.3
    stroke.Parent = parent
    return stroke
end

local function MakeDraggable(frame, dragHandle)
    local dragging = false
    local dragInput, dragStart, startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
    
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or
           input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            update(input)
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- 🖼️ CREAR UI PRINCIPAL
-- ═══════════════════════════════════════════════════════════════════════════

local function CreateMainUI()
    -- Limpiar UI anterior
    if Player.PlayerGui:FindFirstChild("TycoonAI_CompleteUI") then
        Player.PlayerGui:FindFirstChild("TycoonAI_CompleteUI"):Destroy()
    end
    
    -- Screen GUI principal
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "TycoonAI_CompleteUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = Player.PlayerGui
    
    -- Frame principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame.Size = UDim2.new(0, 700, 0, 600)
    mainFrame.BackgroundColor3 = Theme.Background
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    CreateCorner(15, mainFrame)
    CreateStroke(Theme.Primary, 3, mainFrame)
    
    -- Efecto de brillo en el borde
    local glowStroke = mainFrame:FindFirstChild("UIStroke")
    spawn(function()
        while glowStroke and glowStroke.Parent do
            for i = 0, 1, 0.01 do
                if not glowStroke.Parent then break end
                glowStroke.Color = Theme.Primary:Lerp(Theme.Secondary, i)
                wait(0.03)
            end
            for i = 1, 0, -0.01 do
                if not glowStroke.Parent then break end
                glowStroke.Color = Theme.Primary:Lerp(Theme.Secondary, i)
                wait(0.03)
            end
        end
    end)
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- 📌 HEADER
    -- ═══════════════════════════════════════════════════════════════════════
    
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 60)
    header.BackgroundColor3 = Theme.Primary
    header.BorderSizePixel = 0
    header.Parent = mainFrame
    
    CreateCorner(15, header)
    
    -- Título con gradiente
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -120, 1, 0)
    title.Position = UDim2.new(0, 15, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "🧠 TYCOON AI v17.1"
    title.TextColor3 = Theme.Text
    title.TextSize = 24
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header
    
    local titleGradient = Instance.new("UIGradient")
    titleGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 200, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
    }
    titleGradient.Rotation = 45
    titleGradient.Parent = title
    
    -- Animar gradiente
    spawn(function()
        while title.Parent do
            CreateTween(titleGradient, {Rotation = titleGradient.Rotation + 360}, 3):Play()
            wait(3)
        end
    end)
    
    -- Subtitle
    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(1, -120, 0, 20)
    subtitle.Position = UDim2.new(0, 15, 0, 35)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "🤝 5 IAs trabajando juntas"
    subtitle.TextColor3 = Color3.fromRGB(200, 200, 255)
    subtitle.TextSize = 12
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    subtitle.Parent = header
    
    -- Botón minimizar
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Name = "MinimizeBtn"
    minimizeBtn.Size = UDim2.new(0, 45, 0, 45)
    minimizeBtn.Position = UDim2.new(1, -100, 0, 7.5)
    minimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 204, 0)
    minimizeBtn.Text = "━"
    minimizeBtn.TextColor3 = Theme.Text
    minimizeBtn.TextSize = 20
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.Parent = header
    
    CreateCorner(10, minimizeBtn)
    
    -- Botón cerrar
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseBtn"
    closeBtn.Size = UDim2.new(0, 45, 0, 45)
    closeBtn.Position = UDim2.new(1, -50, 0, 7.5)
    closeBtn.BackgroundColor3 = Theme.Danger
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Theme.Text
    closeBtn.TextSize = 24
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = header
    
    CreateCorner(10, closeBtn)
    
    closeBtn.MouseButton1Click:Connect(function()
        local tween = CreateTween(mainFrame, {
            Position = UDim2.new(0.5, 0, 1.5, 0),
            Size = UDim2.new(0, 0, 0, 0)
        }, 0.5, Enum.EasingStyle.Back)
        tween:Play()
        tween.Completed:Wait()
        screenGui:Destroy()
    end)
    
    minimizeBtn.MouseButton1Click:Connect(function()
        local isMinimized = mainFrame.Size.Y.Offset == 60
        
        if isMinimized then
            CreateTween(mainFrame, {Size = UDim2.new(0, 700, 0, 600)}, 0.3):Play()
        else
            CreateTween(mainFrame, {Size = UDim2.new(0, 700, 0, 60)}, 0.3):Play()
        end
    end)
    
    -- Hacer draggable
    MakeDraggable(mainFrame, header)
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- 📑 TABS CONTAINER
    -- ═══════════════════════════════════════════════════════════════════════
    
    local tabsContainer = Instance.new("Frame")
    tabsContainer.Name = "TabsContainer"
    tabsContainer.Position = UDim2.new(0, 10, 0, 70)
    tabsContainer.Size = UDim2.new(1, -20, 0, 45)
    tabsContainer.BackgroundTransparency = 1
    tabsContainer.Parent = mainFrame
    
    local tabsLayout = Instance.new("UIListLayout")
    tabsLayout.FillDirection = Enum.FillDirection.Horizontal
    tabsLayout.Padding = UDim.new(0, 8)
    tabsLayout.Parent = tabsContainer
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- 📄 CONTENT AREA
    -- ═══════════════════════════════════════════════════════════════════════
    
    local contentArea = Instance.new("Frame")
    contentArea.Name = "ContentArea"
    contentArea.Position = UDim2.new(0, 10, 0, 125)
    contentArea.Size = UDim2.new(1, -20, 1, -135)
    contentArea.BackgroundColor3 = Theme.BackgroundLight
    contentArea.BorderSizePixel = 0
    contentArea.ClipsDescendants = true
    contentArea.Parent = mainFrame
    
    CreateCorner(12, contentArea)
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- 💬 CHAT TAB (Principal)
    -- ═══════════════════════════════════════════════════════════════════════
    
    local chatTab = Instance.new("Frame")
    chatTab.Name = "ChatTab"
    chatTab.Size = UDim2.new(1, 0, 1, 0)
    chatTab.BackgroundTransparency = 1
    chatTab.Visible = true
    chatTab.Parent = contentArea
    
    -- Chat messages area
    local chatScroll = Instance.new("ScrollingFrame")
    chatScroll.Name = "ChatScroll"
    chatScroll.Size = UDim2.new(1, -10, 1, -70)
    chatScroll.Position = UDim2.new(0, 5, 0, 5)
    chatScroll.BackgroundTransparency = 1
    chatScroll.BorderSizePixel = 0
    chatScroll.ScrollBarThickness = 6
    chatScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    chatScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    chatScroll.Parent = chatTab
    
    local chatLayout = Instance.new("UIListLayout")
    chatLayout.Padding = UDim.new(0, 10)
    chatLayout.SortOrder = Enum.SortOrder.LayoutOrder
    chatLayout.Parent = chatScroll
    
    -- Input area
    local inputContainer = Instance.new("Frame")
    inputContainer.Size = UDim2.new(1, -10, 0, 55)
    inputContainer.Position = UDim2.new(0, 5, 1, -60)
    inputContainer.BackgroundColor3 = Theme.Background
    inputContainer.BorderSizePixel = 0
    inputContainer.Parent = chatTab
    
    CreateCorner(10, inputContainer)
    CreateStroke(Theme.Primary, 2, inputContainer)
    
    -- Input box
    local inputBox = Instance.new("TextBox")
    inputBox.Name = "InputBox"
    inputBox.Size = UDim2.new(1, -70, 1, -10)
    inputBox.Position = UDim2.new(0, 10, 0, 5)
    inputBox.BackgroundTransparency = 1
    inputBox.Text = ""
    inputBox.PlaceholderText = "💬 Escribe tu comando aquí..."
    inputBox.TextColor3 = Theme.Text
    inputBox.PlaceholderColor3 = Theme.TextDark
    inputBox.TextSize = 14
    inputBox.Font = Enum.Font.Gotham
    inputBox.TextXAlignment = Enum.TextXAlignment.Left
    inputBox.TextWrapped = true
    inputBox.ClearTextOnFocus = false
    inputBox.Parent = inputContainer
    
    -- Send button
    local sendBtn = Instance.new("TextButton")
    sendBtn.Name = "SendBtn"
    sendBtn.Size = UDim2.new(0, 50, 0, 45)
    sendBtn.Position = UDim2.new(1, -55, 0, 5)
    sendBtn.BackgroundColor3 = Theme.Primary
    sendBtn.Text = "➤"
    sendBtn.TextColor3 = Theme.Text
    sendBtn.TextSize = 20
    sendBtn.Font = Enum.Font.GothamBold
    sendBtn.Parent = inputContainer
    
    CreateCorner(8, sendBtn)
    
    -- Función para agregar mensaje al chat
    local function AddChatMessage(message, isUser, aiSource)
        local msgFrame = Instance.new("Frame")
        msgFrame.Size = UDim2.new(1, -10, 0, 0)
        msgFrame.BackgroundColor3 = isUser and Theme.Primary or Theme.BackgroundDark
        msgFrame.BackgroundTransparency = isUser and 0.3 or 0.1
        msgFrame.BorderSizePixel = 0
        msgFrame.AutomaticSize = Enum.AutomaticSize.Y
        msgFrame.LayoutOrder = #chatScroll:GetChildren()
        msgFrame.Parent = chatScroll
        
        CreateCorner(10, msgFrame)
        
        -- Icon/Avatar
        local icon = Instance.new("TextLabel")
        icon.Size = UDim2.new(0, 35, 0, 35)
        icon.Position = UDim2.new(0, 8, 0, 8)
        icon.BackgroundColor3 = isUser and Theme.Info or Theme.Success
        icon.Text = isUser and "👤" or "🧠"
        icon.TextSize = 18
        icon.Font = Enum.Font.GothamBold
        icon.Parent = msgFrame
        
        CreateCorner(8, icon)
        
        -- Message text
        local msgText = Instance.new("TextLabel")
        msgText.Size = UDim2.new(1, -55, 0, 0)
        msgText.Position = UDim2.new(0, 50, 0, 8)
        msgText.BackgroundTransparency = 1
        msgText.Text = message
        msgText.TextColor3 = Theme.Text
        msgText.TextSize = 13
        msgText.Font = Enum.Font.Gotham
        msgText.TextXAlignment = Enum.TextXAlignment.Left
        msgText.TextYAlignment = Enum.TextYAlignment.Top
        msgText.TextWrapped = true
        msgText.AutomaticSize = Enum.AutomaticSize.Y
        msgText.Parent = msgFrame
        
        -- AI source label
        if not isUser and aiSource then
            local sourceLabel = Instance.new("TextLabel")
            sourceLabel.Size = UDim2.new(1, -55, 0, 15)
            sourceLabel.Position = UDim2.new(0, 50, 1, -20)
            sourceLabel.BackgroundTransparency = 1
            sourceLabel.Text = "🤖 " .. aiSource
            sourceLabel.TextColor3 = Theme.TextSecondary
            sourceLabel.TextSize = 10
            sourceLabel.Font = Enum.Font.GothamBold
            sourceLabel.TextXAlignment = Enum.TextXAlignment.Right
            sourceLabel.Parent = msgFrame
        end
        
        -- Ajustar altura del frame
        msgFrame.Size = UDim2.new(1, -10, 0, msgText.AbsoluteSize.Y + 25)
        
        -- Scroll to bottom
        chatScroll.CanvasPosition = Vector2.new(0, chatScroll.AbsoluteCanvasSize.Y)
        
        -- Animación de entrada
        msgFrame.Size = UDim2.new(1, -10, 0, 0)
        CreateTween(msgFrame, {
            Size = UDim2.new(1, -10, 0, msgText.AbsoluteSize.Y + 25)
        }, 0.3, Enum.EasingStyle.Back):Play()
    end
    
    -- Función para procesar comando
    local function ProcessCommand(userInput)
        -- Agregar mensaje del usuario
        AddChatMessage(userInput, true)
        
        -- Guardar en historial
        table.insert(_G.TycoonAI.ChatHistory, {
            sender = "user",
            message = userInput,
            timestamp = tick()
        })
        
        -- Procesar con el Brain
        local response
        if _G.TycoonAI.Brain then
            local result = _G.TycoonAI.Brain:ProcessIntelligently(userInput)
            
            if result.message and result.message ~= "" then
                response = result.message
            elseif result.confidence < 50 then
                response = "⚠️ No estoy seguro de entender ese comando. ¿Podrías reformularlo?"
            else
                response = "✅ Comando procesado correctamente!"
            end
            
            -- Determinar qué IA respondió
            local aiSource = "TycoonAI"
            if result.ai_insights then
                if result.ai_insights["DeepSeek"] then
                    aiSource = "DeepSeek"
                elseif result.ai_insights["Claude"] then
                    aiSource = "Claude"
                elseif result.ai_insights["ChatGPT"] then
                    aiSource = "ChatGPT"
                elseif result.ai_insights["Gemini"] then
                    aiSource = "Gemini"
                end
            end
            
            AddChatMessage(response, false, aiSource)
            
            -- Mostrar sugerencias si hay
            if result.suggestions and #result.suggestions > 0 then
                wait(0.5)
                local suggestionsText = "💡 Sugerencias:\n"
                for i, suggestion in ipairs(result.suggestions) do
                    if i <= 3 then
                        suggestionsText = suggestionsText .. "• " .. suggestion.command .. "\n"
                    end
                end
                AddChatMessage(suggestionsText, false, "Gemini")
            end
        else
            response = "⚠️ Sistema de IA no inicializado. Cargando Brain..."
            AddChatMessage(response, false, "System")
        end
        
        -- Guardar respuesta en historial
        table.insert(_G.TycoonAI.ChatHistory, {
            sender = "ai",
            message = response,
            timestamp = tick()
        })
    end
    
    -- Event listeners
    sendBtn.MouseButton1Click:Connect(function()
        local userInput = inputBox.Text
        if userInput and userInput ~= "" then
            ProcessCommand(userInput)
            inputBox.Text = ""
        end
    end)
    
    inputBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local userInput = inputBox.Text
            if userInput and userInput ~= "" then
                ProcessCommand(userInput)
                inputBox.Text = ""
            end
        end
    end)
    
    -- Mensaje de bienvenida
    AddChatMessage("👋 ¡Hola! Soy Tycoon AI Assistant v17.1\n\n" ..
                   "Creado por la colaboración de 5 IAs:\n" ..
                   "🔵 DeepSeek - 🟣 Claude - 🟢 ChatGPT - 🔴 Gemini - ⚪ Haiku\n\n" ..
                   "¿En qué puedo ayudarte hoy?", false, "TycoonAI")
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- 📁 OTROS TABS
    -- ═══════════════════════════════════════════════════════════════════════
    
    -- Player Tab
    local playerTab = Instance.new("Frame")
    playerTab.Name = "PlayerTab"
    playerTab.Size = UDim2.new(1, 0, 1, 0)
    playerTab.BackgroundTransparency = 1
    playerTab.Visible = false
    playerTab.Parent = contentArea
    
    local playerScroll = Instance.new("ScrollingFrame")
    playerScroll.Size = UDim2.new(1, -10, 1, -10)
    playerScroll.Position = UDim2.new(0, 5, 0, 5)
    playerScroll.BackgroundTransparency = 1
    playerScroll.BorderSizePixel = 0
    playerScroll.ScrollBarThickness = 6
    playerScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    playerScroll.Parent = playerTab
    
    local playerLayout = Instance.new("UIListLayout")
    playerLayout.Padding = UDim.new(0, 10)
    playerLayout.Parent = playerScroll
    
    -- Función para crear botón de comando
    local function CreateCommandButton(name, description, emoji, parent)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 70)
        btn.BackgroundColor3 = Theme.BackgroundDark
        btn.BorderSizePixel = 0
        btn.Text = ""
        btn.Parent = parent
        
        CreateCorner(10, btn)
        CreateStroke(Theme.Primary, 2, btn)
        
        local emojiLabel = Instance.new("TextLabel")
        emojiLabel.Size = UDim2.new(0, 50, 1, 0)
        emojiLabel.BackgroundTransparency = 1
        emojiLabel.Text = emoji
        emojiLabel.TextSize = 32
        emojiLabel.Parent = btn
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, -60, 0, 25)
        nameLabel.Position = UDim2.new(0, 60, 0, 10)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = name
        nameLabel.TextColor3 = Theme.Text
        nameLabel.TextSize = 16
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.Parent = btn
        
        local descLabel = Instance.new("TextLabel")
        descLabel.Size = UDim2.new(1, -60, 0, 30)
        descLabel.Position = UDim2.new(0, 60, 0, 35)
        descLabel.BackgroundTransparency = 1
        descLabel.Text = description
        descLabel.TextColor3 = Theme.TextSecondary
        descLabel.TextSize = 12
        descLabel.Font = Enum.Font.Gotham
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.TextWrapped = true
        descLabel.Parent = btn
        
        btn.MouseButton1Click:Connect(function()
            ProcessCommand(name)
        end)
        
        return btn
    end
    
    -- Agregar comandos de movimiento
    CreateCommandButton("velocidad", "Aumenta tu velocidad de caminata", "⚡", playerScroll)
    CreateCommandButton("salto", "Aumenta tu potencia de salto", "🦘", playerScroll)
    CreateCommandButton("volar", "Activa el modo vuelo", "🚀", playerScroll)
    CreateCommandButton("noclip", "Atraviesa paredes", "👻", playerScroll)
    CreateCommandButton("teleport", "Teletransportación", "📍", playerScroll)
    
    -- Visual Tab
    local visualTab = Instance.new("Frame")
    visualTab.Name = "VisualTab"
    visualTab.Size = UDim2.new(1, 0, 1, 0)
    visualTab.BackgroundTransparency = 1
    visualTab.Visible = false
    visualTab.Parent = contentArea
    
    local visualScroll = Instance.new("ScrollingFrame")
    visualScroll.Size = UDim2.new(1, -10, 1, -10)
    visualScroll.Position = UDim2.new(0, 5, 0, 5)
    visualScroll.BackgroundTransparency = 1
    visualScroll.BorderSizePixel = 0
    visualScroll.ScrollBarThickness = 6
    visualScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    visualScroll.Parent = visualTab
    
    local visualLayout = Instance.new("UIListLayout")
    visualLayout.Padding = UDim.new(0, 10)
    visualLayout.Parent = visualScroll
    
    CreateCommandButton("particulas", "Efectos de partículas", "✨", visualScroll)
    CreateCommandButton("fullbright", "Iluminación máxima", "💡", visualScroll)
    CreateCommandButton("esp", "Ver jugadores a través de paredes", "👁️", visualScroll)
    CreateCommandButton("trail_efecto", "Estela detrás del personaje", "🌈", visualScroll)
    
    -- Misc Tab
    local miscTab = Instance.new("Frame")
    miscTab.Name = "MiscTab"
    miscTab.Size = UDim2.new(1, 0, 1, 0)
    miscTab.BackgroundTransparency = 1
    miscTab.Visible = false
    miscTab.Parent = contentArea
    
    local miscScroll = Instance.new("ScrollingFrame")
    miscScroll.Size = UDim2.new(1, -10, 1, -10)
    miscScroll.Position = UDim2.new(0, 5, 0, 5)
    miscScroll.BackgroundTransparency = 1
    miscScroll.BorderSizePixel = 0
    miscScroll.ScrollBarThickness = 6
    miscScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    miscScroll.Parent = miscTab
    
    local miscLayout = Instance.new("UIListLayout")
    miscLayout.Padding = UDim.new(0, 10)
    miscLayout.Parent = miscScroll
    
    CreateCommandButton("auto_farm", "Farm automático", "🌾", miscScroll)
    CreateCommandButton("anti_afk", "Prevenir kick por inactividad", "⏰", miscScroll)
    CreateCommandButton("rejoin", "Reconectar al servidor", "🔄", miscScroll)
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- 📑 CREAR TABS
    -- ═══════════════════════════════════════════════════════════════════════
    
    local tabs = {
        {name = "Chat", emoji = "💬", tab = chatTab},
        {name = "Player", emoji = "👤", tab = playerTab},
        {name = "Visual", emoji = "🎨", tab = visualTab},
        {name = "Misc", emoji = "⚙️", tab = miscTab}
    }
    
    local activeTab = "Chat"
    
    for _, tabData in ipairs(tabs) do
        local tabBtn = Instance.new("TextButton")
        tabBtn.Name = tabData.name .. "Btn"
        tabBtn.Size = UDim2.new(0, 160, 1, 0)
        tabBtn.BackgroundColor3 = tabData.name == activeTab and Theme.Primary or Theme.BackgroundDark
        tabBtn.Text = tabData.emoji .. " " .. tabData.name
        tabBtn.TextColor3 = Theme.Text
        tabBtn.TextSize = 15
        tabBtn.Font = Enum.Font.GothamBold
        tabBtn.Parent = tabsContainer
        
        CreateCorner(8, tabBtn)
        
        tabBtn.MouseButton1Click:Connect(function()
            activeTab = tabData.name
            
            -- Actualizar colores de tabs
            for _, btn in pairs(tabsContainer:GetChildren()) do
                if btn:IsA("TextButton") then
                    btn.BackgroundColor3 = Theme.BackgroundDark
                end
            end
            tabBtn.BackgroundColor3 = Theme.Primary
            
            -- Mostrar/ocultar contenido
            for _, data in ipairs(tabs) do
                data.tab.Visible = (data.name == tabData.name)
            end
        end)
    end
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- ✨ ANIMACIÓN DE ENTRADA
    -- ═══════════════════════════════════════════════════════════════════════
    
    mainFrame.Position = UDim2.new(0.5, 0, -1, 0)
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    
    local entranceTween = CreateTween(mainFrame, {
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 700, 0, 600)
    }, 0.7, Enum.EasingStyle.Back)
    entranceTween:Play()
    
    -- Guardar referencia
    _G.TycoonAI.UI.MainFrame = mainFrame
    _G.TycoonAI.UI.ScreenGui = screenGui
    
    return screenGui
end

-- ═══════════════════════════════════════════════════════════════════════════
-- 📊 BARRA DE STATS FLOTANTE
-- ═══════════════════════════════════════════════════════════════════════════

local function CreateStatsBar()
    if Player.PlayerGui:FindFirstChild("TycoonAI_StatsBar") then
        return
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "TycoonAI_StatsBar"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = Player.PlayerGui
    
    local statsFrame = Instance.new("Frame")
    statsFrame.Size = UDim2.new(0, 220, 0, 110)
    statsFrame.Position = UDim2.new(0, 10, 1, -120)
    statsFrame.BackgroundColor3 = Theme.Background
    statsFrame.BackgroundTransparency = 0.3
    statsFrame.BorderSizePixel = 0
    statsFrame.Parent = screenGui
    
    CreateCorner(12, statsFrame)
    CreateStroke(Theme.Primary, 2, statsFrame)
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 5)
    layout.Parent = statsFrame
    
    local function createStat(name)
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -10, 0, 22)
        label.BackgroundTransparency = 1
        label.Text = name .. ": --"
        label.TextColor3 = Theme.Text
        label.TextSize = 13
        label.Font = Enum.Font.GothamBold
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = statsFrame
        return label
    end
    
    local speedLabel = createStat("⚡ Speed")
    local jumpLabel = createStat("🦘 Jump")
    local fpsLabel = createStat("📊 FPS")
    local pingLabel = createStat("🌐 Ping")
    
    -- Actualizar stats
    RunService.Heartbeat:Connect(function(dt)
        if Humanoid then
            speedLabel.Text = "⚡ Speed: " .. math.floor(Humanoid.WalkSpeed)
            jumpLabel.Text = "🦘 Jump: " .. math.floor(Humanoid.JumpPower)
        end
        
        local fps = math.floor(1 / dt)
        fpsLabel.Text = "📊 FPS: " .. fps
        
        local Stats = game:GetService("Stats")
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        pingLabel.Text = "🌐 Ping: " .. ping .. "ms"
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- 🚀 INICIALIZAR TODO
-- ═══════════════════════════════════════════════════════════════════════════

print("\n═══════════════════════════════════════════════════════════════")
print("    🎨 TYCOON AI UI v17.1 - INITIALIZING")
print("═══════════════════════════════════════════════════════════════")

local success, err = pcall(function()
    CreateMainUI()
    CreateStatsBar()
end)

if success then
    print("✅ UI cargada exitosamente!")
    print("💬 Sistema de chat activado")
    print("📊 Barra de stats activada")
    print("🎯 4 tabs disponibles: Chat, Player, Visual, Misc")
    print("═══════════════════════════════════════════════════════════════\n")
    
    game.StarterGui:SetCore("SendNotification", {
        Title = "✅ TYCOON AI v17.1",
        Text = "UI completa cargada exitosamente!",
        Duration = 3
    })
else
    warn("❌ Error al cargar UI: " .. tostring(err))
end

return _G.TycoonAI.UI

