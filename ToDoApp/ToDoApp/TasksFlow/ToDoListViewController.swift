//
//  ToDoListViewController.swift
//  ToDoApp
//
//  Created by Людмила Долонтаева on 2023-08-04.
//

import UIKit

final class ToDoListViewController: UIViewController {

    private let taskService: TaskServiceProtocol
    private let toDoView: ToDoViewProtocol

    init(taskService: TaskServiceProtocol, toDoView: ToDoViewProtocol) {
        self.taskService = taskService
        self.toDoView = toDoView
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = toDoView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        loadData()
        toDoView.didLoad()
    }

    private func setUp() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func loadData() {
        taskService.loadTasks()
        toDoView.reloadTable()
    }

    private func showAddTaskAlert() {
        let alertController = UIAlertController(title: "Добавить задачу", message: "Введите название задачи", preferredStyle: .alert)
        alertController.addTextField()

        let saveAction = UIAlertAction(title: "Сохранить", style: .default) { [weak self, alertController] _ in
            self?.addTask(alertController)
        }

        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)

        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)

        present(alertController, animated: true)
    }

    private func addTask(_ alertController: UIAlertController) {
        guard let name = alertController.textFields?.first?.text,
              !name.isEmpty
        else { return }

        let path = IndexPath(row: taskService.tasks.count, section: 0)
        taskService.addTask(name: name)
        toDoView.insertRows(path: path, animation: .middle)
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        toDoView.keyboardWillShow(notification: notification)
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        toDoView.keyboardWillHide(notification: notification)
    }

}

extension ToDoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskService.tasks.count
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        let verticalPadding: CGFloat = 8

        let maskLayer = CALayer()
        maskLayer.cornerRadius = 10
        maskLayer.backgroundColor = UIColor.black.cgColor

        let rect = CGRect(
            x: cell.bounds.origin.x,
            y: cell.bounds.origin.y,
            width: cell.bounds.width ,
            height: cell.bounds.height
        ).insetBy(dx: 0, dy: verticalPadding / 2)

        maskLayer.frame = rect

        cell.layer.mask = maskLayer

    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TaskCell.reuseIdentifier,
            for: indexPath
        ) as? TaskCell else { return UITableViewCell() }

        let task = taskService.tasks[indexPath.row]
        cell.configure(with: task)
        cell.onCompletedButtonTapped = { [weak self, weak tableView] in
            self?.toogleItem(at: indexPath, tableView: tableView)
        }

        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete
        else { return }

        taskService.deleteTask(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        toogleItem(at: indexPath, tableView: tableView)
    }

    private func toogleItem(at indexPath: IndexPath, tableView: UITableView?) {
        taskService.toggleTaskCompletion(at: indexPath.row)
        tableView?.reloadRows(at: [indexPath], with: .automatic)
    }
}

extension ToDoListViewController: ToDoListViewControllerDeleagte {
    var titleView: UIView? {
        get {
            navigationItem.titleView
        }
        set {
            navigationItem.titleView = newValue
        }
    }

    func addButtonDidTap() {
        showAddTaskAlert()
    }
}
