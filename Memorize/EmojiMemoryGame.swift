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
    typealias Card = MemoryGame<String>.Card
    private static let emojis = ["✈️","🚂","🚗","🚢","😀","😃","🙈","😄","🥹","🥰","🤪","😎"]
    
    private static func createMemoryGame()->MemoryGame<String>
    {
        MemoryGame<String>(numberOfPairsOfCards: 10) {pairIndex in emojis[pairIndex]}
    }
    
    
    @Published private var model = createMemoryGame()
    
    
    var cards:Array<Card>{
        return model.cards
    }
    
    func choose(_ card:Card){
        model.choose(card)
    }
    
    func shuffle(){
        model.shuffle()
    }
    
    func restart(){
        model = EmojiMemoryGame.createMemoryGame()
    }
}
