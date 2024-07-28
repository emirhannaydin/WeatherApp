//
//  WATextField.swift
//  WeatherApp
//
//  Created by Emirhan Aydın on 9.07.2024.
//

import UIKit

class WATextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        layer.borderWidth = 1
        layer.cornerRadius = 2
        placeholder = "API KEY"
        textAlignment = .center
    }

}
