//
//  City.swift
//  WeatherApp
//
//  Created by Emirhan Aydın on 13.07.2024.
//

import Foundation


struct City: Codable {
    let name: String
    let local_names: [String: String]?
    let lat: Double
    let lon: Double
    let country: String
}
