local gameState = {
    screen = "menu", -- menu, staging, game, lost
    currentStop = nil,
    guessResult = "",
    passedStage = false,
    finished = false,
    lost = false,
    currentGame = {},
    multiplier = 1,
    buttons = {},
    playerMoney = 1,
    initialStake = 1,
    highestMultiplier = 1,
    deck = {}
}

return gameState
