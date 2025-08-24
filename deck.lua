local deck = {}

function deck.init()
    local d = {}
    for _, suit in ipairs({'club', 'diamond', 'heart', 'spade'}) do
        for rank = 1, 13 do
            table.insert(d, {suit = suit, rank = rank})
        end
    end
    return d
end

function deck.draw(state)
    table.insert(state.currentGame, table.remove(state.deck, love.math.random(#state.deck)))
end

return deck