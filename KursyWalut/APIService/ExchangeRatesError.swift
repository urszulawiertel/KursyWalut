//
//  ExchangeRatesError.swift
//  KursyWalut
//
//  Created by Ula on 30/01/2022.
//

import Foundation

enum ExchangeRatesError: Error {
    case serverResponse(HTTPURLResponse)
    case urlSession(Error)
    case unknown
    case decodingError
}
