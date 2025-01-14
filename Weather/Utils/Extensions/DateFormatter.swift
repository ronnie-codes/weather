//
//  DateFormatter.swift
//  Weather
//
//  Created by George Washington on 1/14/25.
//

import Foundation

extension DateFormatter {
    static let `default`: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()
}
