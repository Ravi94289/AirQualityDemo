//
//  CityDetailTableViewCell.swift
//  AirQuality
//
//  Created by Ravi Bhratkumar Amalseda on 29/01/22.
//

import UIKit

class CityDetailTableViewCell: UITableViewCell {
    @IBOutlet var lblCity: UILabel?
    @IBOutlet var lblAQI: UILabel?
    @IBOutlet var lblLastUpdated: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lblAQI?.layer.cornerRadius = 5
        lblAQI?.layer.masksToBounds = true
    }

    var cityData: CityDataModelData? {
        didSet {
            guard let cityData = cityData else { return }
            lblCity?.text = cityData.city
            
            if let aqi = cityData.prevData.last?.value {
                lblAQI?.text = String(format: "%.2f", aqi)
            }
            
            if let aqi = cityData.prevData.last?.value {
                let index = AirQuality.measureAirQualityIndex(aqi: aqi)
                lblAQI?.textColor = AirQualityRateColors.color(index: index)
            }
            
            if let date = cityData.prevData.last?.date {
                if date.beforeTimeAgo() == "0 seconds" {
                    lblLastUpdated?.text = "just now"
                } else {
                    lblLastUpdated?.text = date.beforeTimeAgo() + " ago"
                }
            }
            
            self.accessibilityLabel = cityData.city
            self.accessibilityIdentifier = cityData.city
            self.accessibilityTraits = [.button]
        }
    }
}

extension Date {
    func beforeTimeAgo() -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
        formatter.zeroFormattingBehavior = .dropAll
        formatter.maximumUnitCount = 1
        return String(format: formatter.string(from: self, to: Date()) ?? "", locale: .current)
    }
}
