//
//  ViewController.swift
//  term_project
//
//  Created by JPL-ST-SPRING2021 on 4/5/22.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    var activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var latLonLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var aqiLabel: UILabel!
    @IBOutlet weak var uviLabel: UILabel!
    @IBOutlet weak var uviDescLabel: UILabel!
    
    
    @IBOutlet weak var RecommendationButton: UIButton!
    
    let locationManager = CLLocationManager()
    let networking = Networking()
    
    var weatherModel: WeatherModel?
    var oneCallModel: OneCallModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // blur the background while making the API call
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.tag = 100
        view.addSubview(blurEffectView)
        
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
            
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(activityIndicator)
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            
            Task {
                do {
                    activityIndicator.startAnimating()
                    let weather = try await networking.fetchWeather(lat: "\(lat)", lon: "\(lon)")
                    let onecall = try await networking.fetchOneCall(lat: "\(lat)", lon: "\(lon)")
                    print(onecall)
                    let airPollution = try await networking.fetchAirPollution(lat: "\(lat)", lon: "\(lon)")
                    self.activityIndicator.stopAnimating()
                    // remove blur subview
                    self.view.viewWithTag(100)?.removeFromSuperview()
                    //self.view.willRemoveSubview(blurEffectView)
                    // print(weather)
                    // let temp = kelvinToFahrenheit(temperature: weather.main.temp!)
                    let temp = kelvinToFahrenheit(temperature: onecall.current!.temp!)
                    // let wind = weather.wind.speed
                    let wind = onecall.current!.windSpeed
                    let uvi = onecall.current!.uvi!
                    let aqi = airPollution.list?[0].main?.aqi
                    tempLabel.text = "\(temp) F°"
                    windLabel.text = "\(wind!) mph"
                    switch(aqi) {
                    case 1:
                        aqiLabel.text = "Good"
                        aqiLabel.textColor = UIColor.green
                    case 2:
                        aqiLabel.text = "Fair"
                        aqiLabel.textColor = UIColor.yellow
                    case 3:
                        aqiLabel.text = "Moderate"
                        aqiLabel.textColor = UIColor.orange
                    case 4:
                        aqiLabel.text = "Poor"
                        aqiLabel.textColor = UIColor.red
                    case 5:
                        aqiLabel.text = "Very Poor"
                        aqiLabel.textColor = UIColor.purple
                    case .none:
                        aqiLabel.text = "Err"
                    case .some(_):
                        aqiLabel.text = "uhh idk"
                    }
                    uviLabel.text = "\(uvi)"
                    if (uvi > 10) {
                        uviLabel.textColor = UIColor.purple
                        uviDescLabel.text = "(Extremely high)"
                    } else if (uvi > 7) {
                        uviLabel.textColor = UIColor.red
                        uviDescLabel.text = "(Very high)"
                    } else if (uvi > 5) {
                        uviLabel.textColor = UIColor.orange
                        uviDescLabel.text = "(High)"
                    } else if (uvi > 2) {
                        uviLabel.textColor = UIColor.yellow
                        uviDescLabel.text = "(Medium)"
                    } else {
                        uviLabel.textColor = UIColor.green
                        uviDescLabel.text = "(Low)"
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

