//
//  Wind.swift
//  Birdievane
//
//  Created by Alex Pouschine on 7/22/15.
//  Copyright (c) 2015 Alex Pouschine. All rights reserved.
//

import Foundation

class Wind {
    let speed: Double
    let speed_gust: Double
    let angle: Double
    let direction_text: String
    let time: NSDate
    
    init(speed: Double, speed_gust: Double, angle: Double, direction_text: String, time: NSDate) {
        self.speed = speed
        self.speed_gust = speed_gust
        self.angle = angle
        self.direction_text = direction_text
        self.time = time
    }
    
    
    
}
