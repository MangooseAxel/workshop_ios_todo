//
//  ToDoService.swift
//  ToDo
//
//  Created by Oleksandr Dolomanov on 21.10.2021.
//

import Foundation

class toDoService {
    static let shared = toDoService()
    
    func getResults(completed: @escaping (Result<[ToDo], ErrorMessage>) -> Void) {
        guard let url = URL(string: "https://utb-todo-backend.docker.b2a.cz/user/1/todo") else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                completed(.failure(.invalidData))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let result = try decoder.decode([ToDo].self, from: data)
                completed(.success(result))
            } catch {
                print(error)
            }
        }
        
        task.resume()
    }
}
