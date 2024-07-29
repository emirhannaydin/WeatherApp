//
//  WATableViewCell.swift
//  WeatherApp
//
//  Created by Emirhan Aydın on 10.07.2024.
//

import UIKit

class WSTableViewCell: UITableViewCell {
    static let identifier = "DailyCell"

    
    var dayLabel = UILabel()
    var minTempLabel = UILabel()
    var maxTempLabel = UILabel()
    var tempImageView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setup(model: Daily) {
        let min = Int(model.temp.min)
        let max = Int(model.temp.max)
        
        minTempLabel.text = "\(min)°"
        maxTempLabel.text = "\(max)°"
        
        let date = Date(timeIntervalSince1970: TimeInterval(model.dt))
        
        if Calendar.current.isDateInToday(date) {
            dayLabel.text = "Today"
            if dayLabel.text == "Today"{
                dayLabel.textColor = UIColor.systemBlue
            }
            dayLabel.font = UIFont.boldSystemFont(ofSize: dayLabel.font.pointSize)

        } else {
            let component = Calendar.current.component(.weekday, from: date)
            let day = Calendar.current.weekdaySymbols[component - 1]
            dayLabel.text = day
        }
        
        let imageID = model.weather[0].icon
        getIcon(icon: imageID)
    }

    
    
    func getIcon(icon : String){
        if let url = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png") {
                    URLSession.shared.dataTask(with: url) { data, response, error in
                        if let data = data, error == nil {
                            DispatchQueue.main.async {
                                self.tempImageView.image = UIImage(data: data)
                            }
                        }
                    }
                    .resume()
                }
    }
    
    private func configure(){
        
        contentView.addSubview(dayLabel)
        contentView.addSubview(minTempLabel)
        contentView.addSubview(maxTempLabel)
        contentView.addSubview(tempImageView)
        

        maxTempLabel.textAlignment = .center
        minTempLabel.textAlignment = .center
        
        minTempLabel.textColor = .systemGray2
        
        tempImageView.contentMode = .scaleAspectFit
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        minTempLabel.translatesAutoresizingMaskIntoConstraints = false
        maxTempLabel.translatesAutoresizingMaskIntoConstraints = false
        tempImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            minTempLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            minTempLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            minTempLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            minTempLabel.widthAnchor.constraint(equalToConstant: 50),
            
            maxTempLabel.trailingAnchor.constraint(equalTo: minTempLabel.leadingAnchor),
            maxTempLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            maxTempLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            maxTempLabel.widthAnchor.constraint(equalToConstant: 50),
            
            tempImageView.trailingAnchor.constraint(equalTo: maxTempLabel.leadingAnchor, constant: -10),
            tempImageView.widthAnchor.constraint(equalToConstant: 40),
            tempImageView.heightAnchor.constraint(equalToConstant: 40),
            tempImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            dayLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 5),
            dayLabel.trailingAnchor.constraint(equalTo: tempImageView.leadingAnchor),
            dayLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            
            
        ])
        
    }
    
    
    
    
}
