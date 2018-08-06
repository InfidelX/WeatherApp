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
    
    weak var homeViewController: HomeViewController!
    
    init(viewController: HomeViewController) {
        self.homeViewController = viewController
    }
    
    public func setGesture () -> Void {
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(self.homeViewController.handleLongPress(gestureReconizer:)) )
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self.homeViewController
        self.homeViewController.mapView!.addGestureRecognizer(lpgr)
    }
    
    @objc private func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        
        if gestureReconizer.state != UIGestureRecognizerState.ended {
            let touchLocation = gestureReconizer.location(in: self.homeViewController.mapView!)
            let locationCoordinate = self.homeViewController.mapView!.convert(touchLocation, toCoordinateFrom: self.homeViewController.mapView!)
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
