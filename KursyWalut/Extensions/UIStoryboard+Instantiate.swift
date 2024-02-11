//
//  UIStoryboard.swift
//  KursyWalut
//
//  Created by Ula on 09/02/2024.
//

import UIKit

extension UIStoryboard {

    func instantiate<T: UIViewController>(_: T.Type) -> T {
        // swiftlint:disable force_cast
        return self.instantiateViewController(withIdentifier: String(describing: T.self)) as! T
    }
}
