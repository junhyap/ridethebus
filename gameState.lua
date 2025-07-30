local gameState = {
    screen = "menu", -- menu, staging, game
    currentStop = nil,
    guessResult = "",
    passedStage = false,
    finished = false,
    currentGame = {},
    multiplier = 1,
    buttons = {},
    playerMoney = 1,
    initialStake = 1,
    highestMultiplier = 1,
    deck = {}
}

return gameState
