//
//  ToDoViewProtocol.swift
//  ToDoApp
//
//  Created by Людмила Долонтаева on 2023-08-07.
//

import Foundation
import UIKit

protocol ToDoViewProtocol: UIView {
    func reloadTable()
    func insertRows(path: IndexPath, animation: UITableView.RowAnimation)
    func keyboardWillHide(notification: NSNotification)
    func keyboardWillShow(notification: NSNotification)
    func didLoad()
}
