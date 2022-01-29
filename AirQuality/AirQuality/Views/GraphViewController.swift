//
//  GraphViewController.swift
//  AirQuality
//
//  Created by Ravi Bhratkumar Amalseda on 29/01/22.
//

import UIKit
import RxSwift
import RxCocoa
import Charts

class GraphViewController: UIViewController {
    var cityModel: CityDataModelData = CityDataModelData(city: "")
    
    private var viewModel: DetailViewModel?
    
    private var dbag = DisposeBag()
    
    private let chartView = LineChartView()
    
    var dataEntries = [ChartDataEntry]()

    var xValue: Double = 30
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = DetailViewModel(dataProvider: DataProvider())
        
        self.title = cityModel.city
        
        view.addSubview(chartView)
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        chartView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        chartView.widthAnchor.constraint(equalToConstant: view.frame.width - 32).isActive = true
        chartView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        setupInitialDataEntries()
        
        setupChartData()
        
        bindData()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.connect(forCity: cityModel.city)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel?.disConnect()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    func bindData() {
     
        viewModel?.item.bind { model in
        
            if let v = model.prevData.last?.value {
                let roundingValue: Double = Double(round(v * 100) / 100.0)
                
                let newDataEntry = ChartDataEntry(x: self.xValue,
                                                  y: Double(roundingValue))
                self.updateChartView(with: newDataEntry, dataEntries: &self.dataEntries)
                self.xValue += 1
            }
                
        }.disposed(by: dbag)
    }
}
// Graph UI
extension GraphViewController {
    func setupInitialDataEntries() {
        (0..<Int(xValue)).forEach {
            let dataEntry = ChartDataEntry(x: Double($0), y: 0)
            dataEntries.append(dataEntry)
        }
    }
    func setupChartData() {
        // 1
        let chartDataSet = LineChartDataSet(entries: dataEntries, label: "AQI for " + self.cityModel.city)
        chartDataSet.drawCirclesEnabled = true
        chartDataSet.drawFilledEnabled = true
        chartDataSet.drawIconsEnabled = true
        chartDataSet.setColor(.systemBlue)
        chartDataSet.mode = .linear
        chartDataSet.setCircleColor(.systemBlue)
        if let font = UIFont(name: "Helvetica Neue", size: 10) {
            chartDataSet.valueFont = font
        }
            
        // 2
        let chartData = LineChartData(dataSet: chartDataSet)
        chartView.data = chartData
        chartView.xAxis.labelPosition = .bottom
    }
    
    func updateChartView(with newDataEntry: ChartDataEntry, dataEntries: inout [ChartDataEntry]) {
        // 1
        if let oldEntry = dataEntries.first {
            dataEntries.removeFirst()
            chartView.data?.removeEntry(oldEntry, dataSetIndex: 0)
        }
        
        // 2
        dataEntries.append(newDataEntry)
        chartView.data?.addEntry(newDataEntry, dataSetIndex: 0)
            
        // 3
        chartView.notifyDataSetChanged()
        chartView.moveViewToX(newDataEntry.x)
    }
    
}
