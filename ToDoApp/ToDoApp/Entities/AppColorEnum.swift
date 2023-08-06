//
//  AppColorEnum.swift
//  ToDoApp
//
//  Created by Людмила Долонтаева on 2023-08-05.
//

import Foundation
import UIKit

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
