//
//  RouteSelectorViewController.swift
//  Shuttle Counter
//
//  Created by SDG1 on 8/3/15.
//  Copyright (c) 2015 SDG1. All rights reserved.
//

import UIKit

class RouteSelectorViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
       // return UIInterfaceOrientation.LandscapeRight.rawValue
        return UIInterfaceOrientationMask.Landscape
            
    }
    
    @IBAction func unwindToSegue(segue:UIStoryboardSegue) {
    }
    
    @IBAction func blackLineButtonPressed(sender: AnyObject) {
        routeNumber = 1
        currentRoute = "Black Route"
        gpsRoute = "black"
        pickerWheelRoute = "blackbusstops.csv"
        performSegueWithIdentifier("segueToCounter", sender: self)
    }
    @IBAction func goldLineButtonPressed(sender: AnyObject) {
        routeNumber = 2
        currentRoute = "Gold Route"
        gpsRoute = "gold"
        pickerWheelRoute = "goldbusstops.csv"
        performSegueWithIdentifier("segueToCounter", sender: self)
    }
    
    @IBAction func greyLineButtonPressed(sender: AnyObject) {
        routeNumber = 3
        currentRoute = "Gray Route"
        gpsRoute = "gray"
        pickerWheelRoute = "graybusstops.csv"
        performSegueWithIdentifier("segueToCounter", sender: self)
    }
    
    @IBAction func nightLineButtonPressed(sender: AnyObject) {
        routeNumber = 4
        currentRoute = "Night Route"
        gpsRoute = "night"
        pickerWheelRoute = "nightbusstops.csv"
        performSegueWithIdentifier("segueToCounter", sender: self)
    }
    
    @IBAction func downtownLineButtonPressed(sender: AnyObject) {
        routeNumber = 5
        currentRoute = "Downtown Route"
        gpsRoute = "downtown"
        pickerWheelRoute = "downtownbusstops.csv"
        performSegueWithIdentifier("segueToCounter", sender: self)
    }
    
    @IBAction func freshmanLineButtonPressed(sender: AnyObject) {
        routeNumber = 6
        currentRoute = "Freshman Route"
        gpsRoute = "freshman"
        pickerWheelRoute = "greenbusstops.csv"
        performSegueWithIdentifier("segueToCounter", sender: self)
    }
    
    
}

