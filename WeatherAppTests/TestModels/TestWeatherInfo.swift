//
//  TestWeatherInfo.swift
//  WeatherAppTests
//
//  Created by Jovanco Jovanovski on 8/7/18.
//  Copyright © 2018 Jovanco Jovanovski. All rights reserved.
//

import Foundation

struct TestWeatherInfo {
    static let weatherInfo = WeatherInfo(main: WeatherInfo.Main(temp: 15.38, humidity: 48),
                                         wind: WeatherInfo.Wind(speed: 5.54),
                                         clouds: WeatherInfo.Clouds(all: 45))
}
