//
//  CityDetailsModel.swift
//  AirQuality
//
//  Created by Ravi Bhratkumar Amalseda on 29/01/22.
//

import Foundation
class AirQualityModel {
    var value: Float = 0.0
    var date: Date = Date()
    init(value: Float, date: Date) {
        self.value = value
        self.date = date
    }
}

protocol CityDataModel {
    var city: String { get set }
    var prevData: [AirQualityModel] { get set }
}

class CityDataModelData: CityDataModel {
    var city: String
    var prevData: [AirQualityModel] = [AirQualityModel]()
    
    init(city: String) {
        self.city = city
    }
}
