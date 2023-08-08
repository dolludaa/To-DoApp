//
//  SystemImage.swift
//  ToDoApp
//
//  Created by Людмила Долонтаева on 2023-08-05.
//

import Foundation
import UIKit

enum SystemImage: String {
    case circle = "circle"
    case checkmarkCircleFill = "checkmark.circle.fill"

    var image: UIImage? {
        UIImage(systemName: rawValue)
    }
}
