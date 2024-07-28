//
//  DailyWeatherScreenVM.swift
//  WeatherApp
//
//  Created by Emirhan Aydın on 22.07.2024.
//

import Foundation

protocol DailyVMInterface {
    var view: DailyWeatherVCInterface? { get set }
    func viewDidLoad()
}

final class DailyWeatherScreenVM {
    weak var view: DailyWeatherVCInterface?
    var dayWeather: Daily?

    
    func getIcon(icon: String) {
        NetworkManager.shared.getIcon(icon: icon) { [weak self] data, errorMessage in
            
            if let errorMessage = errorMessage {
                        DispatchQueue.main.async {
                            self?.view?.presentAlertOnMainThread(title: "Error", message: errorMessage.rawValue, buttonTitle: "OK")
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

extension DailyWeatherScreenVM: DailyVMInterface {
    func viewDidLoad() {
        view?.prepareIconStackView()
        view?.prepareFirstStackView()
        view?.prepareFirstStackView()
        view?.prepareSecondStackView()
        view?.prepareThirdStackView()
        view?.prepareViewWithWeather(weather: dayWeather!)
    }
    
    
}
