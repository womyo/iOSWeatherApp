//
//  WeatherData.swift
//  Weather
//
//  Created by 이인호 on 6/25/24.
//

import Foundation

struct WeatherData: Codable {
    let temperature: String
    let description: String
    let humidity: String
    let windSpeed: String
    let symbolName: String
    
    static var empty = WeatherData(temperature: "", description: "", humidity: "", windSpeed: "", symbolName: "")
}
