//
//  TableViewUtilities.swift
//  WeatherApp
//
//  Created by Emirhan Aydın on 11.07.2024.
//

import UIKit

extension WeatherScreenVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.days.count - 1 // 8 gün döndüğü için 7 ye çekiyoruz
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WATableViewCell.identifier, for: indexPath) as! WATableViewCell
        
        let model = viewModel.days[indexPath.row]
        
        cell.setup(model: model)
        cell.backgroundColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? .black : UIColor(red: 238/255, green: 248/255, blue: 255/255, alpha: 1.0)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dailyWeatherVC = DailyWeatherScreenVC()
        dailyWeatherVC.viewModel.dayWeather = viewModel.days[indexPath.row]
        dailyWeatherVC.modalPresentationStyle = .pageSheet
            
            self.present(dailyWeatherVC, animated: true, completion: nil)
    }
}
