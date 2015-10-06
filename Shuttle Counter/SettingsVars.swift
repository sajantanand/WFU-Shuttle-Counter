//
//  SsettingVars.swift
//  Shuttle Counter
//
//  Created by SDG1 on 8/3/15.
//  Copyright (c) 2015 SDG1. All rights reserved.
//

import Foundation

var routeNumber = 0         //number corresponds to route of shuttle
                            //black = 1; gold = 2; grey = 3; night = 4; downtown = 5; freshman = 6;
var currentRoute:String = ""            //Following three variables set in RouteSelectorViewController.swift
var gpsRoute:String = ""
var pickerWheelRoute:String = ""

//var locationManager: CLLocationManager = CLLocationManager()
var gpsResponseData: NSMutableData? = NSMutableData()
var locationResponseData: NSMutableData? = NSMutableData()

var gpsLatitude:NSString = "0"
var gpsLongitude:NSString = "0"