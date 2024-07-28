//
//  WALocationButton.swift
//  WeatherApp
//
//  Created by Emirhan Aydın on 16.07.2024.
//

import UIKit

class WACircularButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(name: String){
        super.init(frame: .zero)
        self.setImage(UIImage(systemName: name), for: .normal)
        configure()
    }
    
    
    private func configure() {
       tintColor = .systemBlue
       backgroundColor = .white
       layer.cornerRadius = 25
       layer.shadowColor = UIColor.black.cgColor
       layer.shadowOpacity = 0.25
       layer.shadowOffset = CGSize(width: 0, height: 2)
       layer.shadowRadius = 2
    }
    
}
