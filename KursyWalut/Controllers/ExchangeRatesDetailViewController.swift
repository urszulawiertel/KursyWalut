//
//  ExchangeRatesDetailViewController.swift
//  KursyWalut
//
//  Created by Ula on 31/01/2022.
//

import UIKit
import DGCharts

class ExchangeRatesDetailViewController: UIViewController, ChartViewDelegate {

    @IBOutlet private weak var currencyLabel: UILabel!
    @IBOutlet private weak var averageExchangeRateLabel: UILabel!
    @IBOutlet private weak var startDatePicker: UIDatePicker!
    @IBOutlet private weak var endDatePicker: UIDatePicker!
    @IBOutlet private weak var startLabel: UILabel!
    @IBOutlet private weak var endLabel: UILabel!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet private weak var lineChart: LineChartView!
    var viewModel: ExchangeRatesDetailViewModel!

    private let activityIndicator = UIActivityIndicatorView()

    private enum DateRange: Int {
        case week = 7
        case month = 30
        case quarter = 90
        case year = 360
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLineChart()
        setupDatePicker()
        setupRightBarButton()
        configureActivityIndicator()
        loadDataEntries()
        lineChart.delegate = self

        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
    }

    @IBAction private func segmentChanged(_ sender: UISegmentedControl) {
        var selectedIndex = sender.selectedSegmentIndex
        if viewModel.table == TableType.minor.queryParameter {
            selectedIndex += 1
        }
        switch selectedIndex {
        case 0:
            startDatePicker.date = viewModel.dateFormatter.getPastDate(daysAgo: DateRange.week.rawValue)
        case 1:
            startDatePicker.date = viewModel.dateFormatter.getPastDate(daysAgo: DateRange.month.rawValue)
        case 2:
            startDatePicker.date = viewModel.dateFormatter.getPastDate(daysAgo: DateRange.quarter.rawValue)
        default:
            startDatePicker.date = viewModel.dateFormatter.getPastDate(daysAgo: DateRange.year.rawValue)
        }
        refreshLineChart()
    }

    @IBAction private func startDateChanged(_ sender: UIDatePicker) {
        loadDataEntries()
    }
    @IBAction private func endDateChanged(_ sender: UIDatePicker) {
        loadDataEntries()
    }

    private func setupViews() {
        currencyLabel.text = viewModel.rate?.currency
        averageExchangeRateLabel.text = "1 \(viewModel.rate?.code ?? "") = \(viewModel.rate?.mid ?? viewModel.rate?.average ?? 0) PLN"
        lineChart.isHidden = true
    }

    private func setupRightBarButton() {
        let refreshBarItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshLineChart))

        navigationItem.rightBarButtonItem = refreshBarItem
    }

    private func configureActivityIndicator() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)

        activityIndicator.centerXAnchor.constraint(equalTo: lineChart.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: lineChart.centerYAnchor).isActive = true
    }

    private func setupDatePicker() {
        let apiLimit = 367
        let today = Date()

        startDatePicker.minimumDate = viewModel.dateFormatter.getPastDate(daysAgo: apiLimit)
        startDatePicker.maximumDate = today
        startDatePicker.date = viewModel.dateFormatter.getPastDate(daysAgo: DateRange.week.rawValue)

        endDatePicker.minimumDate = viewModel.dateFormatter.getPastDate(daysAgo: apiLimit)
        endDatePicker.maximumDate = today
        endDatePicker.date = today
    }

    private func loadDataEntries() {
        guard let table = viewModel.table, let code = viewModel.rate?.code else { return }
        if table == TableType.minor.queryParameter && segmentedControl.titleForSegment(at: 0) == "7 DNI" {
            segmentedControl.removeSegment(at: 0, animated: true)
            segmentedControl.selectedSegmentIndex = 2
            startDatePicker.date = viewModel.dateFormatter.getPastDate(daysAgo: DateRange.year.rawValue)
        }

        let startDate = viewModel.dateFormatter.formatDate(startDatePicker.date) ?? ""
        let endDate = viewModel.dateFormatter.formatDate(endDatePicker.date) ?? ""

        lineChart.isHidden = true
        activityIndicator.startAnimating()
        viewModel.apiController.fetchHistoricalExchangeRates(forType: table,
                                                             forCurrency: code,
                                                             from: startDate,
                                                             to: endDate) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.lineChart.isHidden = false
            }
            switch result {
            case .success(let exchangeRates):

                self.viewModel.historicalRates = exchangeRates

                DispatchQueue.main.async {
                    self.updateLineChart()
                    self.lineChart.isHidden = false
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    private func setupLineChart() {
        let xAxis = lineChart.xAxis
        xAxis.labelPosition = .bottom
        xAxis.setLabelCount(5, force: true)

        let leftAxis = lineChart.leftAxis
        leftAxis.setLabelCount(5, force: false)

        let rightAxis = lineChart.rightAxis
        rightAxis.setLabelCount(5, force: false)

        let xValuesNumberFormatter = ChartXAxisFormatter()
        xAxis.valueFormatter = xValuesNumberFormatter
    }

    private func updateLineChart() {

        guard let rates = viewModel.historicalRates?.rates else { return }
        var entries = [ChartDataEntry]()
        rates.forEach({ rate in
            guard let date = rate.effectiveDate else { return }
            let timeInterval = date.timeIntervalSince1970
            entries.append(ChartDataEntry(x: timeInterval, y: (rate.mid ?? rate.average) ?? 0))
        })

        let dataSet = LineChartDataSet(entries: entries)
        dataSet.drawCirclesEnabled = false
        dataSet.setColor(.systemBlue)
        lineChart.data = LineChartData(dataSet: dataSet)
        lineChart.data?.setDrawValues(false)
        lineChart.legend.textColor = .white
    }

    @objc private func refreshLineChart() {
        loadDataEntries()
        updateLineChart()
    }
}
