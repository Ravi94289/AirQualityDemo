//
//  DetailViewModel.swift
//  AirQuality
//
//  Created by Ravi Bhratkumar Amalseda on 29/01/22.
//

import Foundation
import RxSwift
import RxCocoa
import Starscream

class DetailViewModel {
    
    private var city: String = ""
    
    var prevItem: CityDataModelData? = nil
    
    var item = PublishSubject<CityDataModelData>()
    
    var provider: DataProvider?
    
    init(dataProvider: DataProvider) {
        provider = dataProvider
        provider?.delegate = self
    }
    
    func connect(forCity: String) {
        self.city = forCity
        provider?.connetSocket()
    }
    func disConnect() {
        provider?.disConnetSocket()
    }
}

extension DetailViewModel: RespDataProviderDelegate {
    func didReceive(response: Result<[AirQualityRespData], Error>) {
        switch response {
        
        case .success(let response):
            parseData(resArray: response)
        
        case .failure(let error):
            handleFail(error: error)
        }
    }
    
    func parseData(resArray: [AirQualityRespData]) {
        
        let cityData = resArray.filter { $0.city == city }
        if let data = cityData.first {
            if let prev = prevItem {
                prev.prevData.append(AirQualityModel(value: data.aqi, date: Date()))
            } else {
                prevItem = CityDataModelData(city: self.city)
                prevItem?.prevData.append(AirQualityModel(value: data.aqi, date: Date()))
            }
        } else {
            if let prev = prevItem, let last = prev.prevData.last {
                prev.prevData.append(last)
            }
        }
    
        if let p = prevItem {
            item.onNext(p)
        }
    }
    
    func handleFail(error: Error?) {
        if let e = error {
            item.onError(e)
        }
    }
}
