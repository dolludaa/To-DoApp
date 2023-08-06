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
            taskCompletedButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            taskCompletedButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            taskCompletedButton.widthAnchor.constraint(equalToConstant: 50),
            taskCompletedButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func setupStyle() {
        taskNameLabel.font = UIFont.systemFont(ofSize: 16)
        taskCompletedButton.setImage(UIImage(systemName: SystemImage.circle.rawValue), for: .normal)
        taskCompletedButton.setImage(UIImage(systemName: SystemImage.checkmarkCircleFill.rawValue), for: .selected)
        taskCompletedButton.addTarget(self, action: #selector(completedTapped), for: .touchUpInside)
        taskCompletedButton.tintColor = AppColorEnum.primaryColor.color
    }

    func configure(with task: TaskModel) {
        taskNameLabel.text = task.name
        taskCompletedButton.isSelected = task.isCompleted
        updateTaskLabel(for: task.isCompleted)
    }

    @objc private func completedTapped() {
        taskCompletedButton.isSelected.toggle()
        let isCompleted = taskCompletedButton.isSelected
        updateTaskLabel(for: isCompleted)
        onCompletedButtonTapped?(isCompleted)
    }

    private func updateTaskLabel(for isCompleted: Bool) {
        let attributes: [NSAttributedString.Key: Any] = isCompleted ? [.strikethroughStyle: NSUnderlineStyle.single.rawValue] : [:]
        taskNameLabel.attributedText = NSAttributedString(string: taskNameLabel.text ?? "", attributes: attributes)
    }
}
