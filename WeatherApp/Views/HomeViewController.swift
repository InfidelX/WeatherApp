//
//  HomeViewController.swift
//  WeatherApp
//
//  Created by Jovanco Jovanovski on 8/6/18.
//  Copyright © 2018 Jovanco Jovanovski. All rights reserved.
//

import UIKit
import MapKit

class HomeViewController: UIViewController, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var citiesTableView: UITableView!
    
    var cities = [City]()
    var selectedCity: City?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        setupMapView()
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
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        
//        let controller = storyboard.instantiateViewController(withIdentifier: "CityViewController") as! CityViewController
//        
//        self.navigationController?.pushViewController(controller, animated: true)
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
        lpgr.delegate = self as? UIGestureRecognizerDelegate
        self.mapView.addGestureRecognizer(lpgr)
//        let mapManager = MapManager(mapView: self.mapView)
        
//        mapManager.mapView = self.mapView
//        self.mapView.delegate = mapManager
//        mapManager.setGesture()
    }
//
    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state != UIGestureRecognizerState.ended {
            let touchLocation = gestureReconizer.location(in: mapView)
            let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
            print("Tapped at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")

            let geocoder = CLGeocoder()
            let location = CLLocation(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
            geocoder.reverseGeocodeLocation(location) {

                (placemarks, error) -> Void in

                if let placemarks = placemarks, placemarks.count > 0 {
                    let placemark = placemarks[0]
//                    print(placemark.locality!)
//                    let address = "\(placemark.thoroughfare ?? ""), \(placemark.locality ?? ""), \(placemark.subLocality ?? ""), \(placemark.administrativeArea ?? ""), \(placemark.postalCode ?? ""), \(placemark.country ?? "")"
//                    print("\(address)")

                    guard let cityName = placemark.locality else {
                        print("no city at tapped point")
                        return
                    }
                    let city = City(name: cityName, latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
                    print("\(city.name)")
                    self.cities.append(city)
                    self.citiesTableView.reloadData()
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
