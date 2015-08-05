//
//  WindViewController.swift
//  Birdievane
//
//  Created by Alex Pouschine on 7/22/15.
//  Copyright (c) 2015 Alex Pouschine. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class WindViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet var windSpeedLabel: UILabel!
    @IBOutlet var windDirectionLabel: UILabel!
    @IBOutlet var sanityCheckMap: MKMapView!
    @IBOutlet var windGustSpeedLabel: UILabel!
    
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let wind = Conds.sharedInstance.wind
        self.windSpeedLabel.text = "Wind Speed: " + String(format: "%.2f",wind.speed) + " mph"
        self.windGustSpeedLabel.text = "Wind Gust Speed: " + String(format: "%.2f", wind.speed_gust) + " mph"
        self.windDirectionLabel.text = "Wind Direction: " + wind.direction_text
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // var userLocation:CLLocation = locations[0]
        let lat = manager.location!.coordinate.latitude
        let long = manager.location!.coordinate.longitude
        let old_wind = Conds.sharedInstance.wind
        Conds.sharedInstance.update(lat, long:long)
        let wind = Conds.sharedInstance.wind
        
        let center = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.sanityCheckMap.setRegion(region, animated: true)
        self.sanityCheckMap.showsUserLocation = true
        
        if (old_wind.speed != wind.speed) {
            self.windSpeedLabel.text = "Wind Speed: " + String(format: "%.2f",wind.speed) + " mph"
        }
        if (old_wind.speed_gust != wind.speed_gust) {
            self.windGustSpeedLabel.text = "Wind Gust Speed: " + String(format: "%.2f", wind.speed_gust) + " mph"
        }
        if (old_wind.direction_text != wind.direction_text) {
            self.windDirectionLabel.text = "Wind Direction: " + wind.direction_text
        }
    }
    
}
