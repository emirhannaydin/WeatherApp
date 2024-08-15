//
//  WeatherScreenVM.swift
//  WeatherApp
//
//  Created by Emirhan Aydın on 22.07.2024.
//

import Foundation
import CoreLocation

protocol WeatherScreenVMInterface {
    var view: WeatherVCInterface? { get set }
    
    func viewDidLoad()
}

final class WeatherScreenVM {
    weak var view: WeatherVCInterface?
    
    var apiKey = String()
    var days : [Daily] = []
    var hours: [Hourly] = []
    var isSearch: Bool = false
    var locationManager = CLLocationManager()
    var searchCoordinate = CLLocationCoordinate2D()
    
    var currentLatitude = Double()
    var currentLongitude = Double()
    
   
    func getCityName(latitude: Double, longitude: Double) {

        NetworkManager.shared.getCityName(latitude: latitude, longitude: longitude, apiKey: apiKey) { [weak self] city, errorMessage in
            if let errorMessage = errorMessage {
                print("Error: \(errorMessage.rawValue)")
                self?.view?.presentAlertOnViewModel(title: "Error", message: errorMessage.rawValue, buttonTitle: "OK")

                return
            }
            
            guard let city = city else {
                self?.view?.presentAlertOnViewModel(title: "Error", message: "No weather data found.", buttonTitle: "OK")

                return
            }
            
            self?.view?.changeCityLabel(city: city)
            

        }
    }
    
    func getWeather(latitude: Double, longitude: Double) {
        view?.startIndicator()

        
        NetworkManager.shared.getWeather(latitude: latitude, longitude: longitude, apiKey: apiKey) { [weak self] weather, errorMessage in
            if let errorMessage = errorMessage {
                print("Error: \(errorMessage.rawValue)")
                self?.view?.presentAlertOnViewModel(title: "Error", message: errorMessage.rawValue, buttonTitle: "OK")
                return
            }
            
            guard let weather = weather else {
                self?.view?.presentAlertOnViewModel(title: "Error", message: "No weather data found.", buttonTitle: "OK")
                return
            }
            
            self?.view?.changeUI(weather: weather, lat: latitude, lon: longitude)
            self?.days = weather.daily
            self?.hours = weather.hourly
            self?.currentLatitude = latitude
            self?.currentLongitude = longitude
            
        }
    }
    
    
    
    func getIcon(icon: String) {
        NetworkManager.shared.getIcon(icon: icon) { [weak self] data, errorMessage in
            
            if let errorMessage = errorMessage {
                        DispatchQueue.main.async {
                            self?.view?.presentAlertOnViewModel(title: "Error", message: errorMessage.rawValue, buttonTitle: "OK")
                        }
                        return
            }
            if let data = data {
                DispatchQueue.main.async {
                    self?.view?.changeImage(data: data)
                        }
                    }
                
        }
    }
}

extension WeatherScreenVM: WeatherScreenVMInterface {
    
    func viewDidLoad() {
        view?.setupLocationManager()
        view?.prepareCollectionView()
        view?.prepareTableView()
        view?.prepareIconStackView()
        view?.prepareFirstParameterStackView()
        view?.prepareSecondParameterStackView()
        view?.prepareThirdParameterStackView()
        view?.prepareCombineStackView()
    }
}
