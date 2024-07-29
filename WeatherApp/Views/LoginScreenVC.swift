//
//  ViewController.swift
//  WeatherApp
//
//  Created by Emirhan Aydın on 9.07.2024.
//

//
//  ViewController.swift
//  WeatherApp
//
//  Created by Emirhan Aydın on 9.07.2024.
//

import UIKit
import Lottie

class LoginScreenVC: UIViewController, UITextFieldDelegate {
    
    static let apiTextField = WATextField()
    let enterButton = WAButton(backgroundColor: .systemGray, title: "Enter")
    let animation = LottieAnimationView(name:"wi")

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAnimation()
        configureWeatherImage()
        configureGestureRecognizer()
        LoginScreenVC.apiTextField.text = "254a1e08a44c468b166af2b5718ae70a"

    }
    
    @objc func pushWeatherScreenVC() {
        guard let apiKey = LoginScreenVC.apiTextField.text, !apiKey.isEmpty else {
            self.presentAlertOnMainThread(title: "Error", message: "API key is empty", buttonTitle: "OK")
            return
        }

        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        let tabBarController = sceneDelegate?.configureTabBarWithWeather(apiKey: apiKey)
        sceneDelegate?.window?.rootViewController = tabBarController
    }
    
    func configureAnimation() {
        animation.contentMode = .scaleAspectFit
        animation.loopMode = .loop
        animation.play()
    }

    func configureWeatherImage() {
        view.addSubview(animation)
        view.addSubview(LoginScreenVC.apiTextField)
        view.addSubview(enterButton)
        
        animation.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? .black : UIColor.systemCyan }
        enterButton.addTarget(self, action: #selector(pushWeatherScreenVC), for: .touchUpInside)
        
        LoginScreenVC.apiTextField.textColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? .black : UIColor.black
        }
        LoginScreenVC.apiTextField.backgroundColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? .white : UIColor.white
        }

        NSLayoutConstraint.activate([
            animation.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            animation.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            animation.heightAnchor.constraint(equalToConstant: 250),
            animation.widthAnchor.constraint(equalToConstant: 250),
            
            LoginScreenVC.apiTextField.topAnchor.constraint(equalTo: animation.bottomAnchor, constant: 20),
            LoginScreenVC.apiTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            LoginScreenVC.apiTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            LoginScreenVC.apiTextField.heightAnchor.constraint(equalToConstant: 60),
            
            enterButton.topAnchor.constraint(equalTo: LoginScreenVC.apiTextField.bottomAnchor, constant: 20),
            enterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            enterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            enterButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        
       
    }
    
    func configureGestureRecognizer() {
        LoginScreenVC.apiTextField.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    
    func presentAlertOnMainThread(title: String, message: String, buttonTitle: String) {
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: buttonTitle, style: .default))
            self.present(alertVC, animated: true)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        pushWeatherScreenVC()
        return true
    }
}








