local gameState = require("gameState")
local deck = require("deck")
local buttons = require("buttons")
local stages = require("stages")
local screens = {}

function screens.loadMenu()
    gameState.screen = "menu"
    buttons.create(gameState)
end

function screens.goToStaging()
    if gameState.highestMultiplier > 1 then
        gameState.playerMoney = gameState.initialStake * gameState.highestMultiplier
    end
    gameState.screen = "staging"
    buttons.create(gameState)
end

function screens.startGame()
    -- Initialize game for this round
    gameState.deck = deck.init()
    gameState.screen = "game"
    gameState.currentStop = "colour"
    gameState.guessResult = ""
    gameState.passedStage = false
    gameState.finished = false
    gameState.currentGame = {}
    gameState.multiplier = 2
    gameState.initialStake = gameState.playerMoney
    gameState.highestMultiplier = 1
    
    -- Draw first card and create buttons
    deck.draw(gameState)
    buttons.create(gameState)
end

function screens.goToNextStage()
    if gameState.currentStop == "colour" then
        gameState.currentStop = "higherlower"
        gameState.multiplier = 3
        deck.draw(gameState)
    elseif gameState.currentStop == "higherlower" then
        gameState.currentStop = "insideoutside"
        gameState.multiplier = 4
        deck.draw(gameState)
    elseif gameState.currentStop == "insideoutside" then
        gameState.currentStop = "suit"
        gameState.multiplier = 20
        deck.draw(gameState)
    elseif gameState.currentStop == "suit" then
        gameState.finished = true
        screens.goToStaging()
        return
    end
    gameState.passedStage = false
    buttons.create(gameState)
end

function screens.drawEnhanced()
    -- MAIN MENU
    if gameState.screen == "menu" then
        love.graphics.setBackgroundColor(0.09,0.09,0.09)
        love.graphics.setColor(1,1,1)
        love.graphics.setFont(love.graphics.newFont(32))
        love.graphics.print("Ride the Bus", 60, 60)
        love.graphics.setFont(love.graphics.newFont(18))
        love.graphics.print("Press Start to Begin", 60, 120)

        -- Buttons
        for _, btn in ipairs(gameState.buttons) do
            love.graphics.setColor(1,1,1)
            love.graphics.rectangle("line", btn.x, btn.y, btn.w, btn.h, 8, 8)
            love.graphics.setFont(love.graphics.newFont(22))
            love.graphics.printf(btn.label, btn.x, btn.y + 12, btn.w, "center")
        end

    -- LOST SCREEN
    elseif gameState.screen == "lost" then
        love.graphics.setBackgroundColor(0.2, 0.05, 0.05)
        
        -- Red "YOU LOSE!" text with shadow
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.setFont(love.graphics.newFont(72))
        love.graphics.printf("YOU LOSE!", 52, 152, love.graphics.getWidth(), "center")
        
        love.graphics.setColor(1, 0.2, 0.2)
        love.graphics.printf("YOU LOSE!", 50, 150, love.graphics.getWidth(), "center")
        
        -- Additional message
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(love.graphics.newFont(24))
        love.graphics.printf("Better luck next time!", 0, 250, love.graphics.getWidth(), "center")
        
        -- Show final result
        love.graphics.setFont(love.graphics.newFont(18))
        love.graphics.printf("You lost $" .. gameState.initialStake, 0, 300, love.graphics.getWidth(), "center")

        -- Buttons
        for _, btn in ipairs(gameState.buttons) do
            love.graphics.setColor(0.8, 0.2, 0.2)
            love.graphics.rectangle("fill", btn.x, btn.y, btn.w, btn.h, 8, 8)
            love.graphics.setColor(1, 1, 1)
            love.graphics.rectangle("line", btn.x, btn.y, btn.w, btn.h, 8, 8)
            love.graphics.setFont(love.graphics.newFont(18))
            love.graphics.printf(btn.label, btn.x, btn.y + 10, btn.w, "center")
        end

    -- STAGING SCREEN
    elseif gameState.screen == "staging" then
        love.graphics.setBackgroundColor(0.07, 0.13, 0.11)
        love.graphics.setColor(1,1,1)
        -- Subtle background pattern (optional)
        for x=0, love.graphics.getWidth(), 64 do
            for y=0, love.graphics.getHeight(), 64 do
                love.graphics.setColor(0,0.15,0.11,0.09)
                love.graphics.circle("fill", x+32, y+32, 32)
            end
        end
        love.graphics.setColor(1,1,1)

        -- === LEFT SIDEBAR ===
        local sidebarX, sidebarY, sidebarW, sidebarH = 0, 0, 235, love.graphics.getHeight()
        love.graphics.setColor(0.15,0.19,0.18, 0.97)
        love.graphics.rectangle("fill", sidebarX, sidebarY, sidebarW, sidebarH)
        love.graphics.setColor(0.17,0.22,0.2)
        love.graphics.rectangle("line", sidebarX, sidebarY, sidebarW, sidebarH)

        -- Sidebar Content
        love.graphics.setColor(1,1,1)
        love.graphics.setFont(love.graphics.newFont(23))
        love.graphics.print("Ride the Bus", sidebarX+22, sidebarY+22)
        love.graphics.setFont(love.graphics.newFont(15))

        love.graphics.print("Money: $" .. gameState.playerMoney, sidebarX+22, sidebarY+62)
        love.graphics.setColor(1,0.78,0.22)
        love.graphics.setFont(love.graphics.newFont(16))
        love.graphics.print("Ready to Play", sidebarX+22, sidebarY+122)
        love.graphics.setFont(love.graphics.newFont(13))
        love.graphics.setColor(1,1,1)

        -- Button column
        local btnY = sidebarY + 190
        for _, btn in ipairs(gameState.buttons) do
            love.graphics.setColor(0.2,0.25,0.22)
            love.graphics.rectangle("fill", sidebarX+18, btnY, sidebarW-36, 44, 8, 8)
            love.graphics.setColor(1,1,1)
            love.graphics.rectangle("line", sidebarX+18, btnY, sidebarW-36, 44, 8, 8)
            love.graphics.setFont(love.graphics.newFont(18))
            love.graphics.printf(btn.label, sidebarX+18, btnY+10, sidebarW-36, "center")
            btnY = btnY + 60
        end

        -- === MAIN PLAY AREA ===
        local playX = sidebarW + 40
        local playY = 50
        
        -- Welcome message for staging
        love.graphics.setColor(1,1,1)
        love.graphics.setFont(love.graphics.newFont(32))
        love.graphics.printf("Welcome to Ride the Bus!", playX, playY + 100, love.graphics.getWidth() - playX - 40, "left")
        love.graphics.setFont(love.graphics.newFont(18))
        love.graphics.printf("Click 'Start Game' when you're ready to begin your card guessing adventure!", playX, playY + 150, love.graphics.getWidth() - playX - 40, "left")

    -- GAME SCREEN  
    elseif gameState.screen == "game" then
        love.graphics.setBackgroundColor(0.07, 0.13, 0.11)
        love.graphics.setColor(1,1,1)
        -- Subtle background pattern (optional)
        for x=0, love.graphics.getWidth(), 64 do
            for y=0, love.graphics.getHeight(), 64 do
                love.graphics.setColor(0,0.15,0.11,0.09)
                love.graphics.circle("fill", x+32, y+32, 32)
            end
        end
        love.graphics.setColor(1,1,1)

        -- === LEFT SIDEBAR ===
        local sidebarX, sidebarY, sidebarW, sidebarH = 0, 0, 235, love.graphics.getHeight()
        love.graphics.setColor(0.15,0.19,0.18, 0.97)
        love.graphics.rectangle("fill", sidebarX, sidebarY, sidebarW, sidebarH)
        love.graphics.setColor(0.17,0.22,0.2)
        love.graphics.rectangle("line", sidebarX, sidebarY, sidebarW, sidebarH)

        -- Sidebar Content
        love.graphics.setColor(1,1,1)
        love.graphics.setFont(love.graphics.newFont(23))
        love.graphics.print("Ride the Bus", sidebarX+22, sidebarY+22)
        love.graphics.setFont(love.graphics.newFont(15))

        love.graphics.print("Money: $" .. gameState.playerMoney, sidebarX+22, sidebarY+62)
        love.graphics.print("Potential: $" .. (gameState.initialStake * gameState.highestMultiplier), sidebarX+22, sidebarY+90)
        love.graphics.setColor(1,0.78,0.22)
        love.graphics.setFont(love.graphics.newFont(16))
        love.graphics.print("Stage: " .. (gameState.currentStop or "-"), sidebarX+22, sidebarY+122)
        love.graphics.setFont(love.graphics.newFont(13))
        love.graphics.setColor(1,1,1)
        love.graphics.print("Result:", sidebarX+22, sidebarY+155)
        love.graphics.print(gameState.guessResult, sidebarX+90, sidebarY+155)

        -- Button column
        local btnY = sidebarY + 190
        for _, btn in ipairs(gameState.buttons) do
            love.graphics.setColor(0.2,0.25,0.22)
            love.graphics.rectangle("fill", sidebarX+18, btnY, sidebarW-36, 44, 8, 8)
            love.graphics.setColor(1,1,1)
            love.graphics.rectangle("line", sidebarX+18, btnY, sidebarW-36, 44, 8, 8)
            love.graphics.setFont(love.graphics.newFont(18))
            love.graphics.printf(btn.label, sidebarX+18, btnY+10, sidebarW-36, "center")
            btnY = btnY + 60
        end
        love.graphics.setFont(love.graphics.newFont(13))

        -- === MAIN PLAY AREA ===
        -- Card layout variables
        local playX = sidebarW + 40
        local playY = 50

        -- Draw Current Card (big) - ONLY in game screen
        if #gameState.currentGame > 0 then
            local card = gameState.currentGame[#gameState.currentGame]
            local cardW, cardH = 90, 130
            -- shadow
            love.graphics.setColor(0,0,0,0.18)
            love.graphics.rectangle("fill", playX+6, playY+10, cardW, cardH, 16, 16)
            -- card
            love.graphics.setColor(1,1,1)
            love.graphics.rectangle("fill", playX, playY, cardW, cardH, 16, 16)
            love.graphics.setColor(0.83,0.83,0.83)
            love.graphics.rectangle("line", playX, playY, cardW, cardH, 16, 16)

            -- Suit and rank (big)
            local rankMap = {[1]="A", [11]="J", [12]="Q", [13]="K"}
            local rankStr = rankMap[card.rank] or tostring(card.rank)
            local suitIcons = {club="C", diamond="D", heart="H", spade="S"}
            local suitStr = suitIcons[card.suit] or card.suit
            if card.suit == "heart" or card.suit == "diamond" then
                love.graphics.setColor(1,0.18,0.18)
            else
                love.graphics.setColor(0.15,0.16,0.17)
            end
            love.graphics.setFont(love.graphics.newFont(34))
            love.graphics.printf(rankStr, playX, playY+8, cardW, "center")
            love.graphics.setFont(love.graphics.newFont(48))
            love.graphics.printf(suitStr, playX, playY+42, cardW, "center")
            love.graphics.setColor(1,1,1)
        end

        -- Previous cards (row, below current) - ONLY in game screen
        if #gameState.currentGame > 0 then
            local prevY = playY + 170
            love.graphics.setFont(love.graphics.newFont(12))
            love.graphics.setColor(1,1,1)
            love.graphics.print("Previous Cards:", playX, prevY)
            local prevCardW, prevCardH = 44, 60
            local prevStartX = playX
            for i, card in ipairs(gameState.currentGame) do
                local x = prevStartX + (i-1) * (prevCardW + 7)
                local y = prevY + 22
                -- shadow
                love.graphics.setColor(0,0,0,0.13)
                love.graphics.rectangle("fill", x+2, y+2, prevCardW, prevCardH, 8, 8)
                -- card
                love.graphics.setColor(1,1,1)
                love.graphics.rectangle("fill", x, y, prevCardW, prevCardH, 8, 8)
                love.graphics.setColor(0.7,0.7,0.7)
                love.graphics.rectangle("line", x, y, prevCardW, prevCardH, 8, 8)
                -- suit and rank
                local rankMap = {[1]="A", [11]="J", [12]="Q", [13]="K"}
                local rankStr = rankMap[card.rank] or tostring(card.rank)
                local suitIcons = {club="C", diamond="D", heart="H", spade="S"}
                local suitStr = suitIcons[card.suit] or card.suit
                if card.suit == "heart" or card.suit == "diamond" then
                    love.graphics.setColor(1,0.18,0.18)
                else
                    love.graphics.setColor(0.13,0.13,0.13)
                end
                love.graphics.setFont(love.graphics.newFont(15))
                love.graphics.printf(rankStr, x, y+3, prevCardW, "center")
                love.graphics.setFont(love.graphics.newFont(22))
                love.graphics.printf(suitStr, x, y+18, prevCardW, "center")
            end

            -- Debug info on far right - ONLY in game screen
            love.graphics.setFont(love.graphics.newFont(13))
            love.graphics.setColor(1,1,1)
            love.graphics.print("Debug - Card List:", playX+530, 60)
            for i, card in ipairs(gameState.currentGame) do
                local rankMap = {[1]="A", [11]="J", [12]="Q", [13]="K"}
                local rankStr = rankMap[card.rank] or tostring(card.rank)
                love.graphics.print(i .. ": " .. card.suit .. " " .. rankStr, playX+530, 80 + (i * 15))
            end
        end
    end
end


function screens.draw()
    screens.drawEnhanced()
end

function screens.handleButtonPress(label)
    if gameState.screen == "menu" then
        if label == "Start Run" then
            -- Reset entire game state for new run
            gameState.playerMoney = 1
            gameState.initialStake = 1
            gameState.highestMultiplier = 1
            gameState.currentStop = nil
            gameState.guessResult = ""
            gameState.passedStage = false
            gameState.finished = false
            gameState.lost = false
            gameState.currentGame = {}
            gameState.multiplier = 1
            gameState.deck = {}
            gameState.buttons = {}
            screens.goToStaging()
        elseif label == "Quit Game" then love.event.quit() end
    elseif gameState.screen == "staging" then
        if label == "Start Game" then screens.startGame()
        elseif label == "Back to Main Menu" then screens.loadMenu() end
    elseif gameState.screen == "lost" then
        if label == "Back to Main Menu" then 
            gameState.lost = false
            screens.loadMenu() 
        end
    elseif gameState.screen == "game" then
        if label == "Quit to Staging" then screens.goToStaging()
        elseif gameState.currentStop == "colour" and (label == "Red" or label == "Black") then
            stages.playColourGuess(gameState, label)
        elseif gameState.currentStop == "higherlower" and (label == "Higher" or label == "Lower") then
            stages.playHigherLower(gameState, label)
        elseif gameState.currentStop == "insideoutside" and (label == "Inside" or label == "Outside") then
            stages.playInsideOutside(gameState, label)
        elseif gameState.currentStop == "suit" and (label == "Club" or label == "Diamond" or label == "Heart" or label == "Spade") then
            stages.playSuitGuess(gameState, label)
        elseif label == "Next Stage" then
            screens.goToNextStage()
        end
    end
end

return screens
