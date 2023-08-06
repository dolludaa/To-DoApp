//
//  TaskManagerService .swift
//  ToDoApp
//
//  Created by Людмила Долонтаева on 2023-08-04.
//

import Foundation

enum TaskServiceError: Error {
    case invalidIndex
}

// MARK: - Task Service

class TaskService {

    // MARK: - Properties

    private let userDefaults = UserDefaults.standard

    private let tasksKey = "tasks"

    private let defaultTasks = [
        TaskModel(name: "Выгулять собаку", isCompleted: false),
        TaskModel(name: "Купить творог", isCompleted: true),
        TaskModel(name: "Забрать посылку с почты", isCompleted: false)
    ]

    private(set) var tasks: [TaskModel] = []

    // MARK: - Public

    func updateTask(at index: Int, with task: TaskModel) throws {
            guard tasks.indices.contains(index) else {
                throw TaskServiceError.invalidIndex
            }
            tasks[index] = task
        try saveTasks()
        }

    func loadTasks() {
        do {
            tasks = try fetchTasks()
        } catch {
            print(error)
        }
    }

    func addTask(name: String) throws {
        let newTask = TaskModel(name: name, isCompleted: false)
        tasks.append(newTask)
        try saveTasks()
    }

    func completeTask(at index: Int) throws {
        guard tasks.indices.contains(index) else {
            throw TaskServiceError.invalidIndex
        }
        tasks[index].isCompleted.toggle()
        try saveTasks()
    }

    func deleteTask(at index: Int) throws {
        guard tasks.indices.contains(index)
        else { throw TaskServiceError.invalidIndex }

        tasks.remove(at: index)
        try saveTasks()
    }

    // MARK: - Private

    private func fetchTasks() throws -> [TaskModel] {
        guard let data = userDefaults.data(forKey: tasksKey)
        else { return defaultTasks }

        return try JSONDecoder().decode([TaskModel].self, from: data)
    }

    private func saveTasks() throws {
        let data = try JSONEncoder().encode(tasks)
        userDefaults.set(data, forKey: tasksKey)
        userDefaults.synchronize()
    }

}
