//
//  WALabel.swift
//  WeatherApp
//
//  Created by Emirhan Aydın on 10.07.2024.
//

import UIKit

class WALabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(textAlignment: NSTextAlignment){
        super.init(frame: .zero)
        self.textAlignment = textAlignment
        configure()
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.75
        font = UIFont.systemFont(ofSize: 20)
        lineBreakMode = .byWordWrapping
        
    }
}
