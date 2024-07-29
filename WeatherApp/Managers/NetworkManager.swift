//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Emirhan Aydın on 9.07.2024.
//

import Foundation
import CoreLocation
import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    let baseURL = "https://api.openweathermap.org/data/3.0/"
    let reverseGeocodeURL = "https://api.openweathermap.org/geo/1.0/reverse"
    let viewController = WeatherScreenVC()
    
    private init() {}
    
    func getWeather(latitude: Double, longitude: Double, apiKey: String, completed: @escaping (Weather?, ErrorMessage?) -> Void) {
        let endpoint = baseURL + "onecall?lat=\(latitude)&lon=\(longitude)&units=metric&appid=\(apiKey)"
        
        guard let url = URL(string: endpoint) else {
            completed(nil, .invalidURL)
            viewController.presentAlertOnMainThread(title: "Error", message: ErrorMessage.invalidURL.rawValue, buttonTitle: "OK")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completed(nil, .unableToComplete)
                self.viewController.presentAlertOnMainThread(title: "Error", message: ErrorMessage.unableToComplete.rawValue, buttonTitle: "OK")
                return
                
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(nil, .invalidResponse)
                self.viewController.presentAlertOnMainThread(title: "Error", message: ErrorMessage.invalidResponse.rawValue, buttonTitle: "OK")

                return
            }
            
            guard let data = data else {
                completed(nil, .invalidData)
                self.viewController.presentAlertOnMainThread(title: "Error", message: ErrorMessage.invalidData.rawValue, buttonTitle: "OK")

                return
            }
            
            do {
                let decoder = JSONDecoder()
                let weatherData = try decoder.decode(Weather.self, from: data)
                completed(weatherData, nil)
            } catch {
                completed(nil, .decodingError)
                self.viewController.presentAlertOnMainThread(title: "Error", message: ErrorMessage.decodingError.rawValue, buttonTitle: "OK")
            }
        }
        print(url)
        task.resume()
    }
    
    func getCityName(latitude: Double, longitude: Double, apiKey: String, completed: @escaping (City?, ErrorMessage?) -> Void) {
        let endpoint = "\(reverseGeocodeURL)?lat=\(latitude)&lon=\(longitude)&limit=1&appid=\(apiKey)"
        print("Request URL: \(endpoint)")
        
        guard let url = URL(string: endpoint) else {
            completed(nil, .invalidURL)
            self.viewController.presentAlertOnMainThread(title: "Error", message: ErrorMessage.invalidURL.rawValue, buttonTitle: "OK")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completed(nil, .unableToComplete)
                self.viewController.presentAlertOnMainThread(title: "Error", message: ErrorMessage.unableToComplete.rawValue, buttonTitle: "OK")
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(nil, .invalidResponse)
                self.viewController.presentAlertOnMainThread(title: "Error", message: ErrorMessage.invalidResponse.rawValue, buttonTitle: "OK")
                return
            }
            
            guard let data = data else {
                self.viewController.presentAlertOnMainThread(title: "Error", message: ErrorMessage.invalidData.rawValue, buttonTitle: "OK")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let cityData = try decoder.decode([City].self, from: data)
                if let city = cityData.first {
                    completed(city, nil)
                } else {
                    completed(nil, .decodingError)
                    self.viewController.presentAlertOnMainThread(title: "Error", message: ErrorMessage.decodingError.rawValue, buttonTitle: "OK")
                }
            } catch {
                completed(nil, .decodingError)
                self.viewController.presentAlertOnMainThread(title: "Error", message: ErrorMessage.decodingError.rawValue, buttonTitle: "OK")
            }
        }
        task.resume()
    }

    
    func getIcon(icon: String, completion: @escaping (Data?, ErrorMessage?) -> Void) {
        if let url = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png") {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if error != nil {
                    completion(nil, .unableToComplete)
                    DispatchQueue.main.async {
                        self.viewController.presentAlertOnMainThread(title: "Error", message: ErrorMessage.unableToComplete.rawValue, buttonTitle: "OK")
                    }
                    return
                }
                
                guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                    completion(nil, .invalidResponse)
                    DispatchQueue.main.async {
                        self.viewController.presentAlertOnMainThread(title: "Error", message: ErrorMessage.invalidResponse.rawValue, buttonTitle: "OK")
                    }
                    return
                }
                
                guard let data = data else {
                    completion(nil, .invalidData)
                    DispatchQueue.main.async {
                        self.viewController.presentAlertOnMainThread(title: "Error", message: ErrorMessage.invalidData.rawValue, buttonTitle: "OK")
                    }
                    return
                }
                
                completion(data, nil)
            }
            task.resume()
        } else {
            completion(nil, .invalidURL)
            DispatchQueue.main.async {
                self.viewController.presentAlertOnMainThread(title: "Error", message: ErrorMessage.invalidURL.rawValue, buttonTitle: "OK")
            }
        }
        
        
    }
}
