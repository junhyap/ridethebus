local gameState = require("gameState")
local screens = require("screens")
local buttons = require("buttons")
local stages = require("stages")

function love.load()
    require("screens").loadMenu()
end

function love.draw()
    screens.draw()
end

function love.mousepressed(mx, my, button)
    if button == 1 then
        for _, btn in ipairs(gameState.buttons) do
            if mx > btn.x and mx < btn.x + btn.w and my > btn.y and my < btn.y + btn.h then
                screens.handleButtonPress(btn.label)
            end
        end
    end
end
