//
//  TaskServiceProtocol.swift
//  ToDoApp
//
//  Created by Людмила Долонтаева on 2023-08-05.
//

import Foundation

protocol TaskServiceProtocol {
    func updateTask(at index: Int, with task: TaskModel)
    func loadTasks()
    func addTask(name: String)
    func completeTask(at index: Int)
    func deleteTask(at index: Int)
}
