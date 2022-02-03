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
    let no: String?
    let effectiveDate: Date?
    let mid: Double?
}
