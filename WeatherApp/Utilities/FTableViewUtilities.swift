//
//  FTableViewUtilities.swift
//  WeatherApp
//
//  Created by Emirhan Aydın on 23.07.2024.
//

import UIKit

extension FavoritesVC: UITableViewDelegate, UITableViewDataSource {
 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     return favoritesCity.count
 }
 
 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "favoritesCell", for: indexPath)
     cell.textLabel?.text = favoritesCity[indexPath.row]
     return cell
 }
 
 func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
     return .delete
 }
 
 func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
         
         favoritesCity.remove(at: indexPath.row)
         
         let defaults = UserDefaults.standard
         defaults.set(favoritesCity, forKey: "favoriteCities")
         
         NotificationCenter.default.post(name: Notification.Name("FavoriteCityRemoved"), object: nil)
         
         
         tableView.beginUpdates()
         tableView.deleteRows(at: [indexPath], with: .fade)
         tableView.endUpdates()
     }
 }
 
 func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

     let weatherScreenVC = WeatherScreenVC()
     let defaults = UserDefaults.standard
     
     if let cityCoordinates = defaults.dictionary(forKey: "cityCoordinates") as? [String: [String: Double]] {
         
         if let coordinates = cityCoordinates[favoritesCity[indexPath.row]] {
             weatherScreenVC.viewModel.isSearch = true
             weatherScreenVC.viewModel.apiKey = LoginScreenVC.apiTextField.text!
             weatherScreenVC.viewModel.getWeather(latitude: coordinates["latitude"] ?? 0, longitude: coordinates["longitude"] ?? 0)
             self.navigationController?.pushViewController(weatherScreenVC, animated: true)
             
             
         }
     }
 }
    
    
}
