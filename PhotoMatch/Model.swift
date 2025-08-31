
//
//  Model.swift
// Photomatch
//
//  Created by me developer on 30/06/2025.

// test from me
//

import SwiftUI

@Observable

class Model {
    
    var playerNameRecovered: String = ""  // Keep this in model to make copying around easier
    
    var recordString: String = "" // Converts imagg count, bestTime into string for display
    
    var bestTimesModded = [String](repeating: "No Record Set Yet", count: 15)
    
    var averageMatchTime: Double = 0.0  // Calculated bestTimes from totalTime/number of photos
    
    var thisPhotoCount: Double = 0.0 // number of photos selected
    
    var myImages: [UIImage] = []    //  Array to hold images converted from SwiftData imagedata
    var faceUpCount: Int  // Track how many builtphotos are face up
    var tempIndicies: [Int] // Psrt of tapped response logic - tempindeces used to capture
    var matchCount: Int = 0 // Keep count of how many matched while on-screen
    var gameOver: Bool = true
    var imageCount = 1
    var timeElapsed = 0.0
    
    struct BuiltPhoto: Identifiable, Hashable {
        
        var id: UUID = UUID()
        var image: UIImage
        var faceUp: Bool = false
        var matched: Bool = false
        var blankColor = Color.green
        
    }
    
    var builtphotos: [BuiltPhoto] = []
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init() {  // Always adds one pair because zero ia a valid number !
        
        bestTimesModded = [String](repeating: "No Record Set Yet", count: 15) // Can do 'repeating' here but compiler whinges
        
        faceUpCount = 0
        tempIndicies = []
        matchCount = 0
        gameOver = false
        imageCount = 1
        
    }
    
    
    func initbuiltphotos(savedImages: [SavedImage]) -> [BuiltPhoto]{
        
        myImages.removeAll()
      
        for i in 0..<savedImages.count {
            
            let myImageTempImageData = savedImages[i].imageData
            
            if let uiImage = UIImage(data: myImageTempImageData) {
                
                myImages.append(uiImage)
                
            }
            
        }
        
        builtphotos.removeAll()     // Need this so don't get duplicates when calling this function
        
        // DUPLICATING CODE HERE LOOKS NAFF BUT IS SIMPLEST METHOG TO GET PAIRS
        
        builtphotos.append(contentsOf: myImages.map(\.self).indices.map(\.self).map { BuiltPhoto(id: UUID(),image: myImages[$0], faceUp: false, matched: false,blankColor: .green) })
        
        
        builtphotos.append(contentsOf: myImages.map(\.self).indices.map(\.self).map { BuiltPhoto(id: UUID(),image: myImages[$0], faceUp: false, matched: false,blankColor: .green) })
        
        faceUpCount = 0
        tempIndicies = []
        matchCount = 0
        gameOver = false
        
        builtphotos.shuffle()   // shuffle builtphotos here
        
        return builtphotos
    }
    
    func tappedResponse(index: Int) {
        
        if builtphotos[index].faceUp || builtphotos[index].matched { return }  // Ignore if already faceUp or matched (prevent double click on same Image)
        
        builtphotos[index].faceUp = true
        faceUpCount += 1
        
        tempIndicies.append(index)
        
        //  MATCH LOGIC ...............................................................
        
        if faceUpCount == 2 {
            
            // IF TWO builtphotos FACEUP AND MATCH ...
            if builtphotos[tempIndicies[0]].image == builtphotos[tempIndicies[1]].image {  // NOTE TEMPINDICES
                
                matchCount += 1 // Keep count of how many matches on-screen
                
                builtphotos[tempIndicies[0]].matched = true  // flag matched
                builtphotos[tempIndicies[1]].matched = true
                builtphotos[tempIndicies[0]].blankColor = .white // make invisible but keep space
                builtphotos[tempIndicies[1]].blankColor = .white
                
                if matchCount == myImages.count {  // if all builtphotos in this session match ...
                    
                    let delay = 1.5 // Set delay for display of geme over
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [self] in
                        
                        self.gameOver = true  // flag 'Game Over'
                        
                        thisPhotoCount = Double(myImages.count) // Get how many photos
                        
                        averageMatchTime = (timeElapsed / thisPhotoCount) // Calculate average time to match
                    }
                }
                
            }
            
        }
        
        if faceUpCount > 2 {  // if no match and faceup count coming up to third one about to become face up ...
            
            
            // TURN UN-MATCHED PAIR TO FACE DOWN
            
            builtphotos[tempIndicies[0]].faceUp = false
            builtphotos[tempIndicies[1]].faceUp = false
            
            faceUpCount = 1 // third faceup BuiltPhoto is now first faceup BuiltPhoto
            
            tempIndicies.removeAll() // clear original tempindeces
            
            tempIndicies.append(index) // capture index of 'third' BuiltPhoto
            
        }
        
    }
    
    
    
    
    
}
