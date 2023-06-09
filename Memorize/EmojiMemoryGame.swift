//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Shawn Christopher on 6/8/23.
//

import SwiftUI


func makeCardContent(index:Int)->String{
    return "😂"
}




class EmojiMemoryGame:ObservableObject
{
    static let emojis = ["✈️","🚂","🚗","🚢","😀","😃","🙈","😄","🥹","🥰","🤪","😎"]
    
    static func createMemoryGame()->MemoryGame<String>
    {
        MemoryGame<String>(numberOfPairsOfCards: 4) {pairIndex in emojis[pairIndex]}
    }
    
    
    @Published private var model:MemoryGame<String> = createMemoryGame()
    
    
    var cards:Array<MemoryGame<String>.Card>{
        return model.cards
    }
    
    func choose(_ card:MemoryGame<String>.Card){
        model.choose(card)
    }
}
