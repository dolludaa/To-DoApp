//
//  TaskManagerService .swift
//  ToDoApp
//
//  Created by Людмила Долонтаева on 2023-08-04.
//

import Foundation

final class TaskService: TaskServiceProtocol {

    private let userDefaults = UserDefaults.standard

    private let tasksKey = "tasks"

    private let defaultTasks = [
        TaskModel(name: "Выгулять собаку", isCompleted: false),
        TaskModel(name: "Купить творог", isCompleted: true),
        TaskModel(name: "Забрать посылку с почты", isCompleted: false)
    ]

    private(set) var tasks: [TaskModel] = []

    func loadTasks() {
        tasks = fetchTasks()
    }

    func addTask(name: String) {
        let newTask = TaskModel(name: name, isCompleted: false)
        tasks.append(newTask)
        saveTasks()
    }

    func toggleTaskCompletion(at index: Int) {
        guard tasks.indices.contains(index)
        else { return }
        tasks[index].isCompleted.toggle()
        saveTasks()
    }

    func deleteTask(at index: Int) {
        guard tasks.indices.contains(index)
        else { return }

        tasks.remove(at: index)
        saveTasks()
    }

    private func fetchTasks() -> [TaskModel] {
        guard let data = userDefaults.data(forKey: tasksKey),
              let models = try? JSONDecoder().decode([TaskModel].self, from: data)
        else { return defaultTasks }

        return models
    }

    private func saveTasks() {
        guard let data = try? JSONEncoder().encode(tasks)
        else { return }
        userDefaults.set(data, forKey: tasksKey)
        userDefaults.synchronize()
    }

}
