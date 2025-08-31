//
//  RecordsView.swift
//  PhotoMatch
//
//  Created by me developer on 03/08/2025.
//

import SwiftUI

struct RecordsView: View {
    
        @Environment(Model.self) var model
        
        @State var bestTimes: [Double] // array of record times when they get set
        
        @State var bestTimesModded: [String] = [] // Stringified version of bestTimes for display
        
        @Binding var playerName: String // Player name
        
        @AppStorage("bestTimesModdedCopy") var  bestTimesModdedCopy: [String] = [] // Don't need @Binding in any other view - just repeat this
        
        var body: some View {
            
            VStack {
                // model.bestTimesModded is the Stringified version for display
                List {
                    
                    ForEach(model.bestTimesModded, id: \ .self) { index in
                        
                        Text("\(index,)")
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                }
                
            }
            
            .onAppear {
                
                bestTimesModded = bestTimesModdedCopy  // Get the stringified stuff from Appstorage and copy for display
                
            }
        }
        
        
    }





