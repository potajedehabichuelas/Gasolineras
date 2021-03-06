//
//  GasolinerasTableViewController.swift
//  Gasolineras
//
//  Created by Daniel Bolivar herrera on 18/11/2015.
//  Copyright © 2015 Xquare. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMobileAds
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}
;

struct priceType {
    var cheapPrice: Double
    var normalPrice: String
    var expensivePrice: Double
}

class GasolinerasTableViewController: UITableViewController, CLLocationManagerDelegate, GADInterstitialDelegate {
    
    var gasTableArray : Array<Gasolinera> = Array();
    
    var locationManager:CLLocationManager!
    
    var userLocation:CLLocationCoordinate2D = kCLLocationCoordinate2DInvalid;
    
    var settingsOnScreen = false;
    
    var fuelSearchType : String = "";

    var interstitialAd: GADInterstitial!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Google ads - load
        self.interstitialAd = createAndLoadInterstitial()
        
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
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(GasolinerasTableViewController.gestureResponder(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        let swipeL = UISwipeGestureRecognizer(target: self, action: #selector(GasolinerasTableViewController.gestureResponder(_:)))
        swipeL.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeL)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.global(qos: .userInitiated).async {
            // Request petrol station data if the  date is different
            if !Storage.sharedInstance.checkpricesUpdated() {
                print("update needed")
                DispatchQueue.main.async {
                    let loadingNotification = MBProgressHUD.showAdded(to: self.navigationController?.view, animated: true)
                    loadingNotification?.mode = MBProgressHUDMode.indeterminate
                    loadingNotification?.labelText = "Actualizando"
                }
                
                NetworkManager.sharedInstance.requestSpanishPetrolStationData();
                //Data and everything is now updated in the storage
                DispatchQueue.main.async {
                    //Reload Data (Update references, UI,...)
                    MBProgressHUD.hideAllHUDs(for: self.navigationController?.view, animated: true)
                    self.showDoneAnimation()
                    self.setGasArray()
                    self.tableView.reloadData()
                }
            } else {
                DispatchQueue.main.async {
                    //self.showDoneAnimation();
                }
            }
        }
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-7267181828972563/3213821133")
        interstitial?.delegate = self
        interstitial?.load(GADRequest())
        
        return interstitial!
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial!) {
        self.interstitialAd = createAndLoadInterstitial()
    }
    
    func showDoneAnimation() {
        //Show progress hud
        let loadingNotification = MBProgressHUD.showAdded(to: self.navigationController?.view, animated: true)
        loadingNotification?.customView = UIImageView(image: UIImage(named: "37x-Checkmark@2x.png"))
        loadingNotification?.mode = MBProgressHUDMode.customView
        loadingNotification?.labelText = "Todo listo"
        loadingNotification?.hide(true, afterDelay: 1.0)
    }
    
    func setGasArray() {
        
        //Get distance setting and filter it
        let distanceStr : String = (Storage.sharedInstance.settings.object(forKey: STORAGE_DISTANCE_SETTINGS)! as AnyObject).replacingOccurrences(of: " Km", with: "")
        
        let distanceRange : Double = Double(distanceStr)! * 1000
        
        //Set the gas array (that was before, now we have an instance)
        _ = Storage.sharedInstance.getPetrolStations(Storage.sharedInstance.settings.object(forKey: STORAGE_LAST_LAT_SETTINGS)! as! Double, long: Storage.sharedInstance.settings.object(forKey: STORAGE_LAST_LON_SETTINGS)! as! Double, range:distanceRange)!;
        //Sort depending on option selected
        sortGasArray()
    }
    
    @IBAction func settingsAction(_ sender: AnyObject) {
        
        self.revealViewController().revealToggle(animated: true)
        //Reload table view in case some settings changed
        if settingsOnScreen {
            self.setGasArray()
        }
        self.settingsOnScreen = self.settingsOnScreen ? false : true;
    }
    
    func gestureResponder(_ gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            if (swipeGesture.direction == UISwipeGestureRecognizerDirection.right) {
                if (!self.settingsOnScreen) {
                    self.settingsAction(swipeGesture);
                }
            } else if (swipeGesture.direction == UISwipeGestureRecognizerDirection.left) {
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
        gasTableArray = Storage.sharedInstance.gasStations.map {$0.copy() as! Gasolinera}
        
        if fuelSearchType == DIESEL {
            gasTableArray = gasTableArray.filter{$0.gasoleoA > 0}
            gasTableArray.sort(by: { $0.gasoleoA < $1.gasoleoA})
        } else if fuelSearchType == DIESELPLUS {
            gasTableArray = gasTableArray.filter{$0.nuevoGasoleoA > 0}
            gasTableArray.sort(by: { $0.nuevoGasoleoA < $1.nuevoGasoleoA})
        } else if fuelSearchType == GAS95 {
            gasTableArray = gasTableArray.filter{$0.gasolina95 > 0}
            gasTableArray.sort(by: { $0.gasolina95 < $1.gasolina95})
        } else if fuelSearchType == GAS98 {
            //Copy, filter and sort
            gasTableArray = gasTableArray.filter{$0.gasolina98 > 0}
            gasTableArray.sort(by: { $0.gasolina98 < $1.gasolina98})
        }
        
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return gasTableArray.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func setColorForLabel(_ label : UILabel, percentage : Double) {
        if percentage < 30 {
            //Green color, cheap
            label.textColor = UIColor(red: 0, green: 128/255, blue: 0, alpha: 1)
        } else if percentage >= 30 && percentage < 70 {
            //Orange normal price
            label.textColor =  UIColor(red: 1, green: 128/255, blue: 0, alpha: 1)
        } else {
            //Red color, expensive
            label.textColor = UIColor(red: 177/255, green: 0, blue: 0, alpha: 1)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if ((indexPath as NSIndexPath).section % 10 == 0) {
            //CEll is an ad
            return 50;
        } else {
            return 100;
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if ((indexPath as NSIndexPath).section % 10 == 0) {
            //CEll is an ad
           let gasCell = tableView.dequeueReusableCell(withIdentifier: "GasCellAd", for: indexPath) as! AdCellTableViewCell
            gasCell.bannerView.rootViewController = self
            
            return gasCell;
            
        } else {
            let gasCell = tableView.dequeueReusableCell(withIdentifier: "GasCell", for: indexPath) as! GasTableViewCell
            
            let petrolStation : Gasolinera = gasTableArray[(((indexPath as NSIndexPath).section - (indexPath as NSIndexPath).section / 10) - 1)] //- 1 cause of first ad, 0 pos
            
            // Configure the gas Cell
            gasCell.gasName.text = petrolStation.rotulo
            
            if petrolStation.gasoleoA != nil && petrolStation.gasoleoA > 0 {
                gasCell.dieselPrice.text = String(format: "%.3f", petrolStation.gasoleoA!)
                //Set the colour
                let pctg = Statistics.sharedInstance.getRangeForValue(petrolStation.gasoleoA!, fuelType: DIESEL)
                self.setColorForLabel(gasCell.dieselPrice, percentage: pctg)
            } else {
                gasCell.dieselPrice.text = "--"
                gasCell.dieselPrice.textColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
            }
            
            if petrolStation.nuevoGasoleoA != nil && petrolStation.nuevoGasoleoA > 0 {
                gasCell.dieselPlusPrice.text = String(format: "%.3f", petrolStation.nuevoGasoleoA!)
                let pctg = Statistics.sharedInstance.getRangeForValue(petrolStation.nuevoGasoleoA!, fuelType: DIESELPLUS)
                self.setColorForLabel(gasCell.dieselPlusPrice, percentage: pctg)
                
            } else {
                gasCell.dieselPlusPrice.text = "--"
                gasCell.dieselPlusPrice.textColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
            }
            
            if petrolStation.gasolina95 != nil && petrolStation.gasolina95 > 0 {
                gasCell.petrol95Price.text = String(format: "%.3f", petrolStation.gasolina95!)
                
                let pctg = Statistics.sharedInstance.getRangeForValue(petrolStation.gasolina95!, fuelType: GAS95)
                self.setColorForLabel(gasCell.petrol95Price, percentage: pctg)
            } else {
                gasCell.petrol95Price.text = "--"
                gasCell.petrol95Price.textColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
            }
            
            if petrolStation.gasolina98 != nil && petrolStation.gasolina98  > 0 {
                gasCell.petrol98Price.text = String(format: "%.3f", petrolStation.gasolina98!)
                let pctg = Statistics.sharedInstance.getRangeForValue(petrolStation.gasolina98!, fuelType: GAS98)
                self.setColorForLabel(gasCell.petrol98Price, percentage: pctg)
            } else {
                gasCell.petrol98Price.text = "--"
                gasCell.petrol98Price.textColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
            }
            
            if CLLocationCoordinate2DIsValid(userLocation) {
                //Calculate distance in Km
                
                let userLoc : CLLocation = CLLocation.init(latitude: userLocation.latitude, longitude: userLocation.longitude)
                
                let gasLocation : CLLocation = CLLocation.init(latitude: petrolStation.latitud, longitude: petrolStation.longitud)
                
                var kilometers = userLoc.distance(from: gasLocation) / 1000
                kilometers = round(10*kilometers)/10
                
                gasCell.distanceKm.text = "\(kilometers) Km"
            }
            return gasCell;
        }
        
    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if self.interstitialAd.isReady {
            self.interstitialAd.present(fromRootViewController: self)
        }
        self.performSegue(withIdentifier: "MapSegue", sender: self)
    }
    
    
    // MARK: - CLLocationManager
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let newlocation: CLLocation = locationManager.location {
            userLocation = newlocation.coordinate
            // Save last location to settings
            //Save distance
            Storage.sharedInstance.settings.setValue(newlocation.coordinate.longitude, forKey: STORAGE_LAST_LON_SETTINGS)
            Storage.sharedInstance.settings.setValue(newlocation.coordinate.latitude, forKey: STORAGE_LAST_LAT_SETTINGS)
            Storage.sharedInstance.saveSettings(Storage.sharedInstance.settings);
        } else {
            print("no location...")
        }
        
        if CLLocationCoordinate2DIsValid(userLocation) {
            self.tableView.reloadData()
        }
        
        //print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if segue.identifier == "MapSegue"{
            //Get the segue VC
            let viewController = segue.destination as! GasMapViewController
            //Set the highlighted cell
            let section : Int = ((self.tableView.indexPathForSelectedRow as NSIndexPath?)?.section)!
            viewController.highlightedStation = gasTableArray[(section - (section / 10) - 1)];
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
