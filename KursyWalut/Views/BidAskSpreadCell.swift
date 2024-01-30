//
//  BidAskSpreadTableViewCell.swift
//  KursyWalut
//
//  Created by Ula on 31/01/2022.
//

import UIKit

struct BidAskSpreadCellViewModel {
    let dateFormatter: DateConverting
    let rate: Rate?
    let date: Date?
    init(dateFormatter: DateConverting, rate: Rate?, date: Date?) {
        self.dateFormatter = dateFormatter
        self.rate = rate
        self.date = date
    }
}

class BidAskSpreadCell: UITableViewCell {

    @IBOutlet private weak var currencyLabel: UILabel!
    @IBOutlet private weak var currencyCodeLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var bidPriceLabel: UILabel!
    @IBOutlet private weak var askPriceLabel: UILabel!

    var viewModel: BidAskSpreadCellViewModel!

    func configureCell() {
        currencyLabel.text = viewModel.rate?.currency
        currencyCodeLabel.text = viewModel.rate?.code
        dateLabel.text = viewModel.dateFormatter.formatDate(viewModel.date ?? Date())
        bidPriceLabel.text = "\(viewModel.rate?.bid ?? 0)"
        askPriceLabel.text = "\(viewModel.rate?.ask ?? 0)"
    }

}
