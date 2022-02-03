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
    @IBOutlet private weak var currencyCodeLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var averageExchangeRateLabel: UILabel!
    @IBOutlet private weak var startDatePicker: UIDatePicker!
    @IBOutlet private weak var endDatePicker: UIDatePicker!
    @IBOutlet private weak var startLabel: UILabel!
    @IBOutlet private weak var endLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    var viewModel: ExchangeRatesDetailViewModel!

    private let activityIndicator = UIActivityIndicatorView()
    private lazy var lineChart = LineChartView()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataEntries()
        setupViews()
        setupLineChartView()
        configureActivityIndicator()
        lineChart.delegate = self

        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
    }

    @IBAction func buttonTapped(_ sender: UISegmentedControl) {
    }

    private func setupViews() {
        currencyLabel.text = viewModel.rate?.currency
        averageExchangeRateLabel.text = "1 \(viewModel.rate?.code ?? "") = \(viewModel.rate?.mid ?? 0) PLN"
        lineChart.isHidden = true
    }

    private func setupLineChartView() {
        lineChart.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(lineChart)

        NSLayoutConstraint.activate([
            lineChart.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            lineChart.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            lineChart.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10),
            lineChart.bottomAnchor.constraint(equalTo: startDatePicker.topAnchor, constant: -20)
        ])
    }

    private func configureActivityIndicator() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)

        activityIndicator.centerXAnchor.constraint(equalTo: lineChart.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: lineChart.centerYAnchor).isActive = true
    }

    private func loadDataEntries() {

        guard let table = viewModel.table, let code = viewModel.rate?.code else { return }
        let startDate = "2022-01-20"
        let endDate = "2022-01-30"
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

    private func updateLineChart() {

        let xAxis = lineChart.xAxis
        xAxis.labelPosition = .bottom

        let xValuesNumberFormatter = ChartXAxisFormatter()
        xAxis.valueFormatter = xValuesNumberFormatter

        guard let rates = viewModel.historicalRates?.rates else { return }
        var entries = [ChartDataEntry]()
        rates.forEach({ rate in
            guard let date = rate.effectiveDate, let price = rate.mid else {return}
            let timeInterval = date.timeIntervalSince1970
            entries.append(ChartDataEntry(x: timeInterval, y: price))
        })
        xAxis.labelCount = entries.count

        let dataSet =  LineChartDataSet(entries: entries)
        dataSet.valueTextColor = .white
        lineChart.data = LineChartData(dataSet: dataSet)
        lineChart.legend.textColor = .white

    }
}
