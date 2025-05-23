//
//  APIService.swift
//  EffectiveMobileTestApp
//
//  Created by Дмитрий Макеев on 23.05.2025.
//


import Foundation

class APIService {
    static let shared = APIService()
    
    func fetchTodos(completion: @escaping ([Task]) -> Void) {
        DispatchQueue.global(qos: .background).async {
            guard let url = URL(string: "https://dummyjson.com/todos") else { return }
            URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data, error == nil else { return }
                do {
                    let response = try JSONDecoder().decode(TodoResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(response.todos)
                    }
                } catch {
                    print("Decoding error: \(error)")
                }
            }.resume()
        }
    }
}
