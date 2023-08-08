//
//  TaskServiceProtocol.swift
//  ToDoApp
//
//  Created by Людмила Долонтаева on 2023-08-05.
//

import Foundation

protocol TaskServiceProtocol {
    var tasks: [TaskModel] { get }
//    func updateTask(at index: Int, with task: TaskModel)
    func loadTasks()
    func addTask(name: String)
    func toggleTaskCompletion(at index: Int)
    func deleteTask(at index: Int)
}
