//
//  DateFormatter.swift
//  ToDoApp
//
//  Created by Людмила Долонтаева on 2023-08-04.
//

import Foundation

extension DateFormatter {

    static let defaultDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "EEEE, MMM d"
        return formatter
    }()
}
