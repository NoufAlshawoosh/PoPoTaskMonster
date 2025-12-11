//
//  ReviewTaskScreen.swift
//  PoPoTaskMonster
//
//  Created by Nouf Alshawoosh on 11/12/2025.
//

import SwiftUI

struct ReviewTaskScreen: View {
    @ObservedObject var viewModel: TaskVM
    @Environment(\.dismiss) var dismiss
    
    @State private var taskTitle: String
    @State private var subtasks: [String]
    @State private var showingAddSubtask = false
    @State private var newSubtaskText = ""
    
    let originalDescription: String
    
    init(viewModel: TaskVM, taskTitle: String, subtasks: [SubTaskModel], originalDescription: String) {
        self.viewModel = viewModel
        self._taskTitle = State(initialValue: taskTitle)
        self._subtasks = State(initialValue: subtasks.map { $0.subTaskDescription })
        self.originalDescription = originalDescription
    }
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    
                    // Header
                    Text("Review Your Task")
                        .font(.custom("krungthep", size: 34))
                        .foregroundStyle(.text)
                        .padding(.top, 20)
                    
                    Text("Edit if needed ☺️")
                        .font(.custom("krungthep", size: 18))
                        .foregroundStyle(.text.opacity(0.7))
                    
                    Spacer().frame(height: 20)
                    
                    // Task Title
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Task Title")
                            .font(.custom("krungthep", size: 20))
                            .foregroundStyle(.text)
                        
                        TextField("Task title", text: $taskTitle)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(20)
                    }
                    .padding(.horizontal)
                    
                    // Subtasks
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Subtasks")
                                .font(.custom("krungthep", size: 20))
                                .foregroundStyle(.text)
                            
                            Spacer()
                            
                            Button {
                                showingAddSubtask = true
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.button)
                            }
                        }
                        
                        ForEach(subtasks.indices, id: \.self) { index in
                            HStack(spacing: 12) {
                                TextEditor(text: $subtasks[index])
                                    .frame(minHeight: 80)
                                    .padding(8)
                                    .background(Color.white)
                                    .cornerRadius(20)
                                
                                Button {
                                    subtasks.remove(at: index)
                                } label: {
                                    Image(systemName: "trash.circle.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer().frame(height: 30)
                    
                    // Buttons
                    HStack(spacing: 20) {
                        Button {
                            dismiss()
                        } label: {
                            Text("Cancel")
                                .font(.custom("krungthep", size: 20))
                                .foregroundColor(.text)
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
                                .background(Color.white)
                                .cornerRadius(30)
                        }
                        
                        Button {
                            saveTask()
                        } label: {
                            Text("Save Task")
                                .font(.custom("krungthep", size: 20))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
                                .background(Color.button)
                                .cornerRadius(30)
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer().frame(height: 40)
                }
            }
            
            // Add Subtask Popup
            if showingAddSubtask {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showingAddSubtask = false
                        newSubtaskText = ""
                    }
                
                VStack(spacing: 20) {
                    Text("Add Subtask")
                        .font(.custom("krungthep", size: 24))
                        .foregroundStyle(.text)
                    
                    TextField("Enter subtask", text: $newSubtaskText)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                    
                    HStack(spacing: 15) {
                        Button {
                            showingAddSubtask = false
                            newSubtaskText = ""
                        } label: {
                            Text("Cancel")
                                .font(.custom("krungthep", size: 18))
                                .foregroundColor(.text)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.white)
                                .cornerRadius(25)
                        }
                        
                        Button {
                            if !newSubtaskText.isEmpty {
                                subtasks.append(newSubtaskText)
                                newSubtaskText = ""
                                showingAddSubtask = false
                            }
                        } label: {
                            Text("Add")
                                .font(.custom("krungthep", size: 18))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color.button)
                                .cornerRadius(25)
                        }
                    }
                }
                .padding(30)
                .background(Color("BackgroundColor"))
                .cornerRadius(25)
                .shadow(radius: 20)
                .padding(.horizontal, 40)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func saveTask() {
        guard !taskTitle.isEmpty && !subtasks.isEmpty else { return }
        
        let subtaskModels = subtasks.map { SubTaskModel(subTaskDescription: $0, isSubTaskCompleted: false) }
        
        let task = TaskModel(
            taskTitle: taskTitle,
            taskDescription: originalDescription,
            tasksList: subtaskModels,
            isTaskCompleted: false
        )
        
        viewModel.tasksList.append(task)
        dismiss()
    }
}

#Preview {
    ReviewTaskScreen(
        viewModel: TaskVM(),
        taskTitle: "Study for Exam",
        subtasks: [
            SubTaskModel(subTaskDescription: "Review notes", isSubTaskCompleted: false),
            SubTaskModel(subTaskDescription: "Practice problems", isSubTaskCompleted: false)
        ],
        originalDescription: "I need to study for my math exam"
    )
}
