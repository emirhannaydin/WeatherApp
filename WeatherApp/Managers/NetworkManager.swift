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
            
            return
        }
        
        AF.request(url, parameters: parameters).responseDecodable(of: Weather.self) { response in
            switch response.result {
            case .success(let weatherData):
                
                if weatherData.daily.isEmpty && weatherData.hourly.isEmpty {
                    completed(nil, .invalidData)

                } else {
                    print(url)
                    completed(weatherData, nil)
                }
            case .failure(_):
                
                if let httpStatusCode = response.response?.statusCode {
                    
                    switch httpStatusCode {
                    case 404:
                        completed(nil, .invalidResponse)

                    case 500:
                        completed(nil, .unableToComplete)

                    default:
                        completed(nil, .unableToComplete)

                    }
                } else {
                    completed(nil, .decodingError)

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

            return
        }
        
        AF.request(url, parameters: parameters).responseDecodable(of: [City].self) { response in
            switch response.result {
            case .success(let cityData):
                if cityData.isEmpty {
                    completed(nil, .invalidData)
                } else if let city = cityData.first{
                    completed(city, nil)
                }
                
            case .failure(_):
                if let httpStatusCode = response.response?.statusCode {
                    switch httpStatusCode {
                    case 404:
                        completed(nil, .invalidResponse)

                    case 500:
                        completed(nil, .unableToComplete)

                    default:
                        completed(nil, .unableToComplete)

                    }
                } else {
                    completed(nil, .decodingError)

                }
            }
        }
    }
    
    func getIcon(icon: String, completion: @escaping (Data?, ErrorMessage?) -> Void) {
        let urlString = iconURL + "\(icon)@2x.png"
        
        guard let url = URL(string: urlString) else {
            completion(nil, .invalidURL)
            return
        }
        
        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                if data.isEmpty {
                    completion(nil, .invalidData)

                } else {
                    completion(data, nil)
                }
            case .failure(_):
                if let httpStatusCode = response.response?.statusCode {
                    switch httpStatusCode {
                    case 404:
                        completion(nil, .invalidResponse)

                    case 500:
                        completion(nil, .unableToComplete)

                    default:
                        completion(nil, .unableToComplete)
                    }
                } else {
                    completion(nil, .decodingError)
                }
            }
        }
    }
}

