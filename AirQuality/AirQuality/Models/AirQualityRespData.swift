//
//  AirQualityRespData.swift
//  AirQuality
//
//  Created by Ravi Bhratkumar Amalseda on 29/01/22.
//

import Foundation
struct AirQualityRespData: Codable {
    var city: String
    var aqi: Float
    init(city: String, aqi: Float) {
        self.city = city
        self.aqi = aqi
    }
}
