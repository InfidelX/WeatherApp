//
//  CityViewController.swift
//  WeatherApp
//
//  Created by Jovanco Jovanovski on 8/6/18.
//  Copyright © 2018 Jovanco Jovanovski. All rights reserved.
//

import UIKit

class CityViewController: UIViewController {
    
    let networkManager = NetworkManager()
    let weatherWorker = ModelsWorker()
    var city: City!
    var weatherInfo: WeatherInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("city: \(city.name) with lat:\(city.latitude) long:\(city.longitude)")
        let url = String(format:"\(networkManager.url)&lat=\(city.latitude)&lon=\(city.longitude)&appid=\(networkManager.APIKey)&units=metric")
        print("url: \(url)")
        networkManager.loadDataFor(urlString: url, withCompletion: {(response) -> () in
            self.weatherInfo = self.weatherWorker.createWeatherInfo(weather: response!)
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
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
