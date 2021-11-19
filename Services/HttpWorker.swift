//
//  HTTPWorker.swift
//  ToDo
//
//  Created by Oleksandr Dolomanov on 15.11.2021.
//

import Foundation

class HttpWorker {
    static let shared = HttpWorker()
    
    func getToDos(completion: @escaping (Result<[ToDo], ErrorMessage>) -> Void) {
        let todosRequest = EndpointCases.getToDos.request
        request(request: todosRequest) { result in
            switch result {
            case .success(let data):
                if let data = data, let todos = try? JSONDecoder().decode([ToDo].self, from: data) {
                    completion(.success(todos))
                } else {
                    completion(.failure(.invalidDataFormat))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func addToDo(todo: ToDo, completion: @escaping (Result<ToDo, ErrorMessage>) -> Void) {
        let todosRequest = EndpointCases.addToDo(todo: todo).request
        request(request: todosRequest) { result in
            switch result {
            case .success(let data):
                if let data = data, let newToDo = try? JSONDecoder().decode(ToDo.self, from: data) {
                    completion(.success(newToDo))
                } else {
                    completion(.failure(.invalidDataFormat))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func deleteToDo(id: Int, completion: @escaping (Result<Any, ErrorMessage>) -> Void) {
        let todosRequest = EndpointCases.deleteToDo(id: id).request
        request(request: todosRequest) { result in
            switch result {
            case .success(_):
                completion(.success(""))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func request(request: URLRequest, completion: @escaping (Result<Data?, ErrorMessage>) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let _ = error {
                completion(.failure(.invalidData))
                return
            }
            
            guard let _ = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            completion(.success(data))
        }
        
        task.resume()
    }
}
