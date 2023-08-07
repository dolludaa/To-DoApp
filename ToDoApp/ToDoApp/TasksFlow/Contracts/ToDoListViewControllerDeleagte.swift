//
//  ToDoListViewControllerDeleagte.swift
//  ToDoApp
//
//  Created by Людмила Долонтаева on 2023-08-05.
//

import Foundation
import UIKit

protocol ToDoListViewControllerDeleagte: AnyObject, UITableViewDelegate, UITableViewDataSource {
    var titleView: UIView? { get set }
    func addButtonDidTap()
}
