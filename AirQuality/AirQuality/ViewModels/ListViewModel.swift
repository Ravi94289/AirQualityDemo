//
//  ListViewModel.swift
//  AirQuality
//
//  Created by Ravi Bhratkumar Amalseda on 29/01/22.
//

import Foundation
import RxSwift
import RxCocoa

class ListViewModel {
    
    var prevItems: [CityDataModelData] = [CityDataModelData]()
    
    var items = PublishSubject<[CityDataModelData]>()
    
    var provider: DataProvider?
    
    init(dataProvider: DataProvider) {
        provider = dataProvider
        provider?.delegate = self
    }
    
    func connect() {
        provider?.connetSocket()
    }
    
    func disConnect() {
        provider?.disConnetSocket()
    }
}

extension ListViewModel: RespDataProviderDelegate {
    func didReceive(response: Result<[AirQualityRespData], Error>) {
        switch response {
        
        case .success(let response):
            parseData(resArray: response)
        
        case .failure(let error):
            handleFail(error: error)
        }
    }
    
    func parseData(resArray: [AirQualityRespData]) {
        
        if prevItems.count == 0 {
            for d in resArray {
                let m = CityDataModelData(city: d.city)
                m.prevData.append(AirQualityModel(value: d.aqi, date: Date()))
                prevItems.append(m)
            }
        } else {
        
            for res in resArray {
                let matchedResults = prevItems.filter { $0.city == res.city }
                if let matchedRes = matchedResults.first {
                    matchedRes.prevData.append(AirQualityModel(value: res.aqi, date: Date()))
                } else {
                    let aTempData = CityDataModelData(city: res.city)
                    aTempData.prevData.append(AirQualityModel(value: res.aqi, date: Date()))
                    prevItems.append(aTempData)
                }
            }
        }
                                                        
        items.onNext(prevItems)
    }
    
    func handleFail(error: Error?) {
        if let e = error {
            items.onError(e)
        }
    }
}
