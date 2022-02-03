//
//  DateValueFormatter.swift
//  KursyWalut
//
//  Created by Ula on 03/02/2022.
//

import UIKit
import Charts

public class ChartXAxisFormatter: NSObject, IAxisValueFormatter {
    private let dateFormatter = DateFormatter()

    override init() {
        super.init()
        dateFormatter.dateFormat = "d/MM"
    }

    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dateFormatter.string(from: Date(timeIntervalSince1970: value))
    }
}
