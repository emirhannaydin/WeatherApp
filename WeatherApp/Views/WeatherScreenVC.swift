//
//  WeatherScreenVC.swift
//  WeatherApp
//
//  Created by Emirhan Aydın on 9.07.2024.
//

import UIKit
import CoreLocation
import AVFoundation
import Lottie

protocol WeatherVCInterface: AnyObject {
    func prepareCollectionView()
    func prepareTableView()
    func prepareIconStackView()
    func prepareFirstParameterStackView()
    func prepareSecondParameterStackView()
    func prepareThirdParameterStackView()
    func prepareCombineStackView()
    func startIndicator()
    func stopIndicator()
    func setupLocationManager()
    func changeUI(weather: Weather, lat: Double, lon: Double)
    func changeCityLabel(city: City)
    func changeImage(data: Data)
    func presentAlertOnViewModel(title: String, message: String, buttonTitle: String)
    func changeGIF(icon: String)
}

final class WeatherScreenVC: UIViewController, CLLocationManagerDelegate {
    
    lazy var viewModel = WeatherScreenVM()
    
    var tableView = UITableView()
    var checkCityLabel = String()
    let cityLabel = WALabel(textAlignment: .center)
    let celciusLabel = WALabel(textAlignment: .center)
    let iconImage = UIImageView()
    var indicator = UIActivityIndicatorView(style: .large)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let logoImageDescription = WALabel(textAlignment: .center)
    let gif = UIImageView()
    let contentView = UIView()
    let scrollView = UIScrollView()
    let iconstackView = UIStackView()
    let firstParameterStackView = UIStackView()
    let secondParameterStackView = UIStackView()
    let thirdParameterStackView = UIStackView()
    let combineStackView = UIStackView()
    let humidityParameter = UILabel()
    let feelsLikeParameter = UILabel()
    let windSpeedParameter = UILabel()
    let windDirectionParameter = UILabel()
    let favoriteButton = WACircularButton(name: "star")
    var favoriteButtonBool = false
    let animation = LottieAnimationView(name: "favorite")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        viewModel.viewDidLoad()
        configureViews()
        

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        updateFavoriteButtonState()
        animation.removeFromSuperview()
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("FavoriteCityRemoved"), object: nil)
    }
    
    @objc func updateFavoriteButtonState() {
        let defaults = UserDefaults.standard
        let favoriteCities = defaults.stringArray(forKey: "favoriteCities") ?? []
        if let cityName = cityLabel.text{
            if favoriteCities.contains(cityName) {
                
                favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
                favoriteButtonBool = true
            } else {
                favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
                favoriteButtonBool = false
            }
        }
    }
    
    
    @objc func changeFavoriteButton() {
        guard let cityName = cityLabel.text else { return }
        let defaults = UserDefaults.standard
        var favoriteCities = defaults.stringArray(forKey: "favoriteCities") ?? []
        var cityCoordinates = defaults.dictionary(forKey: "cityCoordinates") as? [String: [String: Double]] ?? [:]

        let starFillImage = UIImage(systemName: "star.fill")
        let currentImage = favoriteButton.image(for: .normal)

        if currentImage?.pngData() == starFillImage?.pngData() {
            favoriteButtonBool = true
        }

        if favoriteButtonBool {
            favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
            favoriteButtonBool = false
            if let index = favoriteCities.firstIndex(of: cityName) {
                favoriteCities.remove(at: index)
            }
            cityCoordinates.removeValue(forKey: cityName)
        } else {
            favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            favoriteButtonBool = true
            if !favoriteCities.contains(cityName) {
                favoriteCities.append(cityName)
            }
            let coordinates = [
                "latitude": viewModel.currentLatitude,
                "longitude": viewModel.currentLongitude,
            ]
            cityCoordinates[cityName] = coordinates
            
            configureAnimation{}
        }
        defaults.set(favoriteCities, forKey: "favoriteCities")
        defaults.set(cityCoordinates, forKey: "cityCoordinates")
    }


    
    func configureAnimation(completion: @escaping () -> Void) {
        animation.contentMode = .scaleAspectFit
        animation.play { (finished) in
            if finished {
                self.animation.removeFromSuperview()
                completion()
            }
        }
        animation.backgroundColor = .clear
        animation.alpha = 0.5

        view.addSubview(animation)
        animation.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
                animation.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                animation.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                animation.widthAnchor.constraint(equalToConstant: 300),
                animation.heightAnchor.constraint(equalToConstant: 300)
            ])
        
        }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        viewModel.locationManager.startUpdatingLocation()
        
        if let location = locations.first {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            if !viewModel.isSearch{
                viewModel.getWeather(latitude: latitude, longitude: longitude)
                viewModel.locationManager.stopUpdatingLocation()
                
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let message = "Failed to get user location: \(error.localizedDescription)"
        presentAlert(title: "Error", message: message, buttonTitle: "OK")
    }
    
    func configureViews() {
        
        view.backgroundColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? .black : UIColor(red: 169/255, green: 222/255, blue: 249/255, alpha: 1.0)}
        
        favoriteButton.addTarget(self, action: #selector(changeFavoriteButton), for: .touchUpInside)

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(gif)
        contentView.addSubview(cityLabel)
        contentView.addSubview(celciusLabel)
        contentView.addSubview(tableView)
        contentView.addSubview(indicator)
        contentView.addSubview(collectionView)
        contentView.addSubview(iconstackView)
        contentView.addSubview(combineStackView)
        contentView.addSubview(thirdParameterStackView)
        contentView.addSubview(favoriteButton)
                
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        indicator.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        gif.translatesAutoresizingMaskIntoConstraints = false
        iconstackView.translatesAutoresizingMaskIntoConstraints = false
        firstParameterStackView.translatesAutoresizingMaskIntoConstraints = false
        secondParameterStackView.translatesAutoresizingMaskIntoConstraints = false
        thirdParameterStackView.translatesAutoresizingMaskIntoConstraints = false
        combineStackView.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        cityLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        logoImageDescription.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        celciusLabel.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        iconImage.contentMode = .scaleAspectFit
        gif.layer.zPosition = -1
        gif.alpha = 0.3

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
            
            indicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            cityLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 20),
            cityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            cityLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            cityLabel.heightAnchor.constraint(equalToConstant: 40),
            
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            favoriteButton.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 20),
            favoriteButton.widthAnchor.constraint(equalToConstant: 40),
            favoriteButton.heightAnchor.constraint(equalToConstant: 40),
            
            iconstackView.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 20),
            iconstackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            iconstackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            iconstackView.heightAnchor.constraint(equalToConstant: 50),
            
            celciusLabel.topAnchor.constraint(equalTo: iconstackView.bottomAnchor, constant: 10),
            celciusLabel.centerXAnchor.constraint(equalTo: cityLabel.centerXAnchor),
            celciusLabel.heightAnchor.constraint(equalToConstant: 50),
            
            gif.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            gif.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            gif.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            gif.heightAnchor.constraint(equalToConstant: 200),
            
            collectionView.topAnchor.constraint(equalTo: gif.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 100),
            
            tableView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            tableView.heightAnchor.constraint(equalToConstant: 350),
            
            combineStackView.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 20),
            combineStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            combineStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            combineStackView.heightAnchor.constraint(equalToConstant: 140),
            
            thirdParameterStackView.topAnchor.constraint(equalTo: combineStackView.bottomAnchor, constant: 10),
            thirdParameterStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            thirdParameterStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            thirdParameterStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
    }
    
    
}

//MARK: - ViewController Interface Funcs
extension WeatherScreenVC: WeatherVCInterface {
    func changeGIF(icon: String) {
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
    func presentAlertOnViewModel(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: buttonTitle, style: .default))
            self.present(alertVC, animated: true)
        }
    }
    
    func changeImage(data: Data) {
        DispatchQueue.main.async {
            self.iconImage.image = UIImage(data: data)
           }
    }
    
    func changeCityLabel(city: City) {
        DispatchQueue.main.async {
            self.cityLabel.text = "\(city.name), \(city.country)"
    
            let defaults = UserDefaults.standard
            if let favoriteCities = defaults.stringArray(forKey: "favoriteCities"){
                if let cityName = self.cityLabel.text {
                    if favoriteCities.contains(cityName) {
                        self.favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
                        
                    }
                }
            }
        }
    }
    
    func setupLocationManager() {
        viewModel.locationManager.delegate = self
        viewModel.locationManager.requestWhenInUseAuthorization()
        viewModel.locationManager.startUpdatingLocation()
    }
    
    func startIndicator() {
        indicator.startAnimating()
        tableView.isHidden = true
        iconImage.isHidden = true
        cityLabel.isHidden = true
        celciusLabel.isHidden = true
    }
    
    func stopIndicator() {
        indicator.stopAnimating()
        tableView.isHidden = false
        iconImage.isHidden = false
        cityLabel.isHidden = false
        celciusLabel.isHidden = false
        indicator.isHidden = true
    }
    
    func changeUI(weather: Weather, lat: Double, lon: Double) {
        let description = weather.current.weather[0].description
        let capitalizedDescription = description.split(separator: " ").map { $0.prefix(1).uppercased() + $0.dropFirst() }.joined(separator: " ")
        
        DispatchQueue.main.async {
            self.viewModel.getIcon(icon: weather.current.weather[0].icon)
            self.changeGIF(icon: weather.current.weather[0].icon)
            self.celciusLabel.text = "\(Int(weather.current.temp))°C"
            self.logoImageDescription.text = "\(capitalizedDescription)"
            self.collectionView.reloadData()
            self.tableView.reloadData()
            self.viewModel.getCityName(latitude: lat, longitude: lon)
            self.humidityParameter.text = "%\(weather.current.humidity)"
            self.feelsLikeParameter.text = "\(Int(weather.current.feels_like))°C"
            self.windSpeedParameter.text = "Speed = \(weather.current.wind_speed) m/s"
            self.windDirectionParameter.text = "Direction = \(weather.current.wind_deg)°"
            self.stopIndicator()

        }
        
       
    }
    func prepareIconStackView() {
        iconstackView.addArrangedSubview(iconImage)
        iconstackView.addArrangedSubview(logoImageDescription)
        iconstackView.axis = NSLayoutConstraint.Axis.horizontal
        iconstackView.distribution = .fillEqually
        iconstackView.alignment = .center
        iconstackView.layer.borderWidth = 2
        iconstackView.layer.cornerRadius = 30
        iconstackView.layer.borderColor = UIColor.white.cgColor
    }
    
    func prepareFirstParameterStackView() {
        let title = UILabel()
        
        firstParameterStackView.addArrangedSubview(title)
        firstParameterStackView.addArrangedSubview(humidityParameter)
     
        title.text = "༄ HUMIDITY"
        title.font = UIFont.systemFont(ofSize: 15, weight: .black)
        title.alpha = 0.6
        humidityParameter.font = UIFont.systemFont(ofSize: 20, weight: .bold)

        
        title.translatesAutoresizingMaskIntoConstraints = false
        humidityParameter.translatesAutoresizingMaskIntoConstraints = false
        title.heightAnchor.constraint(equalToConstant: 20).isActive = true
        title.topAnchor.constraint(equalTo: firstParameterStackView.topAnchor, constant: 10).isActive = true
        humidityParameter.heightAnchor.constraint(equalToConstant: 60).isActive = true

        firstParameterStackView.axis = NSLayoutConstraint.Axis.vertical
        firstParameterStackView.distribution = .fill
        firstParameterStackView.alignment = .center
        firstParameterStackView.spacing = 20
        firstParameterStackView.layer.cornerRadius = 12
        firstParameterStackView.backgroundColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? .black : UIColor(red: 169/255, green: 222/255, blue: 249/255, alpha: 1.0)}
        firstParameterStackView.layer.shadowColor = UIColor.systemBlue.cgColor
        firstParameterStackView.layer.shadowOpacity = 0.35
        firstParameterStackView.layer.shadowOffset = CGSize(width: 0, height: 7)
        
       

        
    }
    
    func prepareSecondParameterStackView() {
        let title = UILabel()
        secondParameterStackView.addArrangedSubview(title)
        secondParameterStackView.addArrangedSubview(feelsLikeParameter)
        
        title.text = "♨ FEELS LIKE"
        title.font = UIFont.systemFont(ofSize: 15, weight: .black)
        title.alpha = 0.6
        feelsLikeParameter.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        feelsLikeParameter.translatesAutoresizingMaskIntoConstraints = false
        title.heightAnchor.constraint(equalToConstant: 20).isActive = true
        title.topAnchor.constraint(equalTo: secondParameterStackView.topAnchor, constant: 10).isActive = true

        feelsLikeParameter.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        secondParameterStackView.axis = NSLayoutConstraint.Axis.vertical
        secondParameterStackView.distribution = .fill
        secondParameterStackView.alignment = .center
        secondParameterStackView.spacing = 20.0
        secondParameterStackView.layer.cornerRadius = 12
        secondParameterStackView.backgroundColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? .black : UIColor(red: 169/255, green: 222/255, blue: 249/255, alpha: 1.0)}
        secondParameterStackView.layer.shadowColor = UIColor.systemBlue.cgColor
        secondParameterStackView.layer.shadowOpacity = 0.35
        secondParameterStackView.layer.shadowOffset = CGSize(width: 0, height: 7)
      
    }
    
    func prepareThirdParameterStackView() {
        let title = UILabel()
        thirdParameterStackView.addArrangedSubview(title)
        thirdParameterStackView.addArrangedSubview(windSpeedParameter)
        thirdParameterStackView.addArrangedSubview(windDirectionParameter)
        title.text = "💨 WIND"
        title.font = UIFont.systemFont(ofSize: 15, weight: .black)
        title.alpha = 0.6
        windSpeedParameter.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        windDirectionParameter.font = UIFont.systemFont(ofSize: 20, weight: .bold)

        
        title.translatesAutoresizingMaskIntoConstraints = false
        windSpeedParameter.translatesAutoresizingMaskIntoConstraints = false
        windDirectionParameter.translatesAutoresizingMaskIntoConstraints = false
        
        title.heightAnchor.constraint(equalToConstant: 20).isActive = true
        title.topAnchor.constraint(equalTo: thirdParameterStackView.topAnchor, constant: 10).isActive = true

        windSpeedParameter.heightAnchor.constraint(equalToConstant: 40).isActive = true
        windDirectionParameter.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        thirdParameterStackView.axis = NSLayoutConstraint.Axis.vertical
        thirdParameterStackView.distribution = .fill
        thirdParameterStackView.alignment = .center
        thirdParameterStackView.spacing = 10.0
        thirdParameterStackView.layer.cornerRadius = 12
        thirdParameterStackView.backgroundColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? .black : UIColor(red: 169/255, green: 222/255, blue: 249/255, alpha: 1.0)}
        thirdParameterStackView.layer.shadowColor = UIColor.systemBlue.cgColor
        thirdParameterStackView.layer.shadowOpacity = 0.35
        thirdParameterStackView.layer.shadowOffset = CGSize(width: 0, height: 4)
        
      
    }
    
    func prepareCombineStackView() {
        combineStackView.addArrangedSubview(firstParameterStackView)
        combineStackView.addArrangedSubview(secondParameterStackView)
        
        combineStackView.axis = NSLayoutConstraint.Axis.horizontal
        combineStackView.distribution = .fillEqually
        combineStackView.alignment = .center
        combineStackView.spacing = 10.0
        
      
    }
    
    func prepareTableView() {
        tableView.register(WSTableViewCell.self, forCellReuseIdentifier: WSTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorColor = UIColor.white
        tableView.layer.cornerRadius = 12
        tableView.layer.borderColor = UIColor.white.cgColor
        
        
    }
    
    func prepareCollectionView() {
        
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 3
            
            collectionView.collectionViewLayout = layout
            collectionView.register(WSCollectionViewCell.self, forCellWithReuseIdentifier: WSCollectionViewCell.identifier)
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            collectionView.contentInsetAdjustmentBehavior = .never
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.showsVerticalScrollIndicator = false
            collectionView.decelerationRate = .fast
            collectionView.backgroundColor = UIColor { traitCollection in
                return traitCollection.userInterfaceStyle == .dark ? .black : UIColor(red: 169/255, green: 222/255, blue: 249/255, alpha: 1.0)}
            
            
        
            
        
    }
    
}


