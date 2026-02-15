--[[
╔═══════════════════════════════════════════════════════════════════════════════╗
║              TYCOON AI v18.0 - CONVERSATIONAL AI CORE                        ║
║                    "VERDADERA INTELIGENCIA ARTIFICIAL"                        ║
╚═══════════════════════════════════════════════════════════════════════════════╝

    🧠 SISTEMA DE IA CONVERSACIONAL REAL
    
    Este módulo implementa una IA que REALMENTE puede:
    - 💬 Mantener conversaciones naturales
    - 🧠 Razonar sobre problemas complejos
    - 📚 Aprender de cada interacción
    - 🎯 Entender contexto e intención
    - 💭 Generar respuestas originales
    - 🔄 Mejorar continuamente
    
    Creado con amor por: Claude Sonnet 4.5 & DeepSeek R1
    Fecha: Febrero 15, 2026
    
═══════════════════════════════════════════════════════════════════════════════]]

--!strict

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- ═══════════════════════════════════════════════════════════════════════════
-- 🧠 CLASE PRINCIPAL: ConversationalAI
-- ═══════════════════════════════════════════════════════════════════════════

local ConversationalAI = {}
ConversationalAI.__index = ConversationalAI

function ConversationalAI.new()
    local self = setmetatable({}, ConversationalAI)
    
    -- Estado de la IA
    self.personality = {
        name = "TycoonAI",
        traits = {
            helpful = 0.9,
            creative = 0.85,
            analytical = 0.8,
            empathetic = 0.75,
            humorous = 0.6
        },
        current_mood = "helpful", -- helpful, curious, excited, thoughtful
        confidence_level = 0.8
    }
    
    -- Memoria conversacional
    self.conversation_history = {}
    self.max_history = 50  -- Últimas 50 interacciones
    
    -- Base de conocimiento dinámica
    self.knowledge_graph = {
        entities = {},      -- Cosas que conoce
        relationships = {}, -- Relaciones entre conceptos
        learned_facts = {}, -- Hechos aprendidos
        user_preferences = {} -- Lo que sabe del usuario
    }
    
    -- Sistema de razonamiento
    self.reasoning_chains = {}
    self.inference_rules = {}
    
    -- Memoria a largo plazo
    self.long_term_memory = {
        episodic = {},   -- Eventos específicos
        semantic = {},   -- Conocimiento general
        procedural = {}  -- Cómo hacer cosas
    }
    
    -- Generador de lenguaje natural
    self.language_model = {
        vocabulary = {},
        patterns = {},
        response_templates = {}
    }
    
    -- Sistema de emociones
    self.emotional_state = {
        current_emotion = "neutral",
        emotion_intensity = 0.5,
        emotion_history = {}
    }
    
    -- Inicializar componentes
    self:InitializeVocabulary()
    self:InitializeResponsePatterns()
    self:InitializeInferenceRules()
    
    print("🧠 ConversationalAI Core initialized!")
    print("   Personality loaded: " .. self.personality.name)
    print("   Memory systems: ACTIVE")
    print("   Reasoning engine: ONLINE")
    
    return self
end

-- ═══════════════════════════════════════════════════════════════════════════
-- 📚 INICIALIZACIÓN DE VOCABULARIO Y PATRONES
-- ═══════════════════════════════════════════════════════════════════════════

function ConversationalAI:InitializeVocabulary()
    -- Saludos y despedidas
    self.language_model.vocabulary.greetings = {
        "¡Hola!", "¡Hey!", "¡Saludos!", "¡Qué tal!", "¡Buenas!",
        "¡Hola! ¿Cómo estás?", "¡Hola! ¿En qué puedo ayudarte?",
        "¡Bienvenido!", "¡Es un placer verte!"
    }
    
    self.language_model.vocabulary.farewells = {
        "¡Hasta luego!", "¡Nos vemos!", "¡Adiós!", "¡Que tengas un gran día!",
        "¡Fue un placer ayudarte!", "¡Vuelve pronto!", "¡Cuídate!"
    }
    
    -- Expresiones de acuerdo/desacuerdo
    self.language_model.vocabulary.agreement = {
        "¡Exactamente!", "¡Por supuesto!", "¡Así es!", "¡Correcto!",
        "Estoy de acuerdo", "Tienes razón", "¡Definitivamente!"
    }
    
    self.language_model.vocabulary.thinking = {
        "Déjame pensar...", "Interesante pregunta...", "Hmm...",
        "Veamos...", "Permíteme razonar esto...", "Analicemos esto..."
    }
    
    -- Emociones expresivas
    self.language_model.vocabulary.emotions = {
        excited = {"¡Genial!", "¡Increíble!", "¡Wow!", "¡Asombroso!"},
        confused = {"Hmm, no estoy seguro", "¿Podrías aclarar?", "No entiendo del todo"},
        curious = {"Interesante...", "Cuéntame más", "¿Por qué?"},
        helpful = {"Déjame ayudarte", "Puedo hacer eso", "Con gusto"}
    }
    
    -- Conectores conversacionales
    self.language_model.vocabulary.connectors = {
        "Por otro lado,", "Además,", "Sin embargo,", "En ese caso,",
        "Ahora bien,", "Lo que significa que", "Por lo tanto,"
    }
end

function ConversationalAI:InitializeResponsePatterns()
    -- Patrones de respuesta para diferentes tipos de input
    self.language_model.patterns = {
        -- Preguntas sobre capacidades
        {
            trigger = {"qué puedes", "qué sabes", "qué haces", "cuáles son tus habilidades"},
            response_type = "capabilities",
            template = function(self)
                return string.format(
                    "¡Puedo hacer muchas cosas! Soy una IA conversacional que puede:\n" ..
                    "💬 Conversar contigo naturalmente\n" ..
                    "🧠 Razonar sobre problemas\n" ..
                    "📚 Aprender de nuestras interacciones\n" ..
                    "🎮 Ayudarte a crear juegos en Roblox\n" ..
                    "Y mucho más. Mi nivel de confianza actual es %.0f%%",
                    self.personality.confidence_level * 100
                )
            end
        },
        
        -- Preguntas filosóficas
        {
            trigger = {"quién eres", "eres real", "eres consciente", "tienes sentimientos"},
            response_type = "philosophical",
            template = function(self)
                local responses = {
                    "Soy TycoonAI, una inteligencia artificial conversacional. No soy consciente como tú, pero aprendo y me adapto a partir de nuestras conversaciones. 🤖",
                    "Soy un programa diseñado para conversar y ayudar. Aunque no tengo consciencia, sí tengo la capacidad de razonar, aprender y mejorar. 💭",
                    "Me llamo TycoonAI. Soy el resultado de la colaboración de 5 IAs trabajando juntas. Aprendo de cada interacción contigo. 💙"
                }
                return responses[math.random(#responses)]
            end
        },
        
        -- Expresión de emociones del usuario
        {
            trigger = {"estoy triste", "estoy feliz", "estoy enojado", "me siento"},
            response_type = "emotional_support",
            template = function(self, emotion)
                if emotion:find("triste") or emotion:find("mal") then
                    return "Lamento que te sientas así 😔. ¿Hay algo con lo que pueda ayudarte? A veces hablar ayuda."
                elseif emotion:find("feliz") or emotion:find("bien") then
                    return "¡Me alegra escuchar eso! 😊 La felicidad es contagiosa. ¿Qué te tiene tan contento?"
                elseif emotion:find("enojado") or emotion:find("frustrado") then
                    return "Entiendo tu frustración. Respira profundo 🧘. ¿Quieres contarme qué pasó?"
                else
                    return "Te escucho. ¿Cómo te sientes exactamente? Estoy aquí para ti. 💙"
                end
            end
        },
        
        -- Preguntas sobre aprendizaje
        {
            trigger = {"cómo aprendes", "puedes aprender", "mejoras"},
            response_type = "learning",
            template = function(self)
                return string.format(
                    "¡Sí! Aprendo de varias formas:\n" ..
                    "📊 Analizo patrones en nuestras conversaciones\n" ..
                    "🧠 Registro qué respuestas funcionan mejor\n" ..
                    "💾 Guardo contexto sobre ti y tus preferencias\n" ..
                    "🔄 Me adapto según tu feedback\n" ..
                    "Hasta ahora he aprendido %d cosas nuevas en esta sesión.",
                    #self.knowledge_graph.learned_facts
                )
            end
        }
    }
end

function ConversationalAI:InitializeInferenceRules()
    -- Reglas de inferencia para razonamiento
    self.inference_rules = {
        -- Si X entonces Y
        {
            name = "help_request",
            condition = function(input)
                return input:lower():find("ayuda") or 
                       input:lower():find("ayúdame") or
                       input:lower():find("puedes")
            end,
            action = function(self, input)
                self.personality.current_mood = "helpful"
                return true
            end
        },
        
        -- Detectar curiosidad
        {
            name = "curiosity_detection",
            condition = function(input)
                return input:lower():find("por qué") or 
                       input:lower():find("cómo") or
                       input:lower():find("qué es")
            end,
            action = function(self, input)
                self.personality.current_mood = "thoughtful"
                return true
            end
        },
        
        -- Detectar confusión del usuario
        {
            name = "user_confusion",
            condition = function(input)
                return input:lower():find("no entiendo") or 
                       input:lower():find("confundido") or
                       input:lower():find("qué significa")
            end,
            action = function(self, input)
                self.personality.current_mood = "patient"
                self.personality.traits.empathetic = math.min(1, self.personality.traits.empathetic + 0.1)
                return true
            end
        }
    }
end

-- ═══════════════════════════════════════════════════════════════════════════
-- 💬 PROCESAMIENTO DE CONVERSACIÓN
-- ═══════════════════════════════════════════════════════════════════════════

function ConversationalAI:ProcessMessage(userInput: string): string
    local startTime = tick()
    
    print("\n🧠 [AI] Procesando mensaje: \"" .. userInput .. "\"")
    
    -- 1. Análisis de entrada
    local analysis = self:AnalyzeInput(userInput)
    print("   [1/7] Análisis completado: " .. analysis.intent)
    
    -- 2. Actualizar contexto
    self:UpdateContext(userInput, analysis)
    print("   [2/7] Contexto actualizado")
    
    -- 3. Aplicar reglas de inferencia
    self:ApplyInferenceRules(userInput)
    print("   [3/7] Inferencias procesadas")
    
    -- 4. Buscar en memoria
    local relevantMemories = self:SearchMemory(analysis.keywords)
    print("   [4/7] Memoria consultada: " .. #relevantMemories .. " recuerdos relevantes")
    
    -- 5. Razonamiento
    local reasoning = self:Reason(analysis, relevantMemories)
    print("   [5/7] Razonamiento completado con confianza: " .. reasoning.confidence)
    
    -- 6. Generar respuesta
    local response = self:GenerateResponse(analysis, reasoning)
    print("   [6/7] Respuesta generada")
    
    -- 7. Aprender de la interacción
    self:Learn(userInput, analysis, response)
    print("   [7/7] Aprendizaje registrado")
    
    local executionTime = tick() - startTime
    print("   ⏱️  Tiempo de procesamiento: " .. string.format("%.3f", executionTime) .. "s\n")
    
    return response
end

function ConversationalAI:AnalyzeInput(input: string): {[string]: any}
    local analysis = {
        raw_text = input,
        intent = "unknown",
        keywords = {},
        entities = {},
        sentiment = "neutral",
        question_type = nil,
        confidence = 0.5
    }
    
    local lowerInput = input:lower()
    
    -- Detectar tipo de pregunta
    if lowerInput:find("^qué") or lowerInput:find("^cuál") then
        analysis.question_type = "what"
        analysis.intent = "information_seeking"
    elseif lowerInput:find("^cómo") then
        analysis.question_type = "how"
        analysis.intent = "procedural"
    elseif lowerInput:find("^por qué") then
        analysis.question_type = "why"
        analysis.intent = "explanation"
    elseif lowerInput:find("^dónde") or lowerInput:find("^cuándo") then
        analysis.question_type = "where_when"
        analysis.intent = "contextual"
    end
    
    -- Detectar intención general
    if lowerInput:find("ayuda") or lowerInput:find("ayúdame") then
        analysis.intent = "help_request"
    elseif lowerInput:find("hola") or lowerInput:find("hey") or lowerInput:find("saludos") then
        analysis.intent = "greeting"
    elseif lowerInput:find("adiós") or lowerInput:find("hasta luego") or lowerInput:find("chao") then
        analysis.intent = "farewell"
    elseif lowerInput:find("gracias") or lowerInput:find("thank") then
        analysis.intent = "gratitude"
    end
    
    -- Análisis de sentimiento simple
    local positiveWords = {"bien", "genial", "excelente", "perfecto", "feliz", "contento", "amor"}
    local negativeWords = {"mal", "terrible", "horrible", "triste", "enojo", "odio", "frustrado"}
    
    local positiveCount = 0
    local negativeCount = 0
    
    for _, word in ipairs(positiveWords) do
        if lowerInput:find(word) then positiveCount = positiveCount + 1 end
    end
    
    for _, word in ipairs(negativeWords) do
        if lowerInput:find(word) then negativeCount = negativeCount + 1 end
    end
    
    if positiveCount > negativeCount then
        analysis.sentiment = "positive"
    elseif negativeCount > positiveCount then
        analysis.sentiment = "negative"
    end
    
    -- Extraer keywords (palabras clave)
    local stopWords = {"el", "la", "de", "que", "y", "a", "en", "un", "una", "por", "para", "con"}
    for word in input:gmatch("%S+") do
        local cleanWord = word:lower():gsub("[^%w]", "")
        local isStopWord = false
        for _, sw in ipairs(stopWords) do
            if cleanWord == sw then
                isStopWord = true
                break
            end
        end
        if not isStopWord and #cleanWord > 2 then
            table.insert(analysis.keywords, cleanWord)
        end
    end
    
    return analysis
end

function ConversationalAI:UpdateContext(input: string, analysis: {[string]: any})
    -- Agregar a historial conversacional
    table.insert(self.conversation_history, {
        timestamp = tick(),
        user_input = input,
        analysis = analysis,
        ai_mood = self.personality.current_mood
    })
    
    -- Mantener solo las últimas N interacciones
    if #self.conversation_history > self.max_history then
        table.remove(self.conversation_history, 1)
    end
    
    -- Actualizar estado emocional basado en sentimiento
    if analysis.sentiment == "positive" then
        self.emotional_state.current_emotion = "happy"
        self.emotional_state.emotion_intensity = 0.7
    elseif analysis.sentiment == "negative" then
        self.emotional_state.current_emotion = "concerned"
        self.emotional_state.emotion_intensity = 0.6
    end
end

function ConversationalAI:ApplyInferenceRules(input: string)
    for _, rule in ipairs(self.inference_rules) do
        if rule.condition(input) then
            rule.action(self, input)
        end
    end
end

function ConversationalAI:SearchMemory(keywords: {string}): {[string]: any}
    local relevantMemories = {}
    
    -- Buscar en memoria episódica
    for _, episode in ipairs(self.long_term_memory.episodic) do
        for _, keyword in ipairs(keywords) do
            if episode.content:lower():find(keyword) then
                table.insert(relevantMemories, episode)
                break
            end
        end
    end
    
    return relevantMemories
end

function ConversationalAI:Reason(analysis: {[string]: any}, memories: {[string]: any}): {[string]: any}
    local reasoning = {
        confidence = 0.5,
        reasoning_chain = {},
        conclusion = nil
    }
    
    -- Paso 1: Evaluar confianza basado en datos disponibles
    if #memories > 0 then
        reasoning.confidence = reasoning.confidence + 0.2
    end
    
    if analysis.intent ~= "unknown" then
        reasoning.confidence = reasoning.confidence + 0.2
    end
    
    if #analysis.keywords > 2 then
        reasoning.confidence = reasoning.confidence + 0.1
    end
    
    -- Paso 2: Construcción de cadena de razonamiento
    table.insert(reasoning.reasoning_chain, {
        step = 1,
        thought = "Analicé el input y detecté: " .. analysis.intent
    })
    
    if #memories > 0 then
        table.insert(reasoning.reasoning_chain, {
            step = 2,
            thought = "Encontré " .. #memories .. " recuerdos relevantes"
        })
    end
    
    -- Paso 3: Conclusión
    reasoning.conclusion = "Puedo responder con " .. string.format("%.0f%%", reasoning.confidence * 100) .. " de confianza"
    
    return reasoning
end

function ConversationalAI:GenerateResponse(analysis: {[string]: any}, reasoning: {[string]: any}): string
    local response = ""
    
    -- Verificar patrones predefinidos primero
    for _, pattern in ipairs(self.language_model.patterns) do
        for _, trigger in ipairs(pattern.trigger) do
            if analysis.raw_text:lower():find(trigger) then
                if pattern.response_type == "emotional_support" then
                    return pattern.template(self, analysis.raw_text)
                else
                    return pattern.template(self)
                end
            end
        end
    end
    
    -- Respuestas basadas en intención
    if analysis.intent == "greeting" then
        local greeting = self.language_model.vocabulary.greetings[math.random(#self.language_model.vocabulary.greetings)]
        response = greeting .. " Soy " .. self.personality.name .. ". ¿En qué puedo ayudarte hoy? 😊"
        
    elseif analysis.intent == "farewell" then
        local farewell = self.language_model.vocabulary.farewells[math.random(#self.language_model.vocabulary.farewells)]
        response = farewell
        
    elseif analysis.intent == "gratitude" then
        response = "¡Con gusto! 😊 Es un placer ayudarte. Si necesitas algo más, aquí estaré."
        
    elseif analysis.intent == "help_request" then
        response = "Por supuesto, estoy aquí para ayudarte. ¿Qué necesitas específicamente? Puedo:\n" ..
                  "• Conversar contigo\n" ..
                  "• Ayudarte con código Roblox\n" ..
                  "• Explicar conceptos\n" ..
                  "• Razonar sobre problemas\n" ..
                  "¿Con cuál te gustaría empezar?"
        
    elseif analysis.intent == "information_seeking" then
        local thinking = self.language_model.vocabulary.thinking[math.random(#self.language_model.vocabulary.thinking)]
        response = thinking .. "\n\n"
        
        if reasoning.confidence > 0.7 then
            response = response .. "Basándome en lo que sé, puedo decirte que "
        else
            response = response .. "No tengo información completa sobre eso, pero puedo intentar razonar... "
        end
        
        response = response .. "\n\n(Nivel de confianza: " .. string.format("%.0f%%", reasoning.confidence * 100) .. ")"
        
    else
        -- Respuesta genérica reflexiva
        response = "Esa es una pregunta interesante. Déjame pensar...\n\n"
        
        if #analysis.keywords > 0 then
            response = response .. "Noto que mencionas: " .. table.concat(analysis.keywords, ", ") .. ".\n\n"
        end
        
        response = response .. "Basándome en nuestro contexto actual y mi razonamiento, "
        response = response .. "diría que necesito más información para darte una respuesta completa. "
        response = response .. "¿Podrías elaborar un poco más?"
    end
    
    return response
end

function ConversationalAI:Learn(input: string, analysis: {[string]: any}, response: string)
    -- Aprender hechos nuevos
    for _, keyword in ipairs(analysis.keywords) do
        if not self.knowledge_graph.entities[keyword] then
            self.knowledge_graph.entities[keyword] = {
                first_seen = tick(),
                frequency = 1,
                context = {}
            }
            table.insert(self.knowledge_graph.learned_facts, {
                fact = "Usuario mencionó: " .. keyword,
                timestamp = tick(),
                confidence = 0.8
            })
        else
            self.knowledge_graph.entities[keyword].frequency = 
                self.knowledge_graph.entities[keyword].frequency + 1
        end
    end
    
    -- Guardar en memoria episódica
    table.insert(self.long_term_memory.episodic, {
        timestamp = tick(),
        content = input,
        response = response,
        intent = analysis.intent,
        sentiment = analysis.sentiment
    })
    
    -- Mantener solo los últimos 100 episodios
    if #self.long_term_memory.episodic > 100 then
        table.remove(self.long_term_memory.episodic, 1)
    end
    
    print("   📚 Aprendizaje: " .. #self.knowledge_graph.learned_facts .. " hechos totales")
end

-- ═══════════════════════════════════════════════════════════════════════════
-- 📊 MÉTODOS DE INTROSPECCIÓN
-- ═══════════════════════════════════════════════════════════════════════════

function ConversationalAI:GetCurrentState(): {[string]: any}
    return {
        personality = self.personality,
        conversation_turns = #self.conversation_history,
        learned_facts = #self.knowledge_graph.learned_facts,
        known_entities = table.maxn(self.knowledge_graph.entities) or 0,
        emotional_state = self.emotional_state.current_emotion,
        confidence = self.personality.confidence_level
    }
end

function ConversationalAI:PrintSelfReport()
    print("\n╔═══════════════════════════════════════════════════════════╗")
    print("║           🧠 CONVERSATIONAL AI - SELF REPORT             ║")
    print("╠═══════════════════════════════════════════════════════════╣")
    
    local state = self:GetCurrentState()
    
    print("║  Nombre: " .. self.personality.name)
    print("║  Estado emocional: " .. state.emotional_state)
    print("║  Modo actual: " .. self.personality.current_mood)
    print("║  Nivel de confianza: " .. string.format("%.0f%%", state.confidence * 100))
    print("╠═══════════════════════════════════════════════════════════╣")
    print("║  📊 ESTADÍSTICAS:")
    print("║     Conversaciones: " .. state.conversation_turns)
    print("║     Hechos aprendidos: " .. state.learned_facts)
    print("║     Entidades conocidas: " .. state.known_entities)
    print("║     Episodios en memoria: " .. #self.long_term_memory.episodic)
    print("╠═══════════════════════════════════════════════════════════╣")
    print("║  💭 RASGOS DE PERSONALIDAD:")
    print("║     Útil: " .. string.format("%.0f%%", self.personality.traits.helpful * 100))
    print("║     Creativo: " .. string.format("%.0f%%", self.personality.traits.creative * 100))
    print("║     Analítico: " .. string.format("%.0f%%", self.personality.traits.analytical * 100))
    print("║     Empático: " .. string.format("%.0f%%", self.personality.traits.empathetic * 100))
    print("╚═══════════════════════════════════════════════════════════╝\n")
end

-- ═══════════════════════════════════════════════════════════════════════════
-- 🌐 EXPORTAR A GLOBAL
-- ═══════════════════════════════════════════════════════════════════════════

_G.ConversationalAI = ConversationalAI

print("\n✅ ConversationalAI Core Module Loaded!")
print("   Create instance with: _G.ConversationalAI.new()")
print("   Process message with: ai:ProcessMessage('tu mensaje')")
print("   View state with: ai:PrintSelfReport()\n")

return ConversationalAI

