//
//  gpsDelegate.swift
//  Shuttle Counter
//
//  Created by SDG1 on 9/8/15.
//  Copyright (c) 2015 SDG1. All rights reserved.
//


import UIKit
import CoreLocation

class gpsDelegate: NSObject ,NSURLConnectionDelegate {
    
    var gpsConnection:NSURLConnection?

    func gpsLocation() {
        print("GPSLOCATION gpsDelegate.swift")
        
        let urlString = NSString(string: "http://shuttle.cs.wfu.edu/gps/gpsInfo.php")

        
        let date:NSDate = NSDate()
        let formatter:NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "HH:mm:ss"
        
        let curDate:NSString = formatter.stringFromDate(date)
        let parameter:NSString = NSString(format: "latitude=%@&longitude=%@&route=%@&curTime=%@", gpsLatitude, gpsLongitude, gpsRoute, curDate)
        
        print("Parameter GPS: ", terminator: "")
        print(parameter)
        
        let parameterData:NSData = parameter.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)!
        let url = NSURL(string: urlString as String)
        let theRequest = NSMutableURLRequest(URL: url!)
        theRequest.addValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        theRequest.HTTPMethod = "POST"
        theRequest.HTTPBody = parameterData
        
        gpsConnection = NSURLConnection(request: theRequest, delegate: self)!
        if((gpsConnection) != nil)
        {
            gpsResponseData = NSMutableData()
        }
        
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        print("In gps did finish loading");
    }
    
    func cancelNetworkConncection() {
        print("Cancelling GPS Connection!")
        gpsConnection!.cancel()
        
        let badRequest = UIAlertView(title: "Failed!", message: "The update failed to send!", delegate: self, cancelButtonTitle: "OK")
        badRequest.show()
    }



    func gpsConnection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        // This method is called when the server has determined that it
        // has enough information to create the NSURLResponse.
        
        // It can be called multiple times, for example in the case of a
        // redirect, so each time we reset the data.
        
        // receivedData is an instance variable declared elsewhere.
        gpsResponseData?.length = 0
        
        print("GPSCONNECTIONDIDRECEIVERESPONSE1111111111")
    }
    
    func gpsConnection(connection: NSURLConnection, didReceiveData data: NSData) {
        // Append the new data to receivedData.
        // receivedData is an instance variable declared elsewhere.
        gpsResponseData?.appendData(data)
        
        print("GPSCONNECTIONDIDRECEIVEDATA1111111111")
    }
    
    func gpsConnection(connection: NSURLConnection, didFailWithError error: NSError) {
        //self.view.userInteractionEnabled = true
        
        //print("Connection failed! Error - ")
        //print(error.localizedDescription)
        //print(" ")
        //println(error.valueForKey(NSURLErrorFailingURLStringErrorKey))
        
        let badRequest = UIAlertView(title: "Alert!", message: "No network connection!", delegate: self, cancelButtonTitle: "OK")
        badRequest.show()
        
        print("GPSCONNECTIONDIDFAILWITHERROR1111111111")
    }

}
