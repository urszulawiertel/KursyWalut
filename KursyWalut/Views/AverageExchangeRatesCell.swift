//
//  AverageExchangeRatesTableViewCell.swift
//  KursyWalut
//
//  Created by Ula on 29/01/2022.
//

import UIKit

class AverageExchangeRatesCell: UITableViewCell {

    @IBOutlet private weak var currencyLabel: UILabel!
    @IBOutlet private weak var currencyCodeLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var averageExchangeRateLabel: UILabel!

    var viewModel: AverageExchangeRatesCellViewModel!

    func configureCell() {
        currencyLabel.text = viewModel.rate?.currency
        currencyCodeLabel.text = viewModel.rate?.code
        dateLabel.text = viewModel.dateFormatter.formatDate(viewModel.date ?? Date())
        averageExchangeRateLabel.text = "\(viewModel.rate?.mid ?? 0)"
    }

}
