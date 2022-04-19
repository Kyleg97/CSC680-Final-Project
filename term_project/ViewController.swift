//
//  ViewController.swift
//  term_project
//
//  Created by JPL-ST-SPRING2021 on 4/5/22.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var latLabel: UILabel!
    @IBOutlet weak var lonLabel: UILabel!
    
    @IBOutlet weak var cityLabel: UILabel!
    
    let locationManager = CLLocationManager()
    let networking = Networking()
    
    var weatherModel: WeatherModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("Storyboard loaded...")
        locationManager.requestWhenInUseAuthorization()
        var currentLocation: CLLocation!
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways {
            currentLocation = locationManager.location
            print(currentLocation.coordinate.longitude)
            print(currentLocation.coordinate.latitude)
            latLabel.text = "\(currentLocation.coordinate.latitude)"
            lonLabel.text = "\(currentLocation.coordinate.longitude)"
            let lat = currentLocation.coordinate.latitude
            let lon = currentLocation.coordinate.longitude
            let geoCoder = CLGeocoder()
            let location = CLLocation(latitude: lat, longitude: lon)
            geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, _) -> Void in
                placemarks?.forEach { (placemark) in
                    self.cityLabel.text = placemark.locality!
                }
            })
            Task {
                do {
                    let weather = try await networking.fetchWeather(lat: "\(lat)", lon: "\(lon)")
                    print(weather)
                    print("Weather temp: \(kelvinToFahrenheit(temperature: weather.main.temp ?? -1))")
                    let suggestion = CreateSuggestion()
                    let outfit = suggestion.calculateSuggestion(weather: weather)
                    print(outfit.outerwear)
                    print(outfit.bottom)
                    print(outfit.top)
                    print(outfit.shoes)
                    print(outfit.accessory)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    func update(with weatherModel: WeatherModel) {
        DispatchQueue.main.async {
            self.weatherModel = weatherModel
        }
    }


}

