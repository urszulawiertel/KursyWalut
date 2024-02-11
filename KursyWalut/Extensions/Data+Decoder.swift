//
//  Data+Decoder.swift
//  KursyWalut
//
//  Created by Ula on 10/02/2024.
//

import Foundation

extension Data {

    func decode<T: Decodable>(_: T.Type) throws -> T {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormat.dayMonthYearDateFormat
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return try decoder.decode(T.self, from: self)
    }
}
