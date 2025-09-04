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
    @State private var animationAmount = 1.0
    
    var body: some View {
        if timerDidFinish {
            
            StartView()
        } else {
            
            ZStack {
                Color.green
                VStack (spacing: 30) {
                    Image("twocameras")
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(20)
                        .frame(width: 200, height: 200)
                        .scaleEffect(animationAmount)
                        .animation(.easeInOut(duration: 1),value: animationAmount)
                    
                    Text("PhotoMatch")
                        .font(.largeTitle)
                }
                
            }
            .ignoresSafeArea(edges: .all)
            
            
            .onAppear { // ✅ .onAppear is applied directly to the First View
                
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    animationAmount = 1.5
                }
                
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
