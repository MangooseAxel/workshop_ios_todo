//
//  EndpointCases.swift
//  ToDo
//
//  Created by Oleksandr Dolomanov on 15.11.2021.
//

import Foundation

enum EndpointCases: Endpoint {

    case getToDos
    case addToDo(todo: ToDo)
    case deleteToDo(id: Int)
    case changeStatus(todo: ToDo)

    var httpMethod: HTTPMethod {
        switch self {
        case .getToDos:
            return HTTPMethod.GET
        case .addToDo:
            return HTTPMethod.POST
        case .deleteToDo:
            return HTTPMethod.DELETE
        case .changeStatus:
            return HTTPMethod.PATCH
        }
    }

    var baseURLString: URL {
        return URL(string: "https://utb-todo-backend.docker.b2a.cz/")!
    }

    var path: String {
        switch self {
        case .getToDos: return "user/1/todo"
        case .addToDo: return "user/1/todo"
        case .deleteToDo(let id): return "user/1/todo/\(id)"
        case .changeStatus(let todo): return "user/1/todo/\(todo.id ?? -1)"
        }
    }

    var headers: [String: String]? {
        return ["Content-Type": "application/json",
                "Accept": "application/json"]
    }

    var body: [String: Any]? {
        switch self {
        case .getToDos: return nil
        case .addToDo(let todo):
            return ["userId": 1,
                    "title": todo.title,
                    "date": todo.date,
                    "category": todo.category ?? "",
                    "description": todo.description ?? "",
                    "isCompleted": false]
        case .deleteToDo: return nil
        case .changeStatus(let todo):
            return ["isCompleted": !todo.isCompleted]
        }
    }

    var request: URLRequest {
        let url = URL(string: path, relativeTo: baseURLString)!
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.httpMethod = httpMethod.rawValue
        if body != nil, let jsonData = try? JSONSerialization.data(withJSONObject: body as Any) {
            request.httpBody = jsonData
        }

        return request
    }
}
