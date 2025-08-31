//
//  PlayerNameView.swift
//  PhotoMatch
//
//  Created by me developer on 03/08/2025.
//



import SwiftUI

struct PlayerNameView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Environment(Model.self) var model
    
    @Binding var playerName: String
    
    var body: some View {
        
        VStack(spacing: 20) {
            
            let myText = playerName == "" ? "Not set" : "\(playerName)" // if no userHame, enter it as "Not set"
            
            Text("Current Player ")
                .font(.system(size: 20, weight: .bold, design: .default))
                .foregroundStyle(.green)
                .bold()
            
            +  // Combine Text entries via 'plus' to build up string to display
            
          Text(myText)
                .font(.system(size: 20, weight: .bold, design: .default))
                .foregroundStyle(.red)
                .bold()
         
            Text("Enter your name below")
                .fontWeight(.bold)
            
            TextField("Enter your name", text: $playerName)
                .padding()
                .font(.title3) // Makes the text (and placeholder) larger
                .fontWeight(.bold) // Makes the text (and placeholder) bolder
                .padding()
                .border(Color.gray, width: 1)
            
            
            Button("Press to dismiss") {
                
                model.playerNameRecovered = playerName // Update playerName in Model for copying around app
                
                dismiss()
            }
            .buttonStyle(.borderedProminent)
            .font(.title2)
            .tint(.blue)
            
            
            
        }
        .onAppear {
            
            
        }
        
    }
}

//#Preview {
//    playerNameSheet()
//}
