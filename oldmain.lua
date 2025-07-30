playerMoney = 1
initialStake = 1
highestMultiplier = 1

function love.load()
    gameState = {
        screen = "menu", -- menu, staging, game
        currentStop = nil,
        guessResult = "",
        passedStage = false,
        finished = false,
        currentGame = {},
        multiplier = 1,
        buttons = {
            {label = "Start Run", x = 10, y = 100, w = 100, h = 40},
            {label = "Quit Game", x = 120, y = 100, w = 100, h = 40}
        }
    }
end

-- ====== SCREEN SETUP ======
function goToStaging()
    -- Calculate final winnings if not 0
    if highestMultiplier > 1 then
        playerMoney = initialStake * highestMultiplier
    end

    gameState.screen = "staging"
    gameState.buttons = {
        {label = "Start Game", x = 10, y = 100, w = 150, h = 40},
        {label = "Back to Main Menu", x = 170, y = 100, w = 150, h = 40}
    }
end

function startGame()
    initDeck()
    gameState.screen = "game"
    gameState.currentStop = "colour"
    gameState.guessResult = ""
    gameState.passedStage = false
    gameState.finished = false
    gameState.currentGame = {}
    gameState.multiplier = 2
    initialStake = playerMoney
    highestMultiplier = 1
    drawCard()
    createButtons(gameState.currentStop)
end

-- ====== DECK ======
function initDeck()
    deck = {}
    for _, suit in ipairs({'club', 'diamond', 'heart', 'spade'}) do
        for rank = 1, 13 do
            table.insert(deck, {suit = suit, rank = rank})
        end
    end
end

function drawCard()
    table.insert(gameState.currentGame, table.remove(deck, love.math.random(#deck)))
end

-- ====== BUTTONS ======
function createButtons(stop)
    gameState.buttons = {
        {label = "Quit to Staging", x = 10, y = 300, w = 150, h = 40}
    }
    if stop == "colour" then
        table.insert(gameState.buttons, {label = "Red", x = 10, y = 100, w = 100, h = 40})
        table.insert(gameState.buttons, {label = "Black", x = 120, y = 100, w = 100, h = 40})
    elseif stop == "higherlower" then
        table.insert(gameState.buttons, {label = "Higher", x = 10, y = 100, w = 100, h = 40})
        table.insert(gameState.buttons, {label = "Lower", x = 120, y = 100, w = 100, h = 40})
    elseif stop == "insideoutside" then
        table.insert(gameState.buttons, {label = "Inside", x = 10, y = 100, w = 100, h = 40})
        table.insert(gameState.buttons, {label = "Outside", x = 120, y = 100, w = 100, h = 40})
    elseif stop == "suit" then
        table.insert(gameState.buttons, {label = "Club", x = 10, y = 100, w = 100, h = 40})
        table.insert(gameState.buttons, {label = "Diamond", x = 120, y = 100, w = 100, h = 40})
        table.insert(gameState.buttons, {label = "Heart", x = 230, y = 100, w = 100, h = 40})
        table.insert(gameState.buttons, {label = "Spade", x = 340, y = 100, w = 100, h = 40})
    end
    if gameState.passedStage then
        table.insert(gameState.buttons, {label = "Next Stage", x = 10, y = 200, w = 100, h = 40})
    end
end

-- ====== LOSE ======
function loseStage()
    playerMoney = 0
    highestMultiplier = 1
    goToStaging()
end

-- ====== UTILITY ======
function getCardValue(card)
    if card.rank == 1 then return 14 end
    return card.rank
end

-- ====== STAGE LOGIC ======
function markWin()
    highestMultiplier = gameState.multiplier
end

function playColourGuess(label)
    local card = gameState.currentGame[#gameState.currentGame]
    local isRed = (card.suit == "heart" or card.suit == "diamond")
    local correct = (label == "Red" and isRed) or (label == "Black" and not isRed)
    if correct then markWin() else loseStage() end
    gameState.guessResult = correct and "Correct!" or "Wrong!"
    gameState.passedStage = correct
    createButtons(gameState.currentStop)
end

function playHigherLower(label)
    local prevCard = gameState.currentGame[#gameState.currentGame - 1]
    local currentCard = gameState.currentGame[#gameState.currentGame]
    local prevValue = getCardValue(prevCard)
    local currentValue = getCardValue(currentCard)
    local correct = (label == "Higher" and currentValue >= prevValue) or
                    (label == "Lower" and currentValue <= prevValue)
    if correct then markWin() else loseStage() end
    gameState.guessResult = correct and "Correct!" or "Wrong!"
    gameState.passedStage = correct
    createButtons(gameState.currentStop)
end

function playInsideOutside(label)
    local firstCard = gameState.currentGame[#gameState.currentGame - 2]
    local secondCard = gameState.currentGame[#gameState.currentGame - 1]
    local currentCard = gameState.currentGame[#gameState.currentGame]
    local low = math.min(getCardValue(firstCard), getCardValue(secondCard))
    local high = math.max(getCardValue(firstCard), getCardValue(secondCard))
    local inside = getCardValue(currentCard) > low and getCardValue(currentCard) < high
    local correct = (label == "Inside" and inside) or (label == "Outside" and not inside)
    if correct then markWin() else loseStage() end
    gameState.guessResult = correct and "Correct!" or "Wrong!"
    gameState.passedStage = correct
    createButtons(gameState.currentStop)
end

function playSuitGuess(label)
    local currentCard = gameState.currentGame[#gameState.currentGame]
    local correct = (currentCard.suit == string.lower(label))
    if correct then markWin() else loseStage() end
    gameState.guessResult = correct and "Correct!" or "Wrong!"
    gameState.passedStage = correct
    createButtons(gameState.currentStop)
end

-- ====== PROGRESSION ======
function goToNextStage()
    if gameState.currentStop == "colour" then
        gameState.currentStop = "higherlower"
        gameState.multiplier = 3
        drawCard()
    elseif gameState.currentStop == "higherlower" then
        gameState.currentStop = "insideoutside"
        gameState.multiplier = 4
        drawCard()
    elseif gameState.currentStop == "insideoutside" then
        gameState.currentStop = "suit"
        gameState.multiplier = 20
        drawCard()
    elseif gameState.currentStop == "suit" then
        gameState.finished = true
        goToStaging()
        return
    end
    gameState.passedStage = false
    createButtons(gameState.currentStop)
end

-- ====== DRAW ======
function love.draw()
    if gameState.screen == "menu" then
        love.graphics.print("Welcome to Ride the Bus!", 10, 10)
    elseif gameState.screen == "staging" then
        love.graphics.print("Staging Area", 10, 10)
        love.graphics.print("Current Money: $" .. playerMoney, 10, 40)
    elseif gameState.screen == "game" then
        love.graphics.print("Money (Potential): $" .. (initialStake * highestMultiplier), 10, 10)
        if #gameState.currentGame > 0 then
            local currentCard = gameState.currentGame[#gameState.currentGame]
            love.graphics.print("Current Card: " .. currentCard.suit .. " " .. currentCard.rank, 10, 60)
        end
        love.graphics.print("Result: " .. gameState.guessResult, 10, 80)

        -- ✅ Show all previous cards for debugging
        love.graphics.print("Previous Cards:", 300, 10)
        for i, card in ipairs(gameState.currentGame) do
            love.graphics.print(i .. ": " .. card.suit .. " " .. card.rank, 300, 30 + (i * 15))
        end
    end

    for _, btn in ipairs(gameState.buttons) do
        love.graphics.rectangle("line", btn.x, btn.y, btn.w, btn.h)
        love.graphics.printf(btn.label, btn.x, btn.y + 10, btn.w, "center")
    end
end

-- ====== INPUT ======
function love.mousepressed(mx, my, button)
    if button == 1 then
        for _, btn in ipairs(gameState.buttons) do
            if mx > btn.x and mx < btn.x + btn.w and my > btn.y and my < btn.y + btn.h then
                handleButtonPress(btn.label)
            end
        end
    end
end

function handleButtonPress(label)
    if gameState.screen == "menu" then
        if label == "Start Run" then goToStaging()
        elseif label == "Quit Game" then love.event.quit() end
    elseif gameState.screen == "staging" then
        if label == "Start Game" then startGame()
        elseif label == "Back to Main Menu" then love.load() end
    elseif gameState.screen == "game" then
        if label == "Quit to Staging" then goToStaging()
        elseif gameState.currentStop == "colour" and (label == "Red" or label == "Black") then
            playColourGuess(label)
        elseif gameState.currentStop == "higherlower" and (label == "Higher" or label == "Lower") then
            playHigherLower(label)
        elseif gameState.currentStop == "insideoutside" and (label == "Inside" or label == "Outside") then
            playInsideOutside(label)
        elseif gameState.currentStop == "suit" and (label == "Club" or label == "Diamond" or label == "Heart" or label == "Spade") then
            playSuitGuess(label)
        elseif label == "Next Stage" then
            goToNextStage()
        end
    end
end
