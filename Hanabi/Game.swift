//
//  Created by Geoff Hom on 8/6/14.
//  Copyright (c) 2014 Geoff Hom. All rights reserved.
//

import UIKit

class Game: NSObject {
    
    // Start of game is turn 1. At end of game, there's no current turn.
    var currentOptionalTurn: Turn?
    // The draw pile.
    var deckCardArray: [Card] = []
    var numberOfPlayersInt: Int = 2
    // Number for srandom(). Determines card order.
//    var seedInt: Int
    var turnArray: [Turn] = []
    // Return the number of the current turn.
    func currentTurnNumberOptionalInt() -> Int? {
        if let turn = currentOptionalTurn {
            let optionalIndex = find(turnArray, turn)
            if let index = optionalIndex {
                return index + 1
            }
        }
        return nil
    }
    // Deal starting hands to the given players.
    func dealHandsFromDeck(inout deckCardArray: [Card], inout playerArray: [Player]) {
        
    }
    // Do the current action. Make next turn or end game.
    func finishCurrentTurn() {
        if let turn = currentOptionalTurn {
            // this should populate the endingState
            turn.performAction()
            if isDone() {
                currentOptionalTurn = nil
            } else {
                // turn 2 starting state = turn 1 ending state with a different current player
                // turn 1 starting state = ??
                let nextOptionalTurn = Turn.fromTurn(turn)
                if let nextTurn = nextOptionalTurn {
                    turnArray.append(nextTurn)
                    currentOptionalTurn = nextTurn
                }
            }
        }
    }
    // Make deck. Shuffle. Deal hands.
    init(seedOptionalUInt32: UInt32?, numberOfPlayersInt: Int) {
        super.init()
        self.numberOfPlayersInt = numberOfPlayersInt
        deckCardArray = makeADeck()
        // don't need to store seed yet
        // could make the seed an inout var; wait until I figure out where/how to user wants to know seed
        shuffleDeck(&deckCardArray, seedOptionalUInt32: seedOptionalUInt32)
        // debugging
        printDeck(deckCardArray)
        var playerArray: [Player]
        for _ in 1...numberOfPlayersInt {
            playerArray.append(Player())
        }
        dealHandsFromDeck(&deckCardArray, playerArray: &playerArray)
        let gameState = GameState()
        gameState.playerArray = playerArray
        gameState.deckCardArray = deckCardArray
        let turn = Turn(gameState: gameState)
        turnArray.append(turn)
        currentOptionalTurn = turn
    }
    // Return whether the game has ended (not necessarily won).
    func isDone() -> Bool {
        // check some game parameters
        // temp so we don't get infinite loop
        return true
    }
    // Return an unshuffled deck.
    func makeADeck() -> [Card] {
        var cardArray: [Card] = []
        // For each color, add 3/2/2/2/1 of 1/2/3/4/5.
        var card: Card
        for int in 1...5 {
            if let color = Card.Color.fromRaw(int) {
                for _ in 1...3 {
                    card = Card(color: color, numberInt: 1)
                    cardArray.append(card)
                }
                for _ in 1...2 {
                    card = Card(color: color, numberInt: 2)
                    cardArray.append(card)
                    card = Card(color: color, numberInt: 3)
                    cardArray.append(card)
                    card = Card(color: color, numberInt: 4)
                    cardArray.append(card)
                }
                card = Card(color: color, numberInt: 5)
                cardArray.append(card)
            }
        }
        return cardArray
    }
    // User/coder can see cards in deck.
    func printDeck(deckCardArray: [Card]) {
        print("Deck:")
        for card in deckCardArray {
            print(" \(card.string())")
        }
        print("\n")
    }
    // Deck is randomized in a reproducible order.
    func shuffleDeck(inout deckCardArray: [Card], seedOptionalUInt32: UInt32?) {
        // Shuffle deck: Pull a random card and put in new deck. Repeat.
        // If no seed, choose a random one.
        var seedUInt32: UInt32
        if seedOptionalUInt32 == nil {
            seedUInt32 = arc4random()
        } else {
            seedUInt32 = seedOptionalUInt32!
        }
        println("Seed: \(seedUInt32)")
        srandom(seedUInt32)
        var tempCardArray: [Card] = []
        // Number of cards in deck will decrease each time.
        for pullTurnInt in 1...deckCardArray.count {
            let indexInt = random() % deckCardArray.count
            let card = deckCardArray.removeAtIndex(indexInt)
            tempCardArray.append(card)
        }
        deckCardArray = tempCardArray
    }
}