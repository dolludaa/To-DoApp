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

    var onCompletedButtonTapped = { }

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

    override func prepareForReuse() {
        super.prepareForReuse()
        resetConfiguration()
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

        taskCompletedButton.setImage(SystemImage.circle.image, for: .normal)
        taskCompletedButton.setImage(SystemImage.checkmarkCircleFill.image, for: .selected)
        taskCompletedButton.addTarget(self, action: #selector(completedTapped), for: .touchUpInside)
        taskCompletedButton.tintColor = AppColorEnum.primaryColor.color
    }

    private func resetConfiguration() {
      taskNameLabel.attributedText = nil
      taskCompletedButton.isSelected = false
    }

    @objc private func completedTapped() {
        onCompletedButtonTapped()
    }

    private func updateTaskLabel(model: TaskModel) {
        var attributedString = AttributedString(model.name)
        attributedString.strikethroughStyle = model.isCompleted
        ? .single
        : Optional.none

        taskNameLabel.attributedText = .init(attributedString)
    }

    func configure(with task: TaskModel) {
        taskCompletedButton.isSelected = task.isCompleted
        updateTaskLabel(model: task)
    }
}
