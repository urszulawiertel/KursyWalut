//
//  DateConverter.swift
//  KursyWalut
//
//  Created by Ula on 03/02/2022.
//

import Foundation

protocol DateConverting {
    func formatDate(_ date: Date) -> String?
}

struct DateConverter: DateConverting {

    let inputDateFormatter: DateFormatter
    let outputDateFormatter: DateFormatter

    init(inputDateFormatter: DateFormatter, outputDateFormatter: DateFormatter) {
        self.inputDateFormatter = inputDateFormatter
        self.outputDateFormatter = outputDateFormatter
    }

    /// Converts a date from the API using DateFormatter().
    /// - Parameter date: Date to format
    /// - Returns: Returns a string converted to a given date format.
    func formatDate(_ date: Date) -> String? {
        outputDateFormatter.string(from: date)
    }
}

extension DateFormatter {
    /// Returns the date in the format received from the API request.
    static var defaultDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter
    }

    /// Returns a date in the following format:  the 4-digit year, numeric month and numeric day of the month.
    /// Example: 30-12-2021.
    static var dayMonthYearDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }
}
