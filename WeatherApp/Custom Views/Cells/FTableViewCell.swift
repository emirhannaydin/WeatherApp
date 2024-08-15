//
//  FTableViewCell.swift
//  WeatherApp
//
//  Created by Emirhan Aydın on 29.07.2024.
//

import UIKit

final class FTableViewCell: UITableViewCell {
    
    static let identifier = "FavoriteCell"
    
    let cityLabel = UILabel()
    let celciusLabel = UILabel()
    let iconDescription = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(model: CurrentWeather){
        let temp = Int(model.temp)
        celciusLabel.text = "\(temp)°"
        let imageID = model.weather[0].icon
        getIcon(icon: imageID)
        
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
                    self?.iconDescription.image = UIImage(data: data)
                        }
                    }
                
        }

    }
    func configure() {
        contentView.addSubview(cityLabel)
        contentView.addSubview(iconDescription)
        contentView.addSubview(celciusLabel)
        iconDescription.contentMode = .scaleAspectFit
        cityLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        celciusLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        
        cityLabel.translatesAutoresizingMaskIntoConstraints = false
        iconDescription.translatesAutoresizingMaskIntoConstraints = false
        celciusLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            celciusLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            celciusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            celciusLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            celciusLabel.widthAnchor.constraint(equalToConstant: 50),
            
            iconDescription.topAnchor.constraint(equalTo: contentView.topAnchor),
            iconDescription.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            iconDescription.trailingAnchor.constraint(equalTo: celciusLabel.leadingAnchor, constant: -10),
            iconDescription.widthAnchor.constraint(equalToConstant: 50),
            
            cityLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            cityLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            cityLabel.trailingAnchor.constraint(equalTo: iconDescription.leadingAnchor),
            cityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5)
        ])
    }
    
}
