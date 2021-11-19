//
//  Endpoint.swift
//  ToDo
//
//  Created by Oleksandr Dolomanov on 15.11.2021.
//

import Foundation

enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case PATCH
    case DELETE
}

protocol Endpoint {
    var httpMethod: HTTPMethod { get }
    var baseURLString: URL { get }
    var path: String { get }
    var headers: [String: String]? { get }
    var body: [String: Any]? { get }
}
