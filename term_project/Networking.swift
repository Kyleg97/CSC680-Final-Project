//
//  Networking.swift
//  term_project
//
//  Created by JPL-ST-SPRING2021 on 4/8/22.
//

import Foundation

struct Networking {
    
    let baseURLString = "https://api.openweathermap.org/data/2.5/weather?"
    let api_key = API_KEY
    
    func fetchWeather(lat: String, lon: String) async throws -> WeatherModel {
        let url = URL(string: "\(baseURLString)lat=\(lat)&lon=\(lon)&appid=\(api_key)")!
        let (data,_) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        return try decoder.decode(WeatherModel.self, from: data)
    }
}
