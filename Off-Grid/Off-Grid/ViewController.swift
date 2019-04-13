//
//  ViewController.swift
//  Off-Grid
//
//  Created by Zaki Refai and Sammy Najib on 5/23/18.
//  Copyright © 2018 Kazi Studios. All rights reserved.
//

import UIKit
import CoreMotion
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    //UI Stuff
    @IBOutlet weak var CompassHeading: UILabel!
    @IBOutlet weak var StepCounter: UILabel!
     //Connecting view on mainstoryboard to the VectorDraw class for drawing vectors
    @IBOutlet var vectorDrawView: VectorDraw!
    /*
     Color change for StepCounter UILabel:
     
     At first, the label will be see through being able to match the color of whatever the background is. This means
     that it is "hidden" and currently the user has not started the app to track direction and steps. StepCounter will
     change background after user starts app and update with the amount of steps taken
    */
    
    let stepCounterColorChangeStart = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    let stepCounterColorChangeStop = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
    //Other colors for start/stop button
    let startColor = UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
    let stopColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
    
    //Motion Manager: (Only ever have ONE of these, problem might occur with queue and accessing different data
    let motionManager = CMMotionManager()
    let locationManager = CLLocationManager()
    //Pedometer variable/Users/sammy/Downloads/CE10.2 Custom Functions.xlsx
    var pedometer = CMPedometer()
    //Keeps track of number of steps from pedometer
    var numberOfSteps:Int! = nil
    //Used for taking the magnetic heading and putting it into Vector objects
    var mockHeading:Int = 0
    //Standard timer to keep pedometer on same timer as View
    var timer = Timer()
    //Variable changes everytime the pedometer updates with a new set of steps
    var baseLine:Int = 0
    //Counter variable
    var i:Int = 0
    //For setting correct magnitude into next data points (used in capturing data portion)
    var previousSteps:Int = 0
    //For setting correct magnitude into next data points (used in capturing data portion)
    var currentSteps:Int = 0
    //For setting correct magnitude into next data points (used in capturing data portion)
    var keySteps:Int = 0
    //For setting correct magnitude into next data points (used in capturing data portion)
    var tempMagnitude:Double = 0.0
    //Holds data from walking set as global variable
    var masterArray: [Vector] = []

    //CGPoint variables
    var originPoint: CGPoint = CGPoint(x: UIScreen.main.bounds.maxX / 2,y: UIScreen.main.bounds.maxY / 2)
    var terminalPoint1: CGPoint = CGPoint(x: 0.0, y: 0.0)
    var terminalPoint2: CGPoint = CGPoint(x: 0.0, y: 0.0)
    let xMid = UIScreen.main.bounds.maxX / 2
    let yMid = UIScreen.main.bounds.maxY / 2
    
    //Vector Calibrate variables
    let vectorCalibrate = VectorCalibrate()
    var rect: CGRect = CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0)
    
    //Function gathers device heading in degrees and posts it to CompassHeading Label
    func locationManager(_ manager: CLLocationManager, didUpdateHeading heading: CLHeading) {
        CompassHeading.text = "\(Int(heading.magneticHeading))˚"
        mockHeading = Int(heading.magneticHeading)
    }
    
    //Timer function for pedometer, so that it loads correctly with the view
    func startTimer() {
        if !timer.isValid {
            timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { (timer) in
                self.displayDataAndCapture()
            })
        }
    }
    
    //Function to stop pedometer
    func stopTimer() {
        timer.invalidate()
    }
    
    //Function to display pedometer on StepCounter Labels and also contains the variables that
    //  is actively changing when steps are counted (i.e numberOfSteps)
    func displayDataAndCapture() {
        if let numberOfSteps = numberOfSteps {
            StepCounter.text = String(numberOfSteps)
            
            /*
             CAPTURING DATA BEGINS HERE
            */
            if numberOfSteps > 0 {
                //Computing the magnitude based on steps
                tempMagnitude = computeMagnitude(steps: numberOfSteps)
                //Setting variables into vector
                var vector = Vector(direction: mockHeading, magnitude: tempMagnitude)
                
                //If masterArray is 0 (hold no elements) then add the first vector
                if masterArray.count == 0 {
                    masterArray.append(vector)
                    baseLine = vector.getSteps()
                    
                    //Spawning points for vectorDraw
                    vectorCalibrate.globalCalibrate(vector: masterArray.last!, originPoint: originPoint)
                    
                    //Setting terminal point and CGRect for setCGPoints
                    terminalPoint1 = vectorCalibrate.keyTerminalPoint
                    rect = vectorCalibrate.keyCGRect
                    
                    //Draw first vector
                    setCGPoints(cgPoint1: originPoint, cgPoint2: terminalPoint1, rect: rect)
                    
                    //Print Vector data
                    print(masterArray[0], "\nBase Line: ", baseLine, "\t", "Total Steps: ", numberOfSteps, "\n")
                //If masterArray holds the first vector, check the consecutive vectors to see if pedometer updated
                } else {
                    //This keeps out duplicate vectors from entering master array
                    if baseLine != vector.getSteps() {
                        //Increment (may be needed for future)
                        i += 1
                        
                        //Getting factored step data into magnitude so that the change in steps is shown in the data, not the overall change in steps
                        //  was showing total steps taken, now it should show steps at each update to the pedometer
                        //Takes steps from current vector and subtracts it from steps of previous vector (key), then re-sets the currect vector steps with key
                        previousSteps = baseLine
                        currentSteps = vector.getSteps()
                        
                        //Getting new magnitude and formatting it correctly
                        keySteps = currentSteps - previousSteps
                        tempMagnitude = computeMagnitude(steps: keySteps)
                        
                        //Mutating current vector with correct steps
                        vector.setMagnitude(magnitude: tempMagnitude)
                        
                        //Appending vector to data set
                        masterArray.append(vector)
                        
                        //Change baseline back to previous total of steps so that no pollution of data occurs
                        baseLine = currentSteps
                        
                        //Creating point for new vector
                        //terminalPoint2 = pointSpawner.pointSpawner(vector: masterArray.last!, originPoint: terminalPoint1)
                        vectorCalibrate.globalCalibrate(vector: masterArray.last!, originPoint: terminalPoint1)
                    
                        //Setting terminal point and CGRect for setCGPoints
                        terminalPoint2 = vectorCalibrate.keyTerminalPoint
                        rect = vectorCalibrate.keyCGRect
                        
                        //Draw every new vector after first vector
                        setCGPoints(cgPoint1: terminalPoint1, cgPoint2: terminalPoint2, rect: rect)
                        
                        //Print Vector data
                        print(masterArray[i], "\nBase Line: ", baseLine, "\tTotal Steps: ", numberOfSteps, "\tNew Steps: ", keySteps, "\n")
                        
                        terminalPoint1 = terminalPoint2
                    }
                }
            } else {
                //Do nothing
            }
        }
    }
    
    //For vectorDraw and to redraw it when it CGPoints are set
    //TODO: Change parameters to include CGRect, and rename it
    func setCGPoints(cgPoint1: CGPoint, cgPoint2: CGPoint, rect: CGRect) {
        vectorDrawView.origin = cgPoint1
        vectorDrawView.point2 = cgPoint2
        
        //Re-draw view
        vectorDrawView.clearsContextBeforeDrawing = false
        vectorDrawView.setNeedsDisplay(rect)
        print("CGRect origin: ",rect.origin,"\nCGRect width: ", rect.width, "\nCGRect height: ", rect.height)
    }
    
    //Compute magnitude based on steps taken *For Vector Class Only*
    func computeMagnitude(steps: Int)->Double {
        //Average step of human (in feet)
        let averageStep = 2.35
        let tempMagnitude = Double(steps) * averageStep
        return tempMagnitude
    }
    
    //MARK: Checkers for certain devices (i.e pedometer and device heading)
    
    //Checks to see if device heading is available from location manager
    func checkForDeviceHeading()->Bool {
        if !CLLocationManager.headingAvailable() {
            //Create an alert if device heading is not available, app is not usable
            let alert = UIAlertController(title: "Device heading could not be obtained", message: "Your device's compass is not retrieving it's heading, either re-calibrate your compass or use a different device.", preferredStyle: .alert)
            present(alert, animated: true, completion: nil)
            print("Device heading not detected")
        }
        return CLLocationManager.headingAvailable()
    }
    
    /*
        Checks to see if the necessary devices are available on the user's device: (More importantly, checks to see
        if the accelerometer, gyroscope, magnometer, and altimeter are avaliable. If all three are available, then not
        only will the compass become available, but also the pedometer. The pedometer is a high level sensor that may
        or may not use all four of the low level sensors (accelemeter, gyroscope, magnometer, and altimeter))
    */
    func areDevicesAvailable()->Bool {
        //Checking to see if motion sensors are available
        if !motionManager.isDeviceMotionAvailable {
            //Create an alert if motion sensors are not available, app is not usable, thus stopping user from going past intro page
            let alert = UIAlertController(title: "Certain sensors not detected", message: "Your device does not have the necessary sensors to run the app. Please use a different device.", preferredStyle: .alert)
            present(alert, animated: true, completion: nil)
            print("Devices are not detected")
        }
        return motionManager.isDeviceMotionAvailable
    }
    
    //MARK: Actions
    
    @IBAction func startStop(_ sender: UIButton) {
        if sender.titleLabel?.text == "Start" {
            //Change button title and color
            sender.setTitle("Stop", for: .normal)
            sender.backgroundColor = stopColor
            StepCounter.backgroundColor = stepCounterColorChangeStart
            
            //Pedometer stuff checking to see if step counting is available first
            if CMPedometer.isStepCountingAvailable() {
                //Start time so that the view is loaded correctly
                startTimer()
                pedometer.startUpdates(from: Date()) { (pedometerData, error) in
                    if let pedometerData = pedometerData {
                        self.numberOfSteps = Int(truncating: pedometerData.numberOfSteps)
                    }
                }
            } else {
                print("Step counting not available")
                //Alerts user that step counting is not available
                let alert = UIAlertController(title: "Step counting is not available", message: "Your device's step counter is not functioning properly. Either restart your device, or use a different device", preferredStyle: .alert)
                present(alert, animated: true, completion: nil)
            }
            
        } else {
            //Stopping pedometer and timer
            pedometer.stopUpdates()
            stopTimer()
            
            //Change button title and color
            sender.setTitle("Start", for: .normal)
            sender.backgroundColor = startColor
            StepCounter.backgroundColor = stepCounterColorChangeStop
        }
    }
    
    //For func areDevicesAvailable, for alert if sensors are not available: (The alert has to occur once the storyboard has already loaded)
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //Checks to see if all sensors are available
        if areDevicesAvailable() && checkForDeviceHeading() {
            print("Core motion launched")
            print("Core location launched")
            
            //Azimuth
            locationManager.headingFilter = 1
            locationManager.startUpdatingHeading()
            locationManager.delegate = self
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManager.stopUpdatingHeading()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

