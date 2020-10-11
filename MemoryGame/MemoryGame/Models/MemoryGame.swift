//
//  MemoryGame.swift
//  MemoryGame
//
//  Created by Emilio Heinzmann on 10/10/20.
//

import UIKit

public class MemoryGame {
    
    let cards: [Card]
    var matchedCards: [Card] = [] {
        didSet {            
            if cards.count == matchedCards.count {
                hasWon = true
            }
        }
    }
    var visibleCards: [Card] = []
    var hasWon: Bool = false
    var numberOfPlays: Int = 0
    
    internal init() {
        self.cards = randomCardsArrayGenerator()
    }
    
    func guessCard(at index: Int) -> Bool {
        var needsFlip = false
        let wasInArray = !self.cards[index].isIn(self.visibleCards)
        
        if self.visibleCards.count == 2 {
            self.visibleCards = []
            needsFlip = true
        }
        
        if wasInArray {
            self.visibleCards.append(self.cards[index])
            needsFlip = true
        }
        
        if self.visibleCards.count == 2 {
            self.numberOfPlays += 1
            
            if self.visibleCards[0].imageName  == self.visibleCards[1].imageName {
                self.matchedCards.append(contentsOf: self.visibleCards)
                self.visibleCards = []
            }
        }
        
        return needsFlip
    }
    
}
