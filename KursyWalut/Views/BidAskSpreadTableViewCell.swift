//
//  BidAskSpreadTableViewCell.swift
//  KursyWalut
//
//  Created by Ula on 31/01/2022.
//

import UIKit

struct BidAskSpreadTableViewCellViewModel {
    let rate: Rate?
    let date: String?
    init(rate: Rate?, date: String?) {
        self.rate = rate
        self.date = date
    }
}

class BidAskSpreadTableViewCell: UITableViewCell {

    @IBOutlet private weak var currencyLabel: UILabel!
    @IBOutlet private weak var currencyCodeLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var bidPriceLabel: UILabel!
    @IBOutlet private weak var askPriceLabel: UILabel!

    var viewModel: BidAskSpreadTableViewCellViewModel!

    func configureCell() {
        currencyLabel.text = viewModel.rate?.currency
        currencyCodeLabel.text = viewModel.rate?.code
        dateLabel.text = viewModel.date
        bidPriceLabel.text = "\(viewModel.rate?.bid ?? 0)"
        askPriceLabel.text = "\(viewModel.rate?.ask ?? 0)"
    }

}
