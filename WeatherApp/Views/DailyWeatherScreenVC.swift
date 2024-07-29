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

}

final class DailyWeatherScreenVC: UIViewController {
    public lazy var viewModel = DailyWeatherScreenVM()
    
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
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.view = self
        viewModel.viewDidLoad()
        configureViews()
    }
    
    
    
    func configureViews(){
        view.backgroundColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? .black : UIColor(red: 238/255, green: 248/255, blue: 255/255, alpha: 1.0)
        }
        
        view.addSubview(dayTimeLabel)
        view.addSubview(celciusLabel)
        view.addSubview(iconStackView)
        view.addSubview(firstStackView)
        view.addSubview(secondStackView)
        view.addSubview(thirdStackView)
        view.addSubview(gif)
        
        dayTimeLabel.layer.borderWidth = 2
        iconStackView.layer.borderWidth = 2
        celciusLabel.layer.borderWidth = 2
        
        dayTimeLabel.layer.borderColor = UIColor.white.cgColor
        iconStackView.layer.borderColor = UIColor.white.cgColor
        celciusLabel.layer.borderColor = UIColor.white.cgColor
        
        dayTimeLabel.layer.cornerRadius = 12
        iconStackView.layer.cornerRadius = 12
        celciusLabel.layer.cornerRadius = 12
        
        dayTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        celciusLabel.translatesAutoresizingMaskIntoConstraints = false
        iconStackView.translatesAutoresizingMaskIntoConstraints = false
        firstStackView.translatesAutoresizingMaskIntoConstraints = false
        secondStackView.translatesAutoresizingMaskIntoConstraints = false
        thirdStackView.translatesAutoresizingMaskIntoConstraints = false
        gif.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        NSLayoutConstraint.activate([
            dayTimeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            dayTimeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dayTimeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            dayTimeLabel.heightAnchor.constraint(equalToConstant: 50),
            
            celciusLabel.topAnchor.constraint(equalTo: dayTimeLabel.bottomAnchor, constant: 20),
            celciusLabel.centerXAnchor.constraint(equalTo: dayTimeLabel.centerXAnchor),
            celciusLabel.heightAnchor.constraint(equalToConstant: 50),
            celciusLabel.widthAnchor.constraint(equalToConstant: 80),
            
            iconStackView.topAnchor.constraint(equalTo: celciusLabel.bottomAnchor, constant: 20),
            iconStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            iconStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            iconStackView.heightAnchor.constraint(equalToConstant: 50),
            
            gif.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            gif.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gif.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gif.bottomAnchor.constraint(equalTo: firstStackView.topAnchor, constant: -30),
            
            firstStackView.topAnchor.constraint(equalTo: iconStackView.bottomAnchor, constant: 60),
            firstStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            firstStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            firstStackView.heightAnchor.constraint(equalToConstant: 120),
            
            secondStackView.topAnchor.constraint(equalTo: firstStackView.bottomAnchor, constant: 20),
            secondStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            secondStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            secondStackView.heightAnchor.constraint(equalToConstant: 120),
            
            thirdStackView.topAnchor.constraint(equalTo: secondStackView.bottomAnchor, constant: 20),
            thirdStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            thirdStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            thirdStackView.heightAnchor.constraint(equalToConstant: 120),
            
            
            
        ])
        
        gif.layer.zPosition = -1
        gif.alpha = 0.3
    }
   
    
    func getGIF(icon: String){
        
        switch icon{
        case "01d":
            gif.loadGif(name: "clearSky")
        case "02d":
            gif.loadGif(name: "fewClouds")
        case "03d":
            gif.loadGif(name: "fewClouds")
        case "04d":
            gif.loadGif(name: "fewClouds")
        case "09d":
            gif.loadGif(name: "rainy")
        case "10d":
            gif.loadGif(name: "rainy")
        case "11d":
            gif.loadGif(name: "thunderstorm")
        case "13d":
            gif.loadGif(name: "snow")
        case "50d":
            gif.loadGif(name: "mist")
        default:
            gif.loadGif(name: "clearSky")
        }
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

        dayTimeLabel.text = formattedDate
        celciusLabel.text = "\(Int(weather.temp.day))°C"
        minTempLabel.text = "Min: \(Int(weather.temp.min))°C"
        maxTempLabel.text = "Max: \(Int(weather.temp.max))°C"
        humidityParameter.text = "Humidity: \(weather.humidity)%"
        feelsLikeParameter.text = "Feels Like: \(Int(weather.feels_like.day))°C"
        windSpeedParameter.text = "Wind Speed: \(weather.wind_speed) m/s"
        windDirectionParameter.text = "Wind Direction: \(Int(weather.wind_deg))°"
        logoImageDescription.text = weather.weather.first?.description.capitalized ?? "No description"

        if let icon = weather.weather.first?.icon {
            viewModel.getIcon(icon: icon)
            getGIF(icon: icon)
        }
    }
    
    func prepareFirstStackView() {
        firstStackView.axis = NSLayoutConstraint.Axis.horizontal
        firstStackView.distribution = .fillEqually
        firstStackView.alignment = .center
        firstStackView.spacing = 15
        firstStackView.layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        firstStackView.isLayoutMarginsRelativeArrangement = true
        
        /*
        firstStackView.backgroundColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? .black : UIColor(red: 238/255, green: 255/255, blue: 251/255, alpha: 1.0)
        
        
        firstStackView.layer.borderColor = UIColor(red: 172/255, green: 255/255, blue: 251/255, alpha: 1.0).cgColor*/
        
        firstStackView.layer.borderWidth = 2
        firstStackView.layer.cornerRadius = 12
        firstStackView.addArrangedSubview(maxTempLabel)
        firstStackView.addArrangedSubview(minTempLabel)
        maxTempLabel.textAlignment = .center
        minTempLabel.textAlignment = .center
        minTempLabel.font = UIFont.systemFont(ofSize: 30, weight: .black)
        maxTempLabel.font = UIFont.systemFont(ofSize: 30, weight: .black)
        maxTempLabel.textColor = .systemOrange
        minTempLabel.textColor = .systemCyan
        

    }
    
    func prepareSecondStackView() {
        secondStackView.axis = NSLayoutConstraint.Axis.vertical
        secondStackView.distribution = .fillEqually
        secondStackView.alignment = .center
        secondStackView.spacing = 15
        secondStackView.layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        secondStackView.isLayoutMarginsRelativeArrangement = true
        
        /*secondStackView.layer.borderWidth = 2
        secondStackView.layer.cornerRadius = 12
        secondStackView.backgroundColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? .black : UIColor(red: 238/255, green: 255/255, blue: 251/255, alpha: 1.0)
        }
        
        secondStackView.layer.borderColor = UIColor(red: 172/255, green: 255/255, blue: 251/255, alpha: 1.0).cgColor*/
        
        secondStackView.addArrangedSubview(humidityParameter)
        secondStackView.addArrangedSubview(feelsLikeParameter)
        
        humidityParameter.textAlignment = .center
        feelsLikeParameter.textAlignment = .center
        humidityParameter.font = UIFont.systemFont(ofSize: 30, weight: .black)
        feelsLikeParameter.font = UIFont.systemFont(ofSize: 30, weight: .black)
        humidityParameter.textColor = .systemCyan
        feelsLikeParameter.textColor = .systemOrange
        
    }
    
    func prepareThirdStackView() {
        thirdStackView.axis = NSLayoutConstraint.Axis.vertical
        thirdStackView.distribution = .fillEqually
        thirdStackView.alignment = .center
        thirdStackView.spacing = 20
        thirdStackView.layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        thirdStackView.isLayoutMarginsRelativeArrangement = true
        
        thirdStackView.layer.borderWidth = 2
        thirdStackView.layer.cornerRadius = 12
        thirdStackView.backgroundColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? .black : UIColor(red: 115/255, green: 255/255, blue: 251/255, alpha: 1.0)
        }
        
        thirdStackView.layer.borderColor = UIColor(red: 172/255, green: 255/255, blue: 251/255, alpha: 1.0).cgColor
        
        thirdStackView.addArrangedSubview(windSpeedParameter)
        thirdStackView.addArrangedSubview(windDirectionParameter)
        
        windSpeedParameter.textAlignment = .center
        windDirectionParameter.textAlignment = .center
        windSpeedParameter.font = UIFont.systemFont(ofSize: 30, weight: .black)
        windDirectionParameter.font = UIFont.systemFont(ofSize: 30, weight: .black)
        
        windSpeedParameter.textColor = .systemGray
        windDirectionParameter.textColor = .systemIndigo
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
    }
    
    
}
