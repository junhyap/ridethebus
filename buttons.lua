local buttons = {}

function buttons.create(gameState)
    gameState.buttons = {
        {label = "Quit to Staging", x = 10, y = 300, w = 150, h = 40}
    }
    if gameState.currentStop == "colour" then
        table.insert(gameState.buttons, {label = "Red", x = 10, y = 100, w = 100, h = 40})
        table.insert(gameState.buttons, {label = "Black", x = 120, y = 100, w = 100, h = 40})
    elseif gameState.currentStop == "higherlower" then
        table.insert(gameState.buttons, {label = "Higher", x = 10, y = 100, w = 100, h = 40})
        table.insert(gameState.buttons, {label = "Lower", x = 120, y = 100, w = 100, h = 40})
    elseif gameState.currentStop == "insideoutside" then
        table.insert(gameState.buttons, {label = "Inside", x = 10, y = 100, w = 100, h = 40})
        table.insert(gameState.buttons, {label = "Outside", x = 120, y = 100, w = 100, h = 40})
    elseif gameState.currentStop == "suit" then
        table.insert(gameState.buttons, {label = "Club", x = 10, y = 100, w = 100, h = 40})
        table.insert(gameState.buttons, {label = "Diamond", x = 120, y = 100, w = 100, h = 40})
        table.insert(gameState.buttons, {label = "Heart", x = 230, y = 100, w = 100, h = 40})
        table.insert(gameState.buttons, {label = "Spade", x = 340, y = 100, w = 100, h = 40})
    end
    if gameState.passedStage then
        table.insert(gameState.buttons, {label = "Next Stage", x = 10, y = 200, w = 100, h = 40})
    end
end

return buttons

-- local buttons = {}

-- function buttons.create(gameState)
--     local startY = 190
--     local btnHeight = 44
--     local btnSpacing = 60
--     local sidebarX = 0
--     local sidebarW = 235

--     -- Decide button labels based on state
--     local btnLabels = {}

--     -- STAGING screen
--     if gameState.screen == "staging" then
--         btnLabels = {"Start Game", "Back to Main Menu"}

--     -- GAME screen
--     elseif gameState.screen == "game" then
--         table.insert(btnLabels, "Quit to Staging")
--         if gameState.currentStop == "colour" then
--             table.insert(btnLabels, "Red")
--             table.insert(btnLabels, "Black")
--         elseif gameState.currentStop == "higherlower" then
--             table.insert(btnLabels, "Higher")
--             table.insert(btnLabels, "Lower")
--         elseif gameState.currentStop == "insideoutside" then
--             table.insert(btnLabels, "Inside")
--             table.insert(btnLabels, "Outside")
--         elseif gameState.currentStop == "suit" then
--             table.insert(btnLabels, "Club")
--             table.insert(btnLabels, "Diamond")
--             table.insert(btnLabels, "Heart")
--             table.insert(btnLabels, "Spade")
--         end
--         if gameState.passedStage then
--             table.insert(btnLabels, "Next Stage")
--         end
--     end

--     -- Build button objects with correct sidebar coordinates
--     local btns = {}
--     for i, label in ipairs(btnLabels) do
--         btns[#btns+1] = {
--             label = label,
--             x = sidebarX + 18,
--             y = startY + (i-1)*btnSpacing,
--             w = sidebarW - 36,
--             h = btnHeight
--         }
--     end

--     gameState.buttons = btns
-- end

-- return buttons
