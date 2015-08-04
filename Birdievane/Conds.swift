//
//  Conds.swift
//  Birdievane
//
//  Created by Alex Pouschine on 7/22/15.
//  Copyright (c) 2015 Alex Pouschine. All rights reserved.
//

import Foundation
import CoreLocation

class Conds {
    class var sharedInstance: Conds {
        struct Static {
            static let instance = Conds()
        }
        return Static.instance
    }
    
    var wind: Wind
    let offset = 600.0
    
    init() {
        
        // get coordinates
        var speed = 0.0
        var speed_gust = 0.0
        var angle = 0.0
        var direction_text = ""
        
        // set it to an hour ago, to ensure it's updated when first loaded
        let time = NSDate(timeIntervalSinceNow: -3600)
        
        self.wind = Wind(speed:speed, speed_gust: speed_gust, angle: angle, direction_text: direction_text, time: time)
    }
    
    func update(lat: Double, long: Double) {
        let now = NSDate()
        if now.compare(self.wind.time) == .OrderedDescending {
            // open weathermap API
            // as that can do condition lookup by coordinate
            var key = ""

            let lat_str = String(format: "%f", lat)
            let long_str = String(format: "%f", long)
            
            let url_string = "http://api.openweathermap.org/data/2.5/weather?lat=" + lat_str + "&lon=" + long_str +
                "&APPID=" + key
            let url = NSURL(string: url_string)
            let session = NSURLSession.sharedSession()
            var speed = self.wind.speed
            var angle = self.wind.angle
            var speed_gust = self.wind.speed_gust
            
            
            let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
                var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as NSDictionary
                let w: AnyObject = jsonResult["wind"]!
                
                // this one has always been returned
                speed = w["speed"]! as Double
                
                // these two have been spotty
                if let angle_check = w["deg"] as? NSDictionary {
                    angle = w["deg"]! as Double
                }
                if let gust_check = w["gust"] as? NSDictionary {
                    speed_gust = w["gust"]! as Double
                }
                
                let time = NSDate(timeIntervalSinceNow: self.offset)
                let direction_text = self.directionText(angle)
                self.wind = Wind(speed:speed, speed_gust: speed_gust, angle: angle, direction_text: direction_text, time: time)
                
            })
            task.resume()
            
        }
    }
    
    func directionText(dir: Double) -> String {
        var text = ""
        if (dir > 348.75 || dir <= 11.25){
            text = "North"
        }
        if (dir > 11.25 && dir <= 33.75) {
            text = "North Northeast"
        }
        if (dir > 33.75 && dir <= 56.25) {
            text = "Northeast"
        }
        if (dir > 56.25 && dir <= 78.75) {
            text = "East Northeast"
        }
        if (dir > 78.75 && dir <= 101.25) {
            text = "East"
        }
        if (dir > 101.25 && dir <= 123.75) {
            text = "East Southeast"
        }
        if (dir > 123.75 && dir <= 146.25) {
            text = "Southeast"
        }
        if (dir > 146.25 && dir <= 168.75) {
            text = "South Southeast"
        }
        if (dir > 168.75 && dir <= 191.25) {
            text = "South"
        }
        if (dir > 191.25 && dir <= 213.75) {
            text = "South Southwest"
        }
        if (dir > 213.75 && dir <= 236.25) {
            text = "Southwest"
        }
        if (dir > 236.25 && dir <= 258.75) {
            text = "West Southwest"
        }
        if (dir > 258.75 && dir <= 281.25) {
            text = "West"
        }
        if (dir > 281.25 && dir <= 303.75) {
            text = "West Northwest"
        }
        if (dir > 303.75 && dir <= 326.25) {
            text = "Northwest"
        }
        if (dir > 326.25 && dir <= 348.75) {
            text = "North Northwest"
        }
        
        return text
    }
    
    
}