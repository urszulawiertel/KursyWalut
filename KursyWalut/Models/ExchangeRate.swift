//
//  ExchangeRateData.swift
//  KursyWalut
//
//  Created by Ula on 29/01/2022.
//

import Foundation

typealias ExchangeRateNBP = [ExchangeRate]

struct ExchangeRate: Codable {
    let table: String?
    let tradingDate: Date?
    let effectiveDate: Date?
    let rates: [Rate]
}

struct Rate: Codable {
    let currency: String?
    let code: String?
    let mid: Double?
    let bid: Double?
    let ask: Double?

    var average: Double? {
        return ((bid ?? 0) + (ask ?? 0)) / 2
    }
}

enum TableType: String {
    case major
    case minor
    case bidAsk

    var queryParameter: String {
        switch self {
        case .major:
            return "A"
        case .minor:
            return "B"
        case .bidAsk:
            return "C"
        }
    }
}
