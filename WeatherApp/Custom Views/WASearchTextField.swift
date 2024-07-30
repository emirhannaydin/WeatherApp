//
//  WASearchTextField.swift
//  WeatherApp
//
//  Created by Emirhan Aydın on 12.07.2024.
//

import UIKit

final class WASearchTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        
        
        placeholder = "Search"
        backgroundColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? UIColor(red: 0/255, green: 37/255, blue: 127/255, alpha: 0.8) : UIColor(red: 255/255, green: 255/255, blue: 240/255, alpha: 0.8)
        }
        textAlignment = .center
        textColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? .white : UIColor.black
        }
        
        
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        layer.cornerRadius = 10
        autocorrectionType = .no

     
        
    }
    
}
