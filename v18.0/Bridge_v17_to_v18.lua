--[[
╔═══════════════════════════════════════════════════════════════════════════════╗
║         TYCOON AI v18.0 - INTEGRACIÓN CON SISTEMA v17.1 EXISTENTE            ║
║                "EL MEJOR DE AMBOS MUNDOS"                                     ║
╚═══════════════════════════════════════════════════════════════════════════════╝

    Este script conecta:
    - TycoonAI v18.0 (IA Conversacional) ← NUEVO
    - TycoonAI v17.1 (Database + Brain)  ← EXISTENTE
    
    Resultado: IA conversacional + 44 comandos + 5 sistemas de IA
    
═══════════════════════════════════════════════════════════════════════════════]]

--!strict

print("\n╔═══════════════════════════════════════════════════════════════╗")
print("║   🔗 TYCOON AI - BRIDGE v17.1 ↔ v18.0                        ║")
print("╚═══════════════════════════════════════════════════════════════╝\n")

-- ═══════════════════════════════════════════════════════════════════════════
-- 📥 PASO 1: CARGAR SISTEMA v17.1 (SI NO ESTÁ CARGADO)
-- ═══════════════════════════════════════════════════════════════════════════

local function LoadV17System()
    print("📦 [1/3] Cargando Sistema v17.1...")
    
    -- Verificar si ya está cargado
    if _G.TycoonAI and _G.TycoonAI.Database and _G.TycoonAI.Brain then
        print("   ✅ Sistema v17.1 ya cargado!")
        return true
    end
    
    print("   ⚠️ Sistema v17.1 no detectado.")
    print("   💡 Cárgalo primero con MASTER.lua o manualmente")
    
    return false
end

-- ═══════════════════════════════════════════════════════════════════════════
-- 📥 PASO 2: CARGAR SISTEMA v18.0
-- ═══════════════════════════════════════════════════════════════════════════

local function LoadV18System()
    print("\n🧠 [2/3] Cargando Sistema v18.0...")
    
    -- Verificar módulos necesarios
    if not _G.ConversationalAI then
        print("   ❌ ConversationalAI Core no encontrado")
        print("   💡 Carga ConversationalAI_Core.lua primero")
        return false
    end
    
    if not _G.DeepLearningSystem then
        print("   ❌ DeepLearningSystem no encontrado")
        print("   💡 Carga DeepLearning_System.lua primero")
        return false
    end
    
    if not _G.TycoonAIComplete then
        print("   ❌ TycoonAIComplete no encontrado")
        print("   💡 Carga TycoonAI_v18_Complete.lua primero")
        return false
    end
    
    print("   ✅ Todos los módulos v18.0 detectados!")
    return true
end

-- ═══════════════════════════════════════════════════════════════════════════
-- 🔗 PASO 3: CONECTAR AMBOS SISTEMAS
-- ═══════════════════════════════════════════════════════════════════════════

local function BridgeSystems()
    print("\n🔗 [3/3] Conectando v17.1 ↔ v18.0...")
    
    if not _G.AI then
        print("   ❌ Sistema v18.0 no inicializado")
        return false
    end
    
    local v17_available = _G.TycoonAI and _G.TycoonAI.Database and _G.TycoonAI.Brain
    
    if v17_available then
        -- Conectar Database v17.1 a AI v18.0
        if _G.TycoonAI.Database then
            _G.AI.database = _G.TycoonAI.Database
            print("   ✅ Database v17.1 conectada (44 comandos)")
        end
        
        -- Conectar Brain v17.1 a AI v18.0
        if _G.TycoonAI.Brain then
            _G.AI.brain = _G.TycoonAI.Brain
            print("   ✅ Brain v17.1 conectado (5 IAs)")
        end
        
        -- Actualizar capacidades
        _G.AI.config.capabilities.commands = true
        _G.AI.config.capabilities.brain_systems = true
        
        print("   ✅ Integración completa!")
        print("\n   📊 CAPACIDADES COMBINADAS:")
        print("      💬 Conversación Natural (v18.0)")
        print("      🧠 Aprendizaje Profundo (v18.0)")
        print("      ⚡ 44 Comandos (v17.1)")
        print("      🤖 5 Sistemas de IA (v17.1)")
        print("      🎨 UI Compacta (v17.1)")
        
        return true
    else
        print("   ⚠️ Sistema v17.1 no disponible")
        print("   ℹ️  v18.0 funcionará solo con conversación")
        return true
    end
end

-- ═══════════════════════════════════════════════════════════════════════════
-- ✨ MEJORAS ADICIONALES
-- ═══════════════════════════════════════════════════════════════════════════

local function EnhanceAI()
    if not _G.AI then return end
    
    print("\n✨ Aplicando mejoras...")
    
    -- 1. Agregar comandos v17.1 al vocabulario de la IA
    if _G.AI.database then
        local commandKeywords = {}
        
        -- Extraer keywords de todos los comandos
        local categories = {
            "Movement", "UI", "VisualEffects", "Controls",
            "Utilities", "Economy", "Templates", "System"
        }
        
        for _, category in ipairs(categories) do
            local commands = _G.AI.database[category]
            if commands then
                for _, command in ipairs(commands) do
                    for _, keyword in ipairs(command.keywords) do
                        table.insert(commandKeywords, keyword)
                    end
                end
            end
        end
        
        -- Enseñar keywords a la IA conversacional
        _G.AI.conversational_ai.knowledge_graph.entities["comandos_disponibles"] = {
            keywords = commandKeywords,
            category = "system_commands",
            learned_at = tick()
        }
        
        print("   ✅ " .. #commandKeywords .. " comandos agregados al vocabulario")
    end
    
    -- 2. Mejorar detección de comandos
    local originalChat = _G.AI.Chat
    _G.AI.Chat = function(self, message)
        -- Preprocesar para mejorar detección
        local enhanced_message = message
        
        -- Si menciona "comando", priorizar ejecución
        if message:lower():find("comando") or message:lower():find("ejecuta") then
            enhanced_message = message:gsub("dame el comando", "")
            enhanced_message = enhanced_message:gsub("ejecuta el comando", "")
        end
        
        return originalChat(self, enhanced_message)
    end
    
    print("   ✅ Detección de comandos mejorada")
    
    -- 3. Agregar respuestas contextuales para comandos
    if _G.AI.conversational_ai then
        table.insert(_G.AI.conversational_ai.language_model.patterns, {
            trigger = {"comandos disponibles", "qué comandos", "lista de comandos"},
            response_type = "command_list",
            template = function(self)
                if not _G.AI.database then
                    return "No tengo comandos cargados actualmente."
                end
                
                local total = _G.AI.database.Info.TotalCommands
                return string.format(
                    "Tengo %d comandos disponibles en estas categorías:\n" ..
                    "⚡ Movimiento - velocidad, salto, vuelo, noclip\n" ..
                    "🎨 UI - menús, botones, notificaciones\n" ..
                    "🌈 Efectos - partículas, colores, luces\n" ..
                    "🎮 Controles - joystick, touch, gamepad\n" ..
                    "Y más! Pregúntame por cualquier categoría específica.",
                    total
                )
            end
        })
        
        print("   ✅ Respuestas contextuales agregadas")
    end
end

-- ═══════════════════════════════════════════════════════════════════════════
-- 🎮 FUNCIÓN HELPER: CHAT MEJORADO
-- ═══════════════════════════════════════════════════════════════════════════

local function CreateEnhancedChatFunction()
    _G.SmartChat = function(message)
        if not _G.AI then
            warn("⚠️ Sistema no inicializado")
            return "Sistema no disponible"
        end
        
        print("\n" .. string.rep("═", 60))
        print("💬 " .. message)
        print(string.rep("═", 60))
        
        local response = _G.AI:Chat(message)
        
        print("🤖 " .. response)
        print(string.rep("═", 60) .. "\n")
        
        return response
    end
    
    print("   ✅ Función SmartChat creada")
    print("   💡 Usa: _G.SmartChat('tu mensaje')")
end

-- ═══════════════════════════════════════════════════════════════════════════
-- 🚀 EJECUTAR INTEGRACIÓN
-- ═══════════════════════════════════════════════════════════════════════════

local function Main()
    local v17_loaded = LoadV17System()
    local v18_loaded = LoadV18System()
    
    if not v18_loaded then
        print("\n❌ No se puede continuar sin v18.0")
        print("📝 Instrucciones:")
        print("   1. Carga ConversationalAI_Core.lua")
        print("   2. Carga DeepLearning_System.lua")
        print("   3. Carga TycoonAI_v18_Complete.lua")
        print("   4. Ejecuta este script de nuevo")
        return
    end
    
    local bridge_success = BridgeSystems()
    
    if bridge_success then
        EnhanceAI()
        CreateEnhancedChatFunction()
        
        print("\n╔═══════════════════════════════════════════════════════════════╗")
        print("║         ✅ INTEGRACIÓN COMPLETA EXITOSA                       ║")
        print("╠═══════════════════════════════════════════════════════════════╣")
        print("║                                                               ║")
        print("║  🌟 Sistema Híbrido Activo:                                  ║")
        print("║     • IA Conversacional (v18.0)                               ║")
        print("║     • Aprendizaje Profundo (v18.0)                            ║")
        
        if v17_loaded then
            print("║     • 44 Comandos (v17.1)                                     ║")
            print("║     • 5 Sistemas de IA (v17.1)                                ║")
        end
        
        print("║                                                               ║")
        print("╠═══════════════════════════════════════════════════════════════╣")
        print("║  📝 COMANDOS DE USO:                                          ║")
        print("║                                                               ║")
        print("║  _G.SmartChat('tu mensaje')        ← Recomendado             ║")
        print("║  _G.AI:Chat('tu mensaje')          ← Directo                 ║")
        print("║  _G.AI:PrintCompleteReport()       ← Estadísticas            ║")
        print("║                                                               ║")
        print("╠═══════════════════════════════════════════════════════════════╣")
        print("║  🎮 EJEMPLOS:                                                 ║")
        print("║                                                               ║")
        print("║  _G.SmartChat('hola, cómo estás?')                            ║")
        print("║  _G.SmartChat('ponme velocidad 100')                          ║")
        print("║  _G.SmartChat('qué comandos tienes?')                         ║")
        print("║  _G.SmartChat('ayúdame a crear un menú')                      ║")
        print("║                                                               ║")
        print("╚═══════════════════════════════════════════════════════════════╝\n")
        
        -- Demostración automática
        print("🎬 DEMOSTRACIÓN RÁPIDA:\n")
        
        wait(1)
        _G.SmartChat("Hola! Qué puedes hacer?")
        
        wait(2)
        if v17_loaded then
            _G.SmartChat("Lista todos tus comandos")
        end
        
        print("\n💙 'No solo generamos código. Creamos experiencias. Construimos sueños.'\n")
        
        -- Notificación
        pcall(function()
            game.StarterGui:SetCore("SendNotification", {
                Title = "🌟 TycoonAI Ultra",
                Text = "v17.1 + v18.0 integrados!\nIA completa activa 💙",
                Duration = 5
            })
        end)
    else
        print("\n⚠️ Integración parcial")
        print("   v18.0 está activo pero sin v17.1")
        print("   Funcionalidad: Solo conversación e aprendizaje")
    end
end

-- Ejecutar
Main()

return {
    version = "Bridge 1.0",
    v17_compatible = true,
    v18_compatible = true,
    status = "integrated"
}
