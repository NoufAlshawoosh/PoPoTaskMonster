//
//  TaskVM.swift
//  PoPoTaskMonster
//
//  Created by Nouf Alshawoosh on 02/12/2025.
//

import Foundation
import SwiftUI
import Combine

class TaskVM: ObservableObject {
    @Published var tasksList: [TaskModel] = [] {
        didSet {
            saveTasks()
        }
    }
    @Published var showCongrats = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var shouldShowRewriteScreen = false
    @Published var shouldShowReviewScreen = false
    @Published var shouldDismissToTaskList = false
    @Published var pendingTaskTitle = ""
    @Published var pendingSubtasks: [SubTaskModel] = []
    @Published var pendingDescription = ""
    
    private let apiKey = Secret.apiKey
    private let tasksKey = "savedTasks"
    
    init() {
        loadTasks()
    }
    
    // MARK: - Persistence Methods
    
    private func saveTasks() {
        if let encoded = try? JSONEncoder().encode(tasksList) {
            UserDefaults.standard.set(encoded, forKey: tasksKey)
        }
    }
    
    private func loadTasks() {
        if let savedData = UserDefaults.standard.data(forKey: tasksKey),
           let decoded = try? JSONDecoder().decode([TaskModel].self, from: savedData) {
            tasksList = decoded
        }
    }
    
    func clearAllTasks() {
        tasksList.removeAll()
        UserDefaults.standard.removeObject(forKey: tasksKey)
    }
    
    // MARK: - API Methods
    
    // Generate task from description using direct API call
    func generateTask(from description: String) {
        isLoading = true
        errorMessage = nil
        shouldShowRewriteScreen = false
        shouldShowReviewScreen = false
        
        let prompt = """
            Task: \(description)
            
            Give me a title and subtasks of at most 4 subtasks in very easy way with simple words separated by -.
            Format:
            TITLE: [title here]
            - subtask 1
            - subtask 2
            
            If you don't understand, respond: ERROR
            """
        
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            errorMessage = "Invalid URL"
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                ["role": "user", "content": prompt]
            ],
            "max_tokens": 300
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = "Network error: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    self?.errorMessage = "No data received"
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                        if let choices = json["choices"] as? [[String: Any]],
                           let message = choices.first?["message"] as? [String: Any],
                           let content = message["content"] as? String {
                            
                            if content.contains("ERROR") {
                                self?.shouldShowRewriteScreen = true
                                return
                            }
                            
                            self?.parseAndAddTask(content, description: description)
                        } else {
                            self?.errorMessage = "Invalid response format"
                        }
                    }
                } catch {
                    self?.errorMessage = "Failed to parse response"
                }
            }
        }.resume()
    }
    
    private func parseAndAddTask(_ response: String, description: String) {
        let lines = response.split(separator: "\n")
        var title = "Untitled"
        var subtasks: [SubTaskModel] = []
        
        for line in lines {
            let text = line.trimmingCharacters(in: .whitespaces)
            if text.contains("TITLE:") {
                title = text.replacingOccurrences(of: "TITLE:", with: "").trimmingCharacters(in: .whitespaces)
            } else if text.hasPrefix("-") {
                let subtask = String(text.dropFirst()).trimmingCharacters(in: .whitespaces)
                subtasks.append(SubTaskModel(subTaskDescription: subtask, isSubTaskCompleted: false))
            }
        }
        
        // Store for review screen
        pendingTaskTitle = title
        pendingSubtasks = subtasks
        pendingDescription = description
        shouldShowReviewScreen = true
    }
    
    // MARK: - Task Management Methods
    
    // Toggle subtask completion
    func toggleSubtask(task: TaskModel, subtask: SubTaskModel) {
        guard let taskIndex = tasksList.firstIndex(where: { $0.id == task.id }),
              let subtaskIndex = tasksList[taskIndex].tasksList.firstIndex(where: { $0.id == subtask.id }) else { return }
        
        tasksList[taskIndex].tasksList[subtaskIndex].isSubTaskCompleted.toggle()
        
        let allDone = tasksList[taskIndex].tasksList.allSatisfy { $0.isSubTaskCompleted }
        tasksList[taskIndex].isTaskCompleted = allDone
        
        checkProgress()
    }
    
    // Delete task
    func deleteTask(taskID: UUID) {
        tasksList.removeAll { $0.id == taskID }
        checkProgress()
    }
    
    // Calculate progress
    var progress: Double {
        let total = tasksList.flatMap { $0.tasksList }.count
        guard total > 0 else { return 0 }
        
        let done = tasksList.flatMap { $0.tasksList }.filter { $0.isSubTaskCompleted }.count
        return Double(done) / Double(total)
    }
    
    // Check if all tasks are done
    func checkProgress() {
        if progress == 1.0 && !tasksList.isEmpty {
            showCongrats = true
        }
    }
}
