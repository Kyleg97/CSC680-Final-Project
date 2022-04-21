//
//  ViewController.swift
//  term_project
//
//  Created by JPL-ST-SPRING2021 on 4/5/22.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var latLonLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var aqiLabel: UILabel!
    
    let locationManager = CLLocationManager()
    let networking = Networking()
    
    var weatherModel: WeatherModel?
    var oneCallModel: OneCallModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        var currentLocation: CLLocation!
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways {
            currentLocation = locationManager.location
            // round to two decimal places
            let lat = round(currentLocation.coordinate.latitude * 100) / 100.0
            let lon = round(currentLocation.coordinate.longitude * 100) / 100.0
            let latLonStr = "\(lat)° \(lon)°"
            print(latLonStr)
            latLonLabel.text = latLonStr
            let geoCoder = CLGeocoder()
            let location = CLLocation(latitude: lat, longitude: lon)
            // get city from latitude and longitude
            geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, _) -> Void in
                placemarks?.forEach { (placemark) in
                    self.cityLabel.text = placemark.locality!
                }
            })
            Task {
                do {
                    let weather = try await networking.fetchWeather(lat: "\(lat)", lon: "\(lon)")
                    let onecall = try await networking.fetchOneCall(lat: "\(lat)", lon: "\(lat)")
                    let airPollution = try await networking.fetchAirPollution(lat: "\(lat)", lon: "\(lon)")
                    // print(weather)
                    let temp = kelvinToFahrenheit(temperature: weather.main.temp!)
                    let wind = weather.wind.speed
                    let aqi = airPollution.list?[0].main?.aqi
                    tempLabel.text = "\(temp) F°"
                    windLabel.text = "\(wind!) mph"
                    switch(aqi) {
                    case 1:
                        aqiLabel.text = "Good"
                    case 2:
                        aqiLabel.text = "Fair"
                    case 3:
                        aqiLabel.text = "Moderate"
                    case 4:
                        aqiLabel.text = "Poor"
                    case 5:
                        aqiLabel.text = "Very Poor"
                    case .none:
                        aqiLabel.text = "Err"
                    case .some(_):
                        aqiLabel.text = "uhh idk"
                    }
                    //aqiLabel.text = "\(aqi!)"
                    print(airPollution)
                    let suggestion = CreateSuggestion()
                    let outfit = suggestion.calculateSuggestion(weather: weather)
                    // print(outfit)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    /*func update(with weatherModel: WeatherModel) {
        DispatchQueue.main.async {
            self.weatherModel = weatherModel
        }
    }*/


}

