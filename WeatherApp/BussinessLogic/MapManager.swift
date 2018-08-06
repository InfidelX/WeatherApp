//
//  MapManager.swift
//  WeatherApp
//
//  Created by Jovanco Jovanovski on 8/6/18.
//  Copyright © 2018 Jovanco Jovanovski. All rights reserved.
//

import UIKit
import MapKit

class MapManager: NSObject, MKMapViewDelegate {
    
    var mapView : MKMapView? = nil
    
    init(mapView: MKMapView) {
        self.mapView = mapView
        super.init()
        self.mapView?.delegate = self
        self.setGesture()
    }
    
    public func setGesture () -> Void {
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureReconizer:)))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self as? UIGestureRecognizerDelegate
        print(self.mapView!)
        self.mapView!.addGestureRecognizer(lpgr)
    }
    
    @objc public func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        
        if gestureReconizer.state != UIGestureRecognizerState.ended {
            let touchLocation = gestureReconizer.location(in: mapView)
            let locationCoordinate = self.mapView!.convert(touchLocation, toCoordinateFrom: mapView)
            print("Tapped at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
            
            let geocoder = CLGeocoder()
            let location = CLLocation(latitude: (locationCoordinate.latitude), longitude: (locationCoordinate.longitude))
            geocoder.reverseGeocodeLocation(location) {
                
                (placemarks, error) -> Void in
                
                if let placemarks = placemarks, placemarks.count > 0 {
                    let placemark = placemarks[0]
                    //                    print(placemark.locality!)
                    //                    let address = "\(placemark.thoroughfare ?? ""), \(placemark.locality ?? ""), \(placemark.subLocality ?? ""), \(placemark.administrativeArea ?? ""), \(placemark.postalCode ?? ""), \(placemark.country ?? "")"
                    //                    print("\(address)")
                    
                    guard let city = placemark.locality else {
                        print("no city at tapped point")
                        return
                    }
                    print("\(city)")
                }
            }
            
            return
        }
        if gestureReconizer.state != UIGestureRecognizerState.began {
            return
        }
    }

}
