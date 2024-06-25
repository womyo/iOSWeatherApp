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
            VStack {
                Image(systemName: viewModel.weather.symbolName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100)
                Text(viewModel.weather.temperature)
                    .font(.largeTitle)
                Text(viewModel.weather.description)
                    .font(.title2)
                HStack {
                    Text("습도: \(viewModel.weather.humidity)")
                    Text("풍속: \(viewModel.weather.windSpeed)")
                }
            }
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(viewModel.hourlyForecast, id:\.self) { forecast in
                            VStack {
                                Text(forecast.date)
                                Image(systemName: forecast.symbolName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30)
                                Text(forecast.temperature)
                            }
                            .padding(.leading, forecast == viewModel.hourlyForecast.first ? 16 : 8)
                            .padding(.trailing, forecast == viewModel.hourlyForecast.last ? 16 : 8)
                        }
                    }
                }
            }
            .listStyle(.plain)
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            }
        }
        .task {
            viewModel.requestLocation()
        }
    }
    
    func temperatureFormat(_ temperature: Double) -> String {
        return String(format: "%.1f°", temperature)
    }
}

#Preview {
    ContentView()
}
