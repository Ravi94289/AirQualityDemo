//
//  CityListViewController.swift
//  AirQuality
//
//  Created by Ravi Bhratkumar Amalseda on 29/01/22.
//

import UIKit
import RxSwift
import RxCocoa

class CityListViewController: UIViewController {
    
    private var viewModel: ListViewModel?
    private var dbag = DisposeBag()
    @IBOutlet var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.accessibilityIdentifier = "cityTableView"
        viewModel = ListViewModel(dataProvider: DataProvider())
        bindTableData()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.connect()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel?.disConnect()
    }
    
    deinit {
        viewModel?.disConnect()
    }
    
    func bindTableData() {
        
        // bind items to table
        viewModel?.items.bind(to: tblView.rx.items(cellIdentifier: "cellCityDetail", cellType: CityDetailTableViewCell.self)) {row, model, cell in
            cell.cityData = model
        }.disposed(by: dbag)
        
        tblView.rx.modelSelected(CityDataModelData.self).bind { item in
            let cityDetail: GraphViewController = self.storyboard?.instantiateViewController(identifier: "GraphViewController") as! GraphViewController
            cityDetail.cityModel = item
            self.navigationController?.pushViewController(cityDetail, animated: true)
        }.disposed(by: dbag)
        // set delegate
        tblView.rx.setDelegate(self).disposed(by: dbag)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension CityListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
}
