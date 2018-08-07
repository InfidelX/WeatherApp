//
//  ModelsWorker.swift
//  WeatherApp
//
//  Created by Jovanco Jovanovski on 8/6/18.
//  Copyright © 2018 Jovanco Jovanovski. All rights reserved.
//

import UIKit

class ModelsWorker: NSObject
{
    enum ServerKeys: String
    {
        case main = "main"
        case temp = "temp"
        case humidity = "humidity"
        
        case wind = "wind"
        case speed = "speed"
        
        case clouds = "clouds"
        case all = "all"
    }
    
    func createWeatherInfo(weather: AnyObject) -> WeatherInfo?
    {
        let main = weather.object(forKey: ServerKeys.main.rawValue) as AnyObject
        let temp = main.object(forKey: ServerKeys.temp.rawValue) as! NSNumber
        let humidity = main.object(forKey: ServerKeys.humidity.rawValue) as! NSNumber
        
        let wind = weather.object(forKey: ServerKeys.wind.rawValue) as AnyObject
        let speed = wind.object(forKey: ServerKeys.speed.rawValue) as! NSNumber
        
        let clouds = weather.object(forKey: ServerKeys.clouds.rawValue) as AnyObject
        let all = clouds.object(forKey: ServerKeys.all.rawValue) as! NSNumber
        
        let mainInfo = WeatherInfo.Main(temp: temp, humidity: humidity)
        let windInfo = WeatherInfo.Wind(speed: speed)
        let cloudsInfo = WeatherInfo.Clouds(all: all)
        
        let info = WeatherInfo(main: mainInfo, wind: windInfo, clouds: cloudsInfo)
        
        return info
    }
}
