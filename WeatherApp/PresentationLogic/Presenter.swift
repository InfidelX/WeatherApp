//
//  File.swift
//  WeatherApp
//
//  Created by Jovanco Jovanovski on 8/7/18.
//  Copyright © 2018 Jovanco Jovanovski. All rights reserved.
//

import Foundation

class Presenter {
    public static func presentTemp(value: NSNumber) -> String {
        let result = String(format: "%d\("\u{00B0}")", value.intValue)
        return result
    }
    
    public static func presentHumidity(value: NSNumber) -> String {
        let result = "\(value)%"
        return result
    }
    
    public static func presentRainChance(value: NSNumber) -> String {
        let result = "\(value)%"
        return result
    }
    
    public static func presentWindSpeed(value: NSNumber) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        let result = formatter.string(from: value as NSNumber)! + " km/h"
        return result
    }
}
