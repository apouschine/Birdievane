//
//  Bag.swift
//  Birdievane
//
//  Created by Alex Pouschine on 7/22/15.
//  Copyright (c) 2015 Alex Pouschine. All rights reserved.
//

import Foundation

class Bag {
    class var sharedInstance: Bag {
        struct Static {
            static let instance = Bag()
        }
        return Static.instance
    }
    
    var clubs: [Club] = []
    
    var count: Int {
        return clubs.count
    }
    
    // ensure not more than 14 clubs in bag
    func add(club: Club) {
        clubs.append(club)
    }
    
    // rework this
    func replace(club: Club, atIndex index: Int) {
        clubs[index] = club
    }
    
    func get(index: Int) -> Club {
        return clubs[index]
    }
    
    func removeClubAtIndex(index: Int) {
        clubs.removeAtIndex(index)
    }
    
    func updateAtIndex(new_club: Club, atIndex index: Int) {
        clubs[index] = new_club
    }
    
}