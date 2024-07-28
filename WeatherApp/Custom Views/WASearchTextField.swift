//
//  WASearchTextField.swift
//  WeatherApp
//
//  Created by Emirhan Aydın on 12.07.2024.
//

import UIKit

class WASearchTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        
        
        placeholder = "Search"
        textAlignment = .center
        backgroundColor = UIColor.white.withAlphaComponent(0.8)
        
        borderStyle = .none
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        layer.cornerRadius = 10
        autocorrectionType = .no

     
        
    }
    
}
