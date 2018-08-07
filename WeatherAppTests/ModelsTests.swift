//
//  ModelsTests.swift
//  WeatherAppTests
//
//  Created by Jovanco Jovanovski on 8/7/18.
//  Copyright © 2018 Jovanco Jovanovski. All rights reserved.
//

import XCTest

class ModelsTests: XCTestCase {
    
    var sut: ModelsWorker!
    
    override func setUp() {
        super.setUp()
        sut = ModelsWorker()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_CreateWeatherInfo ()
    {
        //Given
        let main = ["temp":28, "humidity": 45]
        let wind = ["speed": 5.53]
        let clouds = ["all": 20]
        
        var actual = [String : Dictionary<String, Any>]()
        actual.updateValue(main, forKey: ModelsWorker.ServerKeys.main.rawValue)
        actual.updateValue(wind , forKey: ModelsWorker.ServerKeys.wind.rawValue)
        actual.updateValue(clouds , forKey: ModelsWorker.ServerKeys.clouds.rawValue)
        
        //When
        let testWeatherInfo = sut.createWeatherInfo(weather: actual as AnyObject)
        
        //Then
        XCTAssertEqual(testWeatherInfo?.main?.temp, 28, "temperature should be set to 28 after creation")
        XCTAssertEqual(testWeatherInfo?.main?.humidity, 45, "humidity should be set to 45 after creation")
        XCTAssertEqual(testWeatherInfo?.wind?.speed, 5.53, "wind speed should be set to 5.53 after creation")
        XCTAssertEqual(testWeatherInfo?.clouds?.all, 20, "rain chance should be set to 20 after creation")
    }
}
