//
//  OpenAIResponseModel.swift
//  PoPoTaskMonster
//
//  Created by Nouf Alshawoosh on 07/12/2025.
//
import SwiftUI

struct OpenAIResponseModel: Identifiable {
    var id = UUID()
    var message: String
    var isUser: Bool
}
