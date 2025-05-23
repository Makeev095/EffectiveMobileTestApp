//
//  Task.swift
//  EffectiveMobileTestApp
//
//  Created by Дмитрий Макеев on 23.05.2025.
//


import Foundation

struct Task: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}

