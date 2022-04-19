//
//  HelperFunctions.swift
//  term_project
//
//  Created by JPL-ST-SPRING2021 on 4/8/22.
//

import Foundation
import CoreLocation

func kelvinToFahrenheit(temperature: Double) -> Double {
    if temperature == -1 {
        return -1
    }
    return (temperature - 273.15) * 9/5 + 32
}

func getCurrentCity(lat: Double, lon: Double) -> String {
    let geoCoder = CLGeocoder()
    let location = CLLocation(latitude: lat, longitude: lon)
    var city = "test"
    geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, _) -> Void in
        placemarks?.forEach { (placemark) in
            city = placemark.locality!
        }
    })
    return city
}
