//
//  Weather.swift
//  WeatherApp
//
//  Created by Jovanco Jovanovski on 8/6/18.
//  Copyright © 2018 Jovanco Jovanovski. All rights reserved.
//

import Foundation

struct WeatherInfo {
    
    var main: Main?
    var wind: Wind?
    var clouds: Clouds?
    
    
    struct Main
    {
        let temp: NSNumber
        let humidity: NSNumber
    }
    
    struct Wind
    {
        let speed: NSNumber
    }
    struct Clouds {
        let all: NSNumber
        
    }
    
    init(main: Main, wind: Wind, clouds: Clouds) {
        self.main = main
        self.wind = wind
        self.clouds = clouds
    }
}
