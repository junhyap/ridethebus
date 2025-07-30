local deck = require("deck")
local buttons = require("buttons")
local stages = {}

local function getCardValue(card)
    return (card.rank == 1) and 14 or card.rank
end

function stages.markWin(gameState)
    gameState.highestMultiplier = gameState.multiplier
end

function stages.loseStage(gameState)
    gameState.playerMoney = 0
    gameState.highestMultiplier = 1
    require("screens").goToStaging()
end

function stages.playColourGuess(gameState, label)
    local card = gameState.currentGame[#gameState.currentGame]
    local isRed = (card.suit == "heart" or card.suit == "diamond")
    local correct = (label == "Red" and isRed) or (label == "Black" and not isRed)
    if correct then stages.markWin(gameState) else stages.loseStage(gameState) return end
    gameState.guessResult = correct and "Correct!" or "Wrong!"
    gameState.passedStage = correct
    buttons.create(gameState)
end

function stages.playHigherLower(gameState, label)
    local prevCard = gameState.currentGame[#gameState.currentGame - 1]
    local currentCard = gameState.currentGame[#gameState.currentGame]
    local prevValue = getCardValue(prevCard)
    local currentValue = getCardValue(currentCard)
    local correct = (label == "Higher" and currentValue >= prevValue) or
                    (label == "Lower" and currentValue <= prevValue)
    if correct then stages.markWin(gameState) else stages.loseStage(gameState) return end
    gameState.guessResult = correct and "Correct!" or "Wrong!"
    gameState.passedStage = correct
    buttons.create(gameState)
end

function stages.playInsideOutside(gameState, label)
    local firstCard = gameState.currentGame[#gameState.currentGame - 2]
    local secondCard = gameState.currentGame[#gameState.currentGame - 1]
    local currentCard = gameState.currentGame[#gameState.currentGame]
    local low = math.min(getCardValue(firstCard), getCardValue(secondCard))
    local high = math.max(getCardValue(firstCard), getCardValue(secondCard))
    local inside = getCardValue(currentCard) > low and getCardValue(currentCard) < high
    local correct = (label == "Inside" and inside) or (label == "Outside" and not inside)
    if correct then stages.markWin(gameState) else stages.loseStage(gameState) return end
    gameState.guessResult = correct and "Correct!" or "Wrong!"
    gameState.passedStage = correct
    buttons.create(gameState)
end

function stages.playSuitGuess(gameState, label)
    local currentCard = gameState.currentGame[#gameState.currentGame]
    local correct = (currentCard.suit == string.lower(label))
    if correct then stages.markWin(gameState) else stages.loseStage(gameState) return end
    gameState.guessResult = correct and "Correct!" or "Wrong!"
    gameState.passedStage = correct
    buttons.create(gameState)
end

return stages
