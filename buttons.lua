local buttons = {}

function buttons.create(gameState)
    -- Handle menu screen with different layout
    if gameState.screen == "menu" then
        gameState.buttons = {
            {label = "Start Run", x = 10, y = 100, w = 100, h = 40},
            {label = "Quit Game", x = 120, y = 100, w = 100, h = 40}
        }
        return
    end

    -- For staging and game screens, use sidebar layout
    local startY = 190
    local btnHeight = 44
    local btnSpacing = 60
    local sidebarX = 0
    local sidebarW = 235

    -- Decide button labels based on state
    local btnLabels = {}

    -- STAGING screen
    if gameState.screen == "staging" then
        btnLabels = {"Start Game", "Back to Main Menu"}

    -- LOST screen
    elseif gameState.screen == "lost" then
        btnLabels = {"Back to Main Menu"}

    -- GAME screen
    elseif gameState.screen == "game" then
        table.insert(btnLabels, "Quit to Staging")
        if gameState.currentStop == "colour" then
            table.insert(btnLabels, "Red")
            table.insert(btnLabels, "Black")
        elseif gameState.currentStop == "higherlower" then
            table.insert(btnLabels, "Higher")
            table.insert(btnLabels, "Lower")
        elseif gameState.currentStop == "insideoutside" then
            table.insert(btnLabels, "Inside")
            table.insert(btnLabels, "Outside")
        elseif gameState.currentStop == "suit" then
            table.insert(btnLabels, "Club")
            table.insert(btnLabels, "Diamond")
            table.insert(btnLabels, "Heart")
            table.insert(btnLabels, "Spade")
        end
        if gameState.passedStage then
            table.insert(btnLabels, "Next Stage")
        end
    end

    -- Build button objects with correct sidebar coordinates
    local btns = {}
    for i, label in ipairs(btnLabels) do
        btns[#btns+1] = {
            label = label,
            x = sidebarX + 18,
            y = startY + (i-1)*btnSpacing,
            w = sidebarW - 36,
            h = btnHeight
        }
    end

    gameState.buttons = btns
end

return buttons
