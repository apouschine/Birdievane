//
//  Conds.swift
//  Birdievane
//
//  Created by Alex Pouschine on 7/22/15.
//  Copyright (c) 2015 Alex Pouschine. All rights reserved.
//

import Foundation

class Conds {
    class var sharedInstance: Conds {
        struct Static {
            static let instance = Conds()
        }
        return Static.instance
    }
    
    var wind: Wind
    let offset = -600.0
    
    init() {
        // replace with wunderground API
        var speed = 10.0
        var speed_gust = 20.0
        var angle = 225.0
        let time = NSDate()
        let direction_text = "SouthWest"
        
        self.wind = Wind(speed:speed, speed_gust: speed_gust, angle: angle, direction_text: direction_text, time: time)
    }
    
    func update() {
        let now = NSDate(timeIntervalSinceNow: offset)
        if now.compare(self.wind.time) == .OrderedDescending {
            println("updating wind")
            // replace with wunderground API
            var speed = 0.0
            var speed_gust = 0.0
            var angle = 0.0
            let time = NSDate()
            let direction_text = "North"
            self.wind = Wind(speed:speed, speed_gust: speed_gust, angle: angle, direction_text: direction_text, time: time)
        }
    }
    
    
}