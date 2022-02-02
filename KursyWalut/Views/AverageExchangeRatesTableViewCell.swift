//
//  AverageExchangeRatesTableViewCell.swift
//  KursyWalut
//
//  Created by Ula on 29/01/2022.
//

import UIKit

struct AverageExchangeRatesTableViewCellViewModel {
    let rate: Rate?
    let date: String?
    init(rate: Rate?, date: String?) {
        self.rate = rate
        self.date = date
    }
}

class AverageExchangeRatesTableViewCell: UITableViewCell {

    @IBOutlet private weak var currencyLabel: UILabel!
    @IBOutlet private weak var currencyCodeLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var averageExchangeRateLabel: UILabel!

    var viewModel: AverageExchangeRatesTableViewCellViewModel!

    func configureCell() {
        currencyLabel.text = viewModel.rate?.currency
        currencyCodeLabel.text = viewModel.rate?.code
        dateLabel.text = viewModel.date
        averageExchangeRateLabel.text = "\(viewModel.rate?.mid ?? 0)"
    }

}
