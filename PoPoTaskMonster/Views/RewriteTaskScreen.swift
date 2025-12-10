//
//  ContentView.swift
//  new project
//
//  Created by Norah Abdulkairm on 09/06/1447 AH.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: TaskVM
    @State private var nextScreen = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            
            Color.background.ignoresSafeArea()
            
            VStack(spacing: 24) {
                Spacer().frame(height: 100)
                
                // العنوان
                Text("I didn't understand your task")
                    .font(.custom("krungthep", size: 26))
                    .foregroundStyle(Color(.text))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                
                Text("Please rewrite it clearly again")
                    .font(.custom("krungthep", size: 18))
                    .foregroundColor(.text)
                    .multilineTextAlignment(.center)
                
                
                Image("NotUnderstoodMonster")
                
                
                Spacer(minLength: 16)
                
                // Bottom button
                Button(action: {
                    nextScreen = true
                }, label: { Text("Rewrite the task")
                        .font(.custom("krungthep", size: 20))
                    .frame(width: 300, height: 64) }).buttonStyle(.glassProminent)
                    .buttonBorderShape(.roundedRectangle(radius: 32))
                    .tint(.button)
                
                Spacer().frame(height: 40)
                
                
            }
            .navigationDestination(isPresented: $nextScreen) {
                AddTaskScreen(viewModel: viewModel)
            }
            
        }
        .navigationBarBackButtonHidden(false)
    }
}

#Preview {
    ContentView(viewModel: TaskVM())
}
