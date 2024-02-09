//
//  ExchangeRatesDetailViewModel.swift
//  KursyWalut
//
//  Created by Ula on 30/01/2024.
//

import Foundation

struct ExchangeRatesDetailViewModel {
    let apiController: ExchangeRatesAPIControlling
    let dateFormatter: DateConverting
    let rate: Rate?
    let date: Date?
    let table: String?
    var historicalRates: HistoricalExchangeRate?
    init(apiController: ExchangeRatesAPIControlling = ExchangeRatesAPIController(),
         dateFormatter: DateConverting,
         rate: Rate?,
         date: Date?,
         table: String?) {
        self.apiController = apiController
        self.dateFormatter = dateFormatter
        self.rate = rate
        self.date = date
        self.table = table
    }
}
