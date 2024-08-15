//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Emirhan Aydın on 9.07.2024.
//

import Foundation

import Alamofire
import UIKit

final class NetworkManager {
    static let shared = NetworkManager()
    let baseURL = "https://api.openweathermap.org/data/2.5/"
    let reverseGeocodeURL = "https://api.openweathermap.org/geo/1.0/"
    let iconURL = "https://openweathermap.org/img/wn/"
    let viewController = WeatherScreenVC()
    
    private init() {}
    
    func getWeather(latitude: Double, longitude: Double, apiKey: String, completed: @escaping (Weather?, ErrorMessage?) -> Void) {
        let endpoint = baseURL + "onecall"
        let parameters: [String: Any] = [
            "lat": latitude,
            "lon": longitude,
            "units": "metric",
            "appid": apiKey
        ]
        
        
        guard let url = URL(string: endpoint) else {
            completed(nil, .invalidURL)
            UIViewController().presentAlert(title: "Error", message: ErrorMessage.invalidURL.rawValue, buttonTitle: "OK")
            
            return
        }
        
        AF.request(url, parameters: parameters).responseDecodable(of: Weather.self) { [self] response in
            switch response.result {
            case .success(let weatherData):
                
                if weatherData.daily.isEmpty && weatherData.hourly.isEmpty {
                    completed(nil, .invalidData)
                    viewController.presentAlert(title: "Error", message: ErrorMessage.invalidData.rawValue, buttonTitle: "OK")

                } else {
                    print(url)
                    completed(weatherData, nil)
                }
            case .failure(_):
                
                if let httpStatusCode = response.response?.statusCode {
                    
                    switch httpStatusCode {
                    case 404:
                        completed(nil, .invalidResponse)
                        viewController.presentAlert(title: "Error", message: ErrorMessage.invalidResponse.rawValue, buttonTitle: "OK")

                    case 500:
                        completed(nil, .unableToComplete)
                        viewController.presentAlert(title: "Error", message: ErrorMessage.unableToComplete.rawValue, buttonTitle: "OK")

                    default:
                        completed(nil, .unableToComplete)
                        viewController.presentAlert(title: "Error", message: ErrorMessage.unableToComplete.rawValue, buttonTitle: "OK")

                    }
                } else {
                    completed(nil, .decodingError)
                    viewController.presentAlert(title: "Error", message: ErrorMessage.decodingError.rawValue, buttonTitle: "OK")

                }
            }
        }
    }
    
    func getCityName(latitude: Double, longitude: Double, apiKey: String, completed: @escaping (City?, ErrorMessage?) -> Void) {
        let endpoint = reverseGeocodeURL + "reverse"
        let parameters: [String: Any] = [
            "lat": latitude,
            "lon": longitude,
            "limit": 1,
            "appid": apiKey
        ]
        
        guard let url = URL(string: endpoint) else {
            completed(nil, .invalidURL)
            viewController.presentAlert(title: "Error", message: ErrorMessage.invalidURL.rawValue, buttonTitle: "OK")

            return
        }
        
        AF.request(url, parameters: parameters).responseDecodable(of: [City].self) { [self] response in
            switch response.result {
            case .success(let cityData):
                if cityData.isEmpty {
                    completed(nil, .invalidData)
                    viewController.presentAlert(title: "Error", message: ErrorMessage.invalidData.rawValue, buttonTitle: "OK")
                } else if let city = cityData.first{
                    completed(city, nil)
                }
                
            case .failure(_):
                if let httpStatusCode = response.response?.statusCode {
                    switch httpStatusCode {
                    case 404:
                        completed(nil, .invalidResponse)
                        viewController.presentAlert(title: "Error", message: ErrorMessage.invalidResponse.rawValue, buttonTitle: "OK")

                    case 500:
                        completed(nil, .unableToComplete)
                        viewController.presentAlert(title: "Error", message: ErrorMessage.unableToComplete.rawValue, buttonTitle: "OK")

                    default:
                        completed(nil, .unableToComplete)
                        viewController.presentAlert(title: "Error", message: ErrorMessage.unableToComplete.rawValue, buttonTitle: "OK")

                    }
                } else {
                    completed(nil, .decodingError)
                    viewController.presentAlert(title: "Error", message: ErrorMessage.decodingError.rawValue, buttonTitle: "OK")

                }
            }
        }
    }
    
    func getIcon(icon: String, completion: @escaping (Data?, ErrorMessage?) -> Void) {
        let urlString = iconURL + "\(icon)@2x.png"
        
        guard let url = URL(string: urlString) else {
            completion(nil, .invalidURL)
            viewController.presentAlert(title: "Error", message: ErrorMessage.invalidURL.rawValue, buttonTitle: "OK")
            return
        }
        
        AF.request(url).responseData { [self] response in
            switch response.result {
            case .success(let data):
                if data.isEmpty {
                    completion(nil, .invalidData)
                    viewController.presentAlert(title: "Error", message: ErrorMessage.invalidData.rawValue, buttonTitle: "OK")

                } else {
                    completion(data, nil)
                }
            case .failure(_):
                if let httpStatusCode = response.response?.statusCode {
                    switch httpStatusCode {
                    case 404:
                        completion(nil, .invalidResponse)
                        viewController.presentAlert(title: "Error", message: ErrorMessage.invalidResponse.rawValue, buttonTitle: "OK")

                    case 500:
                        completion(nil, .unableToComplete)
                        viewController.presentAlert(title: "Error", message: ErrorMessage.unableToComplete.rawValue, buttonTitle: "OK")

                    default:
                        completion(nil, .unableToComplete)
                        viewController.presentAlert(title: "Error", message: ErrorMessage.unableToComplete.rawValue, buttonTitle: "OK")
                    }
                } else {
                    completion(nil, .decodingError)
                    viewController.presentAlert(title: "Error", message: ErrorMessage.decodingError.rawValue, buttonTitle: "OK")
                }
            }
        }
    }
}

