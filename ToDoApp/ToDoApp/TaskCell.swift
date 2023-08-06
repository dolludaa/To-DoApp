//
//  TaskCell.swift
//  ToDoApp
//
//  Created by Людмила Долонтаева on 2023-08-04.
//

import Foundation
import UIKit

final class TaskCell: UITableViewCell {

    static let reuseIdentifier = String(describing: TaskCell.self)

    var onCompletedButtonTapped: ((Bool) -> Void)?

    private let taskNameLabel = UILabel()
    private let taskCompletedButton = UIButton(type: .custom)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupLayout()
        setupStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    private func setupLayout() {

        taskNameLabel.translatesAutoresizingMaskIntoConstraints = false
        taskCompletedButton.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(taskNameLabel)
        contentView.addSubview(taskCompletedButton)

        NSLayoutConstraint.activate([
            taskNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            taskNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            taskCompletedButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            taskCompletedButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            taskCompletedButton.widthAnchor.constraint(equalToConstant: 50),
            taskCompletedButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func setupStyle() {

        taskNameLabel.font = UIFont.systemFont(ofSize: 16)
        let normalStateImage = UIImage(systemName: "circle")
        let selectedStateImage = UIImage(systemName: "checkmark.circle.fill")

        taskCompletedButton.setImage(normalStateImage, for: .normal)
        taskCompletedButton.setImage(selectedStateImage, for: .selected)
        taskCompletedButton.addTarget(self, action: #selector(completedTapped), for: .touchUpInside)
        taskCompletedButton.tintColor = AppColorEnum.primaryColor.color

    }

    @objc func completedTapped() {
        taskCompletedButton.isSelected.toggle()
        let isCompleted = taskCompletedButton.isSelected
        if isCompleted {
            taskNameLabel.attributedText = NSAttributedString(string: taskNameLabel.text ?? "",
                                                              attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
        } else {
            taskNameLabel.attributedText = NSAttributedString(string: taskNameLabel.text ?? "",
                                                              attributes: [:])
        }
        onCompletedButtonTapped?(isCompleted)
    }

    func configure(with task: TaskModel) {
        taskNameLabel.text = task.name
        taskCompletedButton.isSelected = task.isCompleted

        if task.isCompleted {
            taskNameLabel.attributedText = NSAttributedString(string: task.name,
                                                              attributes: [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue])
        } else {
            taskNameLabel.attributedText = NSAttributedString(string: task.name,
                                                              attributes: [:])
        }
    }
}

