//
//  SplashView.swift
//  PoPoTaskMonsterApp
//
//  Created by Fahdah Alsamari on 13/06/1447 AH.
//

import SwiftUI

struct SplashView: View {
    
    @StateObject private var splashVM = SplashViewModel()
    @StateObject private var taskVM = TaskVM()
    @State private var nextScreen = false
    
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                Color(red: 242/255, green: 248/255, blue: 233/255)
                    .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    
                    VStack(spacing: 16) {
                        Text("Beat Your Monster")
                            .font(.custom("krungthep", size: 34))
                            .foregroundColor(Color.text)
                            .padding(.top, 80)
                        
                        Text("Ready to take it down?")
                            .font(.custom("krungthep", size: 20))
                            .foregroundColor(.text.opacity(0.8))
                    }
                    .opacity(splashVM.showTexts ? 1 : 0)
                    .animation(.easeIn(duration: 0.4), value: splashVM.showTexts)
                    
                    Image(splashVM.currentCharacterImageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 280)
                        .opacity(splashVM.showCharacter ? 1 : 0)
                        .offset(y: splashVM.showCharacter ? 0 : 220)
                        .animation(.easeOut(duration: 0.45), value: splashVM.showCharacter)
                        .padding(.top, 110)
                    Spacer()
                    
                    if splashVM.showButton {
                        Button {
                            nextScreen = true
                            splashVM.navigate = true
                        } label: {
                            Text("I'm ready")
                                .font(.custom("krungthep", size: 24))
                                .foregroundColor(.white)
                                .frame(maxWidth: 319, maxHeight: 64)
                                .background(Capsule().fill(Color.button))
                        }
                        .frame(maxWidth: 319, maxHeight: 64)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 80)
                        
                    }
                }
            }
            .onAppear {
                splashVM.startAnimations(reduceMotion: reduceMotion)
            }
            .navigationDestination(isPresented: $nextScreen) {
                TaskListScreen(viewModel: taskVM).navigationBarBackButtonHidden(true)
            }
        }
    }
}

#Preview {
    SplashView()
}
