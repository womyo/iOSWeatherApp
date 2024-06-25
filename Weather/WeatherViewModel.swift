//
//  WeatherViewModel.swift
//  Weather
//
//  Created by 이인호 on 6/25/24.
//

import Foundation
import CoreLocation
import Combine
import WeatherKit

class WeatherViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var weather: WeatherData = WeatherData.empty
    
    @Published var isLoading: Bool = false
    @Published var error: Error?
    @Published var location: CLLocation?
    
    private let weatherService = WeatherService.shared
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
        locationManager.requestLocation()
    }
    
    @MainActor
    func getCurrentWeather() async {
        guard let location = self.location else {
            print("위치 정보 없음")
            return
        }
        
        do {
            isLoading = true
            let weather = try await weatherService.weather(for: location, including: .current)
            isLoading = false
            self.weather = self.updateWeatherDetails(weather)
        } catch {
            print("날씨 정보를 가져오는 데 실패했습니다: \(error)")
            isLoading = false
        }
    }
    
    private func updateWeatherDetails(_ weather: CurrentWeather?) -> WeatherData {
        guard let weather = weather else {
            return WeatherData.empty
        }
        
        return WeatherData(temperature: String(format: "%.1f°C", weather.temperature.value),
                           description: weather.condition.description, 
                           humidity: String(format: "%.0f%%", weather.humidity * 100),
                           windSpeed: String(format: "%.1f km/h", weather.wind.speed.value),
                           symbolName: weather.symbolName
        )
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = locations.first
        
        Task {
            await getCurrentWeather()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error)
        self.error = error
    }
}
