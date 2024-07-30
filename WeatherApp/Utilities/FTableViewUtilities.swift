//
//  FTableViewUtilities.swift
//  WeatherApp
//
//  Created by Emirhan Aydın on 23.07.2024.
//

import UIKit
import CoreLocation


extension FavoritesVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesCity.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FTableViewCell.identifier, for: indexPath) as! FTableViewCell
        let city = favoritesCity[indexPath.row]

        
        cell.cityLabel.text = city
        
        if let coordinates = getCoordinates(for: city) {
            NetworkManager.shared.getWeather(latitude: coordinates.latitude, longitude: coordinates.longitude, apiKey: LoginScreenVC.apiTextField.text ?? "") { [weak self] weatherData, errorMessage in
                if let errorMessage = errorMessage {
                    DispatchQueue.main.async {
                        self?.presentAlert(title: "Error", message: errorMessage.rawValue, buttonTitle: "OK")
                    }
                    return
                }
                
                guard let weatherData = weatherData else {
                    DispatchQueue.main.async {
                        self?.presentAlert(title: "Error", message: "No weather data found.", buttonTitle: "OK")
                    }
                    return
                }
                
                DispatchQueue.main.async {
                    cell.setup(model: weatherData.current)
                    cell.celciusLabel.text = "\(Int(weatherData.current.temp))°"
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            favoritesCity.remove(at: indexPath.row)
            
            let defaults = UserDefaults.standard
            let updatedFavorites = favoritesCity
            defaults.set(updatedFavorites, forKey: "favoriteCities")
            
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            
            NotificationCenter.default.post(name: Notification.Name("FavoriteCityRemoved"), object: nil)
        }
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let city = favoritesCity[indexPath.row]
            
            let weatherScreenVC = WeatherScreenVC()
            
            if let coordinates = getCoordinates(for: city) {
                weatherScreenVC.viewModel.isSearch = true
                weatherScreenVC.viewModel.apiKey = LoginScreenVC.apiTextField.text!
                
                weatherScreenVC.viewModel.getWeather(latitude: coordinates.latitude, longitude: coordinates.longitude)
                
                self.navigationController?.pushViewController(weatherScreenVC, animated: true)
            } else {
                print("Koordinatlar bulunamadı.")
            }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    private func getCoordinates(for city: String) -> (latitude: Double, longitude: Double)? {
            let defaults = UserDefaults.standard
            if let cityCoordinates = defaults.dictionary(forKey: "cityCoordinates") as? [String: [String: Double]] {
                if let coordinates = cityCoordinates[city] {
                    let latitude = coordinates["latitude"] ?? 0
                    let longitude = coordinates["longitude"] ?? 0
                    return (latitude, longitude)
                }
            }
            return nil
        }
    }
    

