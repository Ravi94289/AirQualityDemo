//
//  DetailViewTest.swift
//  AirQualityTests
//
//  Created by Ravi Bhratkumar Amalseda on 29/01/22.
//

import XCTest
import RxSwift
import RxNimble
import Nimble

@testable import AirQuality

let falseResponseForDetails: [AirQualityRespData] = [AirQualityRespData(city: "Delhi", aqi: 200.0)]
let falseDataProviderForDetails: DataProvider = FalseDataProvider(fResponse: .success(falseResponseForDetails))

let falseDataProviderForDetailsWithError: DataProvider
    = FalseDataProvider(fResponse: .failure(NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey : "error message"])))

class DetailViewTest: XCTestCase {

    let detailViewModel: DetailViewModel = DetailViewModel(dataProvider: falseResponseForDetails)
    
    let detailViewModelError: DetailViewModel = DetailViewModel(dataProvider: falseDataProviderForDetailsWithError)
    
    func testRespnoseDataInformation() {
        
        detailViewModel.connect(forCity: "Delhi")
        
        expect(self.detailViewModel.prevItem?.city) == fakeResponse.first?.city
        expect(self.detailViewModel.prevItem?.history.last?.value) == fakeResponse.first?.aqi
        
        detailViewModel.disConnect()
    }
    
    func testDataInformationWhenPrevItemsAvailable() {
        
        let item = CityDataModelData(city: "Mumbai")
        item.prevData = [AirQualityModel(value: 100, date: Date())]
        detailViewModel.prevItem = item
     
        detailViewModel.connect(forCity: "Mumbai")
        
        expect(self.detailViewModel.prevItem?.city) == "Mumbai"
        expect(self.detailViewModel.prevItem?.prevData.last?.value) == 100
        
        detailViewModel.disConnect()
    }
 
    func testErrorResponse() {
        
        detailViewModelError.connect(forCity: "Delhi")
        
        let p = self.detailViewModelError.prevItem
        expect(p) == nil
        
    }

}
