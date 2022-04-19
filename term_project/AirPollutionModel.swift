//
//  AirPollutionModel.swift
//  term_project
//
//  Created by JPL-ST-SPRING2021 on 4/19/22.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let airPollutionModel = try? newJSONDecoder().decode(AirPollutionModel.self, from: jsonData)

import Foundation

// MARK: - AirPollutionModel
struct AirPollutionModel: Codable {
    let coord: Coordinate?
    let list: [List]?
}

// MARK: - Coord
struct Coordinate: Codable {
    let lon, lat: Double?
}

// MARK: - List
struct List: Codable {
    let main: Air?
    let components: [String: Double]?
    let dt: Int?
}

// MARK: - Main
struct Air: Codable {
    let aqi: Int?
}
