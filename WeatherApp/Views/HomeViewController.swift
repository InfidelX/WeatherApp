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
    
    func loadCitiesFromPlist () {
        places = storageManager.readFromPlist(namePlist: StorageManager.StorageKeys.plist.rawValue)
        for city in places {
            let name = (city as AnyObject).value(forKey: StorageManager.StorageKeys.name.rawValue)! as! String
            let latitude = (city as AnyObject).value(forKey: StorageManager.StorageKeys.lat.rawValue)! as! String
            let longitude = (city as AnyObject).value(forKey: StorageManager.StorageKeys.lon.rawValue)! as! String
            let savedCity = City(name: name, latitude: latitude, longitude: longitude)
            cities.append(savedCity)
            citiesTableView.reloadData()

            self.anotation(for: savedCity, add: true)
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
            
            anotation(for: cities[indexPath.row], add: false)
            
            cities.remove(at: indexPath.row)
            self.places.removeObject(at: indexPath.row)
            self.storageManager.writeToPlist(namePlist: StorageManager.StorageKeys.plist.rawValue, array: self.places)
            
            for city in cities{
                anotation(for: city, add: true)
            }
            
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
    
    func setupMapView() {
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
            let location = CLLocation(latitude: locationCoordinate.latitude,
                                      longitude: locationCoordinate.longitude)
            geocoder.reverseGeocodeLocation(location) {

                (placemarks, error) -> Void in

                if let placemarks = placemarks, placemarks.count > 0 {
                    let placemark = placemarks[0]

                    guard let cityName = placemark.locality else {
                        let alert = UIAlertController(title: "Alert",
                                                      message: "No city was not found on tapped point",
                                                      preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK",
                                                      style: .default,
                                                      handler: { action in
                        }))
                        self.present(alert, animated: true, completion: nil)
                        return
                    }

                    let city = City(name: cityName,
                                latitude: "\(locationCoordinate.latitude)",
                                longitude: "\(locationCoordinate.longitude)")
                    
                    self.cities.append(city)
                    self.citiesTableView.reloadData()
                    
                    self.anotation(for: city, add: true)
                    
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

    func anotation(for city: City, add: Bool)
    {
        let lat = CLLocationDegrees.init(city.latitude)
        let lon = CLLocationDegrees.init(city.longitude)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: lat!, longitude: lon!)
        if add {
            self.mapView.addAnnotation(annotation)
        }
        else
        {
            /*
             the below commented out code, was not removing the annotation for the deleted city
             that is why i tried deleting all the annotations which worked and adding new ones
             for the cities remaining in the list
             */
            //self.mapView.removeAnnotation(annotation)
            
            self.mapView.removeAnnotations(mapView.annotations)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
