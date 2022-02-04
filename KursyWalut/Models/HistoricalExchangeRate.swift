//
//  HistoricalExchangeRate.swift
//  KursyWalut
//
//  Created by Ula on 02/02/2022.
//

import Foundation

struct HistoricalExchangeRate: Codable {
    let table: String?
    let currency: String?
    let code: String?
    let rates: [IndividualRate]
}

struct IndividualRate: Codable {
    let effectiveDate: Date?
    let mid: Double?
    let bid: Double?
    let ask: Double?

    var average: Double? {
        return ((bid ?? 0) + (ask ?? 0)) / 2
    }
}
