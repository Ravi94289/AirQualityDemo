//
//  AirQualityClass.swift
//  AirQuality
//
//  Created by Ravi Bhratkumar Amalseda on 29/01/22.
//

import UIKit

enum AirQualityRate {
    case good
    case satisfactory
    case moderate
    case poor
    case veryPoor
    case severe
    case outOfRange
}

class AirQuality {
    static func measureAirQualityIndex(aqi: Float) -> AirQualityRate {
        switch aqi {
        
        case 0...50:
            return .good
        
        case 51...100:
            return .satisfactory
        
        case 101...200:
            return .moderate
        
        case 201...300:
            return .poor
        
        case 301...400:
            return .veryPoor
        
        case 401...500:
            return .severe
        
        default:
            return .outOfRange
        }
    }
}

struct AirQualityRateColors {
    static func color(index: AirQualityRate) -> UIColor {
        switch index {
       
        case .good:
            return UIColor(red: 85.0/255.0, green: 168.0/255.0, blue: 79.0/255.0, alpha: 1.0)
            
        case .satisfactory:
            return UIColor(red: 163.0/255.0, green: 200.0/255.0, blue: 83.0/255.0, alpha: 1.0)
            
        case .moderate:
            return UIColor(red: 255.0/255.0, green: 248.0/255.0, blue: 51.0/255.0, alpha: 1.0)
            
        case .poor:
            return UIColor(red: 242.0/255.0, green: 156.0/255.0, blue: 50.0/255.0, alpha: 1.0)
            
        case .veryPoor:
            return UIColor(red: 233.0/255.0, green: 63.0/255.0, blue: 51.0/255.0, alpha: 1.0)
            
        case .severe:
            return UIColor(red: 175.0/255.0, green: 45.0/255.0, blue: 37.0/255.0, alpha: 1.0)
            
        case .outOfRange:
            return UIColor(red: 175.0/255.0, green: 45.0/255.0, blue: 37.0/255.0, alpha: 1.0)
            
        }
    }
}
