//
//  VectorCalibrate.swift
//  Off-Grid
//
//  Created by Zaki Refai on 8/27/18.
//  Copyright © 2018 Kazi Studios. All rights reserved.
//

import Foundation
import UIKit
//height is y not x
class VectorCalibrate {
    var keyTerminalPoint: CGPoint = CGPoint(x: 0.0, y: 0.0)
    var keyCGRect: CGRect = CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0)
    
    //Global VectorCalibrate function that uses both pointCalibrate and cgRectCalibrate since both functions use the same data to calibrate CGPoints and CGRects.
    func globalCalibrate(vector: Vector, originPoint: CGPoint) {
        //Componenets of vector
        let vectorDirection = Double(vector.getDirection())
        let vectorMagnitude = Double(vector.getMagnitude())
        //Origin Components
        let originX = Double(originPoint.x)
        let originY = Double(originPoint.y)
        // a and b are the magnitudes of the sides of the triangle based off of the hypotenuse (vectorMagnitude) and the direction/angle (vectorDirection). Side a is found through magnitude * sin(angle) and b is found through magnitude * cos(b). THESE ARE SIDES. NOT POINTS
        var a = sinDegrees(degrees: vectorDirection) * vectorMagnitude
        var b = cosDegrees(degrees: vectorDirection) * vectorMagnitude
        
        //a and b should never be negative, will be added in later processes. This is to correct it from being negative due to some math being calculated. 
        if (a < 0) {
            a = a * (-1)
        } else {}
        
        if (b < 0) {
            b = b * (-1)
        } else {}
        
        print("Height a = ", a, "Width b = ", b)
        
        //Calling pointCalibrate to return terminal points of vector for graphing
        keyTerminalPoint = pointCalibrate(vectorDirection: vectorDirection, a: a, b: b, originX: originX, originY: originY)
        
        keyCGRect = cgRectCalibrate(originPoint: originPoint, vectorDirection: vectorDirection, a: a, b: b)
    }
    
    //Finding terminal points of vectors so that it may be plotted exactly on the iphone screen
    private func pointCalibrate(vectorDirection: Double, a: Double, b: Double, originX: Double, originY: Double)->CGPoint {
        //Returning point
        var keyPoint: CGPoint = CGPoint(x: 0.0, y: 0.0)
        
        //If direction is 0 degrees
        if (vectorDirection == 0.0) {
            keyPoint = CGPoint(x: originX + b, y: originY)
            print("Direction 0, x: ", originX, " + ", b, " = ", originX + b)
            print("Direction 0, y: ", originY)
        }
        //If direction is 0 - 90
        else if (vectorDirection > 0.0 && vectorDirection < 90.0) {
            keyPoint = CGPoint(x: originX + b, y: originY - a)
            print("Direction 0 - 90, x: ", originX, " + ", b, " = ", originX + b)
            print("Direction 0 - 90, y: ", originY, " - ", a, " = ", originY - a)
        }
        //If direction is 90
        else if (vectorDirection == 90.0) {
            keyPoint = CGPoint(x: originX, y: originY - a)
            print("Direction 90, x: ", originX)
            print("Direction 90, y: ", originY, " - ", a, " = ", originY - a)
        }
        //If direction is 90 - 180
        else if (vectorDirection > 90.0 && vectorDirection < 180.0) {
            keyPoint = CGPoint(x: originX - b, y: originY - a)
            print("Direction 90 - 180, x: ", originX, " - ", b, " = ", originX - b)
            print("Direction 90 - 180, y: ", originY, " - ", a, " = ", originY - a)
        }
        //If direction is 180
        else if (vectorDirection == 180.0) {
            keyPoint = CGPoint(x: originX - b, y: originY)
            print("Direction 180, x: ", originX, " - ", b, " = ", originX - b)
            print("Direction 180, y: ", originY)
        }
        //If direction is 180 - 270
        else if (vectorDirection > 180.0 && vectorDirection < 270.0) {
            keyPoint = CGPoint(x: originX - b, y: originY + a)
            print("Direction 180 - 270, x: ", originX, " - ", b, " = ", originX - b)
            print("Direction 180 - 270, y: ", originY, " + ", a, " = ", originY + a)
        }
        //If direction is 270
        else if (vectorDirection == 270.0) {
            keyPoint = CGPoint(x: originX, y: originY + a)
            print("Direction 270, x: ", originX)
            print("Direction 270, y: ", originY, " + ", a, " = ", originY + a)
        }
        //If direction is 270 - 360
        else if (vectorDirection > 270.0 && vectorDirection < 360.0) {
            keyPoint = CGPoint(x: originX + b, y: originY + a)
            print("Direction 270 - 360, x: ", originX, " + ", b, " = ", originX + b)
            print("Direction 270 - 360, y: ", originY, " + ", a, " = ", originY + a)
        }
        
        return keyPoint
    }
    
    //Using origin point and a and b to calculate the exact CGRect on the iphone screen to update in the view, so that the line becomes incremental instead of earasing after every setNeedsDisplay redraw. It is also more efficient because it doesn't cause entire screen to redraw, only small portion.
    private func cgRectCalibrate(originPoint: CGPoint, vectorDirection: Double, a: Double, b: Double)->CGRect {
        //General components of CGRect
        var x: Double = 0.0
        var y: Double = 0.0
        let width: Double = b
        let height: Double = a
        
        //TODO: Write cases for 0,90,180, and 270
        //If direction is 0
            //TODO: FIX THIS
        if (vectorDirection == 0.0) {
            x = Double(originPoint.x)
            y = Double(originPoint.y) - a
        }
        //If direction is between 0 - 90 degrees
        else if (vectorDirection > 0.0 && vectorDirection < 90.0) {
            x = Double(originPoint.x)
            y = Double(originPoint.y) - a
        }
        //If direction is 90 degrees
            //TODO: FIX THIS
        else if (vectorDirection == 90.0) {
            x = Double(originPoint.x)
            y = Double(originPoint.y) - a
        }
        //If direction is between 90 - 180 degrees
        else if (vectorDirection > 90.0 && vectorDirection < 180.0) {
            x = Double(originPoint.x) - b
            y = Double(originPoint.y) - a
        }
        //If direction is 180 degrees
            //TODO: FIX THIS
        else if (vectorDirection == 180.0) {
            x = Double(originPoint.x) - b
            y = Double(originPoint.y)
        }
        //If direction is between 180 - 270 degrees
        else if (vectorDirection > 180.0 && vectorDirection < 270.0) {
            x = Double(originPoint.x) - b
            y = Double(originPoint.y)
        }
        //If direction is 270 degrees
            //TODO: FIX THIS
        else if (vectorDirection == 270.0) {
            x = Double(originPoint.x)
            y = Double(originPoint.y)
        }
        //If direction is between 270 - 360
        else if (vectorDirection > 270.0 && vectorDirection < 360) {
            x = Double(originPoint.x)
            y = Double(originPoint.y)
        }
        
        //The CGRect to return
        let keyCGRect: CGRect = CGRect(x: x, y: y, width: width, height: height)
        
        return keyCGRect
    }
    
    //Sin function to calculate in degrees instead of radians
    func sinDegrees(degrees: Double)->Double {
        return __sinpi(degrees/180.0)
    }
    
    //Cos function to calculate in degrees instead of radians
    func cosDegrees(degrees: Double)->Double {
        return __cospi(degrees/180.0)
    }
}
