//
//  ContentView.swift
//  Memorize
//
//  Created by Shawn Christopher on 6/7/23.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var game:EmojiMemoryGame
    
    var body: some View {

        AspectVGrid(items:game.cards,aspectRatio:2/3){ card in
            if card.isMatched && !card.isFaceUp{
                Rectangle().opacity(0)
            }else{
                CardView(card:card).padding(4)
                    .onTapGesture{
                        game.choose(card)
                    }
            }
        }
            .foregroundColor(.red)
            .padding(.horizontal)
    }
}

struct CardView: View{

    let card:EmojiMemoryGame.Card
    
    
    var body: some View{
        GeometryReader{ geometry in
            ZStack{
                
                    Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: 110-90)).padding(7).opacity(0.5)
                    Text(card.content)
                    .rotationEffect(Angle.degrees(card.isMatched ? 360:0))
                    .animation(Animation.linear(duration: 1.0).repeatForever(autoreverses: false))
                    .font(Font.system(size: DrawingConstants.fontSize))
                    .scaleEffect(scale(thatFits:geometry.size))
            }.cardify(isFaceUp: card.isFaceUp)
        }
    }
    
    private func scale (thatFits size:CGSize)->CGFloat{
        min(size.width,size.height) / (DrawingConstants.fontSize / DrawingConstants.fontScale)
    }
    
    private func font(in size:CGSize)-> Font{
        .system(size: min(size.width,size.height)*DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants{
        static let fontScale:CGFloat = 0.70
        static let fontSize:CGFloat = 32
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(game.cards.first!)
        return EmojiMemoryGameView(game: game)
            .preferredColorScheme(.dark)
    }
}
