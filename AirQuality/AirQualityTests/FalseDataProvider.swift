//
//  FalseDataProvider.swift
//  AirQualityTests
//
//  Created by Ravi Bhratkumar Amalseda on 29/01/22.
//

import Foundation
import RxSwift

@testable import AirQuality

typealias AQDataResp = Result<[AirQualityRespData], Error>

class FalseDataProvider: DataProvider {

    private var falseResponse: AQDataResp
    
    var item = PublishSubject<CityDataModelData>()
    
    init(fResponse: AQDataResp) {
        self.falseResponse = fResponse
    }
    
    override func connetSocket() {
        notifyTestResponse()
    }
    
    private func notifyTestResponse() {
        switch self.falseResponse {
        case .success(let res):
            self.delegate?.didReceive(response: .success(res))
        case .failure(let error):
            self.delegate?.didReceive(response: .failure(error))
        }
    }
}
