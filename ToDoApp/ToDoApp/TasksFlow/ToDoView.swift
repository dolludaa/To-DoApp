//
//  ToDoView.swift
//  ToDoApp
//
//  Created by Людмила Долонтаева on 2023-08-05.
//

import Foundation
import UIKit

final class ToDoView: UIView {

    weak var delegate: ToDoListViewControllerDeleagte?

    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let stackView = UIStackView()
    private let tableView = UITableView()
    private let addButton = UIButton()

    private var addButtonBottomConstraint: NSLayoutConstraint!

    private func setUpLayout() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false

        addSubview(tableView)
        addSubview(addButton)

        addButtonBottomConstraint = addButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: addButton.topAnchor),

            addButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            addButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            addButtonBottomConstraint,
            addButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func setUpStyle() {

        backgroundColor = AppColorEnum.backgroundColor.color

        titleLabel.text = "Today's Task"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textAlignment = .center

        dateLabel.text = DateFormatter.defaultDateFormatter.string(from: Date())
        dateLabel.font = UIFont.systemFont(ofSize: 14)
        dateLabel.textAlignment = .center

        tableView.rowHeight = 50
        tableView.dataSource = delegate
        tableView.delegate = delegate
        tableView.register(TaskCell.self, forCellReuseIdentifier: TaskCell.reuseIdentifier)
        tableView.backgroundColor = AppColorEnum.backgroundColor.color

        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        addButton.setTitle("Добавить навык", for: .normal)
        addButton.backgroundColor = AppColorEnum.primaryColor.color
        addButton.layer.cornerRadius = 10
    }

    private func setUpStack() {
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(dateLabel)
        stackView.axis = .vertical
        stackView.spacing = 5

        delegate?.titleView = stackView
    }

    @objc private func addButtonTapped() {
        delegate?.addButtonDidTap()
    }
}

extension ToDoView: ToDoViewProtocol {
    func didLoad() {
        setUpStack()
        setUpStyle()
        setUpLayout()
    }


    func keyboardWillHide(notification: NSNotification) {
        addButtonBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
    }

    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            addButtonBottomConstraint.constant = -keyboardSize.height
            UIView.animate(withDuration: 0.5) {
                self.layoutIfNeeded()
            }
        }
    }

    func insertRows(path: IndexPath, animation: UITableView.RowAnimation) {
        tableView.insertRows(at: [path], with: animation)
    }

    func reloadTable() {
        tableView.reloadData()
    }
}
