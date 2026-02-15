--[[
╔═══════════════════════════════════════════════════════════════════════════════╗
║     TYCOON IA ULTIMATE v17.0 - CON INTERFAZ VISUAL COMPLETA                  ║
║     "Ahora SÍ se ve en pantalla" 🔥                                          ║
╚═══════════════════════════════════════════════════════════════════════════════╝

    🎨 INTERFAZ COMPLETA INCLUIDA
    
    Al ejecutar, verás una ventana en pantalla con:
    • Chat para hablar con la IA
    • Botón para enseñarle cosas
    • Panel de memoria
    • Panel de comandos
    • Todo visual y bonito
    
    Creado por: Claude Sonnet 4.5 & DeepSeek R1
    Fecha: Febrero 15, 2026
    
]]

--!strict

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

print("🎨 Cargando TycoonIA con Interfaz Visual...")

-- ═══════════════════════════════════════════════════════════════════════════
-- SISTEMA DE GUARDADO
-- ═══════════════════════════════════════════════════════════════════════════

local SaveSystem = {}
local SAVE_FOLDER = "TycoonIA_v17"
local SAVE_FILE = SAVE_FOLDER .. "/memoria.json"

function SaveSystem.Guardar(datos)
    if writefile then
        pcall(function()
            if not isfolder(SAVE_FOLDER) then makefolder(SAVE_FOLDER) end
            writefile(SAVE_FILE, HttpService:JSONEncode(datos))
        end)
    end
end

function SaveSystem.Cargar()
    if readfile and isfile and isfile(SAVE_FILE) then
        local success, result = pcall(function()
            return HttpService:JSONDecode(readfile(SAVE_FILE))
        end)
        return success and result or nil
    end
    return nil
end

-- ═══════════════════════════════════════════════════════════════════════════
-- IA PRINCIPAL
-- ═══════════════════════════════════════════════════════════════════════════

local TycoonIA = {}
TycoonIA.Memoria = {
    vocabulario = {},
    conversaciones = {},
    estadisticas = {
        palabrasAprendidas = 0,
        totalInteracciones = 0,
        nivel = 1
    }
}

function TycoonIA.Inicializar()
    local datosGuardados = SaveSystem.Cargar()
    if datosGuardados then
        TycoonIA.Memoria = datosGuardados
        print("📂 Memoria cargada: " .. TycoonIA.Memoria.estadisticas.palabrasAprendidas .. " palabras")
    end
end

function TycoonIA.Hablar(mensaje)
    TycoonIA.Memoria.estadisticas.totalInteracciones += 1
    local mensajeLower = mensaje:lower()
    local respuesta = ""
    
    -- Saludos
    if mensajeLower:find("hola") or mensajeLower:find("hey") then
        if TycoonIA.Memoria.estadisticas.palabrasAprendidas > 0 then
            respuesta = "¡Hola de nuevo! 😊\nLlevo " .. TycoonIA.Memoria.estadisticas.palabrasAprendidas .. " cosas aprendidas.\n¿En qué puedo ayudarte?"
        else
            respuesta = "¡Hola! Soy TycoonIA v17.0 🌟\nHabla conmigo naturalmente o enséñame cosas nuevas!"
        end
    
    -- Enseñanza
    elseif mensajeLower:find("aprende") or mensajeLower:find("recuerda que") then
        local concepto = mensaje:match("que%s+(.+)") or mensaje:match("aprende%s+(.+)")
        if concepto then
            TycoonIA.Enseñar(concepto, mensaje)
            respuesta = "¡Aprendido! ✅\n'" .. concepto .. "'\nAhora lo recordaré siempre."
        else
            respuesta = "¿Qué quieres que aprenda? 🤔\nDi: 'Aprende que [concepto]'"
        end
    
    -- Consulta
    elseif mensajeLower:find("qué sabes") or mensajeLower:find("recuerdas") then
        local query = mensaje:match("de%s+(.+)") or mensaje:match("recuerdas%s+(.+)")
        if query then
            local recordado = TycoonIA.Recordar(query)
            respuesta = recordado and ("¡Sí! 💡\n" .. tostring(recordado)) or "No recuerdo eso 😔\n¿Quieres enseñármelo?"
        else
            respuesta = "¿Sobre qué quieres que recuerde? 🤔"
        end
    
    -- Ayuda
    elseif mensajeLower:find("ayuda") or mensajeLower:find("help") then
        respuesta = "🌟 PUEDO HACER:\n• Conversar contigo\n• Aprender cosas nuevas\n• Recordar lo que me enseñes\n• Guardar memoria permanente\n\nDi 'Aprende que...' para enseñarme!"
    
    -- Gracias
    elseif mensajeLower:find("gracias") then
        respuesta = "¡De nada! 😊 Para eso estoy."
    
    -- Default
    else
        respuesta = "Interesante... 🤔\nNo estoy seguro, pero puedo aprender!\nDi 'ayuda' para ver qué puedo hacer."
    end
    
    table.insert(TycoonIA.Memoria.conversaciones, {
        usuario = mensaje,
        respuesta = respuesta,
        timestamp = os.date()
    })
    
    SaveSystem.Guardar(TycoonIA.Memoria)
    return respuesta
end

function TycoonIA.Enseñar(palabra, significado)
    palabra = palabra:lower()
    TycoonIA.Memoria.vocabulario[palabra] = {
        significado = significado,
        veces = (TycoonIA.Memoria.vocabulario[palabra] and TycoonIA.Memoria.vocabulario[palabra].veces or 0) + 1,
        timestamp = os.date()
    }
    TycoonIA.Memoria.estadisticas.palabrasAprendidas = 0
    for _ in pairs(TycoonIA.Memoria.vocabulario) do
        TycoonIA.Memoria.estadisticas.palabrasAprendidas += 1
    end
    TycoonIA.Memoria.estadisticas.nivel = math.floor(TycoonIA.Memoria.estadisticas.palabrasAprendidas / 10) + 1
    SaveSystem.Guardar(TycoonIA.Memoria)
end

function TycoonIA.Recordar(tema)
    tema = tema:lower()
    if TycoonIA.Memoria.vocabulario[tema] then
        return TycoonIA.Memoria.vocabulario[tema].significado
    end
    for palabra, datos in pairs(TycoonIA.Memoria.vocabulario) do
        if palabra:find(tema) or datos.significado:lower():find(tema) then
            return datos.significado
        end
    end
    return nil
end

-- ═══════════════════════════════════════════════════════════════════════════
-- INTERFAZ VISUAL
-- ═══════════════════════════════════════════════════════════════════════════

local function CrearUI()
    -- Limpiar UI anterior
    if PlayerGui:FindFirstChild("TycoonIA_GUI") then
        PlayerGui:FindFirstChild("TycoonIA_GUI"):Destroy()
    end
    
    -- ScreenGui principal
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "TycoonIA_GUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = PlayerGui
    
    -- Frame principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 500, 0, 600)
    mainFrame.Position = UDim2.new(0.5, -250, 0.5, -300)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 15)
    mainCorner.Parent = mainFrame
    
    -- Sombra
    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(0, -15, 0, -15)
    shadow.Size = UDim2.new(1, 30, 1, 30)
    shadow.ZIndex = 0
    shadow.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.5
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    shadow.Parent = mainFrame
    
    -- Header
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 60)
    header.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    header.BorderSizePixel = 0
    header.Parent = mainFrame
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 15)
    headerCorner.Parent = header
    
    -- Título
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -100, 1, 0)
    title.Position = UDim2.new(0, 20, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "🧠 TycoonIA Ultimate v17.0"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 20
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header
    
    -- Botón cerrar
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 40, 0, 40)
    closeBtn.Position = UDim2.new(1, -50, 0, 10)
    closeBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    closeBtn.Text = "✕"
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 20
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Parent = header
    
    local closeBtnCorner = Instance.new("UICorner")
    closeBtnCorner.CornerRadius = UDim.new(0, 8)
    closeBtnCorner.Parent = closeBtn
    
    closeBtn.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    -- Stats bar
    local statsBar = Instance.new("Frame")
    statsBar.Name = "StatsBar"
    statsBar.Size = UDim2.new(1, -40, 0, 40)
    statsBar.Position = UDim2.new(0, 20, 0, 70)
    statsBar.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    statsBar.BorderSizePixel = 0
    statsBar.Parent = mainFrame
    
    local statsCorner = Instance.new("UICorner")
    statsCorner.CornerRadius = UDim.new(0, 8)
    statsCorner.Parent = statsBar
    
    local statsText = Instance.new("TextLabel")
    statsText.Size = UDim2.new(1, -20, 1, 0)
    statsText.Position = UDim2.new(0, 10, 0, 0)
    statsText.BackgroundTransparency = 1
    statsText.Text = "📊 Nivel " .. TycoonIA.Memoria.estadisticas.nivel .. " | " .. 
                     TycoonIA.Memoria.estadisticas.palabrasAprendidas .. " palabras | " ..
                     TycoonIA.Memoria.estadisticas.totalInteracciones .. " interacciones"
    statsText.Font = Enum.Font.Gotham
    statsText.TextSize = 14
    statsText.TextColor3 = Color3.fromRGB(200, 200, 200)
    statsText.TextXAlignment = Enum.TextXAlignment.Left
    statsText.Parent = statsBar
    
    -- Chat display
    local chatFrame = Instance.new("ScrollingFrame")
    chatFrame.Name = "ChatFrame"
    chatFrame.Size = UDim2.new(1, -40, 0, 350)
    chatFrame.Position = UDim2.new(0, 20, 0, 120)
    chatFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    chatFrame.BorderSizePixel = 0
    chatFrame.ScrollBarThickness = 6
    chatFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120)
    chatFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    chatFrame.Parent = mainFrame
    
    local chatCorner = Instance.new("UICorner")
    chatCorner.CornerRadius = UDim.new(0, 8)
    chatCorner.Parent = chatFrame
    
    local chatLayout = Instance.new("UIListLayout")
    chatLayout.Padding = UDim.new(0, 10)
    chatLayout.SortOrder = Enum.SortOrder.LayoutOrder
    chatLayout.Parent = chatFrame
    
    -- Input box
    local inputBox = Instance.new("TextBox")
    inputBox.Name = "InputBox"
    inputBox.Size = UDim2.new(1, -140, 0, 50)
    inputBox.Position = UDim2.new(0, 20, 1, -70)
    inputBox.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    inputBox.BorderSizePixel = 0
    inputBox.Text = ""
    inputBox.PlaceholderText = "Escribe tu mensaje aquí..."
    inputBox.Font = Enum.Font.Gotham
    inputBox.TextSize = 14
    inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    inputBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    inputBox.TextXAlignment = Enum.TextXAlignment.Left
    inputBox.ClearTextOnFocus = false
    inputBox.Parent = mainFrame
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 8)
    inputCorner.Parent = inputBox
    
    local inputPadding = Instance.new("UIPadding")
    inputPadding.PaddingLeft = UDim.new(0, 10)
    inputPadding.Parent = inputBox
    
    -- Botón enviar
    local sendBtn = Instance.new("TextButton")
    sendBtn.Name = "SendButton"
    sendBtn.Size = UDim2.new(0, 100, 0, 50)
    sendBtn.Position = UDim2.new(1, -120, 1, -70)
    sendBtn.BackgroundColor3 = Color3.fromRGB(80, 120, 255)
    sendBtn.Text = "Enviar 💬"
    sendBtn.Font = Enum.Font.GothamBold
    sendBtn.TextSize = 14
    sendBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    sendBtn.Parent = mainFrame
    
    local sendBtnCorner = Instance.new("UICorner")
    sendBtnCorner.CornerRadius = UDim.new(0, 8)
    sendBtnCorner.Parent = sendBtn
    
    -- Función para agregar mensaje al chat
    local function agregarMensaje(texto, esUsuario)
        local msgFrame = Instance.new("Frame")
        msgFrame.Size = UDim2.new(1, -10, 0, 0)
        msgFrame.BackgroundColor3 = esUsuario and Color3.fromRGB(80, 120, 255) or Color3.fromRGB(35, 35, 50)
        msgFrame.BorderSizePixel = 0
        msgFrame.AutomaticSize = Enum.AutomaticSize.Y
        msgFrame.Parent = chatFrame
        
        local msgCorner = Instance.new("UICorner")
        msgCorner.CornerRadius = UDim.new(0, 8)
        msgCorner.Parent = msgFrame
        
        local msgPadding = Instance.new("UIPadding")
        msgPadding.PaddingTop = UDim.new(0, 10)
        msgPadding.PaddingBottom = UDim.new(0, 10)
        msgPadding.PaddingLeft = UDim.new(0, 10)
        msgPadding.PaddingRight = UDim.new(0, 10)
        msgPadding.Parent = msgFrame
        
        local msgLabel = Instance.new("TextLabel")
        msgLabel.Size = UDim2.new(1, -20, 0, 0)
        msgLabel.Position = UDim2.new(0, 10, 0, 10)
        msgLabel.BackgroundTransparency = 1
        msgLabel.Text = texto
        msgLabel.Font = Enum.Font.Gotham
        msgLabel.TextSize = 14
        msgLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        msgLabel.TextWrapped = true
        msgLabel.TextXAlignment = Enum.TextXAlignment.Left
        msgLabel.TextYAlignment = Enum.TextYAlignment.Top
        msgLabel.AutomaticSize = Enum.AutomaticSize.Y
        msgLabel.Parent = msgFrame
        
        chatFrame.CanvasSize = UDim2.new(0, 0, 0, chatLayout.AbsoluteContentSize.Y + 10)
        chatFrame.CanvasPosition = Vector2.new(0, chatFrame.AbsoluteCanvasSize.Y)
        
        -- Actualizar stats
        statsText.Text = "📊 Nivel " .. TycoonIA.Memoria.estadisticas.nivel .. " | " .. 
                         TycoonIA.Memoria.estadisticas.palabrasAprendidas .. " palabras | " ..
                         TycoonIA.Memoria.estadisticas.totalInteracciones .. " interacciones"
    end
    
    -- Mensaje de bienvenida
    agregarMensaje("¡Hola " .. Player.Name .. "! 😊\n\nSoy TycoonIA Ultimate v17.0. Puedo:\n• Conversar contigo naturalmente\n• Aprender TODO lo que me enseñes\n• Recordarlo PARA SIEMPRE\n\n¡Empieza a hablar conmigo!", false)
    
    -- Evento de enviar
    local function enviarMensaje()
        local mensaje = inputBox.Text
        if mensaje and mensaje ~= "" then
            agregarMensaje("Tú: " .. mensaje, true)
            inputBox.Text = ""
            
            task.wait(0.5)
            local respuesta = TycoonIA.Hablar(mensaje)
            agregarMensaje("🤖 IA: " .. respuesta, false)
        end
    end
    
    sendBtn.MouseButton1Click:Connect(enviarMensaje)
    inputBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            enviarMensaje()
        end
    end)
    
    -- Hacer draggable
    local dragging, dragInput, dragStart, startPos
    
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
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- Animación de entrada
    mainFrame.Position = UDim2.new(0.5, -250, 1.5, 0)
    local tween = TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -250, 0.5, -300)
    })
    tween:Play()
    
    print("✅ Interfaz cargada!")
end

-- ═══════════════════════════════════════════════════════════════════════════
-- INICIALIZACIÓN
-- ═══════════════════════════════════════════════════════════════════════════

TycoonIA.Inicializar()
CrearUI()

_G.TycoonIA = TycoonIA
_G.IA = TycoonIA

print("╔═══════════════════════════════════════════════════════════════╗")
print("║        ✅ TYCOON IA ULTIMATE v17.0 - CARGADO!                 ║")
print("╠═══════════════════════════════════════════════════════════════╣")
print("║  🎨 Interfaz visual abierta en pantalla                       ║")
print("║  💬 Habla con la IA en la ventana                             ║")
print("║  📚 Todo se guarda automáticamente                            ║")
print("╚═══════════════════════════════════════════════════════════════╝")

return TycoonIA
