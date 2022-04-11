//
//  CurrentWeatherData.swift
//  WeatherMap MVC
//
//  Created by Ирина on 10.03.2022.
//

import Foundation

struct CurrentWeatherData: Codable {
    let main: Main
    let name: String
    let weather: [Weather]
    
}

struct Main: Codable {
    let temp: Double
    let feelsLike: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
    }
}

struct Weather: Codable {
    let id: Int
}

