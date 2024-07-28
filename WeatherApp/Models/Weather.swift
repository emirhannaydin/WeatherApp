import Foundation

struct Weather: Codable {
    let lat: Double
    let lon: Double
    let timezone: String
    let current: CurrentWeather
    let daily: [Daily]
    let hourly: [Hourly]
}


struct CurrentWeather: Codable {
    let temp: Double
    let sunset: Int
    let humidity: Int
    let weather: [WeatherDescription]
    let feels_like : Double
    let wind_speed : Double
    let wind_deg : Int
}
struct WeatherDescription: Codable{
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Daily: Codable {
    let dt: Int
    let temp: Temp
    let weather: [WeatherDescription]
    let feels_like: FeelsLike
    let humidity: Int
    let wind_speed: Double
    let wind_deg: Double
}

struct Hourly: Codable{
    let dt: Int
    let temp: Double
    let weather: [WeatherDescription]
    
    
}

struct Temp: Codable {
    let day: Double
    let min: Double
    let max: Double
}

struct FeelsLike: Codable{
    let day: Double
}
