//
//  ToDoDelegate.swift
//  ToDo
//
//  Created by Oleksandr Dolomanov on 18.11.2021.
//

import Foundation

protocol ToDoDelegate: AnyObject {
    func didCreateToDo(_ todo: ToDo)
    func didDeleteToDo(_ todo: ToDo?)
}
