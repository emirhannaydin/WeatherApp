//
//  WAHourlyCell.swift
//  WeatherApp
//
//  Created by Emirhan Aydın on 11.07.2024.
//

import UIKit

final class WSCollectionViewCell: UICollectionViewCell {
    static let identifier = "HourlyCell"
    
    let hoursLabel = UILabel()
    let weatherIcon = UIImageView()
    let degree = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func unixToDayForCompare(unixTime: Int) ->String{
        let date = Date(timeIntervalSince1970: TimeInterval(unixTime))
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH"
            
            let hourString = dateFormatter.string(from: date)
            return hourString
    }
    
    private func unixToDay(unixTime : Int) -> String{
        let date = Date(timeIntervalSince1970: TimeInterval(unixTime))
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            
            let hourString = dateFormatter.string(from: date)
            return hourString
    }
    
    func setup(model: Hourly){
        var hour = unixToDayForCompare(unixTime: model.dt)
        let currentUnixTime = unixToDayForCompare(unixTime: Int(Date().timeIntervalSince1970))
        
        if hour == currentUnixTime {
               hoursLabel.text = "Now"
           } else {
               hour = unixToDay(unixTime: model.dt)
               hoursLabel.text = hour
           }
        
        let imageID = model.weather[0].icon
        getIcon(icon: imageID)
        
        let hourlyDegree = Int(model.temp)
        
        
        degree.text = String(hourlyDegree) + "°"


    }
    
    func getIcon(icon : String){
        NetworkManager.shared.getIcon(icon: icon) { [weak self] data, errorMessage in
            
            if let errorMessage = errorMessage {
                        DispatchQueue.main.async {
                            print("Error: \(errorMessage.rawValue)")
                        }
                        return
            }
            if let data = data {
                DispatchQueue.main.async {
                    self?.weatherIcon.image = UIImage(data: data)
                        }
                    }
                
        }

    }
    
    private func configure() {
        addSubview(hoursLabel)
        addSubview(weatherIcon)
        addSubview(degree)
        
        hoursLabel.translatesAutoresizingMaskIntoConstraints = false
        weatherIcon.translatesAutoresizingMaskIntoConstraints = false
        degree.translatesAutoresizingMaskIntoConstraints = false

        hoursLabel.textAlignment = .center
        degree.textAlignment = .center
        degree.textAlignment = .center
    

        
        NSLayoutConstraint.activate([
            hoursLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            hoursLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 27),
            hoursLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -25),
            hoursLabel.heightAnchor.constraint(equalToConstant: 25),
            
            weatherIcon.topAnchor.constraint(equalTo: hoursLabel.bottomAnchor, constant: 5),
            weatherIcon.centerXAnchor.constraint(equalTo: hoursLabel.centerXAnchor),
            weatherIcon.heightAnchor.constraint(equalToConstant: 30),
            weatherIcon.widthAnchor.constraint(equalToConstant: 30),
            
            degree.topAnchor.constraint(equalTo: weatherIcon.bottomAnchor, constant: 5),
            degree.centerXAnchor.constraint(equalTo: hoursLabel.centerXAnchor),
            degree.heightAnchor.constraint(equalToConstant: 25)
            
            
            
        ])
    }
}
