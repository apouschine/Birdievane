//
//  CalculatorViewController.swift
//  Birdievane
//
//  Created by Alex Pouschine on 7/22/15.
//  Copyright (c) 2015 Alex Pouschine. All rights reserved.
//

import UIKit
import Darwin
import CoreLocation

class CalculatorViewController: UIViewController, UIPickerViewDataSource,UIPickerViewDelegate, CLLocationManagerDelegate {

    @IBOutlet var clubPicker: UIPickerView!
    @IBOutlet var pickerLabel: UILabel!
    @IBOutlet var distanceField: UITextField!
    @IBOutlet var heightField: UITextField!
    
    var lat = 0.0
    var long = 0.0
    
    var clubnames: [String] = []
    var heading: CLHeading!
    // to ensure there is always a club picked
    var active_club: Club?
    
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingHeading()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        clubnames = []
        
        for c in Bag.sharedInstance.clubs {
            clubnames.append(c.name)
        }
        if clubnames.count == 0 {
            pickerLabel.text = "No clubs in bag, please add clubs"
            clubPicker.userInteractionEnabled = false
        }
        else {
            pickerLabel.text = "Choose a club"
            clubPicker.userInteractionEnabled = true
            active_club = Bag.sharedInstance.get(0)
        }
        clubPicker.delegate = self
        clubPicker.dataSource = self
    }
    
    @IBAction func calculate(sender: AnyObject) {
        // stop from calculating without a club
        if clubnames.count == 0 {
            return
        }
        
        Conds.sharedInstance.update(lat, long: long)
        let wind = Conds.sharedInstance.wind
        
        // let dir = heading.trueHeading
        let dir = 225.0
        
        var target_dist: Int
        var v_0: Double
        var d_height: Int
        
        if distanceField.text.isEmpty {
            target_dist = active_club!.carry
            v_0 = active_club!.v0
        }
        else {
            target_dist = distanceField.text.toInt()!
            v_0 = active_club!.get_velocity(target_dist, loft: active_club!.loft)
        }
        
        if heightField.text.isEmpty {
            d_height = 0
        }
        else {
            d_height = heightField.text.toInt()!
        }
        
        // calculate for regular wind speed
        // println("regular")
        let reg_string = self.calculate(wind.speed, wind_speed_gust: wind.speed_gust, distance: target_dist, loft: active_club!.loft, d_height: d_height, v_0: v_0, wind_angle: wind.angle, flight_angle: dir)
        
        showMessages(reg_string)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Calculating stuff
    func locationManager(manager: CLLocationManager!, didUpdateHeading newHeading: CLHeading!) {
        self.heading = newHeading
    }
    
    func calculate(wind_speed: Double, wind_speed_gust: Double, distance: Int, loft: Int, d_height: Int, v_0: Double, wind_angle: Double, flight_angle: Double) -> String {
        // ball flight model from
        // http://nothingnerdy.wikispaces.com/file/view/Flight%20of%20golf%20ball%20-%20sample%20EE.pdf
        
        // wind model from:
        // http://www.luxfamily.com/jimlux/robot/windball.htm
        
        let delta_t = 0.01
        var t = 0.0
        let A = 0.00139 // projected area of the ball
        let rho = 1.22 // density of air
        let drag_coef = 0.235 // estimated from model
        let lift_coef = 0.165 // estimated from model
        let wind_coef = 3.71964 // provided from other model
        let m_ball = 0.04593 // wolfram alpha
        let rad_ball = 0.02134 // wolfram alpha
        
        let meters_to_yards_conversion_factor = 0.9144
        let distance_meters = meters_to_yards_conversion_factor * Double(distance)
        let d_height_meters = meters_to_yards_conversion_factor * Double(d_height)
        
        let deg_to_rad_conversion_factor = M_PI/180.0
        let loft_radians = deg_to_rad_conversion_factor * Double(loft)
        let wind_radians = deg_to_rad_conversion_factor * wind_angle
        let flight_radians = deg_to_rad_conversion_factor * flight_angle
        var wind_phi = flight_radians - wind_radians
        var flight_phi = 0.0
        
        let mph_to_mps_conversion_factor = 0.447
        
        var f_drag: Double
        var f_lift: Double
        var f_wind: Double
        let g = 9.807
        
        var theta = loft_radians
        
        var xpos = 0.0
        var ypos = 0.0
        var zpos = 0.0
        
        var v = v_0
        var v_xyplane: Double
        var v_x = v_0 * sin(theta)
        var v_y = 0.0 // assuming no horizontal motion at launch
        var v_z = v_0 * cos(theta)

        var v_wind = 0.0
        var output_str = ""
        
        for i in 0...1 {
            if i == 0 {
                v_wind = mph_to_mps_conversion_factor * wind_speed
                output_str = output_str + "normal wind: "
            }

            if i == 1 {
                v_wind = mph_to_mps_conversion_factor * wind_speed_gust
                output_str = output_str + "\ngust: "
            }

            t = 0.0
            xpos = 0.0
            ypos = 0.0
            zpos = 0.0
            theta = loft_radians
            flight_phi = 0.0
            v = v_0
            var v_x = v_0 * sin(theta)
            var v_y = 0.0 // assuming no horizontal motion at launch
            var v_z = v_0 * cos(theta)

            while true{
                // ball hit ground while going down, stop simulation
                if (zpos <= d_height_meters && v_z < 0) {
                    break
                }
                
                if (t > 12.0) {
                    return ""
                }
                
                // calculate forces
                f_drag = 0.5 * drag_coef * rho * A * v * v
                f_lift = 0.5 * lift_coef * rho * A * v * v
                f_wind = wind_coef * v_wind * v_wind * rad_ball * rad_ball // model on luxfamily.com
                
                // update velocities
                v_x = v * cos(theta) * cos(flight_phi) - 0.5 * (f_drag * cos(theta) * cos(flight_phi) + f_lift * sin(theta) + f_wind * cos(wind_phi)) * delta_t / m_ball
                v_y = v * cos(theta) * sin(flight_phi) - 0.5 * (f_drag * cos(theta) * sin(flight_phi) + f_wind * sin(wind_phi)) * delta_t / m_ball
                v_z = v * sin(theta) - 0.5 * (f_drag * sin(theta) - f_lift * cos(theta) + g * m_ball) * delta_t / m_ball
                
                xpos = xpos + v_x * delta_t
                ypos = ypos + v_y * delta_t
                zpos = zpos + v_z * delta_t
                
                v = sqrt(v_x * v_x + v_y * v_y + v_z * v_z)
                v_xyplane = sqrt(v_x * v_x + v_y * v_y)
                flight_phi = atan(v_y/v_x)
                theta = atan(v_z/v_xyplane)
            }
            
            xpos = xpos / meters_to_yards_conversion_factor
            ypos = ypos / meters_to_yards_conversion_factor
            
            var dx = xpos - Double(distance)
            
            var x_sign = ""
            var y_sign = ""
            
            if dx < 0 {
                x_sign = " yards shorter, "
            }
            else {
                x_sign = " yards longer, "
            }
            
            if ypos < 0 {
                y_sign = " yards right"
            }
            
            else {
                y_sign = " yards left"
            }
            
            dx = abs(dx)
            ypos = abs(ypos)
            
            output_str = output_str + String(format: "%.2f", dx) + x_sign + String(format:"%.2f", ypos) + y_sign
        }
        return output_str
    }
    
    func showMessages(msg: String) {
        var display = ""
        
        if msg == "" {
            display = "Error: simulated ball took more than 12 seconds to land, check club parameters"
        }
        else {
            display = msg
        }
        
        
        
        let alertController = UIAlertController(title: "Wind Effects", message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Calculate Again", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    //MARK: - Delegates and data sources
    //MARK: Data Sources
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return clubnames.count
    }
    
    //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return clubnames[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        active_club = Bag.sharedInstance.get(row)
    }
    
    //MARK: - Location access
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        var userLocation:CLLocation = locations[0] as CLLocation
        lat = manager.location.coordinate.latitude
        long = manager.location.coordinate.longitude
        Conds.sharedInstance.update(lat, long: long)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
