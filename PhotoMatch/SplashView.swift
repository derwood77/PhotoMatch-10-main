//
//  SplashView.swift
//  PhotoMatch
//
//  Created by me developer on 31/08/2025.

//

import SwiftUI

struct FirstView: View {
    var body: some View {
        Text("Preparing to navigate...")
            .font(.title)
    }
}

struct SecondView: View {
    var body: some View {
        Text("Welcome to the Second View!")
            .font(.title)
    }
}

struct SplashView: View {
    @State private var timerDidFinish = false
    
    var body: some View {
        if timerDidFinish {
            Text("Second View")
            StartView()
        } else {
            
            ZStack {
                Color.green
                
                Image("twocamerasmod")
                
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(20)
                    .frame(width: 300, height: 300)
                
                Text("PhotoMatch")
                
            }
            .ignoresSafeArea(edges: .all)
            
            
            .onAppear { // ✅ .onAppear is applied directly to the First View
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.timerDidFinish = true
                }
            }
        }
    }
}


#Preview {
    SplashView()
}
