--[[
╔═══════════════════════════════════════════════════════════════════════════════╗
║              TYCOON AI ULTIMATE - UI SIMPLE (ARCEUS X FIXED)                 ║
╚═══════════════════════════════════════════════════════════════════════════════╝
]]

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local Player = Players.LocalPlayer

-- ═══════════════════════════════════════════════════════════════════════════
-- 💾 GUARDADO
-- ═══════════════════════════════════════════════════════════════════════════

local SAVE_FILE = "TycoonAI_Memory/memory.json"

local function Save(data)
    pcall(function()
        if not isfolder("TycoonAI_Memory") then makefolder("TycoonAI_Memory") end
        writefile(SAVE_FILE, HttpService:JSONEncode(data))
    end)
end

local function Load()
    local success, result = pcall(function()
        if isfile(SAVE_FILE) then
            return HttpService:JSONDecode(readfile(SAVE_FILE))
        end
    end)
    return success and result or {learned = {}, stats = {chats = 0, learned = 0}}
end

-- ═══════════════════════════════════════════════════════════════════════════
-- 🧠 IA
-- ═══════════════════════════════════════════════════════════════════════════

local Memory = Load()

local function Teach(concept, info)
    table.insert(Memory.learned, {c = concept, i = info})
    Memory.stats.learned = Memory.stats.learned + 1
    Save(Memory)
end

local function Chat(msg)
    Memory.stats.chats = Memory.stats.chats + 1
    local lower = msg:lower()
    
    if lower:find("aprende") then
        local c = msg:match("que%s+(.+)")
        if c then
            Teach(c, msg)
            return "✅ Aprendido!\n" .. c
        end
    end
    
    if lower:find("qué sabes") or lower:find("recuerdas") then
        for _, item in ipairs(Memory.learned) do
            if lower:find(item.c:lower()) then
                return "💡 " .. item.i
            end
        end
        return "❌ No sé eso"
    end
    
    if lower:find("velocidad") then
        local n = tonumber(msg:match("%d+")) or 100
        pcall(function() Player.Character.Humanoid.WalkSpeed = n end)
        return "⚡ Velocidad: " .. n
    end
    
    if lower:find("salto") then
        local n = tonumber(msg:match("%d+")) or 100
        pcall(function() Player.Character.Humanoid.JumpPower = n end)
        return "🦘 Salto: " .. n
    end
    
    if lower:find("hola") then
        return "👋 Hola!\n\n📊 Chats: " .. Memory.stats.chats .. "\n🎓 Aprendido: " .. #Memory.learned
    end
    
    if lower:find("ayuda") then
        return "Comandos:\n• velocidad [N]\n• salto [N]\n• Aprende que...\n• Qué sabes de..."
    end
    
    return "🤔 Prueba:\n• Aprende que...\n• velocidad 100\n• ayuda"
end

-- ═══════════════════════════════════════════════════════════════════════════
-- 🎨 UI SIMPLE
-- ═══════════════════════════════════════════════════════════════════════════

if Player.PlayerGui:FindFirstChild("AI_UI") then
    Player.PlayerGui.AI_UI:Destroy()
end

local UI = Instance.new("ScreenGui")
UI.Name = "AI_UI"
UI.ResetOnSpawn = false
UI.Parent = Player.PlayerGui

-- Frame principal
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 350, 0, 500)
Frame.Position = UDim2.new(0.5, -175, 0.5, -250)
Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Frame.Active = true
Frame.Draggable = true
Frame.Parent = UI

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 12)
Corner.Parent = Frame

-- Header
local Header = Instance.new("TextLabel")
Header.Size = UDim2.new(1, 0, 0, 45)
Header.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
Header.Text = "🧠 TycoonAI"
Header.TextColor3 = Color3.white
Header.TextSize = 18
Header.Font = Enum.Font.GothamBold
Header.Parent = Frame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

-- Botón cerrar
local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 35, 0, 35)
Close.Position = UDim2.new(1, -40, 0, 5)
Close.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
Close.Text = "X"
Close.TextColor3 = Color3.white
Close.TextSize = 16
Close.Font = Enum.Font.GothamBold
Close.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = Close

Close.MouseButton1Click:Connect(function()
    UI:Destroy()
end)

-- Chat scroll
local Chat = Instance.new("ScrollingFrame")
Chat.Size = UDim2.new(1, -20, 1, -160)
Chat.Position = UDim2.new(0, 10, 0, 55)
Chat.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
Chat.BorderSizePixel = 0
Chat.ScrollBarThickness = 6
Chat.Parent = Frame

local ChatCorner = Instance.new("UICorner")
ChatCorner.CornerRadius = UDim.new(0, 10)
ChatCorner.Parent = Chat

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 5)
Layout.Parent = Chat

-- Input
local Input = Instance.new("TextBox")
Input.Size = UDim2.new(1, -70, 0, 40)
Input.Position = UDim2.new(0, 10, 1, -50)
Input.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
Input.Text = ""
Input.PlaceholderText = "Escribe aquí..."
Input.TextColor3 = Color3.white
Input.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
Input.TextSize = 14
Input.Font = Enum.Font.Gotham
Input.ClearTextOnFocus = false
Input.Parent = Frame

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 8)
InputCorner.Parent = Input

-- Botón enviar
local Send = Instance.new("TextButton")
Send.Size = UDim2.new(0, 50, 0, 40)
Send.Position = UDim2.new(1, -60, 1, -50)
Send.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
Send.Text = ">"
Send.TextColor3 = Color3.white
Send.TextSize = 20
Send.Font = Enum.Font.GothamBold
Send.Parent = Frame

local SendCorner = Instance.new("UICorner")
SendCorner.CornerRadius = UDim.new(0, 8)
SendCorner.Parent = Send

-- Botones rápidos
local Btns = Instance.new("Frame")
Btns.Size = UDim2.new(1, -20, 0, 50)
Btns.Position = UDim2.new(0, 10, 1, -100)
Btns.BackgroundTransparency = 1
Btns.Parent = Frame

local BLayout = Instance.new("UIListLayout")
BLayout.FillDirection = Enum.FillDirection.Horizontal
BLayout.Padding = UDim.new(0, 5)
BLayout.Parent = Btns

local function Btn(txt, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 80, 0, 45)
    b.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    b.Text = txt
    b.TextColor3 = Color3.white
    b.TextSize = 11
    b.Font = Enum.Font.GothamBold
    b.Parent = Btns
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = b
    
    b.MouseButton1Click:Connect(callback)
end

-- Función mensaje
local function Msg(txt, isUser)
    local m = Instance.new("TextLabel")
    m.Size = UDim2.new(1, -10, 0, 0)
    m.BackgroundColor3 = isUser and Color3.fromRGB(138, 43, 226) or Color3.fromRGB(50, 50, 60)
    m.BackgroundTransparency = 0.3
    m.Text = txt
    m.TextColor3 = Color3.white
    m.TextSize = 13
    m.Font = Enum.Font.Gotham
    m.TextWrapped = true
    m.TextXAlignment = Enum.TextXAlignment.Left
    m.TextYAlignment = Enum.TextYAlignment.Top
    m.AutomaticSize = Enum.AutomaticSize.Y
    m.Parent = Chat
    
    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 8)
    pad.PaddingRight = UDim.new(0, 8)
    pad.PaddingTop = UDim.new(0, 8)
    pad.PaddingBottom = UDim.new(0, 8)
    pad.Parent = m
    
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = m
    
    Chat.CanvasPosition = Vector2.new(0, 99999)
end

-- Enviar
local function SendMsg()
    local txt = Input.Text
    if txt == "" then return end
    
    Msg("👤 " .. txt, true)
    local resp = Chat(txt)
    wait(0.2)
    Msg("🤖 " .. resp, false)
    
    Input.Text = ""
end

Send.MouseButton1Click:Connect(SendMsg)
Input.FocusLost:Connect(function(enter)
    if enter then SendMsg() end
end)

-- Botones
Btn("📚\nVer", function()
    if #Memory.learned == 0 then
        Msg("🤖 No he aprendido nada", false)
    else
        local list = "Aprendido:\n"
        for i, item in ipairs(Memory.learned) do
            list = list .. i .. ". " .. item.c .. "\n"
        end
        Msg("🤖 " .. list, false)
    end
end)

Btn("📊\nStats", function()
    Msg("🤖 📊 Stats:\n\nChats: " .. Memory.stats.chats .. "\nAprendido: " .. #Memory.learned, false)
end)

Btn("💾\nGuardar", function()
    Save(Memory)
    Msg("🤖 ✅ Guardado!", false)
end)

Btn("❓\nAyuda", function()
    Msg("🤖 Comandos:\n• velocidad [N]\n• salto [N]\n• Aprende que...\n• Qué sabes de...", false)
end)

-- Mensaje inicial
wait(0.5)
if #Memory.learned > 0 then
    Msg("🤖 ¡Hola! Te recuerdo.\nAprendido: " .. #Memory.learned .. " cosas", false)
else
    Msg("🤖 👋 ¡Hola!\n\nSoy TycoonAI Ultimate\n\nPrueba:\n• Aprende que...\n• velocidad 100\n• Los botones de abajo", false)
end

_G.AI = {Chat = Chat, Memory = Memory, Save = function() Save(Memory) end}

print("✅ TycoonAI UI cargada!")

return UI
