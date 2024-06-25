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
                Text("NAMINARA ISLAND")
                    .font(.system(size: 30))
                Text(viewModel.weather.temperature)
                    .font(.system(size: 110, weight: .thin))
                Text(viewModel.weather.description)
                    .font(.system(size: 25))
                HStack {
                    Text("습도: \(viewModel.weather.humidity)")
                    Text("풍속: \(viewModel.weather.windSpeed)")
                }
                .font(.system(size: 23))
            }
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(viewModel.hourlyForecast, id:\.self) { forecast in
                            VStack {
                                Text(forecast.date)
                                Spacer()
                                Image(systemName: forecast.symbolName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30, height: 30)
                                Spacer()
                                Text(forecast.temperature)
                            }
                            .padding(.leading, forecast == viewModel.hourlyForecast.first ? 16 : 8)
                            .padding(.trailing, forecast == viewModel.hourlyForecast.last ? 16 : 8)
                        }
                    }
                }
                .frame(height: 100)
                .padding([.top, .bottom])
                .background(Color.gray.opacity(0.05))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding()
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
