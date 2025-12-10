//
//  TaskModel.swift
//  PoPoTaskMonster
//
//  Created by Nouf Alshawoosh on 02/12/2025.
//
import SwiftUI

struct TaskModel : Identifiable, Codable {
    let id = UUID()
    let taskTitle : String
    let taskDescription : String
    var tasksList : [SubTaskModel]
    var isTaskCompleted : Bool
    
    
}

struct SubTaskModel : Identifiable, Codable {
    let id = UUID()
    let subTaskDescription : String
    var isSubTaskCompleted : Bool
}
