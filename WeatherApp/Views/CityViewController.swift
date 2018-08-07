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
    
    @IBOutlet weak var cityNameLbl: UILabel!
    @IBOutlet weak var tempValue: UILabel!
    @IBOutlet weak var humidityValue: UILabel!
    @IBOutlet weak var rainChance: UILabel!
    @IBOutlet weak var windValue: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityNameLbl.text = city.name
        fetchWeatherData()
    }
    
    func fetchWeatherData() -> Void
    {
        let requestUrl = String(format:"\(networkManager.url)&lat=\(city.latitude)&lon=\(city.longitude)&appid=\(networkManager.APIKey)&units=metric")
        
        networkManager.loadDataFor(urlString: requestUrl, withCompletion: {(response) -> () in
            print(response!)
            guard let weather = self.weatherWorker.createWeatherInfo(weather: response!) else {
                let alert = UIAlertController(title: "Error", message: "No data could be retrieved for this location", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                }))
                self.present(alert, animated: true, completion: nil)
                return
            }
            self.populateFields(with: weather)
        })
    }
    
    func populateFields(with info: WeatherInfo) -> Void
    {
        tempValue.text = Presenter.presentTemp(value: info.main!.temp)
        humidityValue.text = Presenter.presentHumidity(value: info.main!.humidity)
        rainChance.text = Presenter.presentRainChance(value: info.clouds!.all)
        windValue.text = Presenter.presentWindSpeed(value: info.wind!.speed)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
