//
//  ErrorMessage.swift
//  ToDo
//
//  Created by Oleksandr Dolomanov on 21.10.2021.
//

import Foundation

enum ErrorMessage: String, Error {
    case invalidData = "Sorry, Something went wrong, try again"
    case invalidResponse = "Server error. Please, try again later"
    case invalidDataFormat = "Data format is incompatible"
}
