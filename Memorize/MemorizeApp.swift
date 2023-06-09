//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Shawn Christopher on 6/7/23.
//

import SwiftUI

@main
struct MemorizeApp: App {
    private let game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(game:game)
        }
    }
}
