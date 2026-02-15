--[[
╔═══════════════════════════════════════════════════════════════════════════════╗
║        TYCOON AI ULTIMATE - WITH MOBILE UI (PERFECT FOR ARCEUS X)           ║
║                    "UNA IA CON INTERFAZ BONITA"                              ║
╚═══════════════════════════════════════════════════════════════════════════════╝

    🌟 TODO EN UNO + INTERFAZ MÓVIL
    
    ✅ UI compacta y bonita
    ✅ Botones para todo
    ✅ Chat integrado
    ✅ Memoria persistente
    ✅ Aprende TODO
    
    Solo ejecuta una vez y usa la UI!
    
═══════════════════════════════════════════════════════════════════════════════]]

--!strict

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer

-- ═══════════════════════════════════════════════════════════════════════════
-- 💾 SISTEMA DE GUARDADO
-- ═══════════════════════════════════════════════════════════════════════════

local SaveSystem = {}
local SAVE_FOLDER = "TycoonAI_Memory"
local SAVE_FILE = SAVE_FOLDER .. "/my_ai_memory.json"

function SaveSystem.SaveToFile(data)
    pcall(function()
        if writefile then
            if not isfolder(SAVE_FOLDER) then makefolder(SAVE_FOLDER) end
            writefile(SAVE_FILE, HttpService:JSONEncode(data))
            return true
        end
    end)
end

function SaveSystem.LoadFromFile()
    local success, result = pcall(function()
        if readfile and isfile and isfile(SAVE_FILE) then
            return HttpService:JSONDecode(readfile(SAVE_FILE))
        end
    end)
    return success and result or nil
end

-- ═══════════════════════════════════════════════════════════════════════════
-- 🧠 IA CORE
-- ═══════════════════════════════════════════════════════════════════════════

local AI = {
    memory = {
        learned = {},
        conversations = {},
        stats = {
            total_chats = 0,
            things_learned = 0,
            last_use = os.date()
        }
    }
}

function AI:Load()
    local saved = SaveSystem.LoadFromFile()
    if saved then
        self.memory = saved
        return true
    end
    return false
end

function AI:Save()
    self.memory.stats.last_use = os.date()
    SaveSystem.SaveToFile(self.memory)
end

function AI:Teach(concept, info)
    table.insert(self.memory.learned, {
        concept = concept,
        info = info,
        date = os.date()
    })
    self.memory.stats.things_learned = self.memory.stats.things_learned + 1
    self:Save()
end

function AI:Recall(query)
    for _, item in ipairs(self.memory.learned) do
        if item.concept:lower():find(query:lower()) then
            return item.info
        end
    end
    return nil
end

function AI:Chat(msg)
    self.memory.stats.total_chats = self.memory.stats.total_chats + 1
    
    local lower = msg:lower()
    
    -- Enseñar
    if lower:find("aprende que") or lower:find("recuerda que") then
        local concept = msg:match("que%s+(.+)")
        if concept then
            self:Teach(concept, msg)
            return "✅ Aprendido: " .. concept .. "\n💾 Guardado!"
        end
    end
    
    -- Recordar
    if lower:find("qué sabes") or lower:find("recuerdas") then
        local query = msg:match("de%s+(.+)") or msg:match("recuerdas%s+(.+)")
        if query then
            local recall = self:Recall(query)
            if recall then
                return "💡 Recuerdo:\n" .. recall
            else
                return "❌ No sé sobre eso\n🎓 Enséñame!"
            end
        end
    end
    
    -- Comandos
    if lower:find("velocidad") then
        local amount = tonumber(msg:match("%d+")) or 100
        pcall(function()
            local char = Player.Character
            char:WaitForChild("Humanoid").WalkSpeed = amount
        end)
        return "⚡ Velocidad: " .. amount
    end
    
    if lower:find("salto") then
        local amount = tonumber(msg:match("%d+")) or 100
        pcall(function()
            local char = Player.Character
            char:WaitForChild("Humanoid").JumpPower = amount
        end)
        return "🦘 Salto: " .. amount
    end
    
    -- Saludos
    if lower:find("hola") or lower:find("hey") then
        return "¡Hola! 😊\n\nSoy TycoonAI Ultimate\n\n📊 Aprendido: " .. 
               #self.memory.learned .. " cosas\n💬 Chats: " .. 
               self.memory.stats.total_chats
    end
    
    -- Ayuda
    if lower:find("ayuda") or lower:find("qué puedes") then
        return "💬 Converso contigo\n🎓 Aprendo lo que me enseñes\n⚡ Ejecuto comandos\n💾 Guardo TODO\n\nPrueba:\n• velocidad 100\n• Aprende que..."
    end
    
    -- Buscar en memoria
    for _, item in ipairs(self.memory.learned) do
        if msg:lower():find(item.concept:lower()) then
            return "💡 Sobre " .. item.concept .. ":\n" .. item.info
        end
    end
    
    return "🤔 Interesante...\n\n¿Quieres enseñarme sobre eso?\n\nDi: 'Aprende que...'"
end

-- Cargar memoria
AI:Load()

-- ═══════════════════════════════════════════════════════════════════════════
-- 🎨 UI MÓVIL
-- ═══════════════════════════════════════════════════════════════════════════

print("🎨 Creando UI móvil...")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TycoonAI_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Limpiar UI anterior
if Player.PlayerGui:FindFirstChild("TycoonAI_UI") then
    Player.PlayerGui:FindFirstChild("TycoonAI_UI"):Destroy()
end

ScreenGui.Parent = Player.PlayerGui

-- ═══════════════════════════════════════════════════════════════════════════
-- MAIN FRAME (Compacto para móvil)
-- ═══════════════════════════════════════════════════════════════════════════

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 340, 0, 450)
Main.Position = UDim2.new(0.5, -170, 0.5, -225)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 15)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(138, 43, 226)
MainStroke.Thickness = 2
MainStroke.Parent = Main

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
Header.BorderSizePixel = 0
Header.Parent = Main

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 15)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -100, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🧠 TycoonAI Ultimate"
Title.TextColor3 = Color3.white
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Botón Cerrar
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -45, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 69, 58)
CloseBtn.Text = "✕"
CloseBtn.TextSize = 20
CloseBtn.TextColor3 = Color3.white
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Header

local CloseBtnCorner = Instance.new("UICorner")
CloseBtnCorner.CornerRadius = UDim.new(0, 8)
CloseBtnCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- ═══════════════════════════════════════════════════════════════════════════
-- CHAT AREA
-- ═══════════════════════════════════════════════════════════════════════════

local ChatScroll = Instance.new("ScrollingFrame")
ChatScroll.Size = UDim2.new(1, -20, 1, -180)
ChatScroll.Position = UDim2.new(0, 10, 0, 60)
ChatScroll.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
ChatScroll.BorderSizePixel = 0
ChatScroll.ScrollBarThickness = 4
ChatScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
ChatScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
ChatScroll.Parent = Main

local ChatCorner = Instance.new("UICorner")
ChatCorner.CornerRadius = UDim.new(0, 10)
ChatCorner.Parent = ChatScroll

local ChatLayout = Instance.new("UIListLayout")
ChatLayout.Padding = UDim.new(0, 8)
ChatLayout.SortOrder = Enum.SortOrder.LayoutOrder
ChatLayout.Parent = ChatScroll

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingTop = UDim.new(0, 8)
UIPadding.PaddingLeft = UDim.new(0, 8)
UIPadding.PaddingRight = UDim.new(0, 8)
UIPadding.Parent = ChatScroll

-- Función para agregar mensajes
local function AddMessage(text, isUser)
    local Msg = Instance.new("Frame")
    Msg.Size = UDim2.new(1, -16, 0, 0)
    Msg.BackgroundColor3 = isUser and Color3.fromRGB(138, 43, 226) or Color3.fromRGB(45, 45, 55)
    Msg.BackgroundTransparency = 0.2
    Msg.BorderSizePixel = 0
    Msg.AutomaticSize = Enum.AutomaticSize.Y
    Msg.Parent = ChatScroll
    
    local MsgCorner = Instance.new("UICorner")
    MsgCorner.CornerRadius = UDim.new(0, 8)
    MsgCorner.Parent = Msg
    
    local MsgText = Instance.new("TextLabel")
    MsgText.Size = UDim2.new(1, -16, 0, 0)
    MsgText.Position = UDim2.new(0, 8, 0, 8)
    MsgText.BackgroundTransparency = 1
    MsgText.Text = (isUser and "👤 Tú: " or "🤖 AI: ") .. text
    MsgText.TextColor3 = Color3.white
    MsgText.TextSize = 14
    MsgText.Font = Enum.Font.Gotham
    MsgText.TextWrapped = true
    MsgText.TextXAlignment = Enum.TextXAlignment.Left
    MsgText.TextYAlignment = Enum.TextYAlignment.Top
    MsgText.AutomaticSize = Enum.AutomaticSize.Y
    MsgText.Parent = Msg
    
    local MsgPadding = Instance.new("UIPadding")
    MsgPadding.PaddingTop = UDim.new(0, 8)
    MsgPadding.PaddingBottom = UDim.new(0, 8)
    MsgPadding.Parent = Msg
    
    ChatScroll.CanvasPosition = Vector2.new(0, ChatScroll.AbsoluteCanvasSize.Y)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- INPUT AREA
-- ═══════════════════════════════════════════════════════════════════════════

local InputContainer = Instance.new("Frame")
InputContainer.Size = UDim2.new(1, -20, 0, 50)
InputContainer.Position = UDim2.new(0, 10, 1, -60)
InputContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
InputContainer.BorderSizePixel = 0
InputContainer.Parent = Main

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 10)
InputCorner.Parent = InputContainer

local InputBox = Instance.new("TextBox")
InputBox.Size = UDim2.new(1, -60, 1, -10)
InputBox.Position = UDim2.new(0, 10, 0, 5)
InputBox.BackgroundTransparency = 1
InputBox.Text = ""
InputBox.PlaceholderText = "Escribe aquí..."
InputBox.TextColor3 = Color3.white
InputBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
InputBox.TextSize = 14
InputBox.Font = Enum.Font.Gotham
InputBox.TextXAlignment = Enum.TextXAlignment.Left
InputBox.ClearTextOnFocus = false
InputBox.Parent = InputContainer

local SendBtn = Instance.new("TextButton")
SendBtn.Size = UDim2.new(0, 45, 0, 40)
SendBtn.Position = UDim2.new(1, -50, 0, 5)
SendBtn.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
SendBtn.Text = "➤"
SendBtn.TextSize = 18
SendBtn.TextColor3 = Color3.white
SendBtn.Font = Enum.Font.GothamBold
SendBtn.Parent = InputContainer

local SendBtnCorner = Instance.new("UICorner")
SendBtnCorner.CornerRadius = UDim.new(0, 8)
SendBtnCorner.Parent = SendBtn

-- ═══════════════════════════════════════════════════════════════════════════
-- BOTONES RÁPIDOS
-- ═══════════════════════════════════════════════════════════════════════════

local QuickButtons = Instance.new("Frame")
QuickButtons.Size = UDim2.new(1, -20, 0, 50)
QuickButtons.Position = UDim2.new(0, 10, 1, -120)
QuickButtons.BackgroundTransparency = 1
QuickButtons.Parent = Main

local ButtonsLayout = Instance.new("UIListLayout")
ButtonsLayout.FillDirection = Enum.FillDirection.Horizontal
ButtonsLayout.Padding = UDim.new(0, 5)
ButtonsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ButtonsLayout.Parent = QuickButtons

local function CreateQuickButton(text, emoji, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(0, 75, 0, 45)
    Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    Btn.Text = emoji .. "\n" .. text
    Btn.TextSize = 11
    Btn.TextColor3 = Color3.white
    Btn.Font = Enum.Font.GothamBold
    Btn.Parent = QuickButtons
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 8)
    BtnCorner.Parent = Btn
    
    Btn.MouseButton1Click:Connect(callback)
    
    return Btn
end

CreateQuickButton("Ver\nAprendido", "📚", function()
    local learned = AI.memory.learned
    if #learned == 0 then
        AddMessage("No he aprendido nada aún 🎓", false)
    else
        local list = "Cosas aprendidas:\n\n"
        for i, item in ipairs(learned) do
            list = list .. i .. ". " .. item.concept .. "\n"
        end
        AddMessage(list, false)
    end
end)

CreateQuickButton("Stats", "📊", function()
    local stats = AI.memory.stats
    AddMessage(
        "📊 Estadísticas:\n\n" ..
        "💬 Chats: " .. stats.total_chats .. "\n" ..
        "🎓 Aprendido: " .. stats.things_learned .. "\n" ..
        "📅 Último: " .. stats.last_use,
        false
    )
end)

CreateQuickButton("Guardar", "💾", function()
    AI:Save()
    AddMessage("✅ Memoria guardada!", false)
end)

CreateQuickButton("Ayuda", "❓", function()
    AddMessage(
        "🌟 Comandos:\n\n" ..
        "• velocidad [número]\n" ..
        "• salto [número]\n" ..
        "• Aprende que...\n" ..
        "• Qué sabes de...\n\n" ..
        "💡 Escribe natural!",
        false
    )
end)

-- ═══════════════════════════════════════════════════════════════════════════
-- LÓGICA DE ENVÍO
-- ═══════════════════════════════════════════════════════════════════════════

local function SendMessage()
    local msg = InputBox.Text
    if msg == "" then return end
    
    AddMessage(msg, true)
    
    local response = AI:Chat(msg)
    
    wait(0.3)
    AddMessage(response, false)
    
    InputBox.Text = ""
end

SendBtn.MouseButton1Click:Connect(SendMessage)

InputBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        SendMessage()
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════
-- MENSAJE INICIAL
-- ═══════════════════════════════════════════════════════════════════════════

wait(0.5)

if #AI.memory.learned > 0 then
    AddMessage(
        "👋 ¡Hola de nuevo!\n\n" ..
        "He aprendido " .. #AI.memory.learned .. " cosas de ti.\n" ..
        "Última vez: " .. AI.memory.stats.last_use,
        false
    )
else
    AddMessage(
        "👋 ¡Hola! Soy TycoonAI Ultimate\n\n" ..
        "💬 Conversa conmigo\n" ..
        "🎓 Enséñame lo que quieras\n" ..
        "💾 Guardaré TODO\n\n" ..
        "Prueba los botones de abajo! 👇",
        false
    )
end

-- ═══════════════════════════════════════════════════════════════════════════
-- EXPORTAR GLOBALMENTE
-- ═══════════════════════════════════════════════════════════════════════════

_G.AI = AI
_G.TycoonAI_UI = ScreenGui

-- Notificación
pcall(function()
    game.StarterGui:SetCore("SendNotification", {
        Title = "✅ TycoonAI Ultimate",
        Text = "UI cargada! 💙\nUsa la ventana para chatear",
        Duration = 4
    })
end)

print("\n✅ TYCOON AI ULTIMATE CON UI - LISTO!")
print("   Usa la ventana de chat para interactuar")
print("   📱 Perfecta para móvil (Arceus X)")
print("   💾 Todo se guarda automáticamente\n")

return ScreenGui

