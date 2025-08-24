# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a "Ride the Bus" card game implementation built with LÖVE 2D (Lua game framework). The game is a 4-stage guessing game where players make increasingly difficult predictions about cards to multiply their initial stake.

## Development Commands

### Running the Game
```bash
# Run from command line (Windows)
"C:\Program Files\LOVE\love.exe" "C:\Users\jhyap\Documents\ridethebus\own"
```

## Architecture

The codebase follows a modular Lua structure with clear separation of concerns:

### Core Modules
- **main.lua** - Entry point and LÖVE 2D callbacks (load, draw, mousepressed)
- **gameState.lua** - Central state management (screen, money, game progress, deck)
- **screens.lua** - Screen management and navigation (menu, staging, game)
- **stages.lua** - Game logic for each stage (colour, higher/lower, inside/outside, suit)
- **buttons.lua** - Dynamic button creation based on current game state
- **deck.lua** - Card deck initialization and drawing logic

### Game Flow Architecture
1. **Menu Screen** → **Staging Screen** → **Game Screen**
2. Game progresses through 4 stages with increasing multipliers:
   - Colour (2x): Guess red/black
   - Higher/Lower (3x): Compare with previous card
   - Inside/Outside (4x): Check if card falls between first two cards
   - Suit (20x): Guess exact suit

### State Management
- All game state is centralized in `gameState.lua`
- State includes: current screen, player money, game progress, card deck, buttons
- Screen transitions handled through `screens.lua` functions
- Game logic isolated in `stages.lua` with clear win/lose conditions

### Button System
- Dynamic button generation based on current game state and stage
- Mouse click detection handled in `main.lua` with delegation to `screens.handleButtonPress()`
- Button layouts and labels managed by `buttons.create()`

## File Structure Notes

- **oldmain.lua** - Legacy/backup main file (not currently used)
- **screens.lua** contains commented-out elaborate UI rendering code (lines 63-209) that could be restored for enhanced visuals
- The current implementation uses simple text-based rendering for rapid prototyping

## Game Logic Details

- Ace cards are treated as value 14 for higher/lower comparisons
- Players lose all money and return to staging on any wrong guess
- Successful completion of all stages multiplies initial stake by final multiplier
- Game supports multiple runs with accumulated winnings