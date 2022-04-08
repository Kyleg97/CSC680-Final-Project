//
//  ViewController.swift
//  term_project
//
//  Created by JPL-ST-SPRING2021 on 4/5/22.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    //@IBOutlet weak var longLabel: Label1!
    //@IBOutlet weak var latLabel: Label2!
    
    @IBOutlet weak var latLabel: UILabel!
    @IBOutlet weak var lonLabel: UILabel!
    let locationManager = CLLocationManager()
    
    
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
        }
    }


}

