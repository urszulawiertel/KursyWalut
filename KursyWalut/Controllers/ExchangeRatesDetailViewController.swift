//
//  ExchangeRatesDetailViewController.swift
//  KursyWalut
//
//  Created by Ula on 31/01/2022.
//

import UIKit
import Charts

struct ExchangeRatesDetailViewModel {
    let apiController: ExchangeRatesAPIControlling
    let dateFormatter: DateConverting
    let rate: Rate?
    let date: Date?
    let table: String?
    var historicalRates: HistoricalExchangeRate?
    init(apiController: ExchangeRatesAPIControlling = ExchangeRatesAPIController(),
         dateFormatter: DateConverting,
         rate: Rate?,
         date: Date?,
         table: String?) {
        self.apiController = apiController
        self.dateFormatter = dateFormatter
        self.rate = rate
        self.date = date
        self.table = table
    }
}

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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLineChart()
        setupDatePicker()
        configureActivityIndicator()
        loadDataEntries()
        lineChart.delegate = self

        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
    }

    @IBAction func buttonTapped(_ sender: UISegmentedControl) {
    }

    @IBAction func startDateChanged(_ sender: UIDatePicker) {
        loadDataEntries()
    }
    @IBAction func endDateChanged(_ sender: UIDatePicker) {
        loadDataEntries()
    }

    private func setupViews() {
        currencyLabel.text = viewModel.rate?.currency
        averageExchangeRateLabel.text = "1 \(viewModel.rate?.code ?? "") = \(viewModel.rate?.mid ?? viewModel.rate?.average ?? 0) PLN"
        lineChart.isHidden = true
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
        startDatePicker.date = viewModel.dateFormatter.getPastDate(daysAgo: 7) ?? Date()

        endDatePicker.minimumDate = viewModel.dateFormatter.getPastDate(daysAgo: apiLimit)
        endDatePicker.maximumDate = today
        endDatePicker.date = today
    }

    private func loadDataEntries() {
        guard let table = viewModel.table, let code = viewModel.rate?.code else { return }
        let startDate = viewModel.dateFormatter.formatDate(startDatePicker.date) ?? ""
        let endDate = viewModel.dateFormatter.formatDate(endDatePicker.date) ?? ""

        activityIndicator.startAnimating()
        viewModel.apiController.fetchHistoricalExchangeRates(forType: table,
                                                  forCurrency: code,
                                                  from: startDate,
                                                  to: endDate) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
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
}
