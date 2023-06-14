//
//  ContentView.swift
//  Memorize
//
//  Created by Shawn Christopher on 6/7/23.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var game:EmojiMemoryGame
    @Namespace private var dealingNamespace
    
    var body: some View {
        ZStack (alignment: .bottom){
            VStack{
                gameBody
                HStack{
                    restart
                    Spacer()
                    shuffle
                }.padding(.horizontal)
            }
            deckBody
        }
        .padding()

    }
    
    @State private var delt = Set<Int>()
    
    private func deal(_ card:EmojiMemoryGame.Card){
        delt.insert(card.id)
    }
    
    private func isUndelt(_ card:EmojiMemoryGame.Card)->Bool{
        !delt.contains(card.id)
    }
    
    private func dealAnimation(for card:EmojiMemoryGame.Card)->Animation{
        var delay = 0.0
        if let index = game.cards.firstIndex(where: {$0.id == card.id}){
            delay = Double(index) * (CardConstants.totalDealDuration / Double(game.cards.count))
        }
        return Animation.easeInOut(duration: 1).delay(delay)
    }
    
    private func zIndex(of card:EmojiMemoryGame.Card)->Double{
        -Double(game.cards.firstIndex(where: {$0.id == card.id}) ?? 0)
    }
    
    var gameBody:some View{
        AspectVGrid(items:game.cards,aspectRatio:CardConstants.aspectRatio){ card in
            if isUndelt(card) || card.isMatched && !card.isFaceUp{
                Color.clear
            }else{
                CardView(card:card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .padding(4)
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal:.scale ))
                    .zIndex(zIndex(of: card))
                    .onTapGesture{
                        withAnimation{
                            game.choose(card)
                        }
                    }
            }
        }
        .foregroundColor(CardConstants.color)
    }
    
    var deckBody: some View{
        ZStack{
            ForEach(game.cards.filter(isUndelt)) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal:.identity ))
                    .zIndex(zIndex(of: card))
            }
        }
        .frame(width: CardConstants.undeltWidth,height: CardConstants.undeltHeight)
        .foregroundColor(CardConstants.color)
        .onTapGesture {
            for card in game.cards{
                withAnimation(dealAnimation(for : card)){
                    deal(card)
                }
            }
        }
    }
    
    var shuffle: some View{
        Button("Shuffle") {
            withAnimation{
                game.shuffle()
            }
        }
    }
    
    var restart: some View{
        Button("Restart"){
            withAnimation{
                delt = []
                game.restart();
            }
        }
    }
    
    private struct CardConstants{
        static let color = Color.red
        static let aspectRatio:CGFloat = 2/3
        static let dealDuration:Double = 5
        static let totalDealDuration:Double = 2
        static let undeltHeight:CGFloat = 90
        static let undeltWidth:CGFloat = undeltHeight * aspectRatio
    }
}

struct CardView: View{

    let card:EmojiMemoryGame.Card
    
    @State private var animatedBonusRemaing:Double = 0
    
    var body: some View{
        GeometryReader{ geometry in
            ZStack{
                Group{
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1 -  animatedBonusRemaing) * 360 - 90))
                            .onAppear{
                                animatedBonusRemaing = card.bonusRemaining
                                withAnimation(.linear(duration: card.bonusTimeRemaining)){
                                    animatedBonusRemaing = 0
                                }
                            }
                        
                    }else{
                        Pie(startAngle: Angle(degrees: 0-90), endAngle: Angle(degrees: (1 -  card.bonusRemaining) * 360 - 90))
                        
                    }
                }
                .padding(5)
                .opacity(0.5)
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
