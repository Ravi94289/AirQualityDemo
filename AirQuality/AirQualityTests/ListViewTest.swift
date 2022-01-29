//
//  ListViewTest.swift
//  AirQualityTests
//
//  Created by Ravi Bhratkumar Amalseda on 29/01/22.
//

import XCTest
import RxSwift
import RxNimble
import Nimble

@testable import AirQuality

let falseResponse: [AirQualityRespData] = [AirQualityRespData(city: "Delhi", aqi: 200.0)]
let falseDataProvider: DataProvider = FalseDataProvider(fResponse: .success(falseResponse))//FakeDataProvider(fakeResponse: .success(fakeResponse))

let falseDataProviderError: DataProvider
= FalseDataProvider(fResponse: .failure(NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey : "error message"])))


class ListViewTest: XCTestCase {

    let listViewModel: ListViewModel = ListViewModel(dataProvider: falseDataProvider)
    
    let listViewModelError: ListViewModel = ListViewModel(dataProvider: falseDataProviderError)
    
    func testRespnoseDataInformation() {
        
        listViewModel.connect()
        
        expect(self.listViewModel.prevItems.first?.city) == falseResponse.first?.city
        expect(self.listViewModel.prevItems.first?.prevData.last?.value) == falseResponse.first?.aqi
        
        listViewModel.disConnect()
    }
    
    func testDataInformationWhenPrevItemsAvailable() {
        
        let item = CityDataModelData(city: "Mumbai")
        item.prevData = [AirQualityModel(value: 100, date: Date())]
        listViewModel.prevItems = [item]
     
        listViewModel.connect()
        
        expect(self.listViewModel.prevItems.first?.city) == "Mumbai"
        expect(self.listViewModel.prevItems.first?.prevData.last?.value) == 100
        
        listViewModel.disConnect()
    }
    
    func testErrorResponse() {
        
        listViewModelError.connect()
        
        let p = self.listViewModelError.prevItems
        expect(p.count) == 0
        
    }

}
