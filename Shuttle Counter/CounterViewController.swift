//
//  CounterViewController.swift
//  Shuttle Counter
//
//  Created by SDG1 on 8/3/15.
//  Copyright (c) 2015 SDG1. All rights reserved.
//

import UIKit
import CoreLocation

class CounterViewController: UIViewController, CLLocationManagerDelegate, UIPickerViewDataSource,UIPickerViewDelegate, NSURLConnectionDelegate {


    var timer = NSTimer()
    var netTimer = NSTimer()
    var gpsTimer = NSTimer()
    
    @IBOutlet weak var clockLabel: UILabel!
    @IBOutlet weak var busLabel: UILabel!
    @IBOutlet weak var currentStop: UILabel!
    @IBOutlet weak var offLabel: UILabel!
    @IBOutlet weak var onLabel: UILabel!
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var stopSelecter: UIPickerView!
    @IBOutlet weak var submitButton: UIButton!
    
    var locationManager: CLLocationManager!
    var selectedStop: String?
    var conn: NSURLConnection?
    var arrayStops: NSMutableArray?
    var gpsTimerStarted:Bool?
    
    var dummy:gpsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedStop = "None"

        arrayStops = NSMutableArray()
        
        submitButton.hidden = true
        
        stopSelecter.dataSource = self
        stopSelecter.delegate = self
        
        gpsTimerStarted = false
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        busLabel.text = currentRoute
        // Do any additional setup after loading the view.
        
        dummy = gpsDelegate()
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("tick"), userInfo: nil, repeats: true)
        //self.gpsTimer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: Selector("getLocationForGPS") , userInfo: nil, repeats: true)
        //fromGPS = false
        
        setPickerWheel()
    }
   
    override func viewWillAppear(animated: Bool) {
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidDisappear(animated: Bool) {
        locationManager.stopUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Landscape
        
    }
    
    func tick() {
        clockLabel.text = NSDateFormatter.localizedStringFromDate(NSDate(),dateStyle: .NoStyle , timeStyle: .MediumStyle)
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        gpsTimer.invalidate()
        timer.invalidate()
        locationManager.stopUpdatingLocation()
        //unwindForSegue(unwindToStart!, towardsViewController: RouteSelectorViewController())
        performSegueWithIdentifier("returnHome", sender: self)
    }
    
    @IBAction func upOnCount(sender: AnyObject) {
        var value = Int((onLabel.text)!)
        value = value! + 1
        onLabel.text = String(value!)
    }
    
    @IBAction func downOnCount(sender: AnyObject) {
        var value = Int((onLabel.text)!)
        if (value > 0)
        {
            value = value! - 1
            onLabel.text = String(value!)
        }
    }
    
    @IBAction func upOffCount(sender: AnyObject) {
        var value = Int((offLabel.text)!)
        if (value! + 1 <= Int(currentLabel.text!)!)
        {
            value = value! + 1
            offLabel.text = String(value!)
        }
    }
    
    @IBAction func downOffCount(sender: AnyObject) {
        var value = Int((offLabel.text)!)
        if (value > 0)
        {
            value = value! - 1
            offLabel.text = String(value!)
        }
    }
    
    @IBAction func allOffCount(sender: AnyObject) {
        let value = Int((currentLabel.text)!)
        offLabel.text = String(value!)
    }
   /*
    @IBAction func getCurrentLocation(sender: AnyObject) {
        gpsLatitude = NSString(format: "%1f", locationManager.location!.coordinate.longitude)
        gpsLongitude = NSString(format: "%1f", locationManager.location!.coordinate.longitude)
    }
    */
    func getLocationForGPS() {
//        do {
//        try expression
//        statements
//        } catch pattern 1 {
//            statements
//        } catch pattern 2 where condition {
//            statements
//        }
        //do {

        
            gpsLatitude = NSString(format: "%1f", locationManager.location!.coordinate.latitude)
            gpsLongitude = NSString(format: "%1f", locationManager.location!.coordinate.longitude)
       
        
        dummy!.gpsLocation()
    }
    
    @IBAction func submitCount(sender: AnyObject) {
        if (selectedStop == "None" || currentStop.text == "None")
        {
            let noStop = UIAlertView(title: "Error!", message: "Please select the current stop!", delegate: self, cancelButtonTitle: "OK")
            //let noStop = UIAlertController(title: "Error!", message: "Please select the current stop!", preferredStyle: UIAlertControllerStyle.Alert)
            noStop.show()
        }
        else
        {
            var current = Int((currentLabel.text)!)
            let on = Int((onLabel.text)!)
            let off = Int((offLabel.text)!)
            
            let msg = "On:" + String(on!) + " Off:" + String(off!)

            let alert = UIAlertView(title: "Submit Counts", message: msg, delegate: self, cancelButtonTitle: "OK")
            alert.show()
            
            current = current! + on! - off!
            
            let date = NSDate()
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:SS"
            
            let currentDate = dateFormatter.stringFromDate(date)
            print("getting longitude and latitude in submitCount")
            let latitude = NSString(format: "%1f", locationManager.location!.coordinate.latitude)
            let longitude = NSString(format: "%1f", locationManager.location!.coordinate.longitude)
                
            print("SUBMITCOUNT2222222222")
            
            let xml = NSString(format: "<?xml version=\"1.0\"?><stop><time>%@</time><bus>%@</bus><busStop>%@</busStop><location><lat>%@</lat><lon>%@</lon></location><count><on>%d</on><off>%d</off></count></stop>", currentDate, currentRoute, selectedStop!, latitude, longitude, on!, off!)

            let path = NSString(string: "http://shuttle.cs.wfu.edu/count/addCount.php")
            let postData = self.generateDataFromText(xml, fieldName: "xml")

            let uploadRequest = NSMutableURLRequest(URL: NSURL(string: path as String)!)
            uploadRequest.HTTPMethod = "POST"
            uploadRequest.setValue(NSString(format: "%d", postData) as String, forHTTPHeaderField: "Content-Length")

            uploadRequest.setValue("application/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
            uploadRequest.HTTPBody = postData
            uploadRequest.timeoutInterval = 15.0
            
            conn = NSURLConnection(request: uploadRequest, delegate: self)

            netTimer = NSTimer(timeInterval: 30, target: self, selector: "cancelNetworkConnection", userInfo: nil, repeats: false)

            if((conn) != nil) {
                locationResponseData = NSMutableData()
                self.view.userInteractionEnabled = false
            }
            else {
                let badRequest = UIAlertView(title: "Failed!", message: "The update failed to send!", delegate: self, cancelButtonTitle: "OK")
                badRequest.show()

            }
        }
        
        print("SUBMITCOUNT1111111111")
        
    }
    
    func cancelNetworkConncection() {
        print("Cancelling Network Connection!")
        conn?.cancel()
        
        let badRequest = UIAlertView(title: "Failed!", message: "The update failed to send!", delegate: self, cancelButtonTitle: "OK")
        badRequest.show()
        self.view.userInteractionEnabled = true
    }
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        // This method is called when the server has determined that it
        // has enough information to create the NSURLResponse.
        
        // It can be called multiple times, for example in the case of a
        // redirect, so each time we reset the data.
        
        // receivedData is an instance variable declared elsewhere.
        locationResponseData?.length = 0
        
        print("CONNECTIONDIDRECEIVERESPONSE1111111111")
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        // Append the new data to receivedData.
        // receivedData is an instance variable declared elsewhere.
        locationResponseData?.appendData(data)
        print("CONNECTIONDIDRECEIVEDATA1111111111")
    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        self.view.userInteractionEnabled = true
        netTimer.invalidate()
        
        print("Connection failed! Error - ", terminator: "")
        print(error.localizedDescription, terminator: "")
        print(" ", terminator: "")
        print(error.valueForKey(NSURLErrorFailingURLStringErrorKey))
        
        let badRequest = UIAlertView(title: "Failed!", message: "The update failed to send!", delegate: self, cancelButtonTitle: "OK")
        badRequest.show()
        performSegueWithIdentifier("returnHome", sender: self)
        print("CONNECTIONDIDFAILWITHERROR1111111111")
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        netTimer.invalidate()
        
        var current = Int((currentLabel.text)!)
        let on = Int((onLabel.text)!)
        let off = Int((offLabel.text)!)
        var msg:NSString = "On:" + String(on!) + " Off:" + String(off!)

        current = current! + on! - off!
        
        currentLabel.text = NSString(format: "%d", current!) as String
        onLabel.text = "0"
        offLabel.text = "0"
        
        stopSelecter.reloadAllComponents()
        stopSelecter.selectRow(0, inComponent: 0, animated: true)
        selectedStop = "None"
        currentStop.text = "None"
        
        self.view.userInteractionEnabled = true
    }
    /*
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        offLabel.resignFirstResponder()
        onLabel.resignFirstResponder()
        super.touchesBegan(touches as Set<NSObject>, withEvent: event)
    }
    */
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        offLabel.resignFirstResponder()
        onLabel.resignFirstResponder()
        super.touchesBegan(touches as Set<UITouch>, withEvent: event)
    }
    
    func generateDataFromText(dataString: NSString, fieldName: NSString) -> NSMutableData {
        let post = NSString(format: "")
        
        // Get the post header int ASCII format:
        let postHeaderData = post.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
        
        // Generate the mutable data variable:
        let postData = NSMutableData(length: postHeaderData!.length)
        postData?.setData(postHeaderData!)
        let uploadData = dataString.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
        
        // Add the text:
        postData?.appendData(uploadData!)
        
        // Add the closing boundry:
        postData?.appendData(NSString(string: "\r\n").dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)!)
        
        print("GENERATEDATAFROMTEXT1111111111")
        // Return the post data:
        return postData!
    }
    
    func setPickerWheel() {
        var routeURL = "http://shuttle.cs.wfu.edu/iphoneRoutes/"
        routeURL += pickerWheelRoute
        
        let routeRequest:NSURL = NSURL(string: routeURL)!
        let routeData:NSString = try! NSString(contentsOfURL: routeRequest, encoding: NSUTF8StringEncoding)
        let myScanner:NSScanner = NSScanner(string: routeData as String)
        
        let commaSet:NSCharacterSet = NSCharacterSet(charactersInString: ",")
        let endLineSet:NSCharacterSet = NSCharacterSet(charactersInString: "\n\r")
        
        var r:NSString?
        let none = NSMutableDictionary()
        
        none.setObject("None", forKey: "stop")
        none.setObject("0.0", forKey: "lat")
        none.setObject("0.0", forKey: "lng")
        
        arrayStops?.addObject(none)
        
        if(pickerWheelRoute == ("solarbusstops.csv")) {
            arrayStops?.addObject("All")
        }
        else {
            while(!myScanner.atEnd) {
                
                let tmp:NSMutableDictionary = NSMutableDictionary()
                
                myScanner.scanUpToCharactersFromSet(commaSet, intoString: &r)

                tmp.setObject(r!, forKey: "lat")
                myScanner.scanString(",", intoString: nil)
                
                myScanner.scanUpToCharactersFromSet(commaSet, intoString: &r)
                tmp.setObject(r!, forKey: "lng")
                myScanner.scanString(",", intoString: nil)
                
                myScanner.scanUpToCharactersFromSet(commaSet, intoString: &r)
                tmp.setObject(r!, forKey: "stop")
                myScanner.scanUpToCharactersFromSet(endLineSet, intoString: nil)
                
                myScanner.scanString("\n\r", intoString: nil)
                
                arrayStops?.addObject(tmp)
            }
        }
        
        if(arrayStops?.count == 2) {
            let badRequest = UIAlertView(title: "Failed!", message: "No internet connection!", delegate: self, cancelButtonTitle: "OK")
            badRequest.show()
            performSegueWithIdentifier("returnHome", sender: self)
        }
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        print("TITLEFORROW1111111111")
        let temp =  arrayStops?.objectAtIndex(row).objectForKey("stop") as? String
        currentStop.text = temp
        return temp
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedStop = arrayStops?.objectAtIndex(row).objectForKey("stop") as? String
        print("DIDSELECTROW1111111111")
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        print("NUMBEROFCOMPONENTS1111111111")
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        print("NUMBEROFROWS1111111111")
        //return 1
        return arrayStops!.count
    }

    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        var row:Int = 0
        print("in location manager did update to location")
        if(!gpsTimerStarted!)
        {
            self.gpsTimer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: Selector("getLocationForGPS") , userInfo: nil, repeats: true)
            gpsTimerStarted = true
            submitButton.hidden = false
        }
        for bstop in arrayStops! {
            let latString: String? = bstop.objectForKey("lat") as? String
            let lat:NSString = latString!.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "\""))
            
            let longString: String? = bstop.objectForKey("lng") as? String
            let long:NSString = longString!.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "\""))

            let test:CLLocation = CLLocation(latitude: lat.doubleValue, longitude: long.doubleValue)
            
            if (newLocation.distanceFromLocation(test) <= 80) {
                stopSelecter.selectRow(row, inComponent: 0, animated: true)

                selectedStop = String(arrayStops?.objectAtIndex(row).objectForKey("stop") as! NSString)
                currentStop.text = (bstop.objectForKey("stop") as! String)
            }
            
            row++
        }
        
    }
   func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        locationManager.stopUpdatingLocation()
    print("about to end locationManager and gpsTimer")
    //locationManager.finalize()
    //gpsTimer.invalidate()
    print("in locationManagerDidFailWithError counterViewC *****\n")
     //println(error)
        //if ((error) != nil) {
          //  print(error)
        //}
        print("LOCATIONDIDFAILWITHERROR1111111111")
    let badRequest = UIAlertView(title: "Failed!", message: "No GPS Connection!", delegate: self, cancelButtonTitle: "OK")
    badRequest.show()
    performSegueWithIdentifier("returnHome", sender: self)

    }

    func locationManager(manager: CLLocationManager!, didUpdateLocation location: AnyObject!) {
            let locationObj = location as! CLLocation
            let coord = locationObj.coordinate
            print("hello sajant")
            print(coord.latitude)
            print(coord.longitude)
    }
    

}
