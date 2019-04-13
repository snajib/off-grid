//
//  VectorClass.swift
//  Off-Grid
//
//  Created by Zaki Refai on 8/5/18.
//  Copyright © 2018 Kazi Studios. All rights reserved.
//

import Foundation

//Declaration of Vector class
class Vector : CustomStringConvertible {
    
    //Instance properties
    let direction: Int
    var magnitude: Double
    
    //Initializer for vector objects
    init(direction: Int, magnitude: Double) {
        self.direction = direction
        self.magnitude = magnitude
    }
    
    //Get direction
    func getDirection()->Int {
        return self.direction
    }
    
    //Get magnitude
    func getMagnitude()->Double {
        return self.magnitude
    }
    
    func setMagnitude(magnitude: Double) {
        self.magnitude = magnitude
    }
    
    //Get steps taken
    func getSteps()->Int {
        return Int(self.magnitude / 2.35)
    }
    
    //MARK: Describer portions of vector class
    
    //Printing
    var description: String {
        var description = ""
        description += "Direction: \(self.direction)\t"
        description += "Magnitude: \(self.magnitude)"
        return description
    }
    
    //Comparing
    static func == (lhs: Vector, rhs: Vector)->Bool {
        var key = false
        if (lhs.direction == rhs.direction) && (lhs.magnitude == rhs.magnitude) {
            key = true
        }
        return key
    }
}
