//
//  Club.swift
//  Birdievane
//
//  Created by Alex Pouschine on 7/22/15.
//  Copyright (c) 2015 Alex Pouschine. All rights reserved.
//

import Foundation
import Darwin

class Club {
    let name: String
    var carry: Int
    var loft: Int
    var v0 = 0.0
    
    init(name: String, carry: Int, loft: Int) {
        self.name = name
        self.carry = carry
        self.loft = loft
        self.v0 = get_velocity(carry, loft: loft)
    }
    
    func get_velocity(carry: Int, loft: Int) -> Double {
        // ball flight model from:
        // http://nothingnerdy.wikispaces.com/file/view/Flight%20of%20golf%20ball%20-%20sample%20EE.pdf
        
        let delta_t = 0.01
        let A = 0.00139
        var zpos = 0.0
        var xpos = 0.0
        var v_z = 0.0
        var v_x = 0.0
        var v_right = 110.0 // slightly faster than world record
        var v_left = 0.0
        let rho = 1.22 // average, fine for getting average velocity
        let drag_coef = 0.235 // estimated from model
        let lift_coef = 0.165 // estimated from model
        let m_ball = 0.04593
        var v_0 = (v_right + v_left)/2.0
        var v: Double
        var f_drag: Double
        var f_lift: Double
        let g = 9.807
        
        // unit conversions, need meters/second radians
        let meters_to_yards_conversion_factor = 0.9144
        let carry_meters = meters_to_yards_conversion_factor * Double(carry)
        let deg_to_rad_conversion_factor = M_PI/180.0
        let loft_radians = deg_to_rad_conversion_factor * Double(loft)
        var theta: Double
        var sim_dist = 0.0
        let dist_final = round(Double(100*carry_meters)/100)
        
        // precision used is 2 decimal points, which is more than necessary,
        // as golfers almost always think in integer values, outside of putting
        // coordinate system set such that up is positive, down is negative
        
        // coordinate system (when facing the hole):
        // posiitve x: forward, negative x: backward
        // positive y: left, negative y: right
        // positive z: up, negative z: down
        while round((100*sim_dist)/100) != dist_final {
            // inner loop to check how far the ball flies given an initial velocity
            
            theta = loft_radians
            v_z = v_0 * sin(theta)
            v_x = v_0 * cos(theta)
            v = v_0
            xpos = 0.0
            zpos = 0.0
            
            while true {
                // hit ground, and is going down, to avoid initial condition
                if(zpos <= 0 && v_z < 0) {
                    break
                }
                
                // calculate the forces
                f_drag = 0.5 * drag_coef * rho * A * v * v
                f_lift = 0.5 * lift_coef * rho * A * v * v
                
                // update velocities
                v_x = v * cos(theta) - 0.5*(f_drag * cos(theta)/m_ball + f_lift * sin(theta)/m_ball) * delta_t
                v_z = v * sin(theta) - 0.5*(f_drag * sin(theta)/m_ball - f_lift * cos(theta)/m_ball + g) * delta_t
                
                // update positions
                xpos = xpos + v_x * delta_t
                zpos = zpos + v_z * delta_t
                
                // update parameters
                v = sqrt(v_x * v_x + v_z * v_z)
                theta = atan(v_z/v_x)
            }
            
            // update iniital velocity value, if needed
            sim_dist = round((100 * xpos)/100)
            if sim_dist == dist_final {
                break
            } else if sim_dist > dist_final {
                v_right = v_0
            } else {
                v_left = v_0
            }
            v_0 = (v_left + v_right)/2
        }
        return v_0
    }
    
}
