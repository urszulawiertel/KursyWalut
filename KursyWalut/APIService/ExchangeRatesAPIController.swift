//
//  ExchangeRatesAPIController.swift
//  KursyWalut
//
//  Created by Ula on 29/01/2022.
//

import Foundation

protocol ExchangeRatesAPIControlling {
    func fetchExchangeRates(forType query: String, completionHandler: @escaping ((Result<ExchangeRateNBP, ExchangeRatesError>) -> Void))
    func fetchHistoricalExchangeRates(forType type: String, forCurrency code: String, from startDate: String, to endDate: String, completionHandler: @escaping ((Result<HistoricalExchangeRate, ExchangeRatesError>) -> Void))
}

struct ExchangeRatesAPIController: ExchangeRatesAPIControlling {

    private struct Constants {
        static var components: URLComponents {
            var components = URLComponents()
            components.scheme = "https"
            components.host = "api.nbp.pl"
            return components
        }
    }

    private func decode<T: Decodable>(model: T.Type, data: Data) throws -> T {
        let decoder = JSONDecoder()
        let decodedData = try decoder.decode(model.self, from: data)
        return decodedData
    }

    func fetchExchangeRates(forType type: String, completionHandler: @escaping ((Result<ExchangeRateNBP, ExchangeRatesError>) -> Void)) {

        var components = Constants.components
        components.path = "/api/exchangerates/tables/\(type)"

        guard let url = components.url else { return }

        fetchData(for: url, model: ExchangeRateNBP.self, completionHandler: completionHandler)

    }

    func fetchHistoricalExchangeRates(forType type: String, forCurrency code: String, from startDate: String, to endDate: String, completionHandler: @escaping ((Result<HistoricalExchangeRate, ExchangeRatesError>) -> Void)) {

        var components = Constants.components
        components.path = "/api/exchangerates/rates/\(type)/\(code)/\(startDate)/\(endDate)/"

        guard let url = components.url else { return }

        fetchData(for: url, model: HistoricalExchangeRate.self, completionHandler: completionHandler)

    }

    private func fetchData<T>(for url: URL, model: T.Type, completionHandler: @escaping ((Result<T, ExchangeRatesError>) -> Void)) where T: Decodable {

        let task = URLSession.shared.dataTask(with: url) { data, response, error in

            if let error = error {
                completionHandler(.failure(.urlSession(error)))
                return
            }

            guard let data = data, let response = response as? HTTPURLResponse else {
                completionHandler(.failure(.unknown))
                return
            }

            guard 200..<300 ~= response.statusCode else {
                return completionHandler(.failure(.serverResponse(response)))
            }

            do {
                let decoded = try decode(model: model.self, data: data)
                completionHandler(.success(decoded))

            } catch {
                completionHandler(.failure(.decodingError))
            }

        }
        task.resume()
    }

}
