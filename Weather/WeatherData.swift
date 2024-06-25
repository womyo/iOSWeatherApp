//
//  WeatherData.swift
//  Weather
//
//  Created by 이인호 on 6/25/24.
//

import Foundation
import WeatherKit

struct WeatherData: Codable, Identifiable, Hashable {
    var id = UUID()
    let date: String
    let temperature: String
    let description: String
    let humidity: String
    let windSpeed: String
    let symbolName: String
    
    static var empty = WeatherData(date: "", temperature: "", description: "", humidity: "", windSpeed: "", symbolName: "")
}

protocol WeatherProtocol {
    var date: Date { get }
    var temperature: Measurement<UnitTemperature> { get }
    var condition: WeatherCondition { get }
    var humidity: Double { get }
    var wind: Wind { get }
    var symbolName: String { get }
}

extension CurrentWeather: WeatherProtocol {}
extension HourWeather: WeatherProtocol {}
