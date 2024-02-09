//
//  AverageExchangeRatesCellViewModel.swift
//  KursyWalut
//
//  Created by Ula on 30/01/2024.
//

import Foundation

struct AverageExchangeRatesCellViewModel {
    let dateFormatter: DateConverting
    let rate: Rate?
    let date: Date?
    init(dateFormatter: DateConverting, rate: Rate?, date: Date?) {
        self.dateFormatter = dateFormatter
        self.rate = rate
        self.date = date
    }
}
