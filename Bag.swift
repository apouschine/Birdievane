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
    var clubNames: [String] = []
    
    var count: Int {
        return clubs.count
    }
    
    // ensure not more than 14 clubs in bag
    func add(club: Club) -> Bool {
        if (club.v0 == -1) {
            return false
        }
        clubs.append(club)
        clubNames.append(club.name)
        return true
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
        clubNames.removeAtIndex(index)
    }
    
    func updateAtIndex(new_club: Club, atIndex index: Int) {
        clubs[index] = new_club
        clubNames[index] = new_club.name
    }
    
}