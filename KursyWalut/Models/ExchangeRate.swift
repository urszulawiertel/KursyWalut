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
    let tradingDate: String?
    let effectiveDate: String?
    let rates: [Rate]
}

struct Rate: Codable {
    let currency: String?
    let code: String?
    let mid: Double?
    let bid: Double?
    let ask: Double?
}

enum TableType: String {
    case a
    case b
    case c
}
