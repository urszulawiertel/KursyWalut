//
//  ViewController.swift
//  KursyWalut
//
//  Created by Ula on 29/01/2022.
//

import UIKit

final class ExchangeRatesListViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!

    private let apiController: ExchangeRatesAPIControlling = ExchangeRatesAPIController()
    private var exchangeRates: [ExchangeRate]?
    private var tableType = TableType.major.queryParameter

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        segmentedControl.addTarget(self, action: #selector(handleTable), for: .valueChanged)

        loadCurrencyRates()
    }

    @objc private func handleTable() {

        switch segmentedControl.selectedSegmentIndex {
        case 0:
            tableType = TableType.major.queryParameter
        case 1:
            tableType = TableType.minor.queryParameter
        default:
            tableType = TableType.bidAsk.queryParameter
        }

        loadCurrencyRates()

    }

    private func loadCurrencyRates() {
        apiController.fetchExchangeRates(forType: tableType) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let exchangeRates):
                self.exchangeRates = exchangeRates
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }

            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: - UITableViewDelegate

extension ExchangeRatesListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exchangeRates?[0].rates.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = exchangeRates?[0].rates[indexPath.row]
        let effectiveDate = exchangeRates?[0].effectiveDate

        if segmentedControl.selectedSegmentIndex == 2 {
            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "BidAskSpreadTableViewCell", for: indexPath) as! BidAskSpreadTableViewCell
            let tableViewCellViewModel = BidAskSpreadTableViewCellViewModel(rate: item, date: effectiveDate)
            cell.viewModel = tableViewCellViewModel

            cell.configureCell()
            return cell
        } else {
            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "AverageExchangeRatesTableViewCell", for: indexPath) as! AverageExchangeRatesTableViewCell
            let tableViewCellViewModel = AverageExchangeRatesTableViewCellViewModel(rate: item, date: effectiveDate)
            cell.viewModel = tableViewCellViewModel

            cell.configureCell()
            return cell
        }

    }

}

extension ExchangeRatesListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailViewController = storyboard?.instantiateViewController(withIdentifier: "ExchangeRatesDetailViewController") as? ExchangeRatesDetailViewController {

            let item = exchangeRates?[0].rates[indexPath.row]
            let table = exchangeRates?[0].table
            let tradingDate = exchangeRates?[0].tradingDate
            let detailViewModel = ExchangeRatesDetailViewModel(rate: item, date: tradingDate, table: table)
            detailViewController.viewModel = detailViewModel

            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}
