//
//  ErrorMessage.swift
//  WeatherApp
//
//  Created by Emirhan Aydın on 9.07.2024.
//

import Foundation


enum ErrorMessage: String, Error {
    case invalidUsername = "This username created an invalid request"
    case unableToComplete = "Unable to complete your request"
    case invalidResponse = "Invalid response from the server"
    case invalidData = "The data received from the server was invalid"
    case invalidURL = "Invalid URL"
    case decodingError = "Error decoding data"
    
}
