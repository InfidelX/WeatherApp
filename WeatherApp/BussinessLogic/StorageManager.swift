//
//  MapManager.swift
//  WeatherApp
//
//  Created by Jovanco Jovanovski on 8/6/18.
//  Copyright © 2018 Jovanco Jovanovski. All rights reserved.
//

import UIKit
import MapKit

class StorageManager: NSObject {
    
    enum StorageKeys: String {
        case plist = "Places"
        case name = "Name"
        case lat = "Lat"
        case lon = "Lon"
    }
    
    func readFromPlist(namePlist: String) -> NSMutableArray
    {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths.object(at: 0) as! NSString
        let path = documentsDirectory.appendingPathComponent(namePlist+".plist")
        guard let array = NSMutableArray(contentsOfFile: path) else
        {
            return []
        }
        return array
    }
    
    func writeToPlist(namePlist: String, array: NSMutableArray) {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = paths.object(at: 0) as! NSString
        let path = documentsDirectory.appendingPathComponent(namePlist+".plist")
        array.write(toFile: path, atomically: false)
        
    }
}
