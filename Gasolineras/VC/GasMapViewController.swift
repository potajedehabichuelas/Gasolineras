//
//  SecondViewController.swift
//  Gasolineras
//
//  Created by Daniel Bolivar herrera on 10/05/2015.
//  Copyright (c) 2015 Xquare. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class GasMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var map: MKMapView!
    
    var userLocation:CLLocationCoordinate2D = kCLLocationCoordinate2DInvalid;
    
    var gasolineras : Array<Gasolinera> = Array();
    
    var manager:CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        manager.startUpdatingLocation()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //
        // Do you want this to happen every time the vc appears? browsing would be lost
        //CONS In viewDidLoad: IF settings change, or array of stations change it wont be updated
        
        
        //Check if we need to update -> there has been a new query on the db and we need to update array reference
        if gasolineras != Storage.sharedInstance.gasStations {
            //Update array reference
            gasolineras = Storage.sharedInstance.gasStations;
            //Set the markers
            self.placeMarkers();
            
            //Zoom according to the settings
            //Get distance setting and filter it
            let distanceStr : String = Storage.sharedInstance.settings.objectForKey(STORAGE_DISTANCE_SETTINGS)!.stringByReplacingOccurrencesOfString(" Km", withString: "")
            let distanceRange : Double = Double(distanceStr)! * 1000
            
            if manager.location != nil {
                let rgn = MKCoordinateRegionMakeWithDistance(
                    CLLocationCoordinate2DMake(manager.location!.coordinate.latitude, manager.location!.coordinate.longitude), distanceRange, distanceRange);
                map.setRegion(rgn, animated: true)
            } else {
                if  Storage.sharedInstance.settings.objectForKey(STORAGE_LAST_LAT_SETTINGS)!.doubleValue > 0 && Storage.sharedInstance.settings.objectForKey(STORAGE_LAST_LON_SETTINGS)!.doubleValue > 0 {
                    let rgn = MKCoordinateRegionMakeWithDistance(
                        CLLocationCoordinate2DMake(Storage.sharedInstance.settings.objectForKey(STORAGE_LAST_LAT_SETTINGS)!.doubleValue, Storage.sharedInstance.settings.objectForKey(STORAGE_LAST_LON_SETTINGS)!.doubleValue), distanceRange, distanceRange);
                    map.setRegion(rgn, animated: true)
                }
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func placeMarkers () {
        
        //First remove all the current markers on the map
        map.removeAnnotations(map.annotations);
        
        //Place markers for the stations in the map
        for station : Gasolinera in gasolineras {
            let annotation = GasPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(station.latitud, station.longitud)
            annotation.name = station.rotulo
            annotation.address = station.direccion!
            annotation.precioDiesel = station.gasoleoA! > 0 ? String(station.gasoleoA!) : "--"
            annotation.precioDieselPlus = station.nuevoGasoleoA! > 0 ? String(station.nuevoGasoleoA!) : "--"
            annotation.precioGas95 = station.gasolina95! > 0 ? String(station.gasolina95!) : "--"
            annotation.precioGas98 = station.gasolina98! > 0 ? String(station.gasolina98!) : "--"
            map.addAnnotation(annotation)
        }

    }
    
    // MARK: - MKAnnotationView
    
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        if view.annotation!.isKindOfClass(MKUserLocation){
            return
        }
        
        //Remove the calloutview
        let cpa = view.annotation as! GasPointAnnotation
        if cpa.callOutView != nil {
            UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 1.5,
                initialSpringVelocity: 0.5, options: [], animations:
                {
                    cpa.callOutView?.transform = CGAffineTransformMakeScale(0, 0)
                }, completion:{ (Bool)  in
                    //cpa.callOutView?.removeFromSuperview();
            })
        }
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
       
        if view.annotation!.isKindOfClass(MKUserLocation){
            return
        }
        
        view.canShowCallout = false
        
        let customView = (NSBundle.mainBundle().loadNibNamed("GasAnnotationView", owner: self, options: nil))[0] as! GasAnnotationView;
        
        var calloutViewFrame = customView.frame;
        calloutViewFrame.origin = CGPointMake(-calloutViewFrame.size.width/2 + 5, -calloutViewFrame.size.height);
        customView.frame = calloutViewFrame;
        
        customView.clipsToBounds = true
        customView.layer.cornerRadius = 8.0
        customView.layer.borderColor = UIColor.darkGrayColor().CGColor
        customView.layer.borderWidth = 1.5
        
        let cpa = view.annotation as! GasPointAnnotation
        //Set the fields in the view
        customView.name.text = cpa.name;
        customView.addressLabel.text = cpa.address;
        customView.precioGas95.text = cpa.precioGas95;
        customView.precioGas98.text = cpa.precioGas98;
        
        customView.precioDiesel.text = cpa.precioDiesel;
        customView.precioDieselPlus.text = cpa.precioDieselPlus;
        
        //Set the reference to the view
        cpa.callOutView = customView;
        view.addSubview(customView)
        customView.transform = CGAffineTransformMakeScale(0, 0)
        
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 1.5,
            initialSpringVelocity: 0.5, options: [], animations:
            {
                customView.transform = CGAffineTransformMakeScale(1, 1)
            }, completion: nil)
        
        
        //zoom map to show callout
        let spanX = 0.02
        let spanY = 0.02
        
        let newRegion = MKCoordinateRegion(center:cpa.coordinate, span: MKCoordinateSpanMake(spanX, spanY))
        self.map?.setRegion(newRegion, animated: true)
    }
    
    
    // MARK: - CLLocationManager
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        /*let location = locations.last! as CLLocation
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.map.setRegion(region, animated: true)
        */

    }
}

