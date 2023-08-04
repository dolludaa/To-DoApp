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


    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        setUpStyle()
    }

    private func setUpLayout() {
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(dateLabel)
        stackView.axis = .vertical
        stackView.spacing = 5

        stackView.translatesAutoresizingMaskIntoConstraints = false
        navigationItem.titleView = stackView
    }

    private func setUpStyle() {

        view.backgroundColor = .lightGray
        titleLabel.text = "Today's Task"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)
        titleLabel.textAlignment = .center


        dateLabel.text = DateFormatter.defaultDateFormatter.string(from: Date())
        dateLabel.font = UIFont.systemFont(ofSize: 14)
        dateLabel.textAlignment = .center
    }
}

