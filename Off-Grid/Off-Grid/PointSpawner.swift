//
//  PointSpawner.swift
//  Off-Grid
//
//  Created by Zaki Refai on 8/10/18.
//  Copyright © 2018 Kazi Studios. All rights reserved.
//

import Foundation
import UIKit

class PointSpawner {

    //Function for vectorDraw for every vector after first vector
    func pointSpawner(vector: Vector, originPoint: CGPoint)->CGPoint! {
        //Vector components
        let vectorDirection = Double(vector.getDirection())
        let vectorMagnitude = Double(vector.getMagnitude())
        //Origin components
        let originX = Double(originPoint.x)
        let originY = Double(originPoint.y)
        //Components of CGPoint
        var x = 0.0
        var y = 0.0
        //Returned pointed
        var point: CGPoint = CGPoint(x: 0.0, y: 0.0)
        
        /*
         Because the points on the phone are oriented in a different manner, there needs to be some corrections
         applied to the components of the CGPoint. Depending on the angle of the vector the components may be
         to negative, or left alone (implying that they are positive).
         */
        if (vectorDirection == 0) { //Correct
            x = cos(vectorDirection) * vectorMagnitude
            y = sin(vectorDirection) * vectorMagnitude
            
            point = CGPoint(x: (x + originX), y: (y + originY))
            
        } else if (vectorDirection > 0) && (vectorDirection < 90) { //Correct
            x = cos(vectorDirection) * vectorMagnitude
            y = sin(vectorDirection) * vectorMagnitude
            
            point = CGPoint(x: (x + originX), y: ((y * (-1)) + originY))
        } else if (vectorDirection == 90) { //Correct
            x = cos(vectorDirection) * vectorMagnitude
            y = sin(vectorDirection) * vectorMagnitude
            
            point = CGPoint(x: (x + originX), y: ((y * (-1)) + originY))
            
        } else if (vectorDirection > 90) && (vectorDirection < 180) { //Correct
            x = cos(vectorDirection) * vectorMagnitude
            y = sin(vectorDirection) * vectorMagnitude
            
            point = CGPoint(x: (x + originX), y: ((y * (-1)) + originY))
            
        } else if (vectorDirection == 180) { //Correct
            x = cos(vectorDirection) * vectorMagnitude
            y = sin(vectorDirection) * vectorMagnitude
            
            point = CGPoint(x: (x + originX), y: (y + originY))
            
        } else if (vectorDirection > 180) && (vectorDirection < 270) { //Correct
            x = cos(vectorDirection) * vectorMagnitude
            y = sin(vectorDirection) * vectorMagnitude
            
            point = CGPoint(x: (x + originX), y: ((y * (-1)) + originY))
        } else if (vectorDirection == 270) { //Correct
            x = cos(vectorDirection) * vectorMagnitude
            y = sin(vectorDirection) * vectorMagnitude
            
            point = CGPoint(x: (x + originX), y: (y + originY))
            
        } else if (vectorDirection > 270) && (vectorDirection < 360) { //Correct
            x = cos(vectorDirection) * vectorMagnitude
            y = sin(vectorDirection) * vectorMagnitude
            
            point = CGPoint(x: (x + originX), y: ((y * (-1)) + originY))
        }
        
        print("\nx: ", point.x, "y: ", point.y)
        
        //Return point
        return point
    }
    
    func cgRectGenerator(vector: Vector, originPoint: CGPoint, terminalPoint: CGPoint)->CGRect {
        var cgRect: CGRect = CGRect(x: 0.0, y: 0.0, width: 0, height: 0)
        
        return cgRect
    }
}
