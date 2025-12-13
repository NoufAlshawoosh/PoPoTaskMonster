////
////  Untitled.swift
////  PoPoTaskMonsterApp
////
////  Created by  Rayyanah Bu tuwaybah on 12/06/1447 AH.
////

import SwiftUI

struct TaskListScreen: View {
    @ObservedObject var viewModel: TaskVM
    @Environment(\.dismiss) var dismiss
    @State private var goToFinishedScreen = false
    @State private var goToAddTaskScreen = false

    var body: some View {
        ZStack {
            Color(red: 242/255, green: 248/255, blue: 233/255)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("Task List")
                    .font(.custom("krungthep", size: 38))
                    .foregroundColor(Color(red: 0/255, green: 63/255, blue: 103/255))
                    .padding(.top, 35)

                // Progress Circle
                ZStack {
                    Circle()
                        .stroke(.gray.opacity(0.3), lineWidth: 12)
                        .frame(width: 150, height: 150)

                    Circle()
                        .trim(from: 0, to: viewModel.progress)
                        .stroke(Color.button, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .frame(width: 150, height: 150)

                    Text("\(Int(viewModel.progress * 100))%")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundStyle(.text)
                }

                // Tasks List
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(viewModel.tasksList) { task in
                            TaskCardView(task: task, viewModel: viewModel)
                        }
                    }
                    .padding(.bottom, 30)
                }.frame(maxWidth: .infinity, maxHeight: .infinity)
                
                Spacer().frame(height: 40)
                
                // Hidden NavigationLink for programmatic navigation
                NavigationLink(
                    destination: AddTaskScreen(viewModel: viewModel),
                    isActive: $goToAddTaskScreen
                ) {
                    EmptyView()
                }
                .hidden()
                
                NavigationLink(
                    destination: FinishedTodayView(),
                    isActive: $goToFinishedScreen
                ) {
                    EmptyView()
                }
                .hidden()
            }
            

            // Add Button
            Button(action: {
                goToAddTaskScreen = true
            }) {
                ZStack {
                    Circle()
                        .fill(Color.button)
                        .frame(width: 70, height: 70)

                    Image(systemName: "plus")
                        .font(.system(size: 36).bold())
                        .foregroundColor(.white)
                }
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, 20)

            // Congrats Popup
            if viewModel.showCongrats {
                CongratsPopup(goToFinishedScreen: $goToFinishedScreen, viewModel: viewModel)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

// Task Card
struct TaskCardView: View {
    let task: TaskModel
    @ObservedObject var viewModel: TaskVM
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(task.taskTitle)
                    .font(.system(size: 20, weight: .bold))
                Spacer()
                Button(action: { viewModel.deleteTask(taskID: task.id) }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
            
            ForEach(task.tasksList) { subtask in
                HStack {
                    Button(action: { viewModel.toggleSubtask(task: task, subtask: subtask) }) {
                        Image(systemName: subtask.isSubTaskCompleted ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(subtask.isSubTaskCompleted ? .green : .gray)
                    }
                    Text(subtask.subTaskDescription)
                        .strikethrough(subtask.isSubTaskCompleted)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .padding(.horizontal)
    }
}

// Congrats Popup
struct CongratsPopup: View {
    @Binding var goToFinishedScreen: Bool
    @ObservedObject var viewModel: TaskVM
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3).ignoresSafeArea()
            
            VStack(spacing: 10) {
                HStack {
                    Button {
                        viewModel.showCongrats = false
                        goToFinishedScreen = true
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 22, weight: .bold))
                    }
                    Spacer()
                }
                .padding()
                
                Text("Congratulations!")
                    .font(.system(size: 28, weight: .bold))
                
                Text("You defeated the monster!")
                    .font(.system(size: 20))
                
                Image("sadMonster")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                
                Spacer()
            }
            .frame(width: 260, height: 320)
            .background(Color.white)
            .cornerRadius(30)
            .shadow(radius: 15)
        }
    }
}
#Preview {
    TaskListScreen(viewModel: TaskVM())
}
