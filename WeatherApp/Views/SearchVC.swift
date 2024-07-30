//
//  SecondViewController.swift
//  WeatherApp
//
//  Created by Emirhan Aydın on 12.07.2024.
//

import UIKit
import MapKit
import CoreLocation


class SearchVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITextFieldDelegate {
    
    let mapView: MKMapView = {
        let map = MKMapView()
        map.overrideUserInterfaceStyle = .unspecified
        return map
    }()
    
    var locationManager = CLLocationManager()
    var searchTextField = WASearchTextField()
    var locationButton = WACircularButton(name: "location.fill")
    var isSearch: Bool = false
    var hasShownInitialLocation = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        setupLocationManager()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first, !hasShownInitialLocation else { return }
        hasShownInitialLocation = true
        
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        //pin
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "My Location"
        mapView.addAnnotation(annotation)
    }
    
    func configure() {
        
        view.addSubview(mapView)
        view.addSubview(searchTextField)
        view.addSubview(locationButton)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        
        searchTextField.delegate = self
        locationButton.addTarget(self, action: #selector(centerToUserLocation), for: .touchUpInside)

        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            searchTextField.heightAnchor.constraint(equalToConstant: 50),
            
            locationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            locationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            locationButton.widthAnchor.constraint(equalToConstant: 50),
            locationButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        searchTextField.textColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? .black : UIColor(red: 238/255, green: 255/255, blue: 251/255, alpha: 1.0)
        }
    }
    
    @objc func centerToUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
        }
    }
    
    @objc func dismissKeyboard() {
           view.endEditing(true)
       }

  
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            
            guard let searchText = textField.text, !searchText.isEmpty else {
                self.presentAlertOnMainThread(title: "Error", message: "You entered empty text", buttonTitle: "OK")
                return true
            }
            
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(searchText) { (placemarks, error) in
                if let error = error {
                    print("Geocoding error: \(error.localizedDescription)")
                    self.presentAlertOnMainThread(title: "Error", message: "City name could not be found.", buttonTitle: "OK")
                    return
                }
                
                
                
                if let placemark = placemarks?.first {
                    self.mapView.removeAnnotations(self.mapView.annotations)
                    
                    let annotation = MKPointAnnotation()
                    annotation.title = searchText
                    annotation.coordinate = placemark.location!.coordinate
                    self.mapView.addAnnotation(annotation)
                    
                    let currentLocationAnnotation = MKPointAnnotation()
                    currentLocationAnnotation.coordinate = self.locationManager.location!.coordinate
                    currentLocationAnnotation.title = "My Location"
                    self.mapView.addAnnotation(currentLocationAnnotation)
                    
                    let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                    self.mapView.setRegion(region, animated: true)
                }
            }
            
            return true
        }
        
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            guard let annotation = view.annotation else { return }
            
            self.isSearch = true
            let weatherScreenVC = WeatherScreenVC()
            
            weatherScreenVC.viewModel.searchCoordinate = annotation.coordinate
            weatherScreenVC.viewModel.isSearch = self.isSearch
            self.navigationController?.pushViewController(weatherScreenVC, animated: true)
            weatherScreenVC.viewModel.apiKey = LoginScreenVC.apiTextField.text!
            weatherScreenVC.viewModel.getWeather(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
        }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.letters.union(.whitespaces)
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
        }
    
    func presentAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: buttonTitle, style: .default))
            self.present(alertVC, animated: true)
        }
    }


}
