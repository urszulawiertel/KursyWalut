//
//  UITableView.swift
//  KursyWalut
//
//  Created by Ula on 09/02/2024.
//

import UIKit

extension UITableView {

    func dequeueReusableCell<T: UITableViewCell>(_: T.Type, indexPath: IndexPath) -> T {
        // swiftlint:disable force_cast
        return self.dequeueReusableCell(withIdentifier: String(describing: T.self), for: indexPath) as! T
    }
}
