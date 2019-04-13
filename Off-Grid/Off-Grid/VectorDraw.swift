//
//  VectorDraw.swift
//  Off-Grid
//
//  Created by Zaki Refai on 8/9/18.
//  Copyright © 2018 Kazi Studios. All rights reserved.
//

import UIKit

class VectorDraw: UIView {
    
    var origin: CGPoint = CGPoint(x: 0.0, y: 0.0)
    var point2: CGPoint = CGPoint(x: 0.0, y: 0.0)
    
    override func draw(_ rect: CGRect) {
        
        //Declaring context and its properties (i.e its width and color)
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(3.0)
        context?.setStrokeColor(UIColor.purple.cgColor)
        
        //Context directions, what to do with the context a move - addLine = stroke
        context?.move(to: origin)
        context?.addLine(to: point2)
        
        //Actually draws line
        context!.strokePath()
        print("Line drawn from origin at x: ", origin.x, "\tat y: ", origin.y)
        print("To terminal point at x: ", point2.x, "\tat y: ", point2.y)
    }
}
