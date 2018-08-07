//
//  HomeViewController.swift
//  WeatherApp
//
//  Created by Jovanco Jovanovski on 8/6/18.
//  Copyright © 2018 Jovanco Jovanovski. All rights reserved.
//

import UIKit
import MapKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var citiesTableView: UITableView!
    
    let storageManager = StorageManager()
    var cities = [City]()
    var selectedCity: City?
    var places: NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        setupMapView()
        loadCitiesFromPlist()
    }
    
    func loadCitiesFromPlist () -> Void {
        
        places = storageManager.readFromPlist(namePlist: StorageManager.StorageKeys.plist.rawValue)
        for city in places {
            let name = (city as AnyObject).value(forKey: StorageManager.StorageKeys.name.rawValue)! as! String
            let latDouble = (city as AnyObject).value(forKey: StorageManager.StorageKeys.lat.rawValue)!
            let lonDouble = (city as AnyObject).value(forKey: StorageManager.StorageKeys.lon.rawValue)!
            let lat = CLLocationDegrees.init((latDouble as AnyObject).doubleValue)
            let lon = CLLocationDegrees.init((lonDouble as AnyObject).doubleValue)
            let savedCity = City(name: name, latitude: lat, longitude: lon)
            cities.append(savedCity)
            citiesTableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "")
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = cities[indexPath.row].name
        return cell
    }
    
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            cities.remove(at: indexPath.row)
            self.places.removeObject(at: indexPath.row)
            self.storageManager.writeToPlist(namePlist: StorageManager.StorageKeys.plist.rawValue, array: self.places)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCity = cities[indexPath.row]
        performSegue(withIdentifier: "showCity", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.navigationController?.isNavigationBarHidden = false
        let cityViewController = segue.destination as! CityViewController
        cityViewController.city = selectedCity
    }
    
    func setupMapView(){
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureReconizer:)))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        self.mapView.addGestureRecognizer(lpgr)
    }

    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state != UIGestureRecognizerState.ended {
            let touchLocation = gestureReconizer.location(in: mapView)
            let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
            
            let geocoder = CLGeocoder()
            let location = CLLocation(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
            geocoder.reverseGeocodeLocation(location) {

                (placemarks, error) -> Void in

                if let placemarks = placemarks, placemarks.count > 0 {
                    let placemark = placemarks[0]

                    guard let cityName = placemark.locality else {
                        let alert = UIAlertController(title: "Alert", message: "No city was not found on tapped point", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        }))
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                    let city = City(name: cityName, latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
                    self.cities.append(city)
                    self.citiesTableView.reloadData()
                    
                    let cityDict = [StorageManager.StorageKeys.name.rawValue:cityName,
                                    StorageManager.StorageKeys.lat.rawValue:"\(locationCoordinate.latitude)",
                                    StorageManager.StorageKeys.lon.rawValue:"\(locationCoordinate.longitude)"]
                    
                    self.places.add(cityDict)
                    self.storageManager.writeToPlist(namePlist: StorageManager.StorageKeys.plist.rawValue, array: self.places)
                }
            }

            return
        }
        if gestureReconizer.state != UIGestureRecognizerState.began {
            return
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
