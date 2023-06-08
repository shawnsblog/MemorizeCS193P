//
//  MemoryGame.swift
//  Memorize
//
//  Created by Shawn Christopher on 6/8/23.
//

import Foundation

struct MemoryGame<CardContent>{
    private(set) var cards: Array<Card>
    
    func chooseCard(_ card:Card){
        
    }
    
    init(numberOfPairsOfCards:Int, createCardContent:(Int) -> CardContent)
    {
        cards = Array<Card>()
        //add numberOfPairsOfCards x2 to cards array
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            cards.append(Card(content: <#T##CardContent#>))
        }
    }
    
    struct Card{
        var isFaceUp:Bool = false
        var isMatched:Bool = false
        var content:CardContent
    }
}
