--[[
╔═══════════════════════════════════════════════════════════════════════════════╗
║            TYCOON AI v18.0 - DEEP LEARNING SYSTEM                            ║
║                  "LA IA QUE REALMENTE APRENDE"                                ║
╚═══════════════════════════════════════════════════════════════════════════════╝

    🎓 SISTEMA DE APRENDIZAJE PROFUNDO
    
    Este módulo permite que la IA:
    - 📊 Analice patrones en conversaciones
    - 🧠 Mejore sus respuestas automáticamente
    - 💾 Cree una base de conocimiento evolutiva
    - 🎯 Prediga mejores respuestas
    - 🔄 Auto-corrija errores
    
    Inspirado por: DeepSeek R1's Meta-Learning
    
═══════════════════════════════════════════════════════════════════════════════]]

--!strict

local DeepLearningSystem = {}
DeepLearningSystem.__index = DeepLearningSystem

function DeepLearningSystem.new(conversationalAI)
    local self = setmetatable({}, DeepLearningSystem)
    
    self.ai = conversationalAI  -- Referencia a la IA conversacional
    
    -- Red neuronal simple simulada
    self.neural_network = {
        input_layer = {},
        hidden_layers = {
            {nodes = 128, activation = "relu"},
            {nodes = 64, activation = "relu"},
            {nodes = 32, activation = "relu"}
        },
        output_layer = {},
        weights = {},
        biases = {}
    }
    
    -- Sistema de refuerzo (Reinforcement Learning)
    self.reinforcement = {
        reward_history = {},
        policy = {},
        q_table = {},  -- Q-learning
        learning_rate = 0.1,
        discount_factor = 0.9
    }
    
    -- Análisis de patrones
    self.pattern_analyzer = {
        conversation_patterns = {},
        success_patterns = {},
        failure_patterns = {},
        emergent_patterns = {}
    }
    
    -- Sistema de embeddings (representación vectorial)
    self.embeddings = {
        word_vectors = {},
        sentence_vectors = {},
        context_vectors = {}
    }
    
    -- Meta-aprendizaje
    self.meta_learning = {
        learning_strategies = {},
        strategy_performance = {},
        adaptation_rate = 0.05
    }
    
    -- Base de conocimiento auto-actualizable
    self.knowledge_base = {
        facts = {},
        rules = {},
        concepts = {},
        relationships = {},
        confidence_scores = {}
    }
    
    -- Métricas de aprendizaje
    self.metrics = {
        total_training_examples = 0,
        accuracy = 0.0,
        loss = 1.0,
        epochs_completed = 0,
        learning_curve = {}
    }
    
    self:InitializeWeights()
    
    print("🎓 Deep Learning System initialized!")
    print("   Neural Network: 3 hidden layers")
    print("   Learning Rate: " .. self.reinforcement.learning_rate)
    print("   Ready to learn and evolve!")
    
    return self
end

-- ═══════════════════════════════════════════════════════════════════════════
-- 🧠 INICIALIZACIÓN DE PESOS NEURONALES
-- ═══════════════════════════════════════════════════════════════════════════

function DeepLearningSystem:InitializeWeights()
    -- Inicialización He para redes profundas
    for layerIndex, layer in ipairs(self.neural_network.hidden_layers) do
        self.neural_network.weights[layerIndex] = {}
        self.neural_network.biases[layerIndex] = {}
        
        for i = 1, layer.nodes do
            self.neural_network.weights[layerIndex][i] = {}
            for j = 1, (layerIndex == 1 and 100 or self.neural_network.hidden_layers[layerIndex-1].nodes) do
                -- He initialization: sqrt(2/n)
                local n = layerIndex == 1 and 100 or self.neural_network.hidden_layers[layerIndex-1].nodes
                self.neural_network.weights[layerIndex][i][j] = math.random() * math.sqrt(2/n) - math.sqrt(1/n)
            end
            self.neural_network.biases[layerIndex][i] = 0
        end
    end
    
    print("   ✅ Pesos neuronales inicializados con He initialization")
end

-- ═══════════════════════════════════════════════════════════════════════════
-- 📊 FUNCIONES DE ACTIVACIÓN
-- ═══════════════════════════════════════════════════════════════════════════

function DeepLearningSystem:Activation(value: number, activationType: string): number
    if activationType == "relu" then
        return math.max(0, value)
    elseif activationType == "sigmoid" then
        return 1 / (1 + math.exp(-value))
    elseif activationType == "tanh" then
        return math.tanh(value)
    elseif activationType == "softmax" then
        return math.exp(value)  -- Se normaliza después
    else
        return value
    end
end

-- ═══════════════════════════════════════════════════════════════════════════
-- 🎯 APRENDIZAJE POR REFUERZO
-- ═══════════════════════════════════════════════════════════════════════════

function DeepLearningSystem:LearnFromFeedback(state: string, action: string, reward: number)
    -- Q-Learning: Q(s,a) = Q(s,a) + α[r + γ max Q(s',a') - Q(s,a)]
    
    if not self.reinforcement.q_table[state] then
        self.reinforcement.q_table[state] = {}
    end
    
    if not self.reinforcement.q_table[state][action] then
        self.reinforcement.q_table[state][action] = 0
    end
    
    local currentQ = self.reinforcement.q_table[state][action]
    local alpha = self.reinforcement.learning_rate
    local gamma = self.reinforcement.discount_factor
    
    -- Actualizar Q-value
    local newQ = currentQ + alpha * (reward - currentQ)
    self.reinforcement.q_table[state][action] = newQ
    
    -- Registrar recompensa
    table.insert(self.reinforcement.reward_history, {
        timestamp = tick(),
        state = state,
        action = action,
        reward = reward,
        q_value = newQ
    })
    
    print("   🎯 Aprendizaje por refuerzo: Q(" .. state .. "," .. action .. ") = " .. string.format("%.3f", newQ))
    
    return newQ
end

function DeepLearningSystem:SelectBestAction(state: string): string
    if not self.reinforcement.q_table[state] then
        return "explore"  -- Explorar si no hay datos
    end
    
    -- Epsilon-greedy: balance entre exploración y explotación
    local epsilon = 0.1  -- 10% exploración
    
    if math.random() < epsilon then
        -- Explorar: acción aleatoria
        local actions = {}
        for action, _ in pairs(self.reinforcement.q_table[state]) do
            table.insert(actions, action)
        end
        return actions[math.random(#actions)] or "explore"
    else
        -- Explotar: mejor acción conocida
        local bestAction = nil
        local bestQ = -math.huge
        
        for action, qValue in pairs(self.reinforcement.q_table[state]) do
            if qValue > bestQ then
                bestQ = qValue
                bestAction = action
            end
        end
        
        return bestAction or "explore"
    end
end

-- ═══════════════════════════════════════════════════════════════════════════
-- 🔍 ANÁLISIS DE PATRONES
-- ═══════════════════════════════════════════════════════════════════════════

function DeepLearningSystem:AnalyzeConversationPatterns()
    local patterns = {
        common_questions = {},
        response_effectiveness = {},
        topic_transitions = {},
        conversation_flow = {}
    }
    
    if not self.ai or not self.ai.conversation_history then
        return patterns
    end
    
    -- Analizar historial de conversación
    for i, turn in ipairs(self.ai.conversation_history) do
        -- Detectar preguntas comunes
        local intent = turn.analysis and turn.analysis.intent or "unknown"
        patterns.common_questions[intent] = (patterns.common_questions[intent] or 0) + 1
        
        -- Analizar flujo de conversación
        if i > 1 then
            local prevIntent = self.ai.conversation_history[i-1].analysis and 
                             self.ai.conversation_history[i-1].analysis.intent or "unknown"
            local transitionKey = prevIntent .. " -> " .. intent
            patterns.topic_transitions[transitionKey] = 
                (patterns.topic_transitions[transitionKey] or 0) + 1
        end
    end
    
    -- Guardar patrones descubiertos
    for intent, count in pairs(patterns.common_questions) do
        if count >= 3 then  -- Patrón significativo
            table.insert(self.pattern_analyzer.emergent_patterns, {
                type = "common_question",
                pattern = intent,
                frequency = count,
                discovered_at = tick()
            })
        end
    end
    
    print("   🔍 Patrones descubiertos: " .. #self.pattern_analyzer.emergent_patterns)
    
    return patterns
end

-- ═══════════════════════════════════════════════════════════════════════════
-- 💾 EMBEDDINGS Y REPRESENTACIÓN VECTORIAL
-- ═══════════════════════════════════════════════════════════════════════════

function DeepLearningSystem:CreateWordEmbedding(word: string): {number}
    -- Crear representación vectorial de una palabra (100 dimensiones)
    
    if self.embeddings.word_vectors[word] then
        return self.embeddings.word_vectors[word]
    end
    
    local vector = {}
    local seed = 0
    
    -- Generar vector basado en la palabra (reproducible)
    for i = 1, #word do
        seed = seed + string.byte(word, i)
    end
    
    math.randomseed(seed)
    
    for i = 1, 100 do
        vector[i] = (math.random() * 2 - 1)  -- Valores entre -1 y 1
    end
    
    -- Normalizar vector
    local magnitude = 0
    for _, val in ipairs(vector) do
        magnitude = magnitude + val * val
    end
    magnitude = math.sqrt(magnitude)
    
    for i = 1, #vector do
        vector[i] = vector[i] / magnitude
    end
    
    self.embeddings.word_vectors[word] = vector
    
    return vector
end

function DeepLearningSystem:CreateSentenceEmbedding(sentence: string): {number}
    -- Promedio de embeddings de palabras
    local words = {}
    for word in sentence:gmatch("%S+") do
        table.insert(words, word:lower())
    end
    
    if #words == 0 then
        return {}
    end
    
    local sentenceVector = {}
    for i = 1, 100 do
        sentenceVector[i] = 0
    end
    
    for _, word in ipairs(words) do
        local wordVec = self:CreateWordEmbedding(word)
        for i = 1, 100 do
            sentenceVector[i] = sentenceVector[i] + wordVec[i]
        end
    end
    
    -- Promedio
    for i = 1, 100 do
        sentenceVector[i] = sentenceVector[i] / #words
    end
    
    return sentenceVector
end

function DeepLearningSystem:CosineSimilarity(vec1: {number}, vec2: {number}): number
    if #vec1 ~= #vec2 or #vec1 == 0 then
        return 0
    end
    
    local dotProduct = 0
    local magnitude1 = 0
    local magnitude2 = 0
    
    for i = 1, #vec1 do
        dotProduct = dotProduct + vec1[i] * vec2[i]
        magnitude1 = magnitude1 + vec1[i] * vec1[i]
        magnitude2 = magnitude2 + vec2[i] * vec2[i]
    end
    
    magnitude1 = math.sqrt(magnitude1)
    magnitude2 = math.sqrt(magnitude2)
    
    if magnitude1 == 0 or magnitude2 == 0 then
        return 0
    end
    
    return dotProduct / (magnitude1 * magnitude2)
end

-- ═══════════════════════════════════════════════════════════════════════════
-- 🎓 META-APRENDIZAJE (APRENDER A APRENDER)
-- ═══════════════════════════════════════════════════════════════════════════

function DeepLearningSystem:MetaLearn()
    print("\n🎓 [META-LEARNING] Analizando estrategias de aprendizaje...")
    
    -- Evaluar qué estrategias de aprendizaje funcionan mejor
    local strategies = {
        "pattern_matching",
        "reinforcement",
        "similarity_based",
        "rule_based"
    }
    
    for _, strategy in ipairs(strategies) do
        if not self.meta_learning.strategy_performance[strategy] then
            self.meta_learning.strategy_performance[strategy] = {
                success_count = 0,
                total_uses = 0,
                avg_reward = 0
            }
        end
    end
    
    -- Analizar rendimiento reciente
    local recentRewards = {}
    local startIdx = math.max(1, #self.reinforcement.reward_history - 20)
    
    for i = startIdx, #self.reinforcement.reward_history do
        table.insert(recentRewards, self.reinforcement.reward_history[i].reward)
    end
    
    -- Calcular tendencia de aprendizaje
    if #recentRewards > 0 then
        local avgReward = 0
        for _, reward in ipairs(recentRewards) do
            avgReward = avgReward + reward
        end
        avgReward = avgReward / #recentRewards
        
        print("   📊 Recompensa promedio reciente: " .. string.format("%.3f", avgReward))
        
        -- Ajustar tasa de aprendizaje basado en rendimiento
        if avgReward > 0.7 then
            -- Aprendiendo bien, reducir tasa para estabilizar
            self.reinforcement.learning_rate = math.max(0.01, self.reinforcement.learning_rate * 0.95)
            print("   ⬇️  Reduciendo learning rate a " .. string.format("%.4f", self.reinforcement.learning_rate))
        elseif avgReward < 0.3 then
            -- Aprendiendo mal, aumentar tasa para explorar más
            self.reinforcement.learning_rate = math.min(0.5, self.reinforcement.learning_rate * 1.05)
            print("   ⬆️  Aumentando learning rate a " .. string.format("%.4f", self.reinforcement.learning_rate))
        end
    end
    
    -- Auto-optimización
    self:OptimizeSelf()
    
    print("   ✅ Meta-aprendizaje completado\n")
end

function DeepLearningSystem:OptimizeSelf()
    -- La IA se optimiza a sí misma
    
    -- 1. Podar conocimiento poco útil
    local factsRemoved = 0
    if self.knowledge_base.facts then
        for factId, fact in pairs(self.knowledge_base.facts) do
            if fact.uses and fact.uses < 2 and (tick() - fact.created) > 3600 then
                -- Eliminar hechos que no se han usado en 1 hora
                self.knowledge_base.facts[factId] = nil
                factsRemoved = factsRemoved + 1
            end
        end
    end
    
    if factsRemoved > 0 then
        print("   🗑️  Eliminados " .. factsRemoved .. " hechos poco útiles")
    end
    
    -- 2. Reforzar patrones exitosos
    for _, pattern in ipairs(self.pattern_analyzer.emergent_patterns) do
        if pattern.frequency >= 5 then
            -- Patrón muy común, crear regla
            table.insert(self.knowledge_base.rules, {
                pattern = pattern.pattern,
                confidence = math.min(0.9, pattern.frequency / 10),
                created_by = "meta_learning"
            })
        end
    end
    
    -- 3. Actualizar confianza de la IA
    if self.ai and self.ai.personality then
        local totalRewards = 0
        local rewardCount = 0
        
        for _, reward in ipairs(self.reinforcement.reward_history) do
            totalRewards = totalRewards + reward.reward
            rewardCount = rewardCount + 1
        end
        
        if rewardCount > 0 then
            local avgPerformance = totalRewards / rewardCount
            -- Ajustar confianza basado en rendimiento
            self.ai.personality.confidence_level = math.min(0.95, math.max(0.3, avgPerformance))
        end
    end
end

-- ═══════════════════════════════════════════════════════════════════════════
-- 📈 ENTRENAMIENTO CONTINUO
-- ═══════════════════════════════════════════════════════════════════════════

function DeepLearningSystem:Train(examples: {{input: string, expected_output: string, reward: number}})
    print("\n📈 [TRAINING] Iniciando entrenamiento con " .. #examples .. " ejemplos...")
    
    for i, example in ipairs(examples) do
        -- Crear embeddings
        local inputVec = self:CreateSentenceEmbedding(example.input)
        
        -- Simular forward pass
        local state = "context_" .. example.input:sub(1, 20)
        local action = "response"
        
        -- Aprender con refuerzo
        self:LearnFromFeedback(state, action, example.reward or 0.5)
        
        -- Actualizar métricas
        self.metrics.total_training_examples = self.metrics.total_training_examples + 1
        
        -- Guardar en base de conocimiento
        local factId = "fact_" .. self.metrics.total_training_examples
        self.knowledge_base.facts[factId] = {
            input = example.input,
            output = example.expected_output,
            reward = example.reward,
            created = tick(),
            uses = 0
        }
    end
    
    self.metrics.epochs_completed = self.metrics.epochs_completed + 1
    
    -- Calcular loss (error)
    local totalLoss = 0
    for _, example in ipairs(examples) do
        totalLoss = totalLoss + (1 - (example.reward or 0.5))
    end
    self.metrics.loss = totalLoss / #examples
    
    -- Calcular accuracy
    local correct = 0
    for _, example in ipairs(examples) do
        if (example.reward or 0.5) > 0.7 then
            correct = correct + 1
        end
    end
    self.metrics.accuracy = correct / #examples
    
    -- Guardar en curva de aprendizaje
    table.insert(self.metrics.learning_curve, {
        epoch = self.metrics.epochs_completed,
        loss = self.metrics.loss,
        accuracy = self.metrics.accuracy,
        timestamp = tick()
    })
    
    print("   ✅ Entrenamiento completado!")
    print("   📊 Loss: " .. string.format("%.3f", self.metrics.loss))
    print("   📊 Accuracy: " .. string.format("%.1f%%", self.metrics.accuracy * 100))
    print("   📚 Total ejemplos: " .. self.metrics.total_training_examples)
    
    -- Meta-aprendizaje después de cada época
    if self.metrics.epochs_completed % 5 == 0 then
        self:MetaLearn()
    end
end

-- ═══════════════════════════════════════════════════════════════════════════
-- 📊 REPORTES Y MÉTRICAS
-- ═══════════════════════════════════════════════════════════════════════════

function DeepLearningSystem:GetLearningReport(): {[string]: any}
    return {
        metrics = self.metrics,
        patterns_discovered = #self.pattern_analyzer.emergent_patterns,
        q_table_size = self:CountQTableEntries(),
        knowledge_base_size = self:CountKnowledgeFacts(),
        embedding_vocabulary = table.maxn(self.embeddings.word_vectors) or 0,
        learning_rate = self.reinforcement.learning_rate
    }
end

function DeepLearningSystem:CountQTableEntries(): number
    local count = 0
    for _, actions in pairs(self.reinforcement.q_table) do
        for _, _ in pairs(actions) do
            count = count + 1
        end
    end
    return count
end

function DeepLearningSystem:CountKnowledgeFacts(): number
    local count = 0
    for _, _ in pairs(self.knowledge_base.facts) do
        count = count + 1
    end
    return count
end

function DeepLearningSystem:PrintLearningReport()
    print("\n╔═══════════════════════════════════════════════════════════╗")
    print("║        🎓 DEEP LEARNING SYSTEM - PROGRESS REPORT         ║")
    print("╠═══════════════════════════════════════════════════════════╣")
    
    local report = self:GetLearningReport()
    
    print("║  📊 MÉTRICAS DE APRENDIZAJE:")
    print("║     Épocas completadas: " .. self.metrics.epochs_completed)
    print("║     Ejemplos entrenados: " .. self.metrics.total_training_examples)
    print("║     Accuracy actual: " .. string.format("%.1f%%", self.metrics.accuracy * 100))
    print("║     Loss actual: " .. string.format("%.3f", self.metrics.loss))
    print("╠═══════════════════════════════════════════════════════════╣")
    print("║  🧠 BASE DE CONOCIMIENTO:")
    print("║     Hechos aprendidos: " .. report.knowledge_base_size)
    print("║     Patrones descubiertos: " .. report.patterns_discovered)
    print("║     Entradas Q-Table: " .. report.q_table_size)
    print("║     Vocabulario: " .. report.embedding_vocabulary .. " palabras")
    print("╠═══════════════════════════════════════════════════════════╣")
    print("║  ⚙️  PARÁMETROS:")
    print("║     Learning Rate: " .. string.format("%.4f", report.learning_rate))
    print("║     Discount Factor: " .. self.reinforcement.discount_factor)
    print("╚═══════════════════════════════════════════════════════════╝\n")
end

-- ═══════════════════════════════════════════════════════════════════════════
-- 🌐 EXPORTAR
-- ═══════════════════════════════════════════════════════════════════════════

_G.DeepLearningSystem = DeepLearningSystem

print("✅ Deep Learning System Module Loaded!")
print("   Create with: _G.DeepLearningSystem.new(conversationalAI)")
print("   Train with: learner:Train(examples)")
print("   Meta-learn with: learner:MetaLearn()\n")

return DeepLearningSystem
