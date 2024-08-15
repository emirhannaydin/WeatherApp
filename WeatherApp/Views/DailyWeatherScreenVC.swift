//
//  DailyWeatherScreenVC.swift
//  WeatherApp
//
//  Created by Emirhan Aydın on 19.07.2024.
//

import UIKit

protocol DailyWeatherVCInterface: AnyObject {
    func prepareViewWithWeather(weather: Daily)
    func prepareIconStackView()
    func prepareFirstStackView()
    func prepareSecondStackView()
    func prepareThirdStackView()
    func changeImage(data: Data)
    func presentAlertOnMainThread(title: String, message: String, buttonTitle: String)
    func prepareHumidityStackView()
    func prepareFeelsLikeStackView()

}

final class DailyWeatherScreenVC: UIViewController {
    lazy var viewModel = DailyWeatherScreenVM()
    
    let gif = UIImageView()
    let dayTimeLabel = WALabel(textAlignment: .center)
    let celciusLabel = WALabel(textAlignment: .center)
    let logoImage = UIImageView()
    let logoImageDescription = WALabel(textAlignment: .center)
    let minTempLabel = UILabel()
    let maxTempLabel = UILabel()
    let humidityParameter = UILabel()
    let feelsLikeParameter = UILabel()
    let windSpeedParameter = UILabel()
    let windDirectionParameter = UILabel()
    let iconStackView = UIStackView()
    let firstStackView = UIStackView()
    let secondStackView = UIStackView()
    let thirdStackView = UIStackView()
    let humidityStackView = UIStackView()
    let feelsLikeStackView = UIStackView()
    let scrollView = UIScrollView()
    let contentView = UIView()
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.view = self
        viewModel.viewDidLoad()
        configureViews()
    }
    
    
    
    func configureViews(){
        view.backgroundColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? .black : UIColor(red: 175/255, green: 222/255, blue: 255/255, alpha: 0.9)
        }
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(dayTimeLabel)
        contentView.addSubview(iconStackView)
        contentView.addSubview(firstStackView)
        contentView.addSubview(secondStackView)
        contentView.addSubview(thirdStackView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        dayTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        iconStackView.translatesAutoresizingMaskIntoConstraints = false
        firstStackView.translatesAutoresizingMaskIntoConstraints = false
        secondStackView.translatesAutoresizingMaskIntoConstraints = false
        thirdStackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),

            dayTimeLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 20),
            dayTimeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            dayTimeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            dayTimeLabel.heightAnchor.constraint(equalToConstant: 50),
            
            firstStackView.topAnchor.constraint(equalTo: dayTimeLabel.bottomAnchor, constant: 5),
            firstStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            firstStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            firstStackView.heightAnchor.constraint(equalToConstant: 50),
            
            iconStackView.topAnchor.constraint(equalTo: firstStackView.bottomAnchor, constant: 5),
            iconStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            iconStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            iconStackView.heightAnchor.constraint(equalToConstant: 50),
            
            secondStackView.topAnchor.constraint(equalTo: iconStackView.bottomAnchor, constant: 5),
            secondStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            secondStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            secondStackView.heightAnchor.constraint(equalToConstant: 120),
            
            thirdStackView.topAnchor.constraint(equalTo: secondStackView.bottomAnchor, constant: 5),
            thirdStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            thirdStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            thirdStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
            
            
            
        ])
        
        gif.layer.zPosition = -1
        gif.alpha = 0
    }
    
    
}

extension DailyWeatherScreenVC: DailyWeatherVCInterface {
    
    
    func presentAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: buttonTitle, style: .default))
            self.present(alertVC, animated: true)
        }
    }
    
    
    func prepareViewWithWeather(weather: Daily) {
        let date = Date(timeIntervalSince1970: TimeInterval(weather.dt))
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "EEEE, dd/MM/yyyy"
        let formattedDate = dateFormatter.string(from: date)
        dayTimeLabel.font = UIFont.systemFont(ofSize: 18, weight: .black)

        dayTimeLabel.text = formattedDate
        celciusLabel.text = "\(Int(weather.temp.day))°C"
        minTempLabel.text = "Min: \(Int(weather.temp.min))°C"
        maxTempLabel.text = "Max: \(Int(weather.temp.max))°C"
        humidityParameter.text = "\(weather.humidity)%"
        feelsLikeParameter.text = "\(Int(weather.feels_like.day))°C"
        windSpeedParameter.text = "Speed: \(weather.wind_speed) m/s"
        windDirectionParameter.text = "Direction: \(Int(weather.wind_deg))°"
        logoImageDescription.text = weather.weather.first?.description.capitalized ?? "No description"

        if let icon = weather.weather.first?.icon {
            viewModel.getIcon(icon: icon)
        }
    }
    
    func prepareHumidityStackView() {
        let title = UILabel()
        
        humidityStackView.addArrangedSubview(title)
        humidityStackView.addArrangedSubview(humidityParameter)
     
        title.text = "༄ HUMIDITY"
        title.font = UIFont.systemFont(ofSize: 15, weight: .black)
        title.alpha = 0.6
        humidityParameter.font = UIFont.systemFont(ofSize: 20, weight: .bold)

        
        title.translatesAutoresizingMaskIntoConstraints = false
        humidityParameter.translatesAutoresizingMaskIntoConstraints = false
        title.heightAnchor.constraint(equalToConstant: 20).isActive = true
        humidityParameter.heightAnchor.constraint(equalToConstant: 60).isActive = true

        humidityStackView.axis = NSLayoutConstraint.Axis.vertical
        humidityStackView.distribution = .fill
        humidityStackView.alignment = .center
        humidityStackView.spacing = 20
        humidityStackView.layer.borderWidth = 2
        humidityStackView.layer.cornerRadius = 12
        humidityStackView.backgroundColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? .black : UIColor(red: 238/255, green: 255/255, blue: 251/255, alpha: 1.0)
        }
        humidityStackView.layer.borderColor = UIColor(red: 90/255, green: 178/255, blue: 255/255, alpha: 0.9).cgColor
    }
    
    func prepareFeelsLikeStackView() {
        let title = UILabel()
        feelsLikeStackView.addArrangedSubview(title)
        feelsLikeStackView.addArrangedSubview(feelsLikeParameter)
        
        title.text = "♨ FEELS LIKE"
        title.font = UIFont.systemFont(ofSize: 15, weight: .black)
        title.alpha = 0.6
        feelsLikeParameter.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        feelsLikeParameter.translatesAutoresizingMaskIntoConstraints = false
        title.heightAnchor.constraint(equalToConstant: 20).isActive = true
        feelsLikeParameter.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        feelsLikeStackView.axis = NSLayoutConstraint.Axis.vertical
        feelsLikeStackView.distribution = .fill
        feelsLikeStackView.alignment = .center
        feelsLikeStackView.spacing = 20.0
        feelsLikeStackView.layer.borderWidth = 2
        feelsLikeStackView.layer.cornerRadius = 12
        feelsLikeStackView.backgroundColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? .black : UIColor(red: 238/255, green: 255/255, blue: 251/255, alpha: 1.0)
        }
        feelsLikeStackView.layer.borderColor = UIColor(red: 90/255, green: 178/255, blue: 255/255, alpha: 0.9).cgColor
    }
    
    func prepareFirstStackView() {
        firstStackView.axis = NSLayoutConstraint.Axis.horizontal
        firstStackView.distribution = .fillEqually
        firstStackView.alignment = .center
        firstStackView.spacing = 15
        firstStackView.isLayoutMarginsRelativeArrangement = true
        
        minTempLabel.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        
        maxTempLabel.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        
        firstStackView.addArrangedSubview(maxTempLabel)
        firstStackView.addArrangedSubview(minTempLabel)
        maxTempLabel.textAlignment = .center
        minTempLabel.textAlignment = .center
        
        firstStackView.layer.backgroundColor = UIColor(red: 90/255, green: 178/255, blue: 255/255, alpha: 0.9).cgColor
        
        
    }
    
    func prepareSecondStackView() {
        secondStackView.axis = NSLayoutConstraint.Axis.horizontal
        secondStackView.distribution = .fillEqually
        secondStackView.alignment = .center
        secondStackView.spacing = 15
        secondStackView.layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        secondStackView.isLayoutMarginsRelativeArrangement = true
        
        secondStackView.addArrangedSubview(humidityStackView)
        secondStackView.addArrangedSubview(feelsLikeStackView)
        
    }
    
    func prepareThirdStackView() {
        let title = UILabel()
        thirdStackView.addArrangedSubview(title)
        thirdStackView.addArrangedSubview(windSpeedParameter)
        thirdStackView.addArrangedSubview(windDirectionParameter)
        
        title.text = "💨 WIND"
        title.font = UIFont.systemFont(ofSize: 15, weight: .black)
        title.alpha = 0.6
        windSpeedParameter.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        windDirectionParameter.font = UIFont.systemFont(ofSize: 20, weight: .bold)

        
        title.translatesAutoresizingMaskIntoConstraints = false
        windSpeedParameter.translatesAutoresizingMaskIntoConstraints = false
        windDirectionParameter.translatesAutoresizingMaskIntoConstraints = false
        
        title.heightAnchor.constraint(equalToConstant: 20).isActive = true
        windSpeedParameter.heightAnchor.constraint(equalToConstant: 40).isActive = true
        windDirectionParameter.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        thirdStackView.axis = NSLayoutConstraint.Axis.vertical
        thirdStackView.distribution = .fill
        thirdStackView.alignment = .center
        thirdStackView.spacing = 10.0
        thirdStackView.layer.borderWidth = 2
        thirdStackView.layer.cornerRadius = 12
        thirdStackView.backgroundColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? .black : UIColor(red: 238/255, green: 255/255, blue: 251/255, alpha: 1.0)
        }
        thirdStackView.layer.borderColor = UIColor(red: 90/255, green: 178/255, blue: 255/255, alpha: 0.9).cgColor
    }
    
    
    func changeImage(data: Data) {
        DispatchQueue.main.async {
            self.logoImage.image = UIImage(data: data)
        }
    }
    
    func prepareIconStackView() {
        iconStackView.axis = NSLayoutConstraint.Axis.horizontal
        iconStackView.distribution = .fillEqually
        iconStackView.alignment = .center
        
        iconStackView.addArrangedSubview(logoImage)
        iconStackView.addArrangedSubview(logoImageDescription)
        logoImage.contentMode = .scaleAspectFit
        
        iconStackView.layer.borderWidth = 2
        iconStackView.layer.cornerRadius = 12
        iconStackView.backgroundColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? .black : UIColor(red: 238/255, green: 255/255, blue: 251/255, alpha: 1.0)
        }
        iconStackView.layer.borderColor = UIColor(red: 90/255, green: 178/255, blue: 255/255, alpha: 0.9).cgColor
    }
    
    
}
