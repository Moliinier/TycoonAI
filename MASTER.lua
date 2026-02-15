--[[
╔═══════════════════════════════════════════════════════════════════════════════╗
║                  TYCOON AI v17.1 - MASTER SCRIPT                              ║
║                 🎯 ESTE EJECUTA Y CARGA TODO                                  ║
╚═══════════════════════════════════════════════════════════════════════════════╝

    📦 CARGA AUTOMÁTICAMENTE:
    1. Brain.lua          - Sistema de 5 IAs
    2. Database_Part1.lua - 18 comandos
    3. Database_Part2.lua - 26 comandos  
    4. UI.lua             - Interfaz completa
    
    ✨ 1 SCRIPT = TODO EL SISTEMA
    
═══════════════════════════════════════════════════════════════════════════════]]

--!strict

-- ═══════════════════════════════════════════════════════════════════════════
-- 🌐 CONFIGURACIÓN DE GITHUB
-- ═══════════════════════════════════════════════════════════════════════════

local GITHUB_REPO = "https://raw.githubusercontent.com/Moliinier/TycoonAI/main/"

-- ═══════════════════════════════════════════════════════════════════════════
-- 🎨 INICIO
-- ═══════════════════════════════════════════════════════════════════════════

print("\n")
print("╔═══════════════════════════════════════════════════════════════════════════════╗")
print("║                                                                               ║")
print("║                    🧠 TYCOON AI ASSISTANT v17.1                               ║")
print("║                        MASTER SCRIPT UNIFICADO                                ║")
print("║                                                                               ║")
print("╚═══════════════════════════════════════════════════════════════════════════════╝")
print("\n")

-- ═══════════════════════════════════════════════════════════════════════════
-- 📦 INICIALIZACIÓN GLOBAL
-- ═══════════════════════════════════════════════════════════════════════════

_G.TycoonAI = _G.TycoonAI or {}
_G.TycoonAI.Version = "17.1 MASTER"
_G.TycoonAI.LoadTime = tick()
_G.TycoonAI.Status = {
    BrainLoaded = false,
    Database1Loaded = false,
    Database2Loaded = false,
    UILoaded = false,
    Ready = false
}

print("✅ Inicialización global completada")

-- ═══════════════════════════════════════════════════════════════════════════
-- 🔧 FUNCIÓN DE CARGA CON REINTENTOS
-- ═══════════════════════════════════════════════════════════════════════════

local function LoadScript(scriptName, url, maxRetries)
    maxRetries = maxRetries or 3
    local retries = 0
    
    print("\n📥 Cargando: " .. scriptName)
    
    while retries < maxRetries do
        local success, result = pcall(function()
            return game:HttpGet(url)
        end)
        
        if success then
            local loadSuccess, loadResult = pcall(function()
                return loadstring(result)()
            end)
            
            if loadSuccess then
                print("   ✅ " .. scriptName .. " - CARGADO")
                return true
            else
                warn("   ⚠️ Error ejecutando " .. scriptName .. ": " .. tostring(loadResult))
                retries = retries + 1
            end
        else
            warn("   ⚠️ Error descargando " .. scriptName .. ": " .. tostring(result))
            retries = retries + 1
        end
        
        if retries < maxRetries then
            print("   🔄 Reintentando... (" .. retries .. "/" .. maxRetries .. ")")
            wait(1)
        end
    end
    
    warn("   ❌ " .. scriptName .. " - FALLÓ después de " .. maxRetries .. " intentos")
    return false
end

-- ═══════════════════════════════════════════════════════════════════════════
-- 🚀 CARGAR TODOS LOS COMPONENTES
-- ═══════════════════════════════════════════════════════════════════════════

print("\n╔═══════════════════════════════════════╗")
print("║   🔄 CARGANDO COMPONENTES...          ║")
print("╚═══════════════════════════════════════╝")

-- 1. CARGAR BRAIN SYSTEM
print("\n[1/4] 🧠 Brain System")
print("      Cargando 5 IAs integradas...")
if LoadScript("Brain.lua", GITHUB_REPO .. "Brain.lua") then
    _G.TycoonAI.Status.BrainLoaded = true
    wait(0.5)
end

-- 2. CARGAR DATABASE PART 1
print("\n[2/4] 📚 Database Part 1")
print("      Cargando comandos 1-18...")
if LoadScript("Database_Part1.lua", GITHUB_REPO .. "Database_Part1.lua") then
    _G.TycoonAI.Status.Database1Loaded = true
    wait(0.5)
end

-- 3. CARGAR DATABASE PART 2
print("\n[3/4] 📚 Database Part 2")
print("      Cargando comandos 19-44...")
if LoadScript("Database_Part2.lua", GITHUB_REPO .. "Database_Part2.lua") then
    _G.TycoonAI.Status.Database2Loaded = true
    wait(0.5)
end

-- 4. CARGAR UI SYSTEM
print("\n[4/4] 🎨 UI System")
print("      Cargando interfaz compacta...")
if LoadScript("UI.lua", GITHUB_REPO .. "UI.lua") then
    _G.TycoonAI.Status.UILoaded = true
    wait(1)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- ✅ VERIFICACIÓN FINAL
-- ═══════════════════════════════════════════════════════════════════════════

_G.TycoonAI.Status.Ready = 
    _G.TycoonAI.Status.BrainLoaded and 
    _G.TycoonAI.Status.Database1Loaded and
    _G.TycoonAI.Status.Database2Loaded and
    _G.TycoonAI.Status.UILoaded

print("\n")
print("╔═══════════════════════════════════════════════════════════════════════════════╗")
print("║                         📊 REPORTE DE CARGA                                   ║")
print("╠═══════════════════════════════════════════════════════════════════════════════╣")

local function printStatus(name, status)
    local icon = status and "✅" or "❌"
    local text = status and "CARGADO   " or "FALLÓ     "
    print("║  " .. icon .. " " .. name .. ": " .. text .. string.rep(" ", 45 - #name) .. "║")
end

printStatus("🧠 Brain System      ", _G.TycoonAI.Status.BrainLoaded)
printStatus("📚 Database Part 1   ", _G.TycoonAI.Status.Database1Loaded)
printStatus("📚 Database Part 2   ", _G.TycoonAI.Status.Database2Loaded)
printStatus("🎨 UI System         ", _G.TycoonAI.Status.UILoaded)

print("╠═══════════════════════════════════════════════════════════════════════════════╣")

if _G.TycoonAI.Status.Ready then
    print("║                        ✅ SISTEMA STATUS: READY                               ║")
    print("╠═══════════════════════════════════════════════════════════════════════════════╣")
    print("║  💬 Chat IA: ACTIVO                                                           ║")
    print("║  📱 UI Compacta: 320x400                                                      ║")
    print("║  🎮 Comandos: 67 disponibles                                                  ║")
    print("║  ⏱️  Tiempo de carga: " .. string.format("%.2f", tick() - _G.TycoonAI.LoadTime) .. "s" .. string.rep(" ", 52) .. "║")
else
    print("║                       ⚠️ SISTEMA STATUS: PARCIAL                             ║")
    print("╠═══════════════════════════════════════════════════════════════════════════════╣")
    print("║  ⚠️ Algunos componentes no cargaron correctamente                            ║")
    print("║  🔄 Intenta ejecutar el script de nuevo                                      ║")
end

print("╚═══════════════════════════════════════════════════════════════════════════════╝")
print("\n")

-- ═══════════════════════════════════════════════════════════════════════════
-- 🎮 FUNCIONES GLOBALES
-- ═══════════════════════════════════════════════════════════════════════════

if _G.TycoonAI.Status.Ready then
    
    -- Función de ayuda
    _G.ShowHelp = function()
        print("\n╔═══════════════════════════════════════════════════════════════╗")
        print("║              🧠 TYCOON AI v17.1 - AYUDA RÁPIDA                ║")
        print("╠═══════════════════════════════════════════════════════════════╣")
        print("║                                                               ║")
        print("║  📝 COMANDOS DISPONIBLES:                                     ║")
        print("║                                                               ║")
        print("║  💬 Chat: Escribe en la ventana de chat                      ║")
        print("║     'velocidad', 'salto', 'menu', 'particulas'...           ║")
        print("║                                                               ║")
        print("║  📋 _G.ExecuteCommand('velocidad')                           ║")
        print("║     → Ejecuta comando directamente                           ║")
        print("║                                                               ║")
        print("║  🧠 _G.TycoonAI.Brain:ProcessIntelligently('texto')          ║")
        print("║     → Procesa comando con IA                                 ║")
        print("║                                                               ║")
        print("║  📊 _G.GetSystemReport()                                     ║")
        print("║     → Ver estadísticas del sistema                           ║")
        print("║                                                               ║")
        print("╠═══════════════════════════════════════════════════════════════╣")
        print("║  🎯 67 COMANDOS EN 16 CATEGORÍAS                             ║")
        print("║                                                               ║")
        print("║  ⚡ Movimiento  🎨 UI  🌈 Efectos  🎮 Controles              ║")
        print("║  🛠️  Utilidades  💰 Economía  📦 Templates  🔧 Sistema      ║")
        print("║                                                               ║")
        print("╚═══════════════════════════════════════════════════════════════╝\n")
    end
    
    -- Función ejecutar comando
    _G.ExecuteCommand = function(commandName)
        if _G.TycoonAI.Brain then
            local result = _G.TycoonAI.Brain:ProcessIntelligently(commandName)
            print(result.message or "✅ Comando ejecutado")
            return result
        else
            warn("⚠️ Brain System no está cargado")
            return {success = false, message = "Brain no disponible"}
        end
    end
    
    -- Función reporte
    _G.GetSystemReport = function()
        return {
            version = _G.TycoonAI.Version,
            status = _G.TycoonAI.Status,
            uptime = tick() - _G.TycoonAI.LoadTime,
            ready = _G.TycoonAI.Status.Ready
        }
    end
    
    -- Mensaje de bienvenida
    print("🎉 ¡TYCOON AI ESTÁ LISTO!")
    print("💬 Busca la ventana de chat en pantalla")
    print("📝 Escribe: _G.ShowHelp() para ver comandos\n")
    
    -- Notificación en juego
    game.StarterGui:SetCore("SendNotification", {
        Title = "✅ TYCOON AI v17.1",
        Text = "Sistema completo cargado!\n5 IAs trabajando para ti 💙",
        Duration = 5
    })
    
else
    
    -- Si algo falló
    print("⚠️ ALGUNOS COMPONENTES NO CARGARON")
    print("💡 Solución:")
    print("   1. Verifica tu conexión a internet")
    print("   2. Asegúrate que HttpService esté habilitado")
    print("   3. Intenta ejecutar el script de nuevo\n")
    
    game.StarterGui:SetCore("SendNotification", {
        Title = "⚠️ TycoonAI",
        Text = "Carga parcial\nRevisa la consola (F9)",
        Duration = 5
    })
    
end

-- ═══════════════════════════════════════════════════════════════════════════
-- 💙 MENSAJE FINAL
-- ═══════════════════════════════════════════════════════════════════════════

print("╔═══════════════════════════════════════════════════════════════╗")
print("║                                                               ║")
print("║         'No solo generamos código.                            ║")
print("║          Creamos experiencias.                                ║")
print("║          Construimos sueños.'                                 ║")
print("║                                                               ║")
print("║                    💙🤖✨                                       ║")
print("║                                                               ║")
print("║  Creado por: DeepSeek, Claude, ChatGPT, Gemini, Haiku        ║")
print("║                                                               ║")
print("╚═══════════════════════════════════════════════════════════════╝\n")

return _G.TycoonAI
