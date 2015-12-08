//
//  GasolinerasTableViewController.swift
//  Gasolineras
//
//  Created by Daniel Bolivar herrera on 18/11/2015.
//  Copyright © 2015 Xquare. All rights reserved.
//

import UIKit
import CoreLocation

struct priceType {
    var cheapPrice: Double
    var normalPrice: String
    var expensivePrice: Double
}

class GasolinerasTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    var gasArray : Array<Gasolinera> = Array();
    
    var gasTableArray : Array<Gasolinera> = Array();
    
    var locationManager:CLLocationManager!
    
    var userLocation:CLLocationCoordinate2D = kCLLocationCoordinate2DInvalid;
    
    var settingsOnScreen = false;
    
    var fuelSearchType : String = "";

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.setGasArray()
        
        //Get location
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        locationManager.startUpdatingLocation()
        
        //SWRevealVc
        self.revealViewController().toggleAnimationDuration = 0.8;
        self.revealViewController().bounceBackOnOverdraw = true;
        self.revealViewController().bounceBackOnLeftOverdraw = true;
        
        //Gesture recognizers
        let swipeRight = UISwipeGestureRecognizer(target: self, action: "gestureResponder:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            // Request petrol station data if the  date is different
            //NetworkManager.sharedInstance.requestSpanishPetrolStationData();
            //Data and everything is now updated in the storage
            //Reload Data (Update references, UI,...)
            //self.tableView.reloadData()
        }
    }
    
    func setGasArray() {
        
        //Get distance setting and filter it
        let distanceStr : String = Storage.sharedInstance.settings.objectForKey(STORAGE_DISTANCE_SETTINGS)!.stringByReplacingOccurrencesOfString(" Km", withString: "")
        
        let distanceRange : Double = Double(distanceStr)! * 1000
        
        //Set the gas array
        gasArray = Storage.sharedInstance.getPetrolStations(Storage.sharedInstance.settings.objectForKey(STORAGE_LAST_LAT_SETTINGS)!.doubleValue, long: Storage.sharedInstance.settings.objectForKey(STORAGE_LAST_LON_SETTINGS)!.doubleValue, range:distanceRange)!;
        //Sort depending on option selected
        sortGasArray()
    }
    
    @IBAction func settingsAction(sender: AnyObject) {
        
        self.revealViewController().revealToggleAnimated(true)
        //Reload table view in case some settings changed
        if settingsOnScreen {
            self.setGasArray()
        }
        self.settingsOnScreen = self.settingsOnScreen ? false : true;
    }
    
    func gestureResponder(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            if (swipeGesture.direction == UISwipeGestureRecognizerDirection.Right) {
                if (self.settingsOnScreen) {
                    self.settingsAction(swipeGesture);
                }
            }
        }
    }
    
    // MARK: - Aux functions
    
    // Sorts the array based on the type of fuel selected
    func sortGasArray() {
        
        //Set the fuel search type
        fuelSearchType = Storage.sharedInstance.settings[STORAGE_SEARCH_SETTINGS] as! String;
        
        //Duplicate array to remove 0
        gasTableArray = gasArray.map {$0.copy() as! Gasolinera}
        
        if fuelSearchType == DIESEL {
            gasTableArray = gasTableArray.filter{$0.gasoleoA > 0}
            gasTableArray.sortInPlace({ $0.gasoleoA < $1.gasoleoA})
        } else if fuelSearchType == DIESELPLUS {
            gasTableArray = gasTableArray.filter{$0.nuevoGasoleoA > 0}
            gasTableArray.sortInPlace({ $0.nuevoGasoleoA < $1.nuevoGasoleoA})
        } else if fuelSearchType == GAS95 {
            gasTableArray = gasTableArray.filter{$0.gasolina95 > 0}
            gasTableArray.sortInPlace({ $0.gasolina95 < $1.gasolina95})
        } else if fuelSearchType == GAS98 {
            //Copy, filter and sort
            gasTableArray = gasTableArray.filter{$0.gasolina98 > 0}
            gasTableArray.sortInPlace({ $0.gasolina98 < $1.gasolina98})
        }
        
        self.tableView.reloadData()
    }
    
    // Set the colors - green - amber - red depending on the price of the fuel
    func setColors() {
        
     
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return gasTableArray.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let gasCell : GasTableViewCell = tableView.dequeueReusableCellWithIdentifier("GasCell", forIndexPath: indexPath) as! GasTableViewCell
        
        let petrolStation : Gasolinera = gasTableArray[indexPath.section]

        // Configure the gas Cell
        gasCell.gasName.text = petrolStation.rotulo
        
        if petrolStation.gasoleoA != nil && petrolStation.gasoleoA > 0 {
            gasCell.dieselPrice.text = String(format: "%.3f", petrolStation.gasoleoA!)
        } else {
            gasCell.dieselPrice.text = "--"
        }
        
        if petrolStation.nuevoGasoleoA != nil && petrolStation.nuevoGasoleoA > 0 {
            gasCell.dieselPlusPrice.text = String(format: "%.3f", petrolStation.nuevoGasoleoA!)
        } else {
            gasCell.dieselPlusPrice.text = "--"
        }
        
        if petrolStation.gasolina95 != nil && petrolStation.gasolina95 > 0 {
            gasCell.petrol95Price.text = String(format: "%.3f", petrolStation.gasolina95!)
        } else {
            gasCell.petrol95Price.text = "--"
        }
        
        if petrolStation.gasolina98 != nil && petrolStation.gasolina98  > 0 {
            gasCell.petrol98Price.text = String(format: "%.3f", petrolStation.gasolina98!)
        } else {
            gasCell.petrol98Price.text = "--"
        }
        
        if CLLocationCoordinate2DIsValid(userLocation) {
            //Calculate distance in Km
            
            let userLoc : CLLocation = CLLocation.init(latitude: userLocation.latitude, longitude: userLocation.longitude)
            
            let gasLocation : CLLocation = CLLocation.init(latitude: petrolStation.latitud, longitude: petrolStation.longitud)
            
            var kilometers = userLoc.distanceFromLocation(gasLocation) / 1000
            kilometers = round(10*kilometers)/10
            
            gasCell.distanceKm.text = "\(kilometers) Km"
        }
        
        return gasCell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("MapSegue", sender: self)
    }
    
    
    // MARK: - CLLocationManager
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let newlocation: CLLocation! = locationManager.location {
            userLocation = newlocation!.coordinate
            // Save last location to settings
            //Save distance
            Storage.sharedInstance.settings.setValue(newlocation?.coordinate.longitude, forKey: STORAGE_LAST_LON_SETTINGS)
            Storage.sharedInstance.settings.setValue(newlocation?.coordinate.latitude, forKey: STORAGE_LAST_LAT_SETTINGS)
            Storage.sharedInstance.saveSettings(Storage.sharedInstance.settings);
        } else {
            print("no location...")
        }
        
        if CLLocationCoordinate2DIsValid(userLocation) {
            self.tableView.reloadData()
        }
        
        //print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "MapSegue"{
            /*let navigationController = segue.destinationViewController as UINavigationController
            let vc = navigationController.topViewController as RestaurantViewController
            vc.data = currentResponse[i] as NSArray*/
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
