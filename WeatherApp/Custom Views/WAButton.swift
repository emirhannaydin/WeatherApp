//
//  WAButton.swift
//  WeatherApp
//
//  Created by Emirhan Aydın on 9.07.2024.
//

import UIKit

final class WAButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(backgroundColor: UIColor, title: String) {
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
        self.setTitle(title, for: .normal)
        configure()
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.borderWidth = 1
        layer.cornerRadius = 12
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        
    }
}
