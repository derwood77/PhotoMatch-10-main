//
//  CongratsView.swift
//  PhotoMatch
//
//  Created by me developer on 03/08/2025.
//

import SwiftUI
import AVFAudio

// FLAG THAT THIS TIME IS A RECORD ... AND DISPLAY STATS AND SMILEYFACE

struct CongratsView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Environment(Model.self) var model
    
    @Binding var playerName: String
    
    @AppStorage("bestTimesModdedCopy") var  bestTimesModdedCopy: [String] = []  // Don't need @Binding in another view - just do same as this
    
    
    @State var myPhotoText = "Photos"  // Temp text to manage single / plural
    
    @State private var scale = 1.0
    
    @State private var audioPlayer: AVAudioPlayer!
    
    var body: some View {
        
        VStack {
            
           // let _ = print("time \(model.timeElapsed)")
            
            Text("😁")
                .font(.system(size: 80))
                .scaleEffect(scale)
                .animation(.linear(duration: 1), value: model.timeElapsed)
            
            VStack(spacing: 20) {
                Text("👍 FASTEST EVER  FOR \(model.thisPhotoCount, specifier: "%.0f") \(myPhotoText)")
                
                Text("\(Int(model.thisPhotoCount)) photo matches in \(model.averageMatchTime, specifier: "%.2f") seconds")
                Text("Player is \(playerName)")
            }
            .font(.system(size: 15))
            .bold()
            
            Button("Press to dismiss") {
                dismiss()
            }
            .buttonStyle(.borderedProminent)
            .font(.title2)
            .tint(.blue)
            
        }
        .onAppear{
            
            
            var fastestTime = model.averageMatchTime
            
            fastestTime = round(fastestTime * 100) / 100.0 // limit to two decimal places
            
            myPhotoText = "Photos"
            
            if model.thisPhotoCount == 1  {  // single / plural logic
                myPhotoText = "Photo"
            }
            
            //  BUILD RECORD STRING ...
            let tempIndex = Int(model.thisPhotoCount )
            
            let tempString: String = String(fastestTime)
            
            model.recordString = "\(model.thisPhotoCount) \(myPhotoText) , \(tempString) seconds: \(playerName)"
            
            if !model.bestTimesModded.isEmpty{ // make sure already filled with default or modded record strings
                
                model.bestTimesModded[tempIndex-1] = model.recordString // update this specific bestTime record
            }
            
            // bestTimesModdedCopy is @AppStorage .....   model.bestTimesModded is string array for display
            bestTimesModdedCopy = model.bestTimesModded
            
            animateText()
            
            playSound()
            
            
            
        }
        
    }
    
    func playSound() {
        
        let soundName = "sound4"
        
        guard let soundFile = NSDataAsset(name: soundName)else {
            return print("file not found")
        }
        
        do {
            audioPlayer = try AVAudioPlayer(data: soundFile.data)
            audioPlayer.play()
            
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func animateText() {
        Task {
            for _ in 0..<5{
                // Fade out
                withAnimation(.easeInOut(duration: 0.3)) {
                    scale = 0
                }
                try await Task.sleep(nanoseconds: 250_000_000) //
                
                // Fade in
                withAnimation(.easeInOut(duration: 0.3)) {
                    scale = 1
                }
                try await Task.sleep(nanoseconds: 250_000_000) //
            }
        }
    }
}


//#Preview {
//    SheetView()
//}
