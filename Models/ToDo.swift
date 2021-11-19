//
//  ToDoItem.swift
//  ToDo
//
//  Created by Oleksandr Dolomanov on 21.10.2021.
//

import Foundation

struct ToDo: Codable {
    var id: Int?
    var userId: Int
    var title: String
    var date: String
    var category: String?
    var description: String?
    var isCompleted: Bool
}

protocol PropertyReflectable { }

extension PropertyReflectable {
    subscript(key: String) -> Any? {
        let m = Mirror(reflecting: self)
        return m.children.first { $0.label == key }?.value
    }
}

extension ToDo : PropertyReflectable {}

let todosMock: [ToDo] = [ToDo(
    id: 5,
    userId: 1,
    title: "Smazání úkolu",
    date: "2021-11-09T09:40:00.028Z",
    category: "Škola",
    description: "Je možné konzultovat s Ing. Manďákem",
    isCompleted: false
),
ToDo(
    id: 422,
    userId: 1,
    title: "Test",
    date: "2021-11-09T09:40:00.028Z",
    category: "Kategorie",
    description: "Popis",
    isCompleted: false
),
ToDo(
    id: 423,
    userId: 1,
    title: "Test zavření modalu",
    date: "2021-11-09T09:40:00.028Z",
    category: "Testing",
    description: "Je potřeba vyzkoušet, zda se po creatu zavře modal",
    isCompleted: true
)];
