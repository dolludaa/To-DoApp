//
//  ToDoListViewController.swift
//  ToDoApp
//
//  Created by Людмила Долонтаева on 2023-08-04.
//

import UIKit

class ToDoListViewController: UIViewController {

    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let stackView = UIStackView()
    private let tableView = UITableView()
    private let addButton = UIButton()

    private let taskService = TaskService()

    private var addButtonBottomConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        setUpStyle()
        setUpStack()
        loadData()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }


    private func setUpLayout() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(tableView)
        view.addSubview(addButton)

        addButtonBottomConstraint = addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: addButton.topAnchor),

            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addButtonBottomConstraint,
            addButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func setUpStyle() {

        view.backgroundColor = AppColorEnum.backgroundColor.color

        titleLabel.text = "Today's Task"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textAlignment = .center

        dateLabel.text = DateFormatter.defaultDateFormatter.string(from: Date())
        dateLabel.font = UIFont.systemFont(ofSize: 14)
        dateLabel.textAlignment = .center

        tableView.rowHeight = 50
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TaskCell.self, forCellReuseIdentifier: TaskCell.reuseIdentifier)
        tableView.backgroundColor = AppColorEnum.backgroundColor.color

        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        addButton.setTitle("Добавить навык", for: .normal)
        addButton.backgroundColor = AppColorEnum.primaryColor.color
        addButton.layer.cornerRadius = 20
    }

    private func setUpStack() {
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(dateLabel)
        stackView.axis = .vertical
        stackView.spacing = 5

        navigationItem.titleView = stackView
    }

    private func loadData() {
        taskService.loadTasks()
        tableView.reloadData()
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

        do {
            let path = IndexPath(row: taskService.tasks.count, section: 0)
            try taskService.addTask(name: name)
            tableView.insertRows(at: [path], with: .middle)
        } catch {
            print(error)
        }
    }

    @objc private func addButtonTapped() {
        showAddTaskAlert()
    }

    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            addButtonBottomConstraint.constant = -keyboardSize.height
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        addButtonBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }

}

extension ToDoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskService.tasks.count
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        let verticalPadding: CGFloat = 8
        let horizontalPadding: CGFloat = 16

        let maskLayer = CALayer()
        maskLayer.cornerRadius = 10
        maskLayer.backgroundColor = UIColor.black.cgColor

        let xInset = horizontalPadding / 2
        let rect = CGRect(
            x: cell.bounds.origin.x + xInset,
            y: cell.bounds.origin.y,
            width: cell.bounds.width - horizontalPadding,
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

        var task = taskService.tasks[indexPath.row]
        cell.configure(with: task)
        cell.onCompletedButtonTapped = { isCompleted in
            task.isCompleted = isCompleted
            do {
                try self.taskService.updateTask(at: indexPath.row, with: task)
            } catch {
                print(error)
            }
        }

        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete
        else { return }

        do {
            try taskService.deleteTask(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } catch {
            print(error)
        }

        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do {
            try taskService.completeTask(at: indexPath.row)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } catch {
            print(error)
        }
    }

    
}


enum AppColorEnum {
    case backgroundColor
    case primaryColor

    var color: UIColor {
        switch self {
        case .backgroundColor:
            return UIColor(hex: 0xEEEEEE)
        case .primaryColor:
            return UIColor(hex: 0x58808F)
        }
    }
}
