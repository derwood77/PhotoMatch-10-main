//
//  GameView.swift
//  PhotoMatch
//
//  Created by me developer on 03/08/2025.
//


import SwiftUI
import SwiftData

struct GameView: View {
    
    @Environment(Model.self) var model
    
    @Binding  var savedImages: [SavedImage]
    
    let animationAmount: CGFloat = 1.5
    
    var body: some View {
        
        VStack {
            
            //  DISPLAY builtphotos (PHOTOS)
            ScrollView {
                
                LazyVGrid(columns: [GridItem(.adaptive(minimum:80))]) {
                    
                    ForEach(0..<model.builtphotos.count, id: \.self) { index in
                        
                        PhotoBuilderView(
                            image: model.builtphotos[index].image,
                            id: model.builtphotos[index].id,
                            faceUp: model.builtphotos[index].faceUp,
                            blankColor: model.builtphotos[index].blankColor,
                            matched: model.builtphotos[index].matched)
                    }
                }
            }
            
            
            // SHOW TIME TICKING UP IN DISPLAY CIRCLE
            Text("\(model.timeElapsed,specifier: "%.2f")")
                .font(.system(size: 20, weight: .bold, design: .default))
                .foregroundStyle(.black)
                .padding(10)
                .overlay(
                    Circle()
                        .stroke(.red,lineWidth: 3)
                        .scaleEffect(animationAmount)
                        .animation(
                            .easeOut(duration: 1)
                            .repeatForever(autoreverses: false),
                            value: model.timeElapsed
                        )
                )
                .foregroundStyle(.red)
            
            
            // FLAG 'GAME OVER' IF model.gameover flag set
            Text("GAME OVER")
                .font(.system(size: 30, weight: .bold, design: .default))
                .foregroundStyle(.red)
                .opacity(model.gameOver ? 1 : 0)
                .padding()
        }
        
        .onAppear {
            
            //  RESET STUFF AS NEEDED
            model.timeElapsed = 0
            
            model.gameOver = false
            
            model.builtphotos =  model.initbuiltphotos(savedImages: savedImages)
            
        }
        
        
    }
}


