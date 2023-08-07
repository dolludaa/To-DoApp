//
//  ToDoListViewControllerAssembly.swift
//  ToDoApp
//
//  Created by Людмила Долонтаева on 2023-08-05.
//

import Foundation
import UIKit

struct ToDoListViewControllerAssembly {
    func create() -> UIViewController {
        let toDoView = ToDoView()
        let taskService = TaskService()

        let controller = ToDoListViewController(taskService: taskService, toDoView: toDoView)

        toDoView.delegate = controller

        return controller
    }
}
