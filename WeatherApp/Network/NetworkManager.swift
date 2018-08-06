//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Jovanco Jovanovski on 8/6/18.
//  Copyright © 2018 Jovanco Jovanovski. All rights reserved.
//

import UIKit

class NetworkManager: NSObject {
    let APIKey = "d73fa2dad9fa3922244547ceefe6b8ac"
    let url = "http://api.openweathermap.org/data/2.5/weather?"
    
    let session = URLSession(configuration: .ephemeral, delegate: nil, delegateQueue: OperationQueue.main)
    
    func loadDataFor(urlString: String, withCompletion completion: @escaping (_ resourceData : AnyObject?) -> Void) {
        let url = URL(string: urlString)!
        let task = session.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            guard let data = data else {
                completion(nil)
                return
            }
            guard let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as AnyObject else {
                completion(nil)
                return
            }
            completion(json)
        })
        task.resume()
    }
}
