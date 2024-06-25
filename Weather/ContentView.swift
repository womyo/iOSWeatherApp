//
//  ContentView.swift
//  Weather
//
//  Created by 이인호 on 6/25/24.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @StateObject var viewModel = WeatherViewModel()
    
    var body: some View {
        VStack {
            Image(systemName: viewModel.weather.symbolName)
            Text(viewModel.weather.temperature)
                .font(.largeTitle)
            Text(viewModel.weather.description)
                .font(.title2)
            HStack {
                Text("습도: \(viewModel.weather.humidity)")
                Text("풍속: \(viewModel.weather.windSpeed)")
            }
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            }
        }
        .task {
            viewModel.requestLocation()
        }
        Button {
            viewModel.requestLocation()
        } label: {
            Text("현재 위치 날씨 가져오기")
        }
    }
    
    func temperatureFormat(_ temperature: Double) -> String {
        return String(format: "%.1f°", temperature)
    }
}

#Preview {
    ContentView()
}
