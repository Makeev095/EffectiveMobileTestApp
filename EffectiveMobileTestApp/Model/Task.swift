//
//  Task.swift
//  EffectiveMobileTestApp
//
//  Created by Дмитрий Макеев on 23.05.2025.
//


import Foundation

struct Task: Codable {
    let id: Int
    var title: String
    var description: String
    let dateCreated: Date
    var isCompleted: Bool
}
