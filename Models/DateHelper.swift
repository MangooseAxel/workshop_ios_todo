//
//  B2aDateFormatter.swift
//  ToDo
//
//  Created by Oleksandr Dolomanov on 04.11.2021.
//

import Foundation

enum DateStringFormat {
    case short
    case iso8601
}

extension Date {

    func toString(from date: Date, toFormat: DateStringFormat = .short) -> String {
        switch toFormat {
        case .short:
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            return formatter.string(from: date)
        case .iso8601:
            let dateFormatter = ISO8601DateFormatter()
            dateFormatter.formatOptions.insert(.withFractionalSeconds)
            return dateFormatter.string(from: date)
        }
    }

    func toString(from dateISO8601String: String, toFormat: DateStringFormat = .short) -> String {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions.insert(.withFractionalSeconds)
        let date = dateFormatter.date(from: dateISO8601String) ?? Date()

        return self.toString(from: date)
    }

    func toDate(dateISO8601String: String) -> Date {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions.insert(.withFractionalSeconds)
        return formatter.date(from: dateISO8601String) ?? Date()
    }
}
