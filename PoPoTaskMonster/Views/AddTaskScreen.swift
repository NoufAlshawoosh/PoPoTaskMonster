//
//  AddTaskScreen.swift
//  PoPoTaskMonster
//
//  Created by Nouf Alshawoosh on 02/12/2025.
//

import SwiftUI

struct AddTaskScreen : View {
    @ObservedObject var viewModel: TaskVM
    @State private var description: String = ""
    @State private var nextScreen = false
    @FocusState private var isFocused : Bool
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            
            Color("BackgroundColor")
                .ignoresSafeArea()
                .onTapGesture {
                    isFocused = false
                }
            
            ScrollView {
                VStack {
                    
                    Text("Add Task")
                        .font(.custom("krungthep", size: 40))
                        .foregroundStyle(.text)
                        .frame(width: 190, height: 45)
                    
                    Spacer().frame(height: 40)
                    
                    Text("What is on your mind 🧠 ?")
                        .font(.custom("krungthep", size: 18))
                        .foregroundStyle(.text)
                    
                    Spacer().frame(height: 10)
                    
                    
                    ZStack {
                        
                        RoundedRectangle(cornerRadius: 59)
                            .foregroundStyle(.white)
                            .frame(width: 343, height: 400)
                        
                        
                        
                        // text field
                        TextEditor(text: $description)
                            .padding()
                            .frame(width: 340, height: 400)
                            .overlay(RoundedRectangle(cornerRadius: 59).stroke(Color.text))
                            .focused($isFocused)
                        
                        
                        
                        
                    } // end of ZStack
                    
                    Spacer().frame(height: 60)
                    
                    // button
                    
                    Button(action: {
                        if !description.isEmpty {
                            viewModel.generateTask(from: description)
                            description = ""
                            dismiss()
                        }
                    }, label: { Text("Start")
                            .font(.custom("krungthep", size: 36))
                        .frame(width: 300, height: 64) }).buttonStyle(.glassProminent)
                        .buttonBorderShape(.roundedRectangle(radius: 32))
                        .tint(.button)
                    
                    Spacer().frame(height: 40)
                    
                } // end of VStack
                
            }.padding(.all) // end of ScrollView
            
            
        }
        .ignoresSafeArea(.keyboard)
        .navigationBarBackButtonHidden(false)
        .navigationDestination(isPresented: $viewModel.shouldShowRewriteScreen) {
            ContentView(viewModel: viewModel)
        }
    }
}

#Preview {
    AddTaskScreen(viewModel: TaskVM())
}
