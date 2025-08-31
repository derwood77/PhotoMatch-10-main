//
//  PhotoBuilderView.swift
//  PhotoMatch
//
//  Created by me developer on 03/08/2025.
//

import SwiftUI

struct PhotoBuilderView: View {

    @Environment(Model.self) var model
    
    var image: UIImage
    var id: UUID
    var faceUp: Bool
    var blankColor: Color
    var matched: Bool
    
    
    @State private var isImageVisible = true
    
    var body: some View {
        
        ZStack {
        
            Image(uiImage: image)  // Show the chosen image and animate if two get matched
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
            // .border(.black)
                .rotationEffect(.degrees(matched ? 360 : 0))
                .animation(.spin1(duration: 1), value: matched) // Spin if matched
            
            Text("❌") // Put X cancel sign over the images when spin finished
                .font(.system(size: 60, weight: .bold, design: .default))
                .opacity(matched ? 1 : 0)
                .animation(.easeOut(duration: 3), value: matched)
            
            Rectangle()
                .fill(blankColor)
                .opacity(faceUp ? 0 : 1)  // Turn BuiltPhoto (image) over / back
            
        }
        .cornerRadius(10)
        .onTapGesture {  // When tapped, get the index of the tapped BuiltPhoto
            
            let  index = model.builtphotos.firstIndex(where: { $0.id == id }) ?? 0
            
            model.tappedResponse(index: index) // pass index back and trigger tap response
            
        }
        
    }
}




