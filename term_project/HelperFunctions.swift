//
//  HelperFunctions.swift
//  term_project
//
//  Created by JPL-ST-SPRING2021 on 4/8/22.
//

import Foundation

func kelvinToFahrenheit(temperature: Double) -> Double {
    if temperature == -1 {
        return -1
    }
    return (temperature - 273.15) * 9/5 + 32
}
