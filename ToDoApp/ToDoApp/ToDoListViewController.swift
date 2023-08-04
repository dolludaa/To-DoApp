//
//  ToDoListViewController.swift
//  ToDoApp
//
//  Created by Людмила Долонтаева on 2023-08-04.
//

import UIKit

class ToDoListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
        setUpStyle()

    }

    private func setUpLayout() {

    }

    private func setUpStyle() {

      view.backgroundColor = .blue

      title = "Today's Task"

    }

}

