//
//  PresentationTests.swift
//  WeatherAppTests
//
//  Created by Jovanco Jovanovski on 8/7/18.
//  Copyright © 2018 Jovanco Jovanovski. All rights reserved.
//

import XCTest

class PresentationTests: XCTestCase {
    
    var sut: Presenter!
    
    override func setUp() {
        super.setUp()
        sut = Presenter()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_PresentTemperatureValue ()
    {
        //When
        let temp = Presenter.presentTemp(value: (TestWeatherInfo.weatherInfo.main!.temp))
        
        //Then
        XCTAssertEqual(temp, "15\("\u{00B0}")", "temperature should be 15 deg")
    }
    
    func test_PresentHumidityValue ()
    {
        //When
        let humidity = Presenter.presentHumidity(value: (TestWeatherInfo.weatherInfo.main!.humidity))
        
        //Then
        XCTAssertEqual(humidity, "48%", "humidity should be 48%")
    }
    
    func test_PresentWindSpeedValue ()
    {
        //When
        let windSpeed = Presenter.presentWindSpeed(value: (TestWeatherInfo.weatherInfo.wind!.speed))
        
        //Then
        XCTAssertEqual(windSpeed, "5.54 km/h", "windSpeed should be 5.54 km/h")
    }
    
    func test_PresentRainChanceValue ()
    {
        //When
        let rainChance = Presenter.presentHumidity(value: (TestWeatherInfo.weatherInfo.clouds!.all))
        
        //Then
        XCTAssertEqual(rainChance, "45%", "rainChance should be 45%")
    }
    
}
